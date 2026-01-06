## Отчёт по системе уведомлений BizLevel — 17.12.25

Документ описывает **текущую реализацию уведомлений** в приложении BizLevel (Flutter) и инфраструктуре (Supabase + OneSignal): какие типы уведомлений есть, где пользователь настраивает, какие файлы/функции задействованы, какие таблицы/RPC/Edge Functions участвуют, и как работает общий поток событий.

---

### 1) Термины и типы уведомлений

- **Локальные уведомления (device / internal reminders)**: планируются и показываются **на устройстве** через `flutter_local_notifications`. Могут приходить **при закрытом/выгруженном приложении**, если ОС разрешает уведомления и планирование.
- **Пуш‑уведомления (cloud / external push)**: доставляются через OneSignal (дальше APNs/FCM). Могут использоваться для “внешних” событий и/или напоминаний “из облака”.
- **Route (deeplink)**: строка маршрута (например, `/goal`), которую приложение использует для навигации при тапе по уведомлению.

---

### 2) Что настраивает пользователь и где (UX)

#### 2.1 Точки входа в настройку

- **Профиль → меню (⚙️) → “Уведомления”**
  - Файл: `lib/screens/profile_screen.dart`
  - Действие: вызывает `showRemindersSettingsSheet(context)` из `lib/widgets/reminders_settings_sheet.dart`.
- **Цель → “колокольчик” (на карточке/разделе цели)**
  - Файл: `lib/screens/goal/widgets/practice_journal_section.dart`
  - Действие: вызывает `showRemindersSettingsSheet(context)`.
- Дополнительно есть отдельный экран‑обёртка:
  - `lib/screens/notifications_settings_screen.dart` (использует `RemindersSettingsContent`).

#### 2.2 Какие настройки доступны пользователю

- **Время**: `TimeOfDay` (часы/минуты).
- **Дни недели**: Пн..Вс.
- **Выключить напоминания полностью**: снять все дни (пустой набор дней ⇒ “выключено”).

#### 2.3 Что должно происходить при “Сохранить”

1) Запрос permission на уведомления (только по действию пользователя, не на cold start).
2) Пересоздание локального расписания: cancel → schedule.
3) Сохранение prefs локально (SharedPreferences).
4) Синхронизация расписания в Supabase (RPC) **только если дни не пустые** (иначе — считаем это “выключено”, и RPC не вызываем).

---

### 3) Клиент (Flutter): ключевые зависимости и версии

По `pubspec.lock` (зафиксировано в проекте):
- `flutter_local_notifications`: **19.5.0**
- `onesignal_flutter`: **5.3.4**
- `supabase_flutter`: **2.10.3**

---

### 4) Клиент (Flutter): файлы и функции

#### 4.1 Локальные уведомления и напоминания: `NotificationsService`

**Файл:** `lib/services/notifications_service.dart`

Основные задачи:
- Инициализация `FlutterLocalNotificationsPlugin` **без запроса permission** на cold start.
- Создание Android notification channels.
- Планирование/отмена локальных напоминаний.
- Показ локального уведомления “сейчас” (для пуша в foreground).
- Хранение/чтение `route` (deeplink) для навигации при старте.
- Синк расписания в Supabase (RPC) и фоновый refresh из Supabase.

Ключевые методы (важные для понимания потоков):
- `initialize()`
  - iOS: `DarwinInitializationSettings(requestAlertPermission:false, ...)` — не дергаем системный диалог на старте.
  - `onDidReceiveNotificationResponse`: парсит payload `{"route":"/..."}` и кладёт в `pendingRoute`.
  - Android: создаёт каналы через `_ensureAndroidChannels()`.
- `ensurePermissionsRequested(): Future<bool>`
  - Запрашивает разрешение на iOS (`requestPermissions`) и Android (`areNotificationsEnabled`/`requestNotificationsPermission`).
  - Возвращает `true/false`. Если ранее было `true`, повторно не дергает запрос. Если было `false`, разрешает повторную попытку (пользователь мог включить в Settings).
- `schedulePracticeReminders({weekdays, hour, minute})`
  - Если `weekdays` пустой ⇒ трактуем как “выключено”:
    - отменяем расписание;
    - сохраняем пустые дни в локальном storage;
    - **не** вызываем RPC (в базе weekdays не могут быть пустыми).
  - Если `weekdays` непустой:
    - проверяем permission (и при запрете бросаем `NotificationsPermissionDenied`);
    - инициализируем timezone (`TimezoneGate.ensureInitialized`);
    - делаем `cancelDailyPracticeReminder()` и создаём новое расписание через `zonedSchedule`.
  - Android 12+: режим планирования выбирается через `_resolveAndroidScheduleMode()`:
    - если точные алармы недоступны → `inexactAllowWhileIdle`.
- `cancelDailyPracticeReminder()` отменяет уведомления `id=9000+weekday` для всех дней.
- `showNow({title, body, channelId, route})` — показывает локальное уведомление моментально (используется при push в foreground).
- `persistLaunchRoute(route)` / `consumeAnyLaunchRoute()`
  - storage цепочка без тяжёлого I/O на старте: `pendingRoute` → cache → SharedPreferences (`notif_launch_route`) → Hive (только если box уже открыт) → `getNotificationAppLaunchDetails()`.

#### 4.2 Хранение настроек напоминаний (local prefs)

- **`lib/services/reminder_prefs_storage.dart`**
  - Хранение в `SharedPreferences`.
  - Важная семантика:
    - `raw == null` → пользователь ещё не настраивал → показываем дефолт Пн/Ср/Пт.
    - `raw.isEmpty` → пользователь **выключил** напоминания → возвращаем пустой набор дней.
- **`lib/services/reminder_prefs_cache.dart`**
  - In‑memory `ReminderPrefsCache` для быстрых ответов UI без диска.
- **`lib/providers/reminder_prefs_provider.dart`**
  - `AsyncNotifier`: загрузка prefs через `NotificationsService.getPracticeReminderPrefs()` + `refreshPrefs()`.
- **`lib/models/reminder_prefs.dart`**
  - Модель `ReminderPrefs(weekdays, hour, minute)`.

#### 4.3 Таймзона

- **`lib/services/timezone_gate.dart`**
  - Ленивая инициализация: `timezone` + `flutter_timezone`.
  - Вызов идёт **по требованию** (в момент планирования), чтобы не ухудшать cold start.

#### 4.4 UI настройки напоминаний

**Файл:** `lib/widgets/reminders_settings_sheet.dart`

Что делает:
- Рисует UI выбора времени/дней недели.
- Показывает “Следующее напоминание” или “Напоминания выключены”.
- На “Сохранить” вызывает:
  - `NotificationsService.cancelWeeklyPlan()` / `cancelDailyPracticeReminder()`;
  - `NotificationsService.schedulePracticeReminders(...)`.
- Обрабатывает ошибку `NotificationsPermissionDenied` и показывает понятный текст (вместо “настроено”).

#### 4.5 Push/OneSignal: `PushService`

**Файл:** `lib/services/push_service.dart`

Ключевые принципы реализации:
- **Этап 2 (cloud push) выключен по умолчанию**: добавлен флаг `ENABLE_CLOUD_PUSH` (см. `lib/constants/push_flags.dart` → `kEnableCloudPush`).
  - Пока флаг `false`, приложение **не инициализирует OneSignal** и **не пишет** в `public.push_tokens` (используем только локальные напоминания, Этап 1).
  - Для включения: `--dart-define ENABLE_CLOUD_PUSH=true` (и далее настроить схему/edge/cron — см. раздел «Что дальше»).
- OneSignal **инициализируется только после auth** *и только при включённом `ENABLE_CLOUD_PUSH`* (чтобы избежать лишнего I/O/диалогов на старте).
- **Не запрашиваем permission** в OneSignal на cold start. Ожидается, что permission будет запрошен пользователем при настройке “Напоминаний” (это общее notification permission для local/push на iOS и Android 13+).
- Foreground push: `addForegroundWillDisplayListener` делает `preventDefault()` и показывает локальное уведомление через `NotificationsService.showNow(...)`.
- Tap по push: сохраняем `route` через `NotificationsService.persistLaunchRoute(route)`.
- Идентификация OneSignal User Model:
  - `OneSignal.login(externalId)` вызывается только когда доступен `OneSignal.User.pushSubscription.id`.
  - `OneSignal.logout()` на выходе пользователя.
- Регистрация “токена” в Supabase:
  - берётся `pushSubscription.id` (или fallback `pushSubscription.token`);
  - пишется в `public.push_tokens` (см. раздел 6).

#### 4.6 Точки запуска и навигация из уведомлений

- **`lib/main.dart`**
  - `_setupPushInitOnAuth()` включает/выключает `PushService` по событиям Supabase auth.
  - `_handleNotificationLaunchRoute()` читает `NotificationsService.consumeAnyLaunchRoute()` и навигирует `GoRouter.go(route)`.
- **`lib/services/auth_service.dart`**
  - После успешного логина вызывает `NotificationsService.initialize()` (без permission).
  - При `signOut()` отменяет локальные уведомления (cancel*).
- **`lib/constants/push_flags.dart`**
  - `kEnableIosPush` (можно отключить пуши на iOS через `--dart-define ENABLE_IOS_PUSH=false`).
  - `kEnableCloudPush` (cloud push/OneSignal выключен по умолчанию; включать через `--dart-define ENABLE_CLOUD_PUSH=true`).

---

### 5) Нативная конфигурация

#### 5.1 Android

**Файл:** `android/app/src/main/AndroidManifest.xml`

- Разрешения:
  - `android.permission.POST_NOTIFICATIONS` (Android 13+).
  - `android.permission.RECEIVE_BOOT_COMPLETED` (восстановление расписания после перезагрузки; receiver обычно добавляется плагином через manifest merge).
- Intent filter:
  - `FLUTTER_NOTIFICATION_CLICK` для корректной обработки клика.
- Каналы создаются в `NotificationsService._ensureAndroidChannels()`.

#### 5.2 iOS

**Файл:** `ios/Runner/Info.plist`
- `OneSignalAppID = $(ONESIGNAL_APP_ID)`
- `UIBackgroundModes = remote-notification`

**Файл:** `ios/Runner/Runner.entitlements`
- `aps-environment = development`
  - Риск: для TestFlight/AppStore обычно нужен `production` (иначе возможен mismatch окружения APNs).

#### 5.3 Ключи/идентификаторы: где задаются

- **OneSignal App ID (`ONESIGNAL_APP_ID`)**
  - iOS: задаётся как build setting в `ios/Flutter/Debug.xcconfig` и `ios/Flutter/Release.xcconfig`, подставляется в `Info.plist` через `$(ONESIGNAL_APP_ID)`.
  - Dart: `PushService` берёт значение через `envOrDefine('ONESIGNAL_APP_ID')` (источник — `.env` через `flutter_dotenv` или `--dart-define`).
  - Требование: значение должно быть **одинаковым** во всех источниках.

- **Supabase URL / anon key**
  - Клиент (`supabase_flutter`) обычно инициализируется через `SUPABASE_URL` и `SUPABASE_ANON_KEY` (см. `lib/utils/env_helper.dart`).

- **Секреты для серверной отправки push**
  - Должны храниться **в Supabase secrets** (а не в клиенте): `ONESIGNAL_REST_API_KEY`, `SUPABASE_SERVICE_ROLE_KEY` (используются Edge Functions, например `push-dispatch`/`reminder-cron`).

---

### 6) Supabase (проект `acevqbdpzgbtqznbpgzr`): таблицы/RLS/RPC

#### 6.1 Таблица `public.practice_reminders`

Назначение: хранит расписание, чтобы сервер мог вычислять “кому пора напомнить”.

Колонки (по факту в проекте):
- `user_id uuid` (PK/owner)
- `weekdays smallint[]`
- `hour smallint`, `minute smallint`
- `timezone text`
- `source text`
- `updated_at timestamptz`
- `last_notified_at timestamptz null`

RLS:
- owner‑only select/insert/update (`auth.uid() = user_id`).

RPC функции:
- `upsert_practice_reminders(p_weekdays, p_hour, p_minute, p_timezone, p_source)`
- `due_practice_reminders(p_window_minutes)`
- `mark_practice_reminders_notified(p_user_ids uuid[])`

#### 6.2 Таблица `public.push_tokens`

Назначение: хранит идентификаторы/токены устройств для серверной отправки push.

Колонки (по факту в проекте):
- `id, user_id, token, platform, created_at, updated_at, timezone, locale, enabled`

RLS:
- owner‑only select/insert/update/delete (`auth.uid() = user_id`).

Важно: **в прод‑схеме нет колонки `provider`**, но клиент (`PushService`) и Edge (`push-dispatch`) ожидают её наличие — это относится к этапу 2 (cloud push).

---

### 7) Supabase Edge Functions (уведомления)

В проекте задеплоены функции:
- `reminder-cron` (ACTIVE, verify_jwt=true)
- `push-dispatch` (ACTIVE, verify_jwt=true)

#### 7.1 `reminder-cron`

- Репозиторий: `supabase/functions/reminder-cron/index.ts`
- Конфиг в репо: `supabase/functions/reminder-cron/supabase.toml` (`verify_jwt=false`)
- Факт в Supabase (по API): `verify_jwt=true` → конфиг репо и прод‑настройка сейчас расходятся.

Логика:
- Вызывает RPC `due_practice_reminders`.
- Батчит `user_ids` и вызывает `push-dispatch`.
- После успешной отправки — `mark_practice_reminders_notified`.

Требование:
- Нужен Scheduled Trigger (cron) в Supabase, который регулярно вызывает `reminder-cron`.
  - На 17.12.25: по логам Edge за последние 24 часа активных вызовов `reminder-cron/push-dispatch` не видно, а `pg_cron` jobs для `reminder-cron` не заведены → серверный cron‑пайплайн сейчас не активен (ожидаемо, т.к. Этап 2 ещё не делали).

#### 7.2 `push-dispatch`

- Репозиторий: `supabase/functions/push-dispatch/index.ts`
- Задача: по `user_ids` выбрать токены из `push_tokens` и отправить уведомление в OneSignal.

Текущее состояние кода:
- фильтрует `push_tokens` по `provider=onesignal` (которого нет в прод‑таблице);
- шлёт в OneSignal через `include_player_ids` и `Authorization: Basic ...` (под старую модель).

Это требует приведения к актуальной модели OneSignal User Model (External ID / Subscription ID) — относится к этапу 2.

---

### 8) Сквозной сценарий “как работает у пользователя”

1) Пользователь открывает настройки “Уведомления” (Профиль или Цель).
2) Выбирает дни/время → “Сохранить”.
3) Приложение:
   - запрашивает permission, если надо;
   - создаёт/обновляет локальное расписание;
   - сохраняет настройки локально;
   - синкает расписание в Supabase (если дни не пустые).
4) В назначенное время ОС показывает **локальное** уведомление (при закрытом приложении).
5) При тапе по уведомлению приложение открывается и:
   - достаёт `route`;
   - навигирует через `GoRouter.go(route)`.

---

### 9) Известные проблемы/риски (на 17.12.25)

- **Этап 1 (локальные уведомления)**: реализован и стабилизирован (permission‑UX, выключение, Android reboot, Android 12+ fallback).
- **Этап 2 (cloud push)**: требуется донастройка (схема `push_tokens`, формат OneSignal API, cron trigger, согласование verify_jwt). На клиенте добавлен флаг `ENABLE_CLOUD_PUSH=false` по умолчанию, чтобы случайно не «поднимать» недонастроенный OneSignal.
- **iOS APNs entitlement**: `aps-environment=development` — проверить перед прод‑выкатом.

---

### 10) Что дальше (Этап 2: серверные пуши + настройка OneSignal)

Ниже — безопасная последовательность работ, чтобы включить server‑side пуши без регрессий для Этапа 1.

1) **Схема `push_tokens`**
   - Выбрать контракт: что именно хранится в `push_tokens.token` (OneSignal `subscriptionId` / legacy `player_id` / raw push token).
   - Привести таблицу к контракту клиента и edge:
     - вариант А (минимальный, совместимый с текущим клиентом): добавить колонку `provider text` (default `'onesignal'`);
     - вариант B: убрать фильтрацию по `provider` в edge и не писать `provider` на клиенте.

2) **Edge `push-dispatch`**
   - Обновить выбор токенов из `push_tokens` под реальную схему (не использовать `provider`, если его нет).
   - Привести отправку в OneSignal к актуальной модели (User Model): External ID / Subscription ID (сейчас используется `include_player_ids`, что относится к старой модели).
   - Секреты должны быть в Supabase secrets: `ONESIGNAL_APP_ID`, `ONESIGNAL_REST_API_KEY`, `SUPABASE_SERVICE_ROLE_KEY`.

3) **Edge `reminder-cron` + расписание**
   - Завести Scheduled Trigger (Supabase cron) для регулярного вызова `reminder-cron` (например, раз в 5–10 минут).
   - Согласовать `verify_jwt`:
     - либо оставить `verify_jwt=true` и вызывать функцию с сервисным JWT,
     - либо поставить `verify_jwt=false`, но добавить собственную проверку секретного заголовка (чтобы функцию нельзя было дёргать извне).

4) **Включение в клиенте**
   - После того как БД+edge готовы: включить `--dart-define ENABLE_CLOUD_PUSH=true` и проверить, что:
     - `PushService` регистрирует токен в `push_tokens` без ошибок,
     - `push-dispatch` успешно отправляет пуши,
     - `reminder-cron` действительно шлёт напоминания по `practice_reminders`.

5) **iOS перед продом**
   - Переключить `aps-environment` на `production` для TestFlight/App Store (иначе возможен mismatch окружения APNs и «тишина» пушей).

