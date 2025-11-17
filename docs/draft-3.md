## Отчет по расследованию «черного экрана» на iOS

### 1. Контекст и исходные симптомы
- После обновления Flutter SDK (3.35.7) и связанных плагинов приложение перестало запускаться на iPhone: Xcode показывает «Launch succeeded», но на устройстве — черный экран, спиннер Xcode крутится бесконечно.
- Консоль указывала на проблемы Firebase (`[FirebaseCore] No app has been configured yet`) и свиззлинг Firebase Messaging. Позже добавились ошибки codesign (`resource fork, Finder information...`) и сборки GTMAppAuth (`No such module 'AppAuth'`).

### 2. Проверенные гипотезы и исключенные причины
1. **Неверный GoogleService-Info.plist / Bundle ID** — сверено, файл подкладывается в Copy Bundle Resources и совпадает с `bizlevel.kz`.
2. **Неправильная инициализация Supabase/Hive** — выявлено, что `LateInitializationError` и `HiveError` блокировали UI ещё до отображения. Исправлено через `BootstrapGate`, перенос `dotenv.load`, `SupabaseService.initialize`, `Hive.initFlutter` в синхронный этап. Эти ошибки устранены.
3. **Firebase Messaging autoinit/swizzling** — добавлены ключи `FirebaseAppDelegateProxyEnabled = NO`, `FirebaseMessagingAutoInitEnabled = NO`. Логи Firebase перестали быть критичными; проблема черного экрана не исчезла ⇒ гипотеза не подтверждена.
4. **Неверные product IDs IAP** — заменены на `gp_300/1000/2000` в клиенте и Supabase-функции `gp-purchase-verify`. Не влияет на старт приложения ⇒ исключено.
5. **Неполный Pod install / конфликт AppAuth** — обновили Podfile (Sentry Hybrid SDK, удалили пин AppAuth 1.7.6), переустановили Pods. Ошибка «No such module AppAuth» вернулась только после очередного flutter clean → требуется дальнейшая донастройка, но это уже не про черный экран.

### 3. Применённые методы и их эффект
| Направление | Действия | Результат |
|-------------|----------|-----------|
| **Обновление инфраструктуры** | `flutter upgrade`, `flutter pub upgrade`, `pod repo update`, `pod install`, очистка DerivedData, удаление `.symlinks`, `flutter clean`. | Билды проходят, но появилась новая связка проблем (codesign/AppAuth). |
| **iOS проект** | Указали base configuration для Runner (Debug/Profile/Release), добавили phase «Strip Flutter xattr», включили удаление `com.apple.provenance` в `removeFinderExtendedAttributes`, пропатчили flutter_tools (`targets/ios.dart`). | Удалось автоматизировать очистку атрибутов в `Flutter.framework`, но codesign всё равно падает, если атрибуты создаются на уровне ФС. Добавлен fallback: при dev-сборке Flutter пропускает codesign и оставляет задачу Xcode. |
| **Main/bootstrap** | Введён `BootstrapGate`, разделение синхронного и асинхронного старта, тайминг логов, фоновая инициализация Firebase/Sentry/PushService. | Черный экран из-за блокировки UI устранён: теперь при успешном bootstrap показывается `_BootstrapSplash`, а затем `MyApp`. |
| **Firebase диагностика** | Отключили автоматическое swizzling, добавили явный вызов `Firebase.initializeApp` (в `_bootstrapAfterFirstFrame`). | Предупреждение `[FirebaseCore] No app has been configured yet` исчезло после переноса инициализации. |
| **In-app purchase / Supabase** | Приведены product IDs к `gp_*`, обновлена edge-function, добавлены проверки в `docs/status.md`. | Косвенное влияние на проблему исключено. |
| **Codesign** | Многоступенчатая очистка xattr: локально (sudo xattr -rd), в build phase, в flutter_tools + fallback-пропуск. | Codesign ошибки стали диагностироваться, но на машине пользователя системно присутствует `com.apple.provenance`, который мгновенно возвращается при любой записи. Сделали вывод: требуется системное решение (удаление extended attributes на уровне APFS/Volume). |

### 4. Текущее состояние
1. **Черный экран / зависание UI** — больше не воспроизводится после изменений в `main.dart`. Старт приложения теперь упирается в последующие ошибки (codesign → AppAuth), но UI блокировки нет.
2. **Codesign «resource fork / Finder information»** — частично обходится: при debug Flutter пропускает codesign, Xcode до подписывает, но в окружении пользователя `com.apple.provenance` навешивается мгновенно (даже на `mktemp`-файлы). Это системный фактор (скорее всего, включена функция Xcode/ventura Gatekeeper или корпоративный профиль). Пока не решено, нужно проводить очистку на уровне тома или отключать источник атрибута.
3. **AppAuth module** — после снятия кастомного pod `AppAuth` и повторной установки Pods возникла ошибка «Clang dependency scanner failure: Unable to find module dependency: 'AppAuth'». Скорее всего, из-за статической линковки (`use_frameworks! :linkage => :static`) + `GTMAppAuth` ожидает динамический модуль. Надо либо вернуть `AppAuth` как `:modular_headers => true`, либо добавить `s.static_framework = true` через пост-скрипт. Это отдельная задача.

### 5. Что ещё предстоит сделать
1. **Разобраться с системным добавлением xattr** — проверить Security & Privacy → System Integrity Protection, профили MDM, `com.apple.provenance` обычно включается через Apple System Integrity, возможно, нужно выключить File Quarantine (`xattr -w com.apple.quarantine ""`). Без решения подпись и TestFlight могут страдать.
2. **Переустановить Pods/AppAuth** — рассмотреть сценарий без `use_frameworks! :linkage => :static` (вернуться к динамическим фреймворкам либо изолировать GTMAppAuth в podspec). Альтернатива: использовать `google_sign_in_ios` ≥ 6.0.4, который не требует AppAuth.
3. **Повторить `flutter run` на проводном подключении** — последнее выполнение остановилось на «Waiting for iPhone 15 (E) to connect…» (wireless). Нужно убедиться, что устройство подключено по USB, чтобы получить свежие логи.
4. **Документировать изменения** — в `docs/status.md` добавлены записи «startup-bootstrap fix» и «iap-store-fix fix», но надо будет внести итог по codesign/AppAuth, когда найдём стабильное решение.

### 6. Выводы
- Первопричина черного экрана — комбинация блокирующих инициализаций (Supabase, Hive) до `runApp` + ошибки bootstrap, а не Firebase bundle или IAP.
- В процессе были обнаружены сопутствующие инфраструктурные проблемы: конфликт AppAuth, системный атрибут `com.apple.provenance`, необходимость обновить Flutter tooling.
- На данный момент критический блокер — повторная настройка AppAuth и окончательное решение по extended attributes. После этого можно будет снова запускать приложение на устройстве и приступить к проверке Firebase push/StoreKit 2.

