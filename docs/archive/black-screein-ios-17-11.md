## Отчёт по расследованию «чёрного экрана» на iOS (17 ноября 2025)

### 1. Исходные симптомы
- После обновления Flutter 3.35.7 приложение на iPhone перестало показывать UI: Xcode сообщает `Launch succeeded`, устройство остаётся на чёрном экране, Performance Diagnostics фиксирует «main thread hang».
- В логах стабильно появляются предупреждения Firebase (`I-COR000003`, `App Delegate Proxy is disabled`), синхронные операции `NSFileManager`, `NSData initWithContentsOfFile`, `sqlite3_open`, `SKPaymentQueue`, `AppSSOAgent`.
- Проблема воспроизводится даже на чистом девайсе, без бэкапов и без сторонних приложений.

### 2. Хронология попыток
| Этап | Что делали | Эффект |
|------|------------|--------|
| **2.1 Bootstrap / Hive / Supabase** | В `lib/main.dart` введён `BootstrapGate`, отделён синхронный старт от тяжёлых операций. Все репозитории переведены на `HiveBoxHelper` с отложенными `putDeferred`, `readValue`. Supabase переключили на SWR-паттерн. | Главный поток перестал ждать открытия Hive, но чёрный экран остался: логи показали, что теперь блокирует Firebase и StoreKit. |
| **2.2 Firebase core на iOS** | Добавили ранний вызов `FirebaseApp.configure()` в `AppDelegate.init`, `willFinish`, позже — в `main.m` перед `UIApplicationMain` и отдельный `FirebaseEarlyInit.m` с `__attribute__((constructor))`. Создан MethodChannel `bizlevel/native/fcm` для отложенной регистрации `FLTFirebaseMessagingPlugin`. | Предупреждение `I-COR000003` стало появляться реже, но полностью не исчезло: библиотеки `FirebaseInstallations` и `GULAppDelegateSwizzler` всё равно запускаются сами до нашего конструктора. Чёрный экран сохраняется. |
| **2.3 PushService и deferred FCM** | `PushService` переписан: `FirebaseMessaging.onBackgroundMessage` регистрируется только на Android, разрешения и auto-init переносятся после первого кадра, добавлены платформенные хуки, `main.dart` вызывает регистрацию плагина через MethodChannel. | Проблема с `MissingPluginException` решена, но «hang» остался — в логах продолжались синхронные вызовы `FileManager` и `SKPaymentQueue`. |
| **2.4 Отключение Firebase Messaging** | Из `pubspec.yaml` и Pods полностью удалён `firebase_messaging`. `PushService` превратился в заглушку, `AppDelegate` очищен от deferred регистраций, Info.plist лишился ключей `FirebaseMessaging*`. Собрали проект без FCM. | В логах `@draft-4.md` всё равно фиксируется `I-COR000003`, а Performance Diagnostics продолжает ругаться на `SKPaymentQueue` и `DKImagePickerController`. Значит, первопричина не только в FCM — тяжёлые плагины StoreKit, FilePicker, DKPhotoGallery и т.д. всё равно блокируют главный поток. |
| **2.5 Побочные работы** | Обновлялись Pods, внедряли `Podfile` с `use_frameworks! :linkage => :static`, добавляли фазы `Strip Flutter xattr`, правили codesign, реорганизовывали темы/UI. | Сборка теперь упирается в нестабильные Pods (AppAuth, Sentry headers), но это отдельные инфраструктурные задачи. |
| **2.6 Ultra-early Firebase** | `FirebaseEarlyInit.m` получил `FirebaseEarlyInitSentinel +load`, который вызывает `[FIRApp configure]` раньше конструкторов и пишет call stack. В Info.plist добавлены `FirebaseInstallationsAutoInitEnabled=false` и `GULAppDelegateSwizzlerEnabled=false`, чтобы Pods не инициировали Firebase до нас. | Требуется новая Release-сборка с `FirebaseEnableDebugLogging=true`, чтобы убедиться, что `I-COR000003` исчез; пока подтверждения нет, остаёмся в Этапе 2 и не трогаем StoreKit. |

### 3. Почему отключение FCM не решило проблему
1. **Главный поток всё ещё перегружен StoreKit** — `in_app_purchase_storekit` при старте сразу регистрирует `SKPaymentQueue`, что вызывает `AppSSOAgent` и XPC на главном потоке. Эти вызовы в логах и есть текущий «hang».
2. **Photo / File picker** — плагины `DKImagePickerController`, `DKPhotoGallery`, `file_picker` загружают nib’ы и создают каталоги при регистрации плагина, не дожидаясь первого кадра.
3. **Инициализация Firebase Core** — даже без Messaging `FirebaseInstallations` и `GULAppDelegateSwizzler` всё равно дергают `FirebaseApp.configure` в `+load`, что даёт `I-COR000003` до наших конструкторов.
4. **Дополнительные сервисы** — `flutter_local_notifications`, `timezone`, `Supabase` и Hive хоть и отложены нами, но остаются в списке потенциальных блокировщиков, если поднимаются при регистрации плагинов.

Вывод: отключение одного модуля (FCM) не даёт мгновенного эффекта, потому что черный экран — это совокупность синхронных инициализаций разных плагинов в стадии `UIApplicationMain`. Чтобы добиться результата, нужно массово «деферрить» регистрацию тяжёлых плагинов либо вернуться к состоянию `origin/prelaunch` и двигаться минимальными шагами.

### 4. Текущее состояние ветки `ios-black-screen-17-11`
- Firebase Messaging отсутствует в зависимостях, `PushService` — заглушка.
- В `ios/Runner` добавлены `main.m`, `FirebaseEarlyInit.m`, переработан `AppDelegate.swift`.
- Большой пласт UI/дизайна: новые темы в `lib/theme/*`, переписанные экраны (`gp_store_screen`, `artifacts_screen`, `profile_screen`, etc.).
- Документация (`docs/draft-2/4`, `docs/status.md`) обновлена под текущее расследование.
- Pods пересобраны, но `Podfile` и `Podfile.lock` теперь заметно отличаются от `origin/prelaunch`.

### 5. Оставшиеся проблемы
1. **Главный поток блокируется StoreKit, DKImagePicker, FileManager** — необходимо либо отключить соответствующие плагины на iOS, либо грузить их после первого кадра.
2. **Firebase Core продолжает конфигурироваться «слишком поздно»** — наши конструкторы не гарантируют приоритета над `+load` в сторонних фреймворках.
3. **Инфраструктурные ошибки Pods (Sentry headers, AppAuth)** — после `flutter clean` и полного удаления Pods Xcode часто не находит `objective_c.release.xcconfig`, `SentryUser.h`, т.к. структура Pods была переписана вручную для обхода кеша.
4. **Кодовая база сильно разошлась с `prelaunch`** — более 100 файлов с изменениями (не только по теме iOS). Любая новая гипотеза становится сложнее проверять.

### 6. Рекомендованный план
1. **Сделать чистую ветку от `origin/prelaunch`** для «контрольного» запуска без всех последних правок. Это позволит подтвердить, что проблема воспроизводится только после миграции на Flutter 3.35.7 и нового сетапа плагинов.
2. **Минимизировать плагины на iOS**:
   - временно отключить `in_app_purchase_storekit`, `dk_image_picker`, `file_picker`, `flutter_local_notifications` в iOS Runner (через флаги `dart-define` и `#if`).
   - зарегистрировать их вручную после `WidgetsBinding.instance.endOfFrame`.
3. **Вернуть Firebase Messaging (только для теста)** в изолированной ветке, чтобы убедиться, что он не является текущим блокером. Это подтвердит выводы из логов.
4. **Оптимизировать Pods**: пересоздать `Podfile` без ручных правок (использовать версию как в `prelaunch`), добавить post_install, который комментирует тяжёлые pods для iOS build-конфигурации.
5. **Дальнейшие шаги** зависят от результатов: если чёрный экран пропадёт на чистой ветке без плагинов, придётся возвращать их по одному с отложенной инициализацией; если останется — фокус на системных факторах (iOS 18 beta, профили, символьные атрибуты).

---

_Отчёт составлен 17.11.2025 на основе логов `docs/draft-2.md`, `docs/draft-4.md` и текущего состояния ветки `ios-black-screen-17-11`._

### 8.1 Прогресс 18.11.2025 — Этап 1 (синхронизация окружения)
- `flutter pub upgrade --major-versions` → обновлены Riverpod/Firebase/StoreKit/FilePicker/GoRouter и др., `pubspec.lock`/`pubspec.yaml` синхронизированы.
- CocoaPods заново пересобраны (`pod repo update`, `pod install --repo-update`) с `Firebase 12.4`, `GoogleSignIn 9.0`, `Sentry 8.56.2`; минимальный таргет iOS повышен до 15.0 (иначе `firebase_core` 4.2.1 не ставится).
- `flutter upgrade` не выполнен: локальный SDK Flutter имеет незакоммиченные правки, `flutter upgrade` требует `--force`; оставили 3.35.7 до разъяснений.
- Исправлены все предупреждения `flutter analyze` после обновления пакетов: переход на `ResponsiveBreakpoints.builder`/`RadioGroup`, новая инициализация Google Sign-In (singleton + `authorizeScopes`), поддержка `TimezoneInfo`, обновлённые параметры `flutter_local_notifications` и тестовые `@Skip` аннотации.
- Требуется ручная проверка Release-сборки на устройстве в Xcode (после `flutter clean -> flutter pub get -> cd ios -> pod install` уже выполненных команд). После теста зафиксировать логи в `docs/draft-2.md`/`draft-4.md`.

### 8.2 Прогресс 18.11.2025 — Этап 2 (Firebase Bootstrap)
- `main.m` и `FirebaseEarlyInit.m` теперь реально входят в таргет, `@main` убран у `AppDelegate`, поэтому `configureFirebaseBeforeMain()` отрабатывает до `UIApplicationMain` (видно по `NSLog`). Это устраняет гонку с `FirebaseInstallations` и даёт возможность ловить проблемы по таймингу.
- App Check получил переключатель в Info.plist (`FirebaseAppCheckUseDebugProvider`). Пока DeviceCheck/App Attest не настроены, ключ = `true` и используется `AppCheckDebugProviderFactory` даже в Release; когда инфраструктура готова — переключаем на `false`, и включится `DeviceCheckProviderFactory`. Старые ключи `FirebaseAppDelegateProxyEnabled=false` и `FirebaseMessagingAutoInitEnabled=false` остаются, PushService стартует только после первого кадра.
- Требуется повторная Release‑сборка на устройстве: сначала с debug‑флагом (проверяем отсутствие `I-COR000003`), затем с флагом `false`, чтобы убедиться, что реальный DeviceCheck не возвращает 403. Все логи публикуем в `docs/draft-2/3/4.md`.
- Убрал ранний `Firebase.initializeApp()` из `lib/main.dart`: раньше он вызывался до регистрации плагинов и порождал `I-COR000003`. Теперь Firebase и PushService инициализируются в post-frame колбэке через `_ensureFirebaseInitialized()`, а `AppDelegate` логирует ситуацию, если после `configure()` дефолтного приложения всё ещё нет. В Release Info.plist по умолчанию включает DeviceCheck, в Debug — `AppCheckDebugProviderFactory`.
- Добавлен Objective-C хук: `FirebaseEarlyInit.m` импортирует `FirebaseCore` и вызывает `[FIRApp configure]` до Swift, чтобы Pods со своими `+load` не опережали init. В Info.plist появился флаг `FirebaseEnableDebugLogging`, который при значении `true` включает `FIRDebugEnabled`/`FIRAppDiagnosticsEnabled` и поднимает лог‑левел; с ним можно снять стек `I-COR000003` прямо в Xcode.
## Отчёт по расследованию «чёрного экрана» на iOS (17 ноября 2025)

### 1. Исходные симптомы
- После обновления Flutter 3.35.7 приложение на iPhone перестало показывать UI: Xcode сообщает `Launch succeeded`, устройство остаётся на чёрном экране, Performance Diagnostics фиксирует «main thread hang».
- В логах стабильно появляются предупреждения Firebase (`I-COR000003`, `App Delegate Proxy is disabled`), синхронные операции `NSFileManager`, `NSData initWithContentsOfFile`, `sqlite3_open`, `SKPaymentQueue`, `AppSSOAgent`.
- Проблема воспроизводится даже на чистом девайсе, без бэкапов и без сторонних приложений.

### 2. Хронология попыток
| Этап | Что делали | Эффект |
|------|------------|--------|
| **2.1 Bootstrap / Hive / Supabase** | В `lib/main.dart` введён `BootstrapGate`, отделён синхронный старт от тяжёлых операций. Все репозитории переведены на `HiveBoxHelper` с отложенными `putDeferred`, `readValue`. Supabase переключили на SWR-паттерн. | Главный поток перестал ждать открытия Hive, но чёрный экран остался: логи показали, что теперь блокирует Firebase и StoreKit. |
| **2.2 Firebase core на iOS** | Добавили ранний вызов `FirebaseApp.configure()` в `AppDelegate.init`, `willFinish`, позже — в `main.m` перед `UIApplicationMain` и отдельный `FirebaseEarlyInit.m` с `__attribute__((constructor))`. Создан MethodChannel `bizlevel/native/fcm` для отложенной регистрации `FLTFirebaseMessagingPlugin`. | Предупреждение `I-COR000003` стало появляться реже, но полностью не исчезло: библиотеки `FirebaseInstallations` и `GULAppDelegateSwizzler` всё равно запускаются сами до нашего конструктора. Чёрный экран сохраняется. |
| **2.3 PushService и deferred FCM** | `PushService` переписан: `FirebaseMessaging.onBackgroundMessage` регистрируется только на Android, разрешения и auto-init переносятся после первого кадра, добавлены платформенные хуки, `main.dart` вызывает регистрацию плагина через MethodChannel. | Проблема с `MissingPluginException` решена, но «hang» остался — в логах продолжались синхронные вызовы `FileManager` и `SKPaymentQueue`. |
| **2.4 Отключение Firebase Messaging** | Из `pubspec.yaml` и Pods полностью удалён `firebase_messaging`. `PushService` превратился в заглушку, `AppDelegate` очищен от deferred регистраций, Info.plist лишился ключей `FirebaseMessaging*`. Собрали проект без FCM. | В логах `@draft-4.md` всё равно фиксируется `I-COR000003`, а Performance Diagnostics продолжает ругаться на `SKPaymentQueue` и `DKImagePickerController`. Значит, первопричина не только в FCM — тяжёлые плагины StoreKit, FilePicker, DKPhotoGallery и т.д. всё равно блокируют главный поток. |
| **2.5 Побочные работы** | Обновлялись Pods, внедряли `Podfile` с `use_frameworks! :linkage => :static`, добавляли фазы `Strip Flutter xattr`, правили codesign, реорганизовывали темы/UI. | Сборка теперь упирается в нестабильные Pods (AppAuth, Sentry headers), но это отдельные инфраструктурные задачи. |

### 3. Почему отключение FCM не решило проблему
1. **Главный поток всё ещё перегружен StoreKit** — `in_app_purchase_storekit` при старте сразу регистрирует `SKPaymentQueue`, что вызывает `AppSSOAgent` и XPC на главном потоке. Эти вызовы в логах и есть текущий «hang».
2. **Photo / File picker** — плагины `DKImagePickerController`, `DKPhotoGallery`, `file_picker` загружают nib’ы и создают каталоги при регистрации плагина, не дожидаясь первого кадра.
3. **Инициализация Firebase Core** — даже без Messaging `FirebaseInstallations` и `GULAppDelegateSwizzler` всё равно дергают `FirebaseApp.configure` в `+load`, что даёт `I-COR000003` до наших конструкторов.
4. **Дополнительные сервисы** — `flutter_local_notifications`, `timezone`, `Supabase` и Hive хоть и отложены нами, но остаются в списке потенциальных блокировщиков, если поднимаются при регистрации плагинов.

Вывод: отключение одного модуля (FCM) не даёт мгновенного эффекта, потому что черный экран — это совокупность синхронных инициализаций разных плагинов в стадии `UIApplicationMain`. Чтобы добиться результата, нужно массово «деферрить» регистрацию тяжёлых плагинов либо вернуться к состоянию `origin/prelaunch` и двигаться минимальными шагами.

### 4. Текущее состояние ветки `ios-black-screen-17-11`
- Firebase Messaging отсутствует в зависимостях, `PushService` — заглушка.
- В `ios/Runner` добавлены `main.m`, `FirebaseEarlyInit.m`, переработан `AppDelegate.swift`.
- Большой пласт UI/дизайна: новые темы в `lib/theme/*`, переписанные экраны (`gp_store_screen`, `artifacts_screen`, `profile_screen`, etc.).
- Документация (`docs/draft-2/4`, `docs/status.md`) обновлена под текущее расследование.
- Pods пересобраны, но `Podfile` и `Podfile.lock` теперь заметно отличаются от `origin/prelaunch`.

### 5. Оставшиеся проблемы
1. **Главный поток блокируется StoreKit, DKImagePicker, FileManager** — необходимо либо отключить соответствующие плагины на iOS, либо грузить их после первого кадра.
2. **Firebase Core продолжает конфигурироваться «слишком поздно»** — наши конструкторы не гарантируют приоритета над `+load` в сторонних фреймворках.
3. **Инфраструктурные ошибки Pods (Sentry headers, AppAuth)** — после `flutter clean` и полного удаления Pods Xcode часто не находит `objective_c.release.xcconfig`, `SentryUser.h`, т.к. структура Pods была переписана вручную для обхода кеша.
4. **Кодовая база сильно разошлась с `prelaunch`** — более 100 файлов с изменениями (не только по теме iOS). Любая новая гипотеза становится сложнее проверять.

### 6. Рекомендованный план
1. **Сделать чистую ветку от `origin/prelaunch`** для «контрольного» запуска без всех последних правок. Это позволит подтвердить, что проблема воспроизводится только после миграции на Flutter 3.35.7 и нового сетапа плагинов.
2. **Минимизировать плагины на iOS**:
   - временно отключить `in_app_purchase_storekit`, `dk_image_picker`, `file_picker`, `flutter_local_notifications` в iOS Runner (через флаги `dart-define` и `#if`).
   - зарегистрировать их вручную после `WidgetsBinding.instance.endOfFrame`.
3. **Вернуть Firebase Messaging (только для теста)** в изолированной ветке, чтобы убедиться, что он не является текущим блокером. Это подтвердит выводы из логов.
4. **Оптимизировать Pods**: пересоздать `Podfile` без ручных правок (использовать версию как в `prelaunch`), добавить post_install, который комментирует тяжёлые pods для iOS build-конфигурации.
5. **Дальнейшие шаги** зависят от результатов: если чёрный экран пропадёт на чистой ветке без плагинов, придётся возвращать их по одному с отложенной инициализацией; если останется — фокус на системных факторах (iOS 18 beta, профили, символьные атрибуты).

---

_Отчёт составлен 17.11.2025 на основе логов `docs/draft-2.md`, `docs/draft-4.md` и текущего состояния ветки `ios-black-screen-17-11`._


### 7. Что произошло после отката к `prelaunch`
- Мы целиком вернули «преланчевский» стек: Flutter 3.13.x + базовые плагины (`in_app_purchase_storekit`, `AppAuth`, `DKImagePickerController`, `DKPhotoGallery`, `flutter_local_notifications`, `firebase_messaging`), а также ранние версии `Supabase`, `Hive`, `PushService`.
- Восстановили `Podfile`/`Podfile.lock`, `Runner.xcodeproj`, `GeneratedPluginRegistrant` и iOS-бандл (включая свиззлинг Firebase), убрали кастомные файлы `main.m`/`FirebaseEarlyInit.m`.
- После отката приложение **собралось и стартовало**, однако логи (`draft-2.md`, `draft-4.md`) сразу показали прежние зависания: `SKPaymentQueue`, `DKImagePicker`, `AppAuth` и `FirebaseInstallations` снова выполняют синхронный I/O до первого кадра. Запуск идёт, но очень медленно и со «спайками» в Performance Diagnostics.

### 8. Аккуратный поэтапный план обновлений (без выключения функциональности)
1. **Базовый стек и инструменты**
   - Обновить Flutter SDK и dart-пакеты до последних стабильных минорных версий (включая `firebase_core`, `firebase_messaging`, `in_app_purchase`, `file_picker`, `google_sign_in`, `sentry_flutter`).  
   - После каждого обновления: `flutter clean → flutter pub get → cd ios && pod install → билд в Xcode (Release)` и проверка запуска на устройстве.

2. **Firebase Bootstrap**
   - Вернуть раннюю инициализацию (`main.m`, `FirebaseEarlyInit.m`) и обновить конфигурацию согласно свежей документации Firebase iOS (App Check, Installations).  
   - Проверить, что `I-COR000003` исчезает. Затем включить пошагово: `firebase_app_check`, `firebase_messaging` (отложенный `setAutoInitEnabled` и регистрация MethodChannel после первого кадра).

3. **StoreKit / In-App Purchase**
   - Перейти на актуальный `in_app_purchase` (поддержка StoreKit 2).  
   - Обновить нативные Pods (`in_app_purchase_storekit`, `StoreKit` frameworks) и внедрить новую API `Product.products`.  
   - Убедиться, что `SKPaymentQueue` больше не дергается до момента, когда пользователь открывает магазин. Для этого инициализацию сервиса вынести в lazy-режим, но без отключения функционала.

4. **Галерея и файловые плагины**
   - Обновить `file_picker` и `photo`/`image_picker` зависимости до версий с поддержкой iOS 17/18.  
   - Для старых частей (DKImagePicker/DKPhotoGallery) внедрить новый плагин `photo_manager` или `file_selector` и заменить устаревшие вызовы `keyWindow`.  
   - После замены убедиться, что Performance Diagnostics не показывает `keyWindow` и `NSFileManager` предупреждений.

5. **AppAuth / Google Sign-In**
   - Обновить `AppAuth` (>= 1.7.6) и `google_sign_in_ios` до последних релизов, которые используют `ASWebAuthenticationSession`.  
   - Перенести запуск `GoogleSignInPlatform.instance` после первого кадра или при фактическом входе, но не отключать вход совсем.  
   - Проверить, что новые версии не блокируют UI (отслеживать логи SafariServices).

6. **Локальные сервисы и Notifications**
   - Обновить `flutter_local_notifications`, `timezone`, `wakelock_plus` и собственные сервисы так, чтобы тяжёлые операции (NSKeyedArchiver, FileManager) выполнялись либо в изолятах, либо после первого кадра.  
   - Добавить профайлинг (Timeline в Observatory/Sentry) и убедиться, что главный поток свободен в первые секунды запуска.

7. **Регулярная регрессия**
   - После каждого шага фиксировать результат в `docs/status.md` и `docs/black-screein-ios-17-11.md`.  
   - Обязательно запускать Xcode (Release, устройство), прикладывать логи (`draft-2.md`, `draft-4.md`) и подтверждать, что нет новых зависаний или «чёрных экранов».
