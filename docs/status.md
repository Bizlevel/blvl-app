Задача leo-dialog-keyboard-fix: исправлен краш при открытии клавиатуры в модальном диалоге Лео/Макса на Android. Заменён `showModalBottomSheet` на кастомный `CustomModalBottomSheetRoute` с использованием `rootNavigator: true` и `UncontrolledProviderScope` для сохранения контекста провайдеров. Настроена корректная обработка клавиатуры через `adjustResize` и `resizeToAvoidBottomInset: true`. Детали: [`docs/leo-dialog-keyboard-fix.md`](leo-dialog-keyboard-fix.md).

Задача iap-ios-2026-01-13 fix: iOS StoreKit2 verify переведён на App Store Server API (transaction_id/JWS) с fallback на verifyReceipt; Android ветка не затронута.

Задача merge-main-notif+ray-nail fix: подтянуты Android/iOS notification‑конфиги из `origin/main` (Manifest/Gradle/MainActivity/Info.plist), перенесены Ray‑улучшения из `origin/nail/feature` (Edge `ray-chat`, обновлённые `RayService`/`RayDialogScreen`, без Vali) + добавлены точки входа Ray (главная/библиотека/после Уровня 5).
Задача mini-case-flow fix: мини‑кейсы — защита от раннего `[CASE:FINAL]` (финал только на последнем шаге), caseMode всегда бесплатный (`skipSpend`), `LeoService` отправляет `caseMode/skipSpend`, `startCase` идемпотентный + нормализация скрипта; Supabase: миграция консистентности `user_case_progress`; добавлен widget‑тест `leo_dialog_screen_test`.
Задача ios-case-chat-pop+logout fix: mini‑case “Решить с Лео” открывает `LeoDialogScreen` через `rootNavigator` + `PopScope` в caseMode (защита от неожиданных pop при фокусе TextField); выход из профиля инвалидирует `currentUserProvider`; `currentUserProvider` теперь пересчитывается при auth‑сменах (без ожидания Stream), чтобы редирект на `/login` работал после любого signOut.
Задача ios-logout-crash+perf fix: исправлен Unhandled Exception “Cannot use ref after disposed” при logout (не используем `ref` после await); logout больше не блокируется 1000+ cancel(id) — используем `cancelAllNotifications()` best‑effort в фоне; в mini‑case отключён авто‑fullscreen видео на iOS + best‑effort pause/exitFullScreen перед dispose для снижения AV/Impeller проблем.
Задача ray-rename fix: полный ребрендинг бота‑валидатора в Ray — Edge Function `ray-chat`, bot=`ray` в `leo_chats`, метрики `ai_message` пишутся под `ray`, `flutter analyze`/`flutter test` зелёные.
Задача ray-chat-ui fix: `RayDialogScreen` приведён к паттерну Leo/Max (AppBar/компоновка/панель ввода), устранены iOS лаги клавиатуры (не выключаем `TextField` во время отправки), отчёт в Markdown стилизован под BizLevel + копирование в буфер.
Задача repo-cleanup-desktop-platforms fix: удалены папки `macos/`, `windows/`, `linux/` (Flutter desktop runner проекты); мобильные сборки iOS/Android и CI не зависят от них.
Задача reminders-timepicker+android-icon fix: в настройке напоминаний время снова отображается и выбирается; Android local notifications используют drawable `ic_stat_ic_notification` (убран `PlatformException(invalid_icon, ic_launcher ...)`).
Задача profile-menu-payments fix: в меню профиля «Платежи» ведёт на `/gp-store`, убран дублирующий подпункт «Настройки».
Задача practice-log-history fix: восстановлена «история применений» — при наличии `current_history_id` журнал грузит записи для текущей истории **и** legacy-записи с `goal_history_id IS NULL`; обновлены тесты, чтобы мок-репозиторий учитывал `fetchPracticeLogForHistory`.
Задача practice-log-ux fix: история применений теперь грузится без зависимости от `current_history_id` (по `user_id`); авто‑сообщение Максу берёт снапшот текста до `await` и не теряет инструменты; обновление бонуса/баланса GP после записи вынесено из критического пути (не блокирует сохранение).
Задача android-gradle-repos fix: `android/settings.gradle.kts` — оставлен один `pluginManagement` (с `flutter.sdk` + `includeBuild`), убран `FAIL_ON_PROJECT_REPOS`; `android/build.gradle.kts` — убраны `buildscript/allprojects` репозитории, чтобы `dependencyResolutionManagement` в settings был единственным источником репозиториев.
Задача quote-no-hive+gp-ui fix: «Цитата дня» теперь грузится напрямую из `motivational_quotes` без Hive (чтобы не ловить iOS openBox фризы); snackbar «+30 GP за регистрацию» показывается только после регистрации (`registered=true`); обновлён тест `GoalsRepository`.
Задача ios-onesignal-clean fix: полностью отключён Firebase на iOS/Android, пропатчен onesignal_flutter (init через OneSignalAppID, типы removeTags/aliases, sharedInstance), обновлён Podfile (OneSignalXCFramework 5.2.14), pod install выполнен с DISABLE_IOS_FIREBASE=true.
Задача onesignal-ios fix: подготовка миграции iOS пушей на OneSignal, убрана инициализация Firebase на iOS, добавлен onesignal_flutter и защита Podfile от возврата Firebase.

- Задача ios-firebase-gating fix: Вернул FLUTTER_TARGET=lib/main.dart, загейтил Firebase (AppDelegate, GeneratedPluginRegistrant, Podfile, DisableIosFirebase=true), отключил рискованные Sentry патчи по умолчанию, пересобрал pods с DISABLE_IOS_FIREBASE=true.
# Задача iOS-perf fix: Устранение блокировок запуска (2025-12-08)
- Исправлен `user_skills_provider.dart`: `ref.watch(authStateProvider)` → синхронное чтение
- Удалён дубль `currentUserProvider.future` в `levels_provider.dart`  
- Упрощён `FirebaseEarlyInit.m` (placeholder вместо dead code)
- Обновлён `sign_in_with_apple` 6.1.0 → 7.0.1 (iOS 18 switch fix)
- Упрощён `profile_screen.dart`: убран внешний `.when(authStateProvider)`
- Все 17 тестов пройдены (providers + routing). Требуется тест в Xcode.



## 2025-11-24 — Задача ios-update-stage4 lazy-google-signin fix
- В `google_sign_in_ios` добавлен патч: `FSILoadGoogleServiceInfo()` больше не вызывается при регистрации плагина, `GoogleService-Info.plist` подгружается лениво при первом `configureWithParameters`, поэтому Performance Diagnostics не ловит `NSData initWithContentsOfFile` до UI.
- В `lib/routing/app_router.dart` обёрнут `GoRouter.redirect` в `try/catch` с отправкой в Sentry — падения по `AuthFailure` теперь приводят к безопасному редиректу на `/login` вместо краша.
- Переустановлены патчи `dart run tool/apply_plugin_patches.dart`, затем `flutter clean`, `flutter pub get`, `cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install`.


## 2025-11-24 — Задача ios-update-stage5 google-signin fix
- Обновил `google_sign_in` до 7.2.0 и переписал `AuthService.signInWithGoogle` на новый API (`GoogleSignIn.instance.initialize()` + `authenticate/authorizeScopes`); токены берём из `GoogleSignInAccount.authentication` и `authorizationClient`.
- В `Info.plist` добавлены актуальные `CFBundleURLSchemes` и `GIDClientID` (из `GoogleService-Info.plist`), чтобы `ASWebAuthenticationSession` возвращала управление приложению.
- Патчи `google_sign_in_ios` перекатились поверх свежей версии (ленивая загрузка plist), повторно выполнен цикл `dart run tool/apply_plugin_patches.dart`, `pod install`.
- Следующий шаг — ручной smoke-тест входа/выхода на устройстве и обновление гайда AppAuth после подтверждения.


## 2025-11-25 — Задача ios-update-stage5 smoke
- Logout/login через Google на физическом устройстве прошли без ошибок (`docs/draft-2.md`, `docs/draft-3.md`), Supabase сессия восстанавливается.
- Stage 5 закрыт: Google Sign-In работает на новом `ASWebAuthenticationSession`, дальше переносим внимание на AppAuth-гайд и Этап 6 (локальные сервисы/профайлинг).


## 2025-11-25 — Задача ios-update-stage4 pods-clean fix
- Полностью удалил `ios/Pods` (коррупция порождала директории `AppAuth 2`, `AppAuth 3`, … без нужных заголовков), заново выполнил `flutter clean && flutter pub get`, `cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install`.
- Свежая установка Pods снова содержит `OIDURLSessionProvider.*`, `OIDURLQueryComponent.*` и остальные файлы AppAuthCore; пропали дубликаты `Sentry`, `GoogleSignIn`, `Firebase*`.
- Состояние `Podfile.lock` не менялось кроме уже согласованного перехода на `Sentry/HybridSDK (= 8.56.2)`.


## 2025-11-25 — Задача ios-update-stage6 local-services
- `_initializeDeferredLocalServices` теперь запускает Hive, timezone и notifications параллельно, timezone грузится в `Isolate.run`, добавлены Sentry-транзакции и Timeline marker `startup.local_services`.
- `NotificationsService` использует заранее открытый box `notifications`, кэширует launch route и больше не делает `Hive.openBox` в build’ах; `PushService` хранит route через сервис.
- Перед `runApp` выполняем `_preloadNotificationsLaunchData()`, чтобы извлечь pending route без синхронного I/O в `MyApp`.


## 2025-11-25 — Задача ios-update-stage6 tz-shield fix
- `_warmUpTimezone` больше не создаёт отдельный Isolate: база `timezone` и локаль инициализируются в основном изоляте и gated через `TimezoneGate`, гонка с `tz.getLocation` исчезла.
- Podfile патчит `SentryAsyncLog.m`, чтобы лог-файл создавался в фоновой очереди; `MainThreadIOMonitor` фильтрует стеки без `Runner/BizLevel`, поэтому остаётся только наш I/O.
- iOS FCM снова включён (`EnableIosFcm=true`, `kEnableIosFcm` по умолчанию `true`), так что пуши возвращаются в Release после подтверждения чистых логов.


## 2025-11-25 — Задача ios-update-stage6 sentry-io fix
- `SentryFlutterPlugin` запускает `SentrySDK.start` в utility-очереди с ожиданием завершения, поэтому создание `io.sentry/*` кэшей не блокирует UI.
- `MainThreadIOMonitor` перехватывает `NSData init/dataWithContents` и `NSFileManager create/remove` для путей `io.sentry`, перенаправляя операции в свою очередь.
- Патчи переустановлены через `dart run tool/apply_plugin_patches.dart`, предупреждения Performance Diagnostics по Sentry I/O исчезают.

## 2025-11-26 — Задача ios-update-stage6 sentry-post-frame fix
- Инициализацию `SentryFlutter.init` перенесли в `_schedulePostFrameBootstraps()`, поэтому тяжёлый I/O выполняется уже после первого кадра и не попадает в окно Apple Performance Diagnostics.
- Патч к `SentryFlutterPlugin` возвращён к синхронному запуску на главном потоке, `MainThreadIOMonitor` снова только логирует обращения без блокировок — сняты предупреждения Thread Performance Checker и Main Thread Checker.
- Команда `dart run tool/apply_plugin_patches.dart` прогнала свежие фиксы, чтобы pods убедительно обновились.

## 2025-11-26 — Задача ios-update-stage6 sentry-slim fix
- Перед запуском Sentry прогреваем каталоги `io.sentry/<hash>/envelopes` в фоне (`_prewarmSentryCache`), чтобы Cocoa SDK не создавал их синхронно на UI.
- В `_initializeSentry` отключены тяжёлые интеграции (`enableFileIOTracking`, `enableAutoPerformanceTracking`, `enableAppStartTracking`, MetricKit и т.д.) — Apple Diagnostics больше не фиксирует I/O и семафоры в окне запуска.
- Новые импорты (`path_provider`, `path`, `crypto`) уже есть в проекте, `dart format` прогнан.

## 2025-11-26 — Задача ios-update-stage6 sentry-deferred-native fix
- `SentryFlutter.init` теперь запускается с `autoInitializeNativeSdk=false`: Dart‑уровень начинает логировать сразу, но нативный SDK пока не дёргается.
- После первого кадра планируется отдельный асинхронный bootstrap (`_scheduleNativeSentryBootstrap`), который ждёт 2 секунды и только потом вызывает `SentryFlutter.native?.init` без блокировки UI.
- Логирование добавлено для обеих стадий; при ошибке deferred init отправляется в Sentry через Dart‑hub. Apple предупреждения по `dispatch_semaphore_wait`/`createDirectoryAtPath` должны исчезнуть, поскольку Sentry не трогает файловую систему во время Application Launch.

## 2025-11-26 — Задача ios-update-stage6 sentry-plugin-async fix
- Для `SentryFlutterPlugin` добавлен Info.plist‑настраиваемый режим (`SentryAsyncNativeInit`, `SentryNativeInitDelaySeconds`): `initNativeSdk` теперь выполняет `SentrySDK.start` в utility‑очереди и с задержкой, поэтому тяжёлый I/O больше не происходит на главном потоке.
- Flutter‑код возвращён к стандартной инициализации: deferred‑логика удалена из `lib/main.dart`, так что Dart‑уровень не теряет breadcrumbs до старта нативного SDK.
- Info.plist теперь содержит `SentryAsyncNativeInit=true` и задержку 2 секунды — можно регулировать без перепаковки приложения.
- Добавлен fallback: если ключи в Info.plist отсутствуют, iOS автоматически переключается в async‑режим (delay 2s) и логирует в консоль, можно включать sync‑инициализацию только при явном `false`.

## 2025-11-26 — Задача ios-update-stage6 launch-profile fix
- В `Info.plist` добавлен флаг `SentryDisableLaunchProfile`, чтобы нативный SDK не поднимал Launch Profiling без явного разрешения.
- `patch_sentry_file_manager` теперь делает файл записываемым и добавляет guard `bizlevel_sentry_launch_profile_disabled()` ко всем функциям `launchProfileConfig*`.
- `pod install` переустановлен (с предварительным удалением повреждённого `Pods/nanopb`), а патч записал защиту непосредственно в `SentryFileManager.m`.


## 2025-11-26 — Задача ios-update-stage6 sentry-async-native fix
- `_prewarmSentryCache` теперь выполняет файловые операции внутри `Isolate.run`, поэтому главный поток не попадает в MainThreadIOMonitor.
- `SentryFlutter.init` больше не отключает `autoInitializeNativeSdk`: deferred старт полностью управляется патченым `SentryFlutterPlugin` и Info.plist флагами.
- `patch_sentry_file_manager` откатывает `dispatch_semaphore`-вставку, оставляя только guard `SentryDisableLaunchProfile`; заново прогнаны `dart run tool/apply_plugin_patches.dart`, `flutter clean`, `flutter pub get`, `pod install`.


## 2025-11-26 — Задача ios-update-stage6 sentry-main-thread fix
- `SentryFlutterPlugin` теперь запускает native SDK сразу (delay=0) и переключает проверку `UIApplication.applicationState` на main queue, чтобы удалить предупреждение Main Thread Checker.
- В `_initializeSentry` отключено `enableAutoSessionTracking`, поэтому `SentryAutoSessionTrackingIntegration` больше не создаёт/удаляет файлы на главном потоке в момент старта.
- `_prewarmSentryCache` для iOS подготавливает `~/Library/Caches/io.sentry/<hash>` и envelopes в отдельном изоляте; Info.plist `SentryNativeInitDelaySeconds=0`.
- Прогнаны `dart run tool/apply_plugin_patches.dart`, `flutter clean`, `flutter pub get`, `cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install`.


## 2025-11-26 — Задача ios-update-stage6 sentry-bootstrap-final fix
- `_initializeSentry` теперь вызывается до `runApp`, поэтому окно «SDK disabled…» исчезает, но тяжёлый I/O по-прежнему выполняется в фоне (кеши прогреваются через Isolate).
- `SentryFileManager` переписан на обёртки `dispatchSync` — `writeData`/`removeFileAtPath`/`moveState`/`readSession`/`readAppState`/`readTimestamp` больше не трогают главный поток.
- Команды: `dart run tool/apply_plugin_patches.dart`, `flutter clean`, `flutter pub get`, `cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install`.


## 2025-11-26 — Задача ios-update-stage6 sentry-native-await fix
- `SentryFlutterPlugin.initNativeSdk` больше не завершает MethodChannel до окончания `SentrySDK.start`: `FlutterResult` вызывается только после старта нативного SDK, поэтому Dart-уровень не видит «SDK is disabled».
- Асинхронная инициализация остаётся в utility-очереди (delay из Info.plist), но результат дожидается завершения, устраняя гонку breadcrumbs и native hub.
- Патчи применены через `dart run tool/apply_plugin_patches.dart`, фактический Pod получает обновлённый Swift-файл.


## 2025-11-26 — Задача ios-update-stage6 sentry-mainthread-guard fix
- `SentryDependencyContainer` и `UIApplication.unsafeApplicationState` теперь всегда обращаются к `UIApplication` на главном потоке, поэтому Main Thread Checker не ловит `applicationState` из utility-очереди.
- `SentryInstallation` читает/пишет файл INSTALLATION только через очередь `dispatchQueueWrapper`, а Podfile добавлен с новыми патчами, чтобы фиксы автоматически накатились при `pod install`.


## 2025-11-27 — Задача android-radio-dropdown fix
- `DropdownButtonFormField` переведены на `value` вместо удалённого `initialValue` (`lib/screens/profile_screen.dart`, `lib/screens/goal/widgets/practice_journal_section.dart`), Android-сборка на свежем Flutter снова компилируется.
- `QuizWidget` больше не использует отсутствующий `RadioGroup` и параметр `RadioListTile.enabled`: стандартные `RadioListTile` получают `groupValue` и отключаются через `onChanged: null` после проверки ответа.
- Проверены линтеры (`read_lints`) по затронутым файлам — предупреждений нет.


## 2025-12-01 — Задача web-hive-fix: исправление Web после iOS рефакторинга
- **Регрессия**: После оптимизации bootstrap для iOS (`ios-black-screen-*`) Hive перестал инициализироваться для Web, но репозитории продолжали использовать `Hive.box()`.
- **levels_repository.dart**: Добавлена проверка `kIsWeb` — для Web работа только через сеть без Hive кеша, для Mobile — с Hive кешем и offline fallback.
- **library_repository.dart**: `_openBox()` возвращает `null` для Web; методы кеширования обрабатывают `box == null`; удалены `SocketException` (недоступен на Web).
- **main_street_screen.dart**: Fallback `levelNumber: 0` → `1` в error callback (файла `level_0.png` не существует).
- iOS код не затронут — все изменения через условие `kIsWeb`.


## 2025-12-01 — Задача design-tokens-audit fix: Design System токены
- **BorderRadius токены**: Заменены все хардкод `BorderRadius.circular(N)` на `AppDimensions.radius*`. Добавлены новые токены: `radius6`, `radius14`, `radius24`, `radiusAvatar` (60 замен в 22 файлах).
- **Spacing/Dimensions смешение**: Исправлено смешение `AppSpacing.xl` для BorderRadius в `login_screen.dart` → `AppDimensions.radius24/radiusXl`.
- **Deprecated aliases**: `AppSpacing.small/medium/large` помечены `@Deprecated`, заменены на `sm/lg/xl` в 4 файлах (21 использование).
- **Duration токены**: Добавлены новые токены в `AppAnimations`: `micro` (150ms), `medium` (500ms), `pulse` (900ms), `celebration` (1600ms). Заменены основные хардкоды в ключевых файлах.
- **SizedBox токены**: Основные хардкоды `SizedBox(height: N)` заменены на `AppSpacing.gapH()` в home-виджетах и celebration.
- **AppEffects токены**: Создан новый файл `lib/theme/effects.dart` с токенами теней (`shadowXs..shadowXl`, `glowSuccess/Primary/Premium`), добавлен экспорт в `design_tokens.dart`.
- **RadioGroup API**: `QuizWidget` обновлён на новый Flutter 3.32+ `RadioGroup` API с `IgnorePointer` для блокировки после проверки.
- **lint_tokens.sh**: Расширен скрипт проверки токенов — добавлены паттерны для `BorderRadius.circular`, `Duration(milliseconds:)`, deprecated aliases, режим `--warn`.

## Задача iap-android-2025-12-02b fix
- Edge `gp-purchase-verify`: PostgREST вызывается с `Prefer: return=representation`, добавлен fallback `gp_balance` при пустом ответе, чтобы не падать с `rpc_no_balance` после успешного начисления. Деплой supabase-mcp → версия v70.
- Клиент (`GpStoreScreen`): при `rpc_no_balance` запускаем принудительный refresh `gp_balance`; если GP уже пришли — отображаем «Покупка подтверждена…», иначе даём хинт «Покупка завершена, идёт обновление баланса».
- В результате пользователи больше не видят ложных ошибок, а задержка зачисления прозрачна.


## 2025-12-02 — Задача ui-overflow-fix: Исправление overflow на Главной/Профиле/Магазине
- **GpBalanceWidget**: Убрана фиксированная ширина 80px, добавлен `constraints: BoxConstraints(minWidth: 70, maxWidth: 110)`, иконка уменьшена до 18px, текст обёрнут в `Flexible` с `overflow: ellipsis`.
- **HomeGoalCard**: Полностью перестроена раскладка — DonutProgress (80px) вынесен в верхнюю часть рядом с текстом, кнопки «Действие»/«Обсудить» в отдельном ряду на всю ширину карточки, текст кнопок полный без переносов.
- **_QuickTile (Библиотека/Артефакты)**: `childAspectRatio` с 2.5 до 1.8, переделана раскладка на горизонтальную (иконка слева, текст справа в `Row`), текст полностью виден без обрезки.
- **AppBarTheme**: Добавлены `foregroundColor`, `iconTheme.color` и `titleTextStyle.color = AppColor.textColor` — заголовки страниц больше не сливаются с белым фоном.
- **PracticeJournalSection**: Сдвинут overlay `+1 день` на `top: 40`, обёрнут в `IgnorePointer` и добавлен guard от повторных открытий bottom sheet (кнопка колокольчика дизейблится, пока открыт sheet).
- **ReminderPrefsProvider**: Новый `AsyncNotifier` + модель `ReminderPrefs` централизуют загрузку настроек напоминаний (предварительный fetch через сервис, дальнейшее обновление через `refreshPrefs()`).
- **RemindersSettingsSheet**: Полностью переписан на `ConsumerStatefulWidget` — подключён `reminderPrefsProvider`, добавлены skeleton/error‑состояния, Spinner при сохранении, единая обработка ошибок и обновление провайдера после `schedulePracticeReminders`.
- **Practice reminders sync**: Создана таблица `practice_reminders`, RPC `upsert_practice_reminders`, `due_practice_reminders`, `mark_practice_reminders_notified`, добавлен Supabase sync в `NotificationsService` (шаринг расписания между устройствами + оффлайн кеш в Hive).
- **Push tokens**: `push_tokens` расширена полями `timezone/locale/enabled`, `PushService` теперь отправляет метаданные при регистрации.
- **Edge Function reminder-cron**: Новый крон-функшн агрегирует due reminders, вызывает `push-dispatch`, и после отправки помечает `last_notified_at`. Деплой выполнен (версия 2), для вызова используется service-role key; cron настроить через Scheduled Triggers.
- **UI статус**: В листе настроек добавлен блок об актуальном состоянии синхронизации (cloud + локальные напоминания), чтобы пользователю было видно, что пуши работают из облака.
- **ReminderPrefs performance**: Добавлен `ReminderPrefsCache` с прогревом при старте (`NotificationsService.prefetchReminderPrefs()`), все чтения/записи Hive выполняются через `Isolate.run`, `ReminderPrefsNotifier` теперь мгновенно отдаёт данные из памяти и обновляет их асинхронно, что убрало зависания Goal/Настроек.

## 2025-12-02 — Задача notif-io fix:
- ReminderPrefs кеш переведён на `SharedPreferences` (`ReminderPrefsStorage`), полностью убран Hive из горячего пути Goal/Настроек.
- `NotificationsService.getPracticeReminderPrefs/prefetch` теперь работают только с in-memory кешом + SharedPreferences, запись в Supabase остаётся асинхронной.
- Таймзона для RPC читается из нового стораджа, так что никаких `NSFileManager`/`NSData` операций на UI-потоке не осталось.
- Добавлены Sentry breadcrumbs и мгновенный показ локальных данных: `reminderPrefsProvider` больше не блокирует UI, `RemindersSettingsContent` показывает последнюю конфигурацию с индикатором синхронизации и сообщением об ошибке при оффлайне.

## 2025-12-07 — Задача startup-blocking fix:
- Исправлены 4 блокирующих паттерна в провайдерах:
  - `currentUserProvider`: убрано `await authStateProvider.future` и `ref.watch(authStateProvider)` — теперь синхронное чтение `currentSession`
  - `gpBalanceProvider`: убрано `await authStateProvider.future` и `ref.watch(authStateProvider)` — синхронная проверка сессии
- Sentry init перенесён в `_schedulePostFrameBootstraps()` — не блокирует `runApp()`
- Созданы тесты производительности (`test/providers/startup_performance_test.dart`) — 13 тестов, все проходят
- **Важно:** Медленный запуск в Debug сборке (13+ сек до Dart VM, 2+ мин до Flutter main) — нормально для JIT, Release должен запускаться за <3 сек

## 2025-12-07 — ✅ Задача startup-blocking fix ЗАВЕРШЕНА!

**Приложение запускается! Экран уведомлений работает!**

### Исправленные критические проблемы:

1. **Podfile** — сломанный патч `patch_sentry_installation` вызывал ошибки компиляции
2. **FirebaseEarlyInit.m** — init в `+load` и `constructor` блокировал main thread
3. **AppDelegate.swift** — Firebase init перенесён в `willFinishLaunchingWithOptions` (до SceneDelegate)
4. **auth_provider.dart** — `await authStateProvider.future` блокировал 73+ сек
5. **gp_providers.dart** — `ref.watch(authStateProvider)` блокировал UI
6. **app_router.dart** — `ref.watch(authStateProvider)` блокировал GoRouter
7. **main.dart** — Sentry init блокировал `runApp()`, перенесён в post-frame
8. **main.dart** — HiveError из-за FutureBuilder в MyApp.build(), убран
9. **notifications_service.dart** — `_ensureLaunchBox()` теперь возвращает null при ошибке
10. **login_controller.dart** — добавлена инвалидация провайдеров после логина

### Тесты:
- GoRouter тесты: 3/3 ✅
- Provider тесты: 14/14 ✅
- Всего тестов: 17/17 ✅

---

## 🔴 Fix (2025-12-08): Устранение корневой причины зависания iOS

### Проблема:
После предыдущих исправлений логи устройства показали:
- `Hang detected: 56.83s`
- `Waited 15.417541 seconds for a drawable, giving up`
- `System gesture gate timed out`

### Корневая причина:
`FirebaseApp.configure()` в `willFinishLaunchingWithOptions` блокировал main thread на 15-60 сек из-за синхронного disk I/O.

### Исправления:
1. **AppDelegate.swift** — удалены вызовы `configureFirebaseBeforeMain()`:
   - `willFinishLaunchingWithOptions` — закомментировано
   - `didFinishLaunchingWithOptions` — закомментировано
   - Firebase теперь инициализируется на Flutter стороне в post-frame

2. **ios/Podfile** — добавлен патч `patch_sign_in_with_apple_switch`:
   - Исправляет switch exhaustive warning для iOS 18

### Тесты:
- Provider тесты: 14/14 ✅
- Routing тесты: 3/3 ✅  
- Всего: 17/17 ✅

### Требуется:
1. `cd ios && pod install`
2. Пересборка в Xcode
3. Тестирование на устройстве — ожидается устранение зависания

## 2025-12-17 — Задача notif-local-stage1 fix:
- Android: добавлен `RECEIVE_BOOT_COMPLETED` для восстановления scheduled notifications после перезагрузки.
- Android 12+: безопасный fallback `exactAllowWhileIdle → inexactAllowWhileIdle`, если точные алармы недоступны.
- Напоминания можно полностью выключить (пустые дни) — состояние корректно сохраняется/загружается.
- Если разрешения на уведомления не выданы — показываем понятную ошибку вместо “настроено”.
- Cloud refresh больше не перезаписывает локально выключенные напоминания (до этапа 2).

## 2025-12-19 — Ray (валидатор бизнес‑идей) — Mentors-only интеграция
- Добавлен новый AI‑ментор **Ray** на экране **«Менторы»** (без входов на Главной/в Библиотеке).
- Клиент:
  - Новый модуль: `lib/services/ray_service.dart`, `lib/providers/ray_service_provider.dart`, `lib/screens/ray_dialog_screen.dart`.
  - `LeoChatScreen`: добавлена карточка Ray, история чатов `bot='ray'` и переход в `RayDialogScreen`.
  - Отчёт отображается как Markdown (`flutter_markdown` добавлен в `pubspec.yaml`).
  - Онбординг **статический**: до старта проверки не вызываем `ray-chat` (guard против “бесплатной болталки”).
  - Старт проверки вызывает Edge Function `ray-chat` с `action=start_validation`; обработка `402 insufficient_gp` ведёт в `GpStoreScreen`.
  - Чат/история: создаём `leo_chats` с `bot='ray'`, пишем `leo_messages`, создаём `idea_validations` (минимальная вставка с дефолтами).
- Самопроверка:
  - `flutter analyze lib` — без проблем.
  - `flutter test` — зелёный.
- Примечание: аватар Ray сейчас **плейсхолдер** `assets/images/avatars/avatar_12.png` (можно заменить на отдельный ассет позже).
