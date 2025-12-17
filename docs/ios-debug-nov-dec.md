## Финальный сводный отчёт: iOS запуск/зависания/уведомления (17.11–13.12.2025)

### 0) TL;DR — текущее состояние на конец этапа
- **Запуск iOS**: приложение **стартует без зависаний**, LaunchScreen больше не держится из‑за `await`/инициализаций до первого кадра.
- **Пуши**: Firebase/FCM **удалены**. Пуши работают через **OneSignal**. На iOS отключён авто‑init плагина — OneSignal поднимается **только по нашей логике**.
- **Оплата**: iOS — **StoreKit 2** через нативный `StoreKit2Bridge`; Android — `in_app_purchase`. Установка каналов StoreKit2 на iOS сделана **ленивой** (не на cold start).
- **Sentry**: **не удалён** и не «вырезан». Работает, если DSN задан и `DISABLE_SENTRY!=true`. Асинхронный нативный init отключён (по логам: `Async native init disabled`). Остался небольшой I/O на main при старте Sentry (создание каталога/лог‑файла) — не блокирует UI.
- **Сборка (Xcode)**: ускорили инкрементальные билды — `tool/apply_plugin_patches.dart` стал **идемпотентным** (не переписывает файлы плагинов, если контент не изменился), чтобы не инвалидировать кеши Pods на каждом билде.
- **Осталось**: 
  - В логах всё ещё встречается `SKPaymentQueue` (скорее всего системная активность StoreKit/purchase intents либо косвенный вызов — нужна точная атрибуция, но это **не блокирует запуск**).
  - OneSignal иногда пишет `... External ID nil ...` — нужно корректно привязать пользователя (`OneSignal.login/logout`) после auth.

### 0.1) Зафиксированный стек и версии (для воспроизводимости)
По состоянию ветки `ios-prelaunch-with-design` (фиксировали по `ios/Pods/Manifest.lock` и `Podfile.lock`):
- **onesignal_flutter**: `5.3.4`
- **OneSignalXCFramework**: `5.2.14`
- **sentry_flutter**: `9.8.0`
- **Sentry/HybridSDK** (Pods): `8.56.2`
- **GoogleSignIn**: `9.0.0` (+ **AppAuth** `2.0.0`)
- **CocoaPods**: `1.16.2`

### 0.2) Ключевые настройки/флаги, влияющие на старт
- `ios/Runner/Info.plist`:
  - `SentryAsyncNativeInit = false` (иначе часто ловили `Main Thread Checker`/нестабильный поток старта Sentry).
  - `OneSignalAppID = $(ONESIGNAL_APP_ID)` (ID берётся из build settings; реальная инициализация теперь управляется из Dart).
- `DISABLE_SENTRY`:
  - можно передать как `--dart-define=DISABLE_SENTRY=true` или через env (`.env`) — Sentry останется в проекте, но не будет инициализироваться.
- `DISABLE_MAIN_THREAD_IO_MONITOR`:
  - если установить env‑переменную, выключит `MainThreadIOMonitor` (на этапе диагностики держим включённым).
- `DISABLE_IOS_FIREBASE`:
  - используется как «страховка» в Podfile/скриптах (Firebase сейчас удалён, но флаг оставляли как защитный механизм на время миграции).

### 0.3) Почему «правки откатывались при сборке» (важно понимать)
Мы наблюдали не «магический откат», а работу генераторов/скриптов:
- **CocoaPods** пересоздаёт `ios/Pods/**` при `pod install`.
- Flutter пересоздаёт `ios/Runner/GeneratedPluginRegistrant.m` при регенерации плагинов.
- В проекте есть build phases, которые намеренно правят файлы:
  - **`Flutter Pub Get`**
  - **`Strip In-App Purchase Plugin`** (запускает `tool/strip_iap_from_registrant.dart`)
  - **`Run Script`** (запускает `dart run tool/apply_plugin_patches.dart`)
  - **`[CP] Check Pods Manifest.lock`** (падает, если `Pods/Manifest.lock` отсутствует)

Правило этапа: **не лечим проблемы правками в Pods**, всё устойчивое — либо в исходниках проекта, либо в наших скриптах/конфигах.

---

### 1) Исходные симптомы (что болело)
С конца ноября 2025 на iOS наблюдались повторяющиеся проблемы:
- **Чёрный/белый экран на старте** после обновления Flutter (описано в `docs/black-screein-ios-17-11.md`).
- **Долгий cold start / «зависание на LaunchScreen»**: первый кадр не появлялся десятки секунд.
- **Фризы на логине и экранах**, которые косвенно зависели от auth‑состояния (вплоть до вечного loading).
- **Зависание/нестабильность экрана уведомлений** (race с Hive/launch-route и ранними вызовами сервиса уведомлений).
- **Падения сборки/нестабильность после откатов**:
  - `Pods/Manifest.lock: No such file or directory` → `The sandbox is not in sync...`
  - периодические ошибки/дубли Pods после чисток
  - `pod install` мог падать на locale/encoding.

---

### 2) Инструменты диагностики, которые реально помогли
- **MainThreadIOMonitor (наш iOS хук)**: показывал, где именно выполняются синхронные операции на главном потоке (`NSFileManager`, `NSData`, `NSBundle`, `dlopen`).
- **Main Thread Checker** (UIKit API на background thread): ловил некорректный поток инициализации.
- **Сравнение таймингов между стадиями**: момент `UIApplicationMain`, создание сцены (`SceneDelegate`), момент появления Flutter‑логов и «первого кадра». Это позволило отделить:
  - «нелепо ранние» вызовы (до UI loop)
  - «слишком поздние» (после регистрации плагинов)
  - «блокирующие на стороне Flutter» (await до `runApp`, провайдеры, которые ждут stream).

---

### 3) Корневые причины (почему вообще возникали фризы)

#### 3.1 Блокировка первого кадра из‑за `await` до `runApp()`
Любые тяжёлые операции до `runApp()` удерживают LaunchScreen. В нашем случае это были:
- `dotenv.load()`
- `SupabaseService.initialize()`
- `Hive.initFlutter()` и связанные действия
- prewarm/init Sentry

**Итог**: первый кадр не появлялся быстро → ощущение «приложение зависло».

#### 3.2 Блокирующие Riverpod‑цепочки вокруг auth (вечные ожидания)
Критическая ошибка из декабрьских логов/анализа (см. `docs/ios-launch-notifiication-problems(dec.07).md`):
- использование `await ref.watch(authStateProvider.future)` (или даже `ref.watch(authStateProvider)` в неподходящем месте)
- `authStateProvider` — это StreamProvider; `.future` ждёт первое событие → при плохой сети/отсутствии эмита UI мог «вечно грузиться».

**Итог**: GoRouter/провайдеры зависали, UI не строился.

#### 3.3 Нативный ранний init (Firebase/плагины) и iOS 13+ Scene Lifecycle
Исторически проблема усиливалась тем, что на iOS 13+:
- `SceneDelegate` может быть вызван до `didFinishLaunchingWithOptions`.
- если какой‑то SDK/плагин ожидает наличие конфигурации (например Firebase) **до регистрации Flutter‑плагинов**, а мы конфигурируем позже — получаем ошибки типа `No app has been configured` и задержки/ретраи.

На ранних этапах это приводило к серии неправильных попыток:
- `+load`/`constructor`/`main.m` — «слишком рано» → I/O до UI loop → чёрный экран.
- `didFinishLaunching...` — «слишком поздно» для сцен/плагинов → ошибки и ретраи.

#### 3.4 Самооткаты/самоповреждение из‑за автопатчей
Отдельный класс проблем (подробно раскрыт в старых черновиках):
- правки в `ios/Pods/**` **неустойчивы** (перегенерация при `pod install`).
- при наличии нескольких уровней автопатча (Podfile hooks + Xcode build phases + Dart‑скрипт) возможны конфликты.

**Вывод этапа**: мы перестали опираться на «редактирование Pods как источник правды».

---

### 4) Что пробовали (и почему часть попыток провалилась)

#### 4.1 Ноябрь: «чёрный экран» и борьба с ранним I/O
По `docs/black-screein-ios-17-11.md`:
- Пробовали сверхранний Firebase init (`+load`, `constructor`, `main.m`) — это уменьшало часть ошибок Firebase, но ухудшало основной симптом: **main thread I/O до запуска UI loop**.
- Отключали/включали FCM, пробовали deferred‑регистрации — но причина оказалась не только в FCM, а в сумме тяжёлых инициализаций.

**Почему не сработало**: перенос «всё инициализировать раньше» лечил одну ошибку, но делал старт тяжелее и более хрупким.

#### 4.2 07.12: после отката — билд/рантайм проблемы и цепочка фризов
По `docs/ios-launch-notifiication-problems(dec.07).md`:
- Билд валился из‑за сломанного патча Sentry в Podfile → временно отключали этот патч.
- Чёрный экран от раннего bootstrap Firebase (`FirebaseEarlyInit.m` + `main.m`).
- После удаления раннего init появились ошибки «слишком поздно для SceneDelegate».
- Затем выявили блокировку на стороне Flutter: `await authStateProvider.future` + `Sentry init до runApp()`.
- Затем словили `HiveError` из‑за чтения launch-route в `build()` до `Hive.initFlutter()`.

**Почему это важно**: этот этап показал, что проблема была многослойной: часть в iOS lifecycle, часть в Riverpod, часть в Sentry, часть в notifications/Hive.

#### 4.3 10–13.12: «устойчивый старт без правок Pods» + финализация порядка инициализаций
Ключевые решения этого подпериода:
- **Firebase удалён** (Dart/Pods/регистрант) → снимаем пласт раннего I/O и конфликтов `I-COR*`.
- **OneSignal** внедрён как единый пуш‑провайдер:
  - допатчили `onesignal_flutter` (исправляли ObjC warning’и, а затем отключили iOS auto‑init в `registerWithRegistrar`).
- **Sentry стабилизировали**:
  - перестали патчить Sentry внутри `ios/Pods/**` (это и было источником «самоповреждения» и неустойчивости),
  - отключили `SentryAsyncNativeInit`,
  - перенесли инициализацию Sentry после первого кадра (post‑frame).
- **IAP/StoreKit2Bridge**:
  - StoreKit2 мост оставили (для iOS платежей),
  - установку каналов StoreKit2 сделали ленивой (не на cold start).
- **Инфраструктура сборки**:
  - типовые поломки Pods лечили «жёсткой чисткой»: `flutter clean`, удаление `ios/Pods`, затем `pod install` с корректной locale (иначе ловили `Encoding::CompatibilityError`).

---

### 5) Что сработало и закреплено в коде (итоговые решения)

#### 5.1 Стратегия «первый кадр сразу» (перестали держать LaunchScreen)
Сделано:
- `runApp()` вызывается **сразу**.
- тяжёлые операции перенесены в контролируемый bootstrap внутри Flutter (`appBootstrapProvider`) и в post‑frame (`_schedulePostFrameBootstraps`).
- убраны блокирующие ожидания в провайдерах/роутере.

#### 5.2 Уведомления: убрали race с Hive
Сделано:
- `Hive.initFlutter()` выполняется в bootstrap, а обработка launch-route (из локального хранилища) — **после** bootstrap.
- убран анти‑паттерн `FutureBuilder` для критичных операций в `build()`.

#### 5.3 OneSignal вместо Firebase/FCM + контроль порядка запуска
Сделано:
- Firebase зависимости удалены из Dart/Pods.
- Push‑логика переведена на OneSignal.
- **Ключевой момент**: iOS‑плагин `onesignal_flutter` раньше делал авто‑init в `registerWithRegistrar`.
  - Мы отключили авто‑init на стороне iOS плагина (через `tool/apply_plugin_patches.dart`), чтобы OneSignal поднимался только по нашей логике.

#### 5.4 StoreKit 2: мост + ленивый native install
Сделано:
- iOS покупки обслуживаются через `StoreKit2Bridge` (Swift + MethodChannel/EventChannel).
- `StoreKit2Bridge` **не устанавливается на cold start**. Он устанавливается по запросу из Dart через `bizlevel/native_bootstrap`.

#### 5.5 Стабильность сборки и «источник правды» для патчей
Сделано:
- Все правки, которые должны переживать `flutter clean`, `pub get`, `pod install`, вынесены в **детерминированный скрипт** `tool/apply_plugin_patches.dart`.
- Избавились от подхода «чинить Pods руками».

### 5.6) Критичные провалы, которые мы больше не повторяем (и почему)
- **Править Sentry в `ios/Pods/**`**:
  - это нестабильно (перегенерация),
  - и уже приводило к критическим дефектам (в прошлых итерациях встречались некорректные патчи, вплоть до рекурсивных helper‑функций).
  - **итог**: только конфигурация/порядок init, либо форк/версия зависимости, но не «строковые патчи Pods».
- **Делать `await` до `runApp()`** (для всего тяжёлого):
  - **итог**: UI должен появляться сразу, остальное — bootstrap/post-frame.
- **Ждать `StreamProvider.future` для auth‑состояния**:
  - **итог**: читаем `Supabase.instance.client.auth.currentSession` синхронно, а обновления — подпиской без блокировки.

### 5.7) Таблица: «что ломалось → что пробовали → почему не работало → как исправили»
| Симптом/проблема | Неудачные попытки | Почему не работало | Итоговое решение (что оставили) |
|---|---|---|---|
| LaunchScreen держится, «приложение зависло» | `await` тяжёлых init до `runApp()` | Первый кадр не рисуется, iOS остаётся на LaunchScreen | `runApp()` сразу + bootstrap внутри Flutter (`appBootstrapProvider`) + post-frame для тяжёлого |
| Чёрный экран после обновлений | Сверхранний init (через `+load/constructor/main.m`) | I/O до UI loop → main thread hang | Отказ от раннего init как стратегии; в финале Firebase убрали целиком |
| Белый экран / «слишком поздно для SceneDelegate» (исторически) | Перенос критичного init в `didFinishLaunching` | На iOS 13+ `SceneDelegate`/регистрация плагинов может идти раньше | В финале ушли от Firebase и от зависимости плагинов от него; общий принцип: критичные зависимости должны быть готовы до регистрации плагинов |
| Вечный loading/фризы на auth‑экранах | `await ref.watch(authStateProvider.future)` | StreamProvider может не эмитить «первое событие» сразу → ожидание без конца | Синхронное чтение `currentSession`, подписка без блокировки, явная инвалидация провайдеров после логина |
| HiveError/фриз уведомлений | `FutureBuilder` в `build()` вызывает чтение launch-route до init | Race: build может выполниться раньше инициализации Hive | Обработка launch-route после bootstrap; безопасный `NotificationsService` (null/try-catch) |
| Sentry ломает старт/нестабилен | Патчить `ios/Pods/Sentry/**`, включать async init | Pods перегенерируются, патчи хрупкие; async init даёт поточные проблемы | `SentryAsyncNativeInit=false`, init после первого кадра, без патчей Pods |
| OneSignal стартует раньше, чем надо | Auto-init в iOS плагине при регистрации | Плагин сам вызывает initialize до нашей логики | Отключили auto-init в `onesignal_flutter` (патч скриптом), старт OneSignal контролируем после auth |
| `Pods/Manifest.lock` missing / sandbox not in sync | Собирать без `pod install`/не через workspace | `[CP] Check Pods Manifest.lock` падает | Всегда `pod install`, открывать `Runner.xcworkspace` |
| StoreKit1 (`SKPaymentQueue`) в логах | «вырезать» `in_app_purchase_storekit`/не трогать IAP | Часть активности может быть системной (purchase intents) | Оставили: iOS через StoreKit2Bridge + lazy install; источник `SKPaymentQueue` требует отдельной атрибуции |

---

### 6) Что видно по последним логам (после P0/P2)
- **Запуск без зависаний** подтверждён.
- **Sentry запускается** (логи `SentryFlutterPlugin ... started` присутствуют).
- **OneSignal сеть есть** (это ожидаемо после нашей инициализации), но есть warning про External ID nil — это функциональная донастройка.
- **StoreKit2Bridge не ставится на cold start** (нет `StoreKit2Bridge: channels installed`), но при этом `SKPaymentQueue` всё ещё пишет логи.

#### 6.1) 14.12 — свежие логи `docs/draft-2.md` / `docs/draft-4.md` / `docs/draft-3.md` (контрольная точка)
- **KPI старта (draft-2)**:
  - `STARTUP[ui.bootstrap.first_frame] {t_ms: 172}` — первый кадр быстрый.
  - `STARTUP[bootstrap.done] {t_ms: 190}` — базовый bootstrap лёгкий.
  - `STARTUP[postframe.local_services.start] {t_ms: 434}` → `...ok {t_ms: 434}` — postframe задачи **не блокируют**.
  - `STARTUP[postframe.launch_route.ok] {t_ms: 708}` — чтение launch-route занимает ~274ms (не критично, но это единственный заметный I/O‑кусок в postframe).
- **Клавиатура (draft-4)**:
  - фиксируется микро‑hang `Hang detected: 0.26s` **в момент первого ввода**, но с пометкой `debugger attached, not reporting`.
  - рядом идут системные предупреждения `Performance Diagnostics` про main-thread I/O (`NSBundle bundlePath`, `NSData initWithContentsOfFile`, `dlopen`). По стекам/контексту это выглядит как iOS TextInput/AssistantServices (а не Flutter‑код), но если “первая буква” будет лагать и в Release без дебаггера — нужно профилировать отдельно.
  - встречается `Unable to simultaneously satisfy constraints` в `TUIKeyboard...` — чаще системный шум, но совпадает по времени с первым показом клавиатуры.
- **Сборка (draft-3)**:
  - ожидаемо дорого: `[CP] Copy XCFrameworks` + `Embed Pods Frameworks` + множественные `codesign` на OneSignal XCFramework (в Release это “тяжёлое место”).
  - ранее в логах было видно, что `tool/apply_plugin_patches.dart` “шумел” и переписывал плагины, что могло замедлять инкрементальные билды — сейчас патчер сделан идемпотентным.

---

### 7) Что осталось доделать (остаточные задачи этапа)

#### 7.1 OneSignal: привязка пользователя (высокий приоритет, но не блокер запуска)
Симптом:
- `WARNING: OneSignalUserManagerImpl.startNewSession() ... External ID nil ...`

Нужно:
- После успешной авторизации: `OneSignal.login(<userId>)`
- При logout: `OneSignal.logout()`

Это стабилизирует сессию OneSignal и уберёт warning.

#### 7.2 `SKPaymentQueue` в логах (средний приоритет)
Сейчас по логам:
- `SKPaymentQueue` активируется на старте, даже когда `StoreKit2Bridge` ещё не установлен.

Что это означает:
- либо это системная активность StoreKit (purchase intents/обновление storefront),
- либо где‑то всё ещё косвенно дергается StoreKit1 API.

Рекомендованный следующий шаг (в отдельном этапе):
- добавить точечную диагностику, чтобы понять, кто инициатор (и только затем принимать решение «можно ли убрать полностью»).

#### 7.3 Sentry: I/O на main в начале (низкий/средний приоритет)
По логам остаётся создание директории/файла под кэш/лог.
- Это **не вызывает фризов**, но оставляет шум в MainThreadIOMonitor.
- Опционально можно:
  - переносить инициализацию Sentry ещё позже (после показа первого реального экрана),
  - или менять настройки Sentry, если потребуется «идеально чистый старт».

#### 7.4 Smoke‑проверка оплаты после “lazy StoreKit2Bridge” (обязательно)
Нужно в следующем прогоне:
- зайти на экран магазина/restore
- убедиться, что в логах появляется `installStoreKit2Bridge` и затем StoreKit2 работает.

#### 7.5 Инкрементальная сборка Xcode (опционально, если снова будет “долго”)
Если вернётся ощущение “каждый билд как чистый”, то следующий шаг — не в коде Flutter, а в Xcode build phases:
- проверить, что `Run Script` (apply_plugin_patches) и другие скрипты не помечены как always‑run без необходимости (outputs/“Based on dependency analysis”).
- сохранить правило: **патчи должны быть детерминированными и идемпотентными**, иначе Xcode будет пересобирать Pods.

---

### 8) Практические правила, чтобы не вернуться к этой проблеме
1) **Не правим `ios/Pods/**` руками** как способ фикса.
2) Любая правка, которая должна пережить `pub get / pod install`, делается через `tool/apply_plugin_patches.dart`.
3) В Xcode всегда открываем **`ios/Runner.xcworkspace`**.
4) После крупных изменений: `flutter clean → flutter pub get → (ios) pod install → apply_plugin_patches`.
5) Весь «тяжёлый» init — только после первого кадра (post‑frame) или после auth.
6) Если Xcode падает на `[CP] Check Pods Manifest.lock` / `sandbox is not in sync`:
   - выполнить `cd ios && pod install` (не собирать с «поломанными» Pods),
   - убедиться, что открыта именно `.xcworkspace`, а не `.xcodeproj`.
7) Если `pod install` падает на `Encoding::CompatibilityError`:
   - запускать с locale: `LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install`.
8) После `flutter pub get` (или обновления зависимостей) обязательно убедиться, что отработал `dart run tool/apply_plugin_patches.dart`
   (вручную или через Xcode build phase `Run Script`).

---

### 9) Ключевые файлы/узлы, которые были затронуты в этом этапе
- `lib/main.dart` — порядок старта, bootstrap/post-frame, обработка launch-route, deferred init.
- `lib/services/push_service.dart` — OneSignal init/permission/listeners/token registration.
- `tool/apply_plugin_patches.dart` — устойчивые патчи (включая отключение OneSignal auto-init, прюнинг StoreKit1).
- `ios/Runner/NativeBootstrapCoordinator.swift` — ленивый install StoreKit2Bridge по запросу.
- `lib/services/storekit2_service.dart` — `_ensureNativeBridgeInstalled()` перед вызовами StoreKit2.
- `lib/services/iap_service.dart` — iOS через StoreKit2Service, Android через InAppPurchase.

---

### 10) Заключение
Мы закрыли этап «приложение не запускается / висит / долго грузится / ломается после pod install» за счёт:
- правильного порядка первого кадра,
- снятия блокировок в Riverpod/auth,
- отказа от Firebase на iOS (миграция пушей на OneSignal),
- отказа от редактирования Pods как стратегии,
- ленивых инициализаций (OneSignal контролируемо, StoreKit2Bridge по требованию).

Остаточные пункты (OneSignal externalId, природа `SKPaymentQueue`, косметика по Sentry I/O) не блокируют старт, но должны быть доведены в следующем отдельном цикле.
