## Хронология попыток починить Goal/Notifications (2025‑11 → 2025‑12)

### 1. Исходное состояние (до 2025‑11-18)
- **Симптомы:** при каждом холодном запуске на iOS появлялся чёрный экран. В логах — `MainThreadIOMonitor` с `NSFileManager`, `NSData`, `SKPaymentQueue`, `FirebaseCore I-COR000003`.
- **Причина:** Firebase и тяжёлые плагины (StoreKit 1, DKImagePicker, Google Sign-In) поднимались в ObjC `+load`, до Flutter. NotificationsService, Hive и SharedPreferences тоже инициализировались синхронно.

### 2. План обновления iOS (18–24 ноября)
1. **Stage 1** — синхронизация Flutter/Pods.
2. **Stage 2** — ранний bootstrap Firebase:
   - Добавлены `FirebaseEarlyInit.m`, `AppDelegate.configureFirebaseBeforeMain()`, флаги `FirebaseEnableDebugLogging`, `EnableIosFcm`.
   - Несколько итераций (`docs/draft-2/3/4.md`) показывали, что `I-COR000003` всё ещё появляется. Варианты с `constructor(0)`/`+load` и отключением `GULAppDelegateSwizzler` тестировались до тех пор, пока предупреждение не исчезло (20.11).
   - Для диагностики временно включали `FIRDebugEnabled` и breakpoint на `FIRLogBasic`.
3. **Stage 3** — StoreKit 2 и deferred IAP:
   - В `NativeBootstrapCoordinator` появился MethodChannel `bizlevel/native_bootstrap`.
   - `BizPluginRegistrant` перестал регистрировать `InAppPurchasePlugin` в `GeneratedPluginRegistrant`.
   - Новый Swift‑мост `StoreKit2Bridge` + Dart-сервис.
   - Скрипт `tool/strip_iap_from_registrant.dart` чистит `GeneratedPluginRegistrant.m` при каждой сборке.
4. **Stage 4** — Галерея/файловые плагины:
   - Убраны `dk_image_picker`, `file_picker`; добавлены SceneDelegate, отложенные инициализации.
5. **Stage 6 (часть)** — Notifications/Hive/timezone перенесены в post-frame, но ранний ObjC bootstrap Firebase по-прежнему существовал.

### 3. Декабрьские попытки (2025‑12-01 → 2025‑12-06)

#### 3.1. Исправления в Flutter‑коде
- **GoalScreen / NotificationsOverlay**: убрали бесконечные `BoxConstraints`, добавили LayoutBuilder/CustomScrollView, устраняли RenderBox asserts.
- **NotificationsService**: внедрены `_guardedCloudRefresh`, `ReminderPrefsCache`, `_workSerial`, `bindAuthLifecycle`, очередь SharedPreferences, позднее — `ensureReady()` для ленивой инициализации.
- **Providers**: `notification_settings_provider`, `levelsProvider`, `libraryProvider`, goal/practice log провайдеры возвращают заглушки, пока нет сессии, чтобы Supabase/Hive не грузились на экране логина.
- **Tests**: обновлялись `street_screen_test.dart`, `checkpoint_l7_cta_navigation_test.dart`, `login_screen_test.dart` под новые сценарии.
- **Docs**: `docs/status.md` пополнялся задачами `notif-freeze`, `notif-goal-final`, `notif-lazy-bootstrap`.

#### 3.2. Декабрьские проблемы
- Логи (`docs/draft-2.md`, `docs/draft-4.md`) продолжали показывать `FirebaseEarlyInit: +load ... FIRApp configure()` до Flutter, затем `MainThreadIOMonitor` с `NSFileManager`/`NSData`/`dlopen`.
- NotificationsService, Supabase провайдеры и SharedPreferences уже ленивые, но пользы нет, пока ObjC слой блокирует главный поток.
- Пользователь наблюдал: экран Goal не открывается, настройки уведомлений дают затемнение, приложение «замирает» даже перед авторизацией.

### 4. Последняя попытка (2025‑12-07)
1. **Идея:** полностью отложить нативный bootstrap — ObjC не конфигурирует Firebase, пока Flutter сам не попросит по MethodChannel.
2. **Реализация:**
   - Добавлен флаг `FirebaseDeferredBootstrap` в `Info.plist`.
   - `FirebaseEarlyInit.m` проверяет флаг: если true — `+load`/конструкторы логируют defer и не вызывают `FIRApp configure`.
   - `AppDelegate` получил метод `configureFirebaseDeferred(reason:)`; старый `configureFirebaseBeforeMain()` теперь просто логирует, если bootstrap отложен.
   - `NativeBootstrapCoordinator` обрабатывает метод `configureFirebase`.
   - В Dart (`NativeBootstrap.ensureFirebaseConfigured`) вызов добавлен в `_schedulePostFrameBootstraps()` до `_ensureFirebaseInitialized`.
   - Репозитории (`levels`, `lessons`, `goals`, `gp_service`) переведены на `HiveBoxHelper.openBox`.
3. **Проверки:** `dart analyze` → только старые warning’и. Но устройственный лог всё ещё показывает `FirebaseEarlyInit: +load ... configure()` — значит, проект не пересобран (Info.plist/Pods не обновлены), и флаг не попал на устройство.

### 5. Текущее состояние (по последним логам)
- ObjC конструкторы продолжают конфигурировать Firebase до запуска Flutter, из-за чего `MainThreadIOMonitor` ловит `NSFileManager`, `NSData`, `bundlePath`, `createFileAtPath`.
- NotificationsService и другие ленивые слои не успевают помочь — приложение зависает на чёрном экране ещё до первого UI кадра.

### 6. Рекомендации для повторного внедрения
1. **Полная пересборка iOS**: `flutter clean`, удаление `ios/Pods` и `Podfile.lock`, `pod install`, затем Xcode Release на устройстве. Убедиться, что Info.plist с `FirebaseDeferredBootstrap=true` присутствует в собранном `.ipa`.
2. **Диагностика логов**: временно поставить `FirebaseEnableDebugLogging=true`, собрать Release, убедиться, что лог содержит «Firebase bootstrap deferred until Flutter», а `MainThreadIOMonitor` молчит до первого кадра.
3. **После подтверждения**: вернуть `FirebaseEnableDebugLogging=false`, включить `EnableIosFcm` по необходимости, повторно проверить App Check/PushService.
4. **Мониторинг**: при обновлении Pods/Flutter повторно запускать `tool/strip_iap_from_registrant.dart` и проверять `FirebaseEarlyInit.m`, чтобы флаг не потерялся.

### 7. Выводы
- Одних Flutter‑поправок недостаточно — ключевая проблема в ObjC bootstrap’е.
- После каждого изменения iOS‑слоя нужно проверять логи `docs/draft-*.md` и убеждаться, что `FirebaseEarlyInit` ведёт себя согласно плану.
- Без чистой пересборки (pod install, clean build) даже правильные изменения не попадут на устройство, и вся оптимизация сверху будет бесполезна.
