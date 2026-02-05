### BizLevel — структура проекта (актуально: 2026‑02‑03)

Этот документ фиксирует **текущий стек**, **архитектуру**, **взаимосвязи модулей** и **детальную структуру репозитория** BizLevel (Flutter + Supabase).

- **Зачем**: иметь «карту проекта», чтобы безопасно развивать BizLevel (уровни/башня/цель/чаты/GP/уведомления) без регрессий.
- **Как читать**: сначала разделы «Стек» и «Ключевые потоки», затем «Структура репозитория» (по файлам).
- **Про Supabase**: проект `acevqbdpzgbtqznbpgzr`. В идеале актуальные настройки/секреты/проверки брать через `supabase-mcp`; в этом документе описано то, что **видно из кода, Edge Functions и миграций**.

---

### Актуализация (2026‑02‑03)
Этот документ был написан как «снимок» и частично устарел. Ниже — что обновлено/уточнено по факту **кода** и **живого Supabase** (через MCP).

- **Источник истины**:  
  - клиентская логика — `lib/**` (Riverpod/GoRouter/Services/Repositories)  
  - backend — *и миграции/функции в репозитории*, и **фактический деплой в Supabase** (в проде есть функции/миграции, которых нет в `supabase/functions`/`supabase/migrations` в репо)

- **Ключевые добавления/изменения после 2025‑12‑14**:
  - **Ray AI (валидатор идей)**: бот `ray`, Edge `ray-chat`, таблица `idea_validations`, UI `RayDialogScreen` + `RayService`.
  - **Рефералки и промокоды**: deep links `bizlevel://ref|promo`, таблицы `referral_codes/referrals/promo_codes/promo_redemptions`, миграции `20260117*`, `20260202_referral_bonus_both_sides`.
  - **Синхронизация напоминаний**: таблица `practice_reminders` + RPC `upsert_practice_reminders` (локальные prefs хранятся в `SharedPreferences`, синк best‑effort).
  - **Чаты Leo/Max**: UI отправляет сообщения в Edge `leo-chat`, получает `chat_id` и читает историю из `leo_messages`. Клиентский метод `LeoService.saveConversation()` остался как legacy и в актуальном UI не используется.
  - **GP‑Store**: продуктовые SKU `gp_300/gp_1000/gp_2000`; отображаемые пакеты учитывают бонусы (например «1000 + 400»).
  - **Башня**: чекпоинты цели сейчас живые и блокируют следующий уровень после **1/4/7** (по заполненности `user_goal.goal_text/financial_focus/action_plan_note`).

---

### 1) Продукт и доменная модель (BizLevel)

#### Основные сущности BizLevel (клиент ↔ Supabase)
- **Уровни обучения**: `levels`, `lessons`, `user_progress` (+ локальный прогресс прохождения уроков).
- **Башня (Tower)**: композиция узлов `level` + `mini_case` + `goal_checkpoint` (после уровней 1/4/7).
- **Цель**: единая запись `user_goal` + журнал применений `practice_log` + история целей `user_goal_history`.
- **Чаты**: `leo_chats`, `leo_messages` (боты `leo|max`), доп.таблицы для стоимости/памяти (`ai_message`, `user_memories`, `memory_archive`).
- **GP‑экономика**: `gp_wallets/gp_ledger`, покупка пакетов, списания за сообщения, доступ к этажам (`floor_access`/`packages`).
- **Уведомления**: локальные напоминания (OS) + облачные пуши через OneSignal + таблица `push_tokens` + крон‑функции Supabase.

---

### 2) Текущий стек (клиент/бэкенд/инфра)

#### Клиент (Flutter)
- **Flutter/Dart**: кроссплатформа iOS/Android/Web/Desktop.
- **State management**: `flutter_riverpod` + `hooks_riverpod` (точечно), без блокирующих `StreamProvider` на холодном старте.
- **Навигация**: `go_router` (ShellRoute для табов: `/home /tower /chat /profile`).
- **Сеть/HTTP**: `supabase_flutter` (PostgREST/Storage/Auth) + `dio` (вызовы Edge Functions с кастомными заголовками).
- **Медиа**: `video_player` + `chewie`; Web HLS — `web/hls_player.html`.
- **Кэш**:
  - **Hive**: мобильный SWR‑кэш репозиториев (`levels/lessons/user_goal/practice_log/...`), открытие боксов — лениво.
  - **SharedPreferences**: локальный прогресс уроков + prefs напоминаний (`ReminderPrefsStorage`).
- **Уведомления**: `flutter_local_notifications` + `timezone` + `flutter_timezone` (инициализация tz — через `TimezoneGate` on‑demand).
- **Пуши**: `onesignal_flutter` (FCM путь на iOS/Android удалён/заглушки).
- **Аналитика/мониторинг**: `sentry_flutter` (инициализация отложена после первого кадра).
- **IAP**: `in_app_purchase` + iOS мост StoreKit2 (`storekit2_service.dart`, `native_bootstrap.dart`).

#### Бэкенд (Supabase)
- **Postgres**: таблицы под RLS, hot‑RPC для GP и вспомогательных задач.
- **PostgREST**: основной API для чтения/записи.
- **Storage**: видео/артефакты/обложки через signed URL.
- **Edge Functions** (Deno): `leo-chat`, `leo-memory`, `gp-purchase-verify`, `push-dispatch`, `reminder-cron`, `storage-integrity-check`, и др.
- **ИИ‑провайдеры (фактическая реализация)**:
  - **XAI (Grok)**: генерация ответов в `leo-chat` (требуется `XAI_API_KEY`).
  - **OpenAI**: эмбеддинги для RAG и семантической памяти (требуется `OPENAI_API_KEY`).

#### CI/Инфра
- **GitHub Actions**: `.github/workflows/ci.yaml` (unit + integration web/android/ios + supabase advisors + sentry check).
- **Web deploy**: `vercel.json` + `scripts/vercel_build.sh`.

---

### 3) Архитектура клиента (слои и зависимости)

#### Слои
- **UI**: `lib/screens/*`, `lib/widgets/*`
- **State**: `lib/providers/*`
- **Data access**:
  - **Repositories**: `lib/repositories/*` (SWR‑кэш + offline fallback)
  - **Services**: `lib/services/*` (Supabase/Auth/GP/Leo/Notifications/Push/IAP и т.д.)
- **Models**: `lib/models/*` (Freezed/JSON)
- **Theme/Design System**: `lib/theme/*` (токены цветов/spacing/типографики/компонентные темы)
- **Utils/Compat**: `lib/utils/*`, `lib/compat/*`

#### 3.1 Design System (тема, токены, компоненты)
##### Токены
- `lib/theme/color.dart` — **палитра и семантические цвета** (brand + states + “liquid glass” поверхности/градиенты).
- `lib/theme/spacing.dart` — **spacing‑шкала** + утилиты `insetsAll/insetsSymmetric/gapH/gapW`.
- `lib/theme/dimensions.dart` — **радиусы, min touch target, высоты**, elevation hairline.
- `lib/theme/typography.dart` — **TextTheme BizLevel** (размеры/веса/line-height).
- `lib/theme/effects.dart`, `lib/theme/animations.dart` — токены теней/глоу и длительности/кривые motion.

##### Сборка ThemeData
- `lib/theme/app_theme.dart`:
  - строит `ThemeData` из `ColorScheme` (есть `light/dark/darkOled`)
  - подключает domain‑extensions (ThemeExtension):
    - `ChatTheme` (`lib/theme/chat_theme.dart`)
    - `QuizTheme` (`lib/theme/quiz_theme.dart`)
    - `GpTheme` (`lib/theme/gp_theme.dart`)
    - `GameProgressTheme` (`lib/theme/game_progress_theme.dart`)
    - `VideoTheme` (`lib/theme/video_theme.dart`)
  - задаёт стили компонентов (buttons/chips/nav/tabbar/card/dialog/bottomsheet/snackbar)
- `lib/theme/dynamic_theme_builder.dart` — **legacy/не используется** (заготовка под dynamic ColorScheme Android 12+; сейчас не подключена в активной сборке темы).

##### Библиотека общих UI‑компонентов (high‑usage)
- `BizLevelCard` (`lib/widgets/common/bizlevel_card.dart`) — единая “glass” карточка: градиент/бордер/мягкая тень, без blur по умолчанию.
- `BizLevelButton` (`lib/widgets/common/bizlevel_button.dart`) — унифицированные варианты кнопок (primary/secondary/outline/text/danger/link) + haptic.
- `BizLevelTextField` (`lib/widgets/common/bizlevel_text_field.dart`) — обёртка поля ввода с label/error.
- `NotificationCenter` (`lib/widgets/common/notification_center.dart`) — MaterialBanner‑нотификации + Sentry breadcrumb + запись в локальный журнал.
  - `NotificationLogService` (`lib/services/notification_log_service.dart`) — Hive‑журнал баннеров (unread, latest, markAllRead).
- Плейсхолдеры состояний: `BizLevelLoading`, `BizLevelError`, `BizLevelEmpty`.
- `ThemeGalleryScreen` (`lib/widgets/dev/theme_gallery.dart`) — dev‑экран для визуальной проверки токенов/компонентов/доменных тем.

#### Важные архитектурные решения (фиксируем как «правила проекта»)
- **Быстрый старт**: `main.dart` делает `runApp()` сразу; тяжёлое переносится в `appBootstrapProvider` и post‑frame bootstrap.
- **Навигация без блокировок**: `GoRouter` не должен зависеть от `authStateProvider.watch()`; используется синхронный `currentSession` и `currentUserProvider`.
- **Web особенности**: Hive не используется; PostgREST требует `apikey` в заголовках (см. `SupabaseService.initialize()`).
- **Пуши только после логина**: `PushService` (OneSignal) стартует после авторизации, чтобы избежать некорректных `logout/login` до `initialize`.
- **Timezone init по требованию**: `TimezoneGate.ensureInitialized()` вызывается только при планировании уведомлений.

---

### 4) Ключевые потоки (end‑to‑end)

#### 4.1 Bootstrap приложения
1) `main()` → `runApp(ProviderScope(MyApp))`
2) `appBootstrapProvider`:
   - `dotenv.load()`
   - `SupabaseService.initialize()`
   - `_ensureHiveInitialized()`
3) После успеха bootstrap:
   - создаётся `GoRouter` (`goRouterProvider`)
   - post‑frame: локальные сервисы (notifications prefs/cache), обработка launch route, настройка пушей по auth‑сессии, deferred Sentry init

#### 4.2 Авторизация и профиль
- `AuthService` оборачивает Supabase Auth (email/password, Google, Apple) и типизирует ошибки (`AuthFailure`).
- После логина `LoginController` инвалидирует `currentUserProvider` и `goRouterProvider`, чтобы роутер пересобрался и сделал redirect.
- Профиль хранится в таблице `users` (`UserRepository.fetchProfile`).

#### 4.3 Уровни/уроки/прогресс
- `LevelsRepository` → Supabase levels (+ progress) → подставляет signed cover (`cover_path` → Storage signed URL).
- `LessonsRepository` → lessons + кэш.
- Локальный прогресс урока: `LessonProgressNotifier` (SharedPreferences).
- Завершение уровня: `SupabaseService.completeLevel` (upsert `user_progress` + RPC `update_current_level`).

#### 4.4 Башня (Tower)
- `towerNodesProvider` строит список узлов: уровни + мини‑кейсы + goal_checkpoint (после 1/4/7).
- Гейтинг:
  - уровни на этажах требуют `floor_access` (и `packages` для цены)
  - mini‑case может блокировать следующий уровень до `completed/skipped`
  - goal_checkpoint завершённость определяется заполненностью `user_goal/practice_log`

#### 4.5 Цель и журнал применений
- `userGoalProvider` читает `user_goal`, `practiceLogProvider` читает `practice_log` фильтром по `current_history_id`.
- Сохранение записи в журнал:
  - RPC `log_practice_and_update_metric` (транзакция) → fallback на insert + update
  - best‑effort бонус `gp_claim_daily_application`
- Чекпоинты L4/L7 — embedded‑чат с Максом + CTA на напоминания/завершение.

#### 4.6 Чаты (Leo/Max)
##### UI/UX и навигация
- Экран «Менторы»: `lib/screens/leo_chat_screen.dart`
  - Показывает 2 CTA‑карточки: **Leo AI** (ментор по бизнесу) и **Max AI** (трекер цели).
  - История диалогов берётся из `leo_chats` (только чаты с `message_count > 0`), сортировка по `updated_at desc`.
  - Открытие чата ведёт на `LeoDialogScreen(chatId: ...)`, создание нового — на `LeoDialogScreen(chatId: null, bot: leo|max)`.
- Экран «Диалог»: `lib/screens/leo_dialog_screen.dart`
  - Поддерживает **полноэкранный** и **embedded** режим (`embedded=true` — без `Scaffold/AppBar`, используется в чекпоинтах L4/L7).
  - Сообщения рендерятся через `LeoMessageBubble → BizLevelChatBubble` (+ `SelectableText` для ассистента).
  - UX:
    - скрытие клавиатуры по `onTapOutside` и скроллу
    - FAB «Вниз» при отскролле
    - подсказки‑chips (серверные + локальный fallback), режим «Ещё…» через bottom‑sheet

##### Хранение истории чатов (Supabase таблицы)
- `leo_chats`: мета‑информация чата (id, title, updated_at, message_count, bot, unread_count).
- `leo_messages`: сообщения (role/user/assistant, content, created_at).

##### Пагинация сообщений
- `LeoDialogScreen` грузит сообщения порциями по 30 (`_pageSize=30`) из `leo_messages`:
  - запрос идёт по `range(start, end)` + `order(created_at desc)`
  - затем результат приводится к chronological order (reverse) и вставляется в начало списка
  - включён дедуп по ключу `role::content` (защита от редких дублей)

##### Отправка сообщения: клиент → Edge → сохранение
- UI добавляет user‑сообщение локально, затем вызывает `LeoService.sendMessageWithRAG(...)` → Edge Function `leo-chat`.
- Сервер (Edge `leo-chat`) является **источником истины** по истории:
  - создаёт чат в `leo_chats` при первом сообщении (если `chatId == null`)
  - сохраняет сообщения в `leo_messages`
  - возвращает `chat_id` в ответе, чтобы клиент мог продолжать диалог
- Клиент читает историю через пагинацию из `leo_messages` (`LeoDialogScreen._loadMessages()`).

**Примечание:** в коде сервиса есть `LeoService.saveConversation(...)` (вставка в `leo_messages` и инкремент `leo_chats.message_count`) — это legacy‑контур и в текущем UI не используется. Соответственно, риск «двойного сохранения» (клиент+сервер) для Leo/Max в актуальном флоу считается снятым; дедуп в UI остаётся как защита от редких дублей данных в источнике.

##### Контекст и персонализация (userContext/levelContext)
- Экран списка чатов строит контексты через `ContextService.buildUserContext/buildLevelContext`.
- `LeoDialogScreen` передаёт в Edge:
  - `messages` (история)
  - `userContext` и `levelContext` (очищаются от строк `"null"`/пустых значений)
  - `bot` (`leo|max`)
  - `chatId` (для идемпотентности и списаний GP)

##### GP‑политика внутри чата
- На клиенте доступен флаг `skipSpend` (используется для «тонких реакций» и сервисных сообщений).
- После успешного ответа UI инвалидирует `gpBalanceProvider` для обновления баланса.
- Доп. аварийный флаг: `kDisableGpSpendInChat` (global rollback).

##### Непрочитанные сообщения (unread)
- В коде есть `leoUnreadProvider` (StreamProvider `unread_count` из `leo_chats` по `chatId`), но **в текущем UI не используется** (встречается только в legacy‑виджетах).
- `LeoService.resetUnread(chatId)` вызывает RPC `reset_leo_unread` (best‑effort).

##### Mini‑case / caseMode (важно для BizLevel)
- `LeoDialogScreen` поддерживает режим `caseMode=true`:
  - **не создаёт chat в БД** (не пишет в `leo_chats/leo_messages`)
  - добавляет системный промпт фасилитатора (`systemPrompt`) в `messages[0]`
  - умеет шагать по сценарию через маркеры в ответе ассистента: `[CASE:NEXT]`, `[CASE:FINAL]`
  - финал может показать bottom‑sheet «Кейс завершён → вернуться в Башню»

##### Серверная реализация `leo-chat` (Edge Function)
- **Файл**: `supabase/functions/leo-chat/index.ts`
- **Режимы**:
  - `mode=quiz`: короткий ответ без RAG (используется в чат‑квизах уроков)
  - `mode=goal_comment` и `mode=weekly_checkin`: отключены (410 Gone)
  - `version_check=true`: диагностический ответ для проверки деплоя
- **RAG (только для Leo)**:
  - включается только если есть `OPENAI_API_KEY`, бот не `max`, не `caseMode`
  - использует эмбеддинг‑модель (по умолчанию `text-embedding-3-small`) + RPC `match_documents`
  - поддерживает `metadata_filter.level_id` из `levelContext`
  - сжимает документы в тезисы и ограничивает объём по токенам (`RAG_MAX_TOKENS`)
  - включает **гейтинг по прогрессу**: если вопрос относится к уровню выше пройденного — RAG не подгружается, а системный промпт требует «нейтрального отказа»
- **Память и сводки**:
  - семантическая память через RPC `match_user_memories` (эмбеддинги OpenAI) + обновление счётчиков `touch_user_memories`
  - добавляет в промпт: `persona_summary`, релевантные memories, последние `leo_chats.summary`, RAG‑контекст
  - применяет капы токенов по блокам (`*_MAX_TOKENS`) и общий лимит (`CONTEXT_MAX_TOKENS`)
- **Контекст Макса (цель/журнал)**:
  - подгружает `user_goal` и последние записи `practice_log` (фильтр по `current_history_id`) и добавляет это в системный промпт Макса
- **Наблюдаемость/стоимость**:
  - сохраняет usage/cost в таблицу `ai_message` (стоимость считается из usage + конфигов)
  - выполняет санитаризацию ответов Макса (вырезает emoji/табличную разметку) как guard

##### Серверная реализация `leo-memory` (Edge Function)
- **Файл**: `supabase/functions/leo-memory/index.ts`
- **Назначение**:
  - триггер/вебхук на вставку `leo_messages` (role=assistant) → извлечение фактов о пользователе из истории
  - эмбеддинги (OpenAI) → upsert в `user_memories`
  - поддержание лимита hot‑памяти (`HOT_MEM_LIMIT`, дефолт 50) + перенос хвоста в `memory_archive`
  - обновление `leo_chats.summary` и `leo_chats.last_topics`

---

#### 4.7 Мини‑кейсы (Mini Cases)
##### Данные и прогресс
- Таблицы:
  - `mini_cases`: мета кейса + `script` (JSON) + `video_url`
  - `user_case_progress`: прогресс пользователя по кейсу (`started/completed/skipped`, hints, timestamps)
- Провайдеры/репозиторий:
  - `CasesRepository` (`lib/repositories/cases_repository.dart`): upsert статуса + SWR‑кэш `Hive.openBox('cases_progress')`
  - `caseStatusProvider`, `caseActionsProvider` (`lib/providers/cases_provider.dart`): start/skip/complete (+ invalidate статуса)

##### UI и сценарий
- `MiniCaseScreen` (`lib/screens/mini_case_screen.dart`):
  - 2‑страничный flow (`PageView` без свайпов):
    1) интро (картинка + краткое описание)
    2) видео (через переиспользование `LessonWidget` на mock `LessonModel`)
  - CTA «Решить с Лео» открывает `LeoDialogScreen(caseMode=true)` и прокидывает:
    - `systemPrompt` фасилитатора
    - список вопросов `casePrompts` (из `script.questions[].prompt`)
    - контексты `q2_context/q3_context/q4_context`
    - `checklist` как префейс + `final_story`
  - Завершение кейса:
    - `caseActionsProvider.complete(caseId)` → `user_case_progress`
    - попытка выдать бонус `gp_bonus_claim('all_three_cases_completed')` (+ celebration UI)
    - best‑effort: повышение прогресса уровня (через `SupabaseService.completeLevel` для `after_level + 1`)
    - инвалидируются `towerNodesProvider/levelsProvider/nextLevelToContinueProvider/currentUserProvider/userSkillsProvider`
    - навигация на `/tower?scrollTo=<after_level+1>`

#### 4.8 GP‑экономика и покупки (Store / IAP / Web)
##### Базовые компоненты
- **Баланс**: `gpBalanceProvider` (`lib/providers/gp_providers.dart`) — SWR:
  - мгновенный ответ из кеша (`GpService.readBalanceCache()` + Hive)
  - фоновое обновление `GpService.getBalance()` без блокировки UI (гейт по `currentSession`)
- **UI магазина**: `lib/screens/gp_store_screen.dart`
  - 3 пакета: `gp_300`, `gp_1000`, `gp_2000` (в UI отображаются бонусы: `1000+400`, `2000+1000`)
  - цены берутся из магазина (StoreKit/Google Play) и/или как фолбэк из таблицы `store_pricing`
  - есть кнопки **«Оплатить»** и **«Проверить»** (web‑verify разрешён только на Web)

##### iOS: StoreKit 2 (нативный мост) → verify → кредит GP
- **Клиент**:
  - `StoreKit2Service` (`lib/services/storekit2_service.dart`): MethodChannel/EventChannel `bizlevel/storekit2`
  - `IapService` (`lib/services/iap_service.dart`): на iOS *не использует* `in_app_purchase` (SK1) → только StoreKit2
  - `GpStoreScreen._handleIosPurchase`: покупка → получение `receipt/jws` → `GpService.verifyIapPurchase(platform: 'ios', token: ...)`
- **Сервер**:
  - `supabase/functions/gp-purchase-verify/index.ts`: `verifyReceipt` (prod→sandbox), извлечение `transaction_id`
  - идемпотентный кредит через RPC `gp_iap_credit(p_purchase_id, p_amount_gp)` (purchase_id строится как `ios:product_id:transactionId`)

##### Android: Google Billing (in_app_purchase) → verify → кредит GP
- `GpStoreScreen._handleAndroidPurchase`: `InAppPurchase.buyConsumable` → берёт `serverVerificationData`
  - если токен не подходит, пытается извлечь `purchaseToken` из `localVerificationData` (JSON/regex fallback)
  - верификация: `GpService.verifyIapPurchase(platform: 'android', packageName: <package>)`
- Сервер (`gp-purchase-verify`): OAuth2 через service account `GOOGLE_SERVICE_ACCOUNT_JSON` → `androidpublisher.purchases.products.get`

##### Web: initPurchase → внешняя оплата → verifyPurchase
- `GpService.initPurchase` (Edge `gp-purchase-init`) возвращает `payment_url` и `purchase_id`
  - **Примечание**: исходников `gp-purchase-init` нет в `supabase/functions/` этого репозитория — актуальный код/конфиг функции нужно сверить через `supabase-mcp` проекта `acevqbdpzgbtqznbpgzr`.
  - `GpStoreScreen` открывает ссылку во внешнем браузере, `purchase_id` хранит локально (Hive box `gp`, key `last_purchase_id`)
- `GpStoreScreen._verifyLastPurchase` (только web) вызывает `GpService.verifyPurchase(purchaseId)`:
  - сервер (`gp-purchase-verify`) вызывает RPC `gp_purchase_verify(p_purchase_id)`

##### Наблюдаемость и защита от «непришёл баланс»
- В UI стоят Sentry breadcrumbs (`gp_*_purchase_started/verify_started/verify_success`)
- На Android/iOS есть обработка кейса `rpc_no_balance`: задержка + рефреш `gpBalanceProvider` как fallback

##### Legacy/инструкция по ручной оплате
- `PaymentService` (`lib/services/payment_service.dart`) и `PaymentScreen` (`lib/screens/payment_screen.dart`) — **legacy‑контур оплаты**, который сейчас **не используется приложением** (нет роутов/вызовов из `GoRouter` и актуального GP‑store). Остался как исторический код/тесты; связан с Edge `create-checkout-session`.

#### 4.9 Библиотека (Courses/Grants/Accelerators + Избранное)
##### Данные
- Таблицы:
  - `library_courses`, `library_grants`, `library_accelerators` (контент ресурсов)
  - `library_favorites` (user ↔ resource_type/resource_id)

##### Репозиторий и кеширование
- `LibraryRepository` (`lib/repositories/library_repository.dart`)
  - SWR‑паттерн: кеш (Hive) → сеть → обновление кеша
  - **Web‑особенность**: `_openBox()` возвращает `null`, кеширование отключено (network‑only)
  - категории собираются динамически: `select('category')` + уникализация
  - `fetchFavoritesDetailed()` делает 3 запроса по `inFilter('id', ids)` для карточек избранного

##### UI
- `LibraryScreen` (`lib/screens/library/library_screen.dart`)
  - вкладки: **Разделы** и **Избранное**
  - переходы: `/library/courses`, `/library/grants`, `/library/accelerators`
- `LibrarySectionScreen` (`lib/screens/library/library_section_screen.dart`)
  - breadcrumb‑навигация (главная → библиотека → раздел)
  - фильтр по категории (Dropdown)
  - карточка ресурса: expand/collapse, кнопка «Перейти ↗», toggle favorite

### 5) Структура репозитория (детально, по папкам/файлам)

> В этом разделе будет перечислено **полное дерево tracked‑файлов** (по `git ls-files`) с кратким описанием назначения каждого элемента.

#### 5.1 Корень репозитория
Файлы верхнего уровня (tracked) и их назначение:
- **`README.md`**: вводная документация по BizLevel (как запустить, ключевые модули, GP‑экономика, особенности).
- **`pubspec.yaml`**: зависимости Flutter/Dart, ассеты, настройки SDK.
- **`pubspec.lock`**: зафиксированные версии зависимостей (важно для воспроизводимых сборок).
- **`analysis_options.yaml`**: правила `dart analyze` / lints (качество и стиль кода).
- **`devtools_options.yaml`**: настройки Flutter DevTools.
- **`package.json`**: минимальные web‑скрипты (в т.ч. vercel build).
- **`vercel.json`**: конфиг деплоя web‑сборки на Vercel.
- **`build.gradle`**: корневой Gradle‑конфиг для Android сборки.
- **`gradlew`, `gradlew.bat`**: Gradle wrapper scripts.
- **`.gitignore`**: правила исключения файлов из git.
- **`.metadata`**: служебный файл Flutter (генерируется toolchain).
- **`local.properties`**: Android‑локальные настройки SDK (обычно не коммитится; в этом репозитории файл tracked — стоит проверить, нет ли чувствительных путей).
- **`.flutter-plugins-dependencies 2/3/4`**: нетипичные tracked‑файлы (похожие на артефакты Flutter toolchain; вероятно случайно закоммичены).

Каталоги верхнего уровня (tracked) и общая роль:
- **`lib/`**: исходники приложения Flutter (UI/State/Data/Theme/Utils).
- **`assets/`**: ассеты (изображения уровней/кейсов/аватаров, SVG, и т.д.).
- **`docs/`**: основная документация проекта (статусы, концепты, архивы, тексты).
- **`supabase/`**: Edge Functions + миграции БД (Postgres/RLS/RPC).
- **`test/`**: unit/widget/integration тесты.
- **`android/`, `ios/`, `macos/`, `windows/`, `linux/`, `web/`**: платформенные проекты и конфиги сборок.
- **`tool/`**: Dart tooling/скрипты, патчи плагинов (в т.ч. iOS‑подфиксы).
- **`scripts/`**: вспомогательные скрипты (build/deploy/интеграции/данные).
- **`.github/`**: CI (GitHub Actions workflows).
- **`.vscode/`**: IDE‑конфиги.
- **`.cursor/`**: правила/конфиги Cursor (AI‑ассистента).
- **`.specstory/`**: служебные артефакты IDE‑истории (нетипично, но tracked).
- **`coverage/`**: артефакты покрытия (нетипично, но tracked).
- **`.gradle/`**, **`.sentry-native/`**: служебные каталоги (обычно не коммитятся; в этом репозитории есть tracked‑элементы — стоит оценить необходимость).
- **`gradle/`**: Gradle wrapper/конфиги (нормально для Android).
- **`integrations/`**: интеграционные компоненты/серверы (например, вспомогательные инструменты).
- **`docs/archive/` с кириллическими именами файлов**: часть архивных заметок названа на русском; некоторые git‑команды могут выводить такие пути в quoted‑виде, но физически это обычные файлы внутри `docs/`.

#### 5.2 `lib/` — приложение Flutter
- **`lib/main.dart`**: entrypoint; bootstrap (dotenv/Supabase/Hive), post‑frame init (локальные сервисы, пуши, Sentry), deep links.

<details>
<summary><code>lib/routing/</code> (1 файл)</summary>

- `lib/routing/app_router.dart`: конфигурация `GoRouter` (routes + redirect‑логика, shell‑навигация, Sentry observer).

</details>

#### 5.3 `supabase/` — миграции и Edge Functions
Этот каталог — «backend в репо»: **SQL‑миграции Postgres** (схема/таблицы/RLS/RPC) и **Edge Functions (Deno)**.

Важно:
- Реальные секреты/ENV и текущий деплой функций/миграций корректнее сверять через `supabase-mcp` (проект `acevqbdpzgbtqznbpgzr`).
- В репозитории хранится то, что можно воспроизвести локально (SQL + TS‑функции); «живое» состояние в Supabase может отличаться.

Основные связки клиента с Supabase (high‑level):
- `lib/services/leo_service.dart` → `supabase/functions/leo-chat` (чат), `supabase/functions/leo-memory` (память/summary), (legacy) `leo-rag`.
- `lib/services/gp_service.dart` → `supabase/functions/gp-purchase-verify` (verify покупок) + RPC (`gp_*`).
- **Важно**: клиент также вызывает Edge `gp-purchase-init`, но исходников этой функции нет в `supabase/functions/` этого репозитория (сверять через `supabase-mcp`).
- Уведомления: `supabase/functions/reminder-cron` (cron) → `supabase/functions/push-dispatch` (OneSignal).

<details>
<summary><code>supabase/.temp/</code> (7 файлов)</summary>

- `supabase/.temp/cli-latest`: служебный файл Supabase CLI (кеш/версия/метаданные: `cli-latest`)
- `supabase/.temp/gotrue-version`: служебный файл Supabase CLI (кеш/версия/метаданные: `gotrue-version`)
- `supabase/.temp/pooler-url`: служебный файл Supabase CLI (кеш/версия/метаданные: `pooler-url`)
- `supabase/.temp/postgres-version`: служебный файл Supabase CLI (кеш/версия/метаданные: `postgres-version`)
- `supabase/.temp/project-ref`: служебный файл Supabase CLI (кеш/версия/метаданные: `project-ref`)
- `supabase/.temp/rest-version`: служебный файл Supabase CLI (кеш/версия/метаданные: `rest-version`)
- `supabase/.temp/storage-version`: служебный файл Supabase CLI (кеш/версия/метаданные: `storage-version`)

</details>

<details>
<summary><code>supabase/functions/</code> (12 файлов)</summary>

- `supabase/functions/README.md`: README по синхронизации Edge Functions (что в репо vs что в проде)
- `supabase/functions/create-checkout-session/index.ts`: Edge Function: legacy checkout session (пока mock URL)
- `supabase/functions/gp-purchase-verify/index.ts`: Edge Function: верификация покупок (iOS receipts / Android purchaseToken / web purchase_id) + RPC кредит GP
- `supabase/functions/leo-chat/index.ts`: Edge Function: основной чат Leo/Max (XAI ответы + OpenAI embeddings для RAG/памяти, chips, cost tracking)
- `supabase/functions/leo-memory/index.ts`: Edge Function: извлечение памяти/summary после сообщений (user_memories, chat summary)
- `supabase/functions/leo-rag/index.ts`: Edge Function: отдельный RAG endpoint (embeddings + match_documents) (legacy/диагностический)
- `supabase/functions/leo-test/index.ts`: Edge Function: тестовый endpoint (эхо)
- `supabase/functions/push-dispatch/index.ts`: Edge Function: отправка push через OneSignal по user_ids (читает push_tokens)
- `supabase/functions/ray-chat/index.ts`: Edge Function: Ray AI (валидатор идей) — валидация бизнес‑идей, запись отчёта и прогресса в `idea_validations` (+ сообщения в `leo_*` с bot=`ray`)
- `supabase/functions/reminder-cron/index.ts`: Edge Function: cron-напоминания (due_practice_reminders → push-dispatch → mark_notified)
- `supabase/functions/reminder-cron/supabase.toml`: конфиг Edge Function (verify_jwt/CORS и т.п.)
- `supabase/functions/storage-integrity-check/index.ts`: Edge Function: проверка целостности ссылок на Storage (levels.cover_path, lessons.video_url)

</details>

> ВАЖНО (prod vs repo): в живом Supabase деплое присутствуют дополнительные Edge Functions, которых нет в `supabase/functions/` репозитория (например: `gp-purchase-init`, `gp-balance`, `gp-spend`, `gp-bonus-claim`, `gp-floor-unlock`, а также служебные `delete-account`, `telegram-auth`, `leo_context` и др.). Для актуального списка всегда сверять через `supabase-mcp`.

<details>
<summary><code>supabase/migrations/</code> (39 файлов)</summary>

- `supabase/migrations/20250125_fix_update_current_level_with_skills.sql`: фиксы функции update_current_level
- `supabase/migrations/20250724_0001_add_missing_rls_policies.sql`: включение RLS и создание базовых политик (lessons/levels/leo_messages/user_progress)
- `supabase/migrations/20250724_0002_add_subscriptions.sql`: таблицы subscriptions/payments + RLS
- `supabase/migrations/20250801_add_cover_path_to_levels.sql`: добавление cover_path к levels (Storage)
- `supabase/migrations/20250802_add_avatar_id_to_users.sql`: добавление avatar_id к users
- `supabase/migrations/20250806_fix_update_current_level.sql`: фиксы функции update_current_level
- `supabase/migrations/20250808_add_leo_messages_processed.sql`: таблица leo_messages_processed (дедуп обработки leo-memory)
- `supabase/migrations/20250808_add_level_zero_first_step.sql`: onboarding: добавление/настройка поля для первого шага (ур.0)
- `supabase/migrations/20250808_add_personalization_and_memories.sql`: persona_summary/users, summary/topics в leo_chats, таблица user_memories + индексы + RLS
- `supabase/migrations/20250808_documents_metadata_backfill.sql`: подготовка/бэкфилл метаданных документов для RAG
- `supabase/migrations/20250808_optimize_documents_for_rag.sql`: оптимизация documents для RAG (служебные таблицы/индексы)
- `supabase/migrations/20250808_update_match_documents.sql`: обновление RPC match_documents (RAG выборка)
- `supabase/migrations/20250810_adjust_skills_to_five.sql`: нормализация skills до 5 и маппинг уровней на навыки
- `supabase/migrations/20250811_add_leo_memory_trigger.sql`: триггер/функции вызова leo-memory + app_settings, дедуп
- `supabase/migrations/20250812_28_1_create_goal_feature_tables.sql`: первичная схема цели (core_goals/weekly_progress/reminder_checks/motivational_quotes) + RLS/триггеры
- `supabase/migrations/20250813_29_1_add_leo_chats_bot.sql`: добавление поля bot в leo_chats
- `supabase/migrations/20250815_30_3_rename_alex_to_max.sql`: переименование alex→max в чатах
- `supabase/migrations/20250816_allow_select_motivational_quotes.sql`: политика чтения motivational_quotes (anon/auth)
- `supabase/migrations/20250908120000_create_push_tokens.sql`: таблица push_tokens + RLS + триггер updated_at
- `supabase/migrations/20250910_add_profile_personalization_fields.sql`: добавление полей персонализации профиля в users
- `supabase/migrations/20251009_memory_decay_persona_summary.sql`: механика “decay” памяти + пересчёт persona_summary (touch/refresh)
- `supabase/migrations/20251013_bunny_lessons_update.sql`: миграция видео на Bunny HLS (обновление lessons.video_url)
- `supabase/migrations/20251015_create_user_goal.sql`: таблица user_goal + RLS/updated_at
- `supabase/migrations/20251015_drop_weekly_and_checkpoint.sql`: удаление legacy weekly_progress и goal_checkpoint_progress
- `supabase/migrations/20251015_gp_daily_application_bonus.sql`: RPC gp_claim_daily_application (бонус за ежедневную практику)
- `supabase/migrations/20251015_migrate_core_goals_to_user_goal.sql`: миграция данных core_goals → user_goal, чистка
- `supabase/migrations/20251015_rename_daily_progress_to_practice_log.sql`: переименование/миграция daily_progress → practice_log + RLS
- `supabase/migrations/20251016_add_target_date_to_user_goal.sql`: добавление target_date в user_goal
- `supabase/migrations/20251016_goal_progress_milestones.sql`: бонусы/милестоуны прогресса цели (gp_claim_goal_progress)
- `supabase/migrations/20251017_add_financial_fields_to_user_goal.sql`: финансовые поля (metric_current/metric_target/...) в user_goal
- `supabase/migrations/20251017_add_unique_user_goal.sql`: уникальность цели на пользователя (ограничения/индексы)
- `supabase/migrations/20251017_drop_legacy_goal_tables.sql`: удаление legacy таблиц цели (weekly/checkpoint/core_goals/daily_progress)
- `supabase/migrations/20251017_rls_public_lessons_packages.sql`: RLS/политики для lesson_metadata/lesson_facts/package_items (select auth)
- `supabase/migrations/20251020_add_user_goal_top_skills.sql`: top_skills для user_goal + refresh_user_goal_top_skills
- `supabase/migrations/20251020_create_application_bank.sql`: таблица application_bank + RLS (банк “применений”)
- `supabase/migrations/20251020_create_user_rhythm.sql`: таблица user_rhythm + refresh_user_rhythm + RLS
- `supabase/migrations/20251020_db_clean_legacy.sql`: дополнительная чистка legacy таблиц
- `supabase/migrations/20251111_iap_verify_logs.sql`: таблица iap_verify_logs + RLS (диагностика verify)
- `supabase/migrations/20251111_log_practice_and_update_metric.sql`: RPC log_practice_and_update_metric (транзакция: лог + апдейт метрики)

</details>

#### 5.4 Платформы: `ios/`, `android/`, `web/`
> Это host‑проекты Flutter под конкретные платформы (build/packaging/native bridges).  
> Desktop runner’ы (`macos/`, `windows/`, `linux/`) в текущем состоянии репозитория не являются частью актуального поставляемого продукта (и могут отсутствовать в дереве). Если они возвращаются — нужно заново описывать их сборку/CI отдельно.
>
> В репозитории встречаются **нетипично закоммиченные build‑артефакты** (например, `ios/build/*`, `android/build/reports/*`) — ниже они перечислены, но обычно такие файлы не хранят в git.

<details>
<summary><code>android/</code> (26 файлов)</summary>

- `android/.gitignore`: gitignore Android-проекта
- `android/app/build.gradle.kts`: Gradle-конфиг app-модуля (applicationId, deps, signing, flavors)
- `android/app/src/debug/AndroidManifest.xml`: AndroidManifest (debug buildType)
- `android/app/src/main/AndroidManifest.xml`: AndroidManifest (main)
- `android/app/src/main/kotlin/com/example/bizlevel/MainActivity.kt`: точка входа Android (FlutterActivity)
- `android/app/src/main/res/drawable-v21/launch_background.xml`: ресурс splash/launch background
- `android/app/src/main/res/drawable/ic_stat_ic_notification.xml`: иконка уведомлений (status bar)
- `android/app/src/main/res/drawable/launch_background.xml`: ресурс splash/launch background
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`: launcher icon (ic_launcher)
- `android/app/src/main/res/mipmap-hdpi/launcher_icon.png`: альтернативная иконка (launcher_icon)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`: launcher icon (ic_launcher)
- `android/app/src/main/res/mipmap-mdpi/launcher_icon.png`: альтернативная иконка (launcher_icon)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`: launcher icon (ic_launcher)
- `android/app/src/main/res/mipmap-xhdpi/launcher_icon.png`: альтернативная иконка (launcher_icon)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`: launcher icon (ic_launcher)
- `android/app/src/main/res/mipmap-xxhdpi/launcher_icon.png`: альтернативная иконка (launcher_icon)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`: launcher icon (ic_launcher)
- `android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png`: альтернативная иконка (launcher_icon)
- `android/app/src/main/res/values-night/styles.xml`: темы/стили Android (night)
- `android/app/src/main/res/values/styles.xml`: темы/стили Android (light)
- `android/app/src/profile/AndroidManifest.xml`: AndroidManifest (profile buildType)
- `android/build.gradle.kts`: корневой Gradle-конфиг (Kotlin DSL)
- `android/build/reports/problems/problems-report.html`: Gradle report (артефакт сборки; обычно не коммитится)
- `android/gradle.properties`: Gradle properties (оптимизации/флаги)
- `android/gradle/wrapper/gradle-wrapper.properties`: Gradle Wrapper (версия Gradle)
- `android/settings.gradle.kts`: Gradle settings (модули/плагины)

</details>

<details>
<summary><code>ios/</code> (85 файлов)</summary>

- `ios/.gitignore`: gitignore iOS-проекта
- `ios/.metadata`: служебный файл Flutter toolchain (вложенный проект; обычно корень)
- `ios/Flutter/AppFrameworkInfo.plist`: служебный plist Flutter iOS embed
- `ios/Flutter/Debug.xcconfig`: Xcode build-конфиг (Debug/Profile/Release)
- `ios/Flutter/Flutter 2.podspec`: Flutter engine podspec (артефакт CocoaPods/Flutter)
- `ios/Flutter/Flutter 3.podspec`: Flutter engine podspec (артефакт CocoaPods/Flutter)
- `ios/Flutter/Generated 2.xcconfig`: генерируемые build-настройки Flutter (xcconfig)
- `ios/Flutter/Generated 3.xcconfig`: генерируемые build-настройки Flutter (xcconfig)
- `ios/Flutter/Profile.xcconfig`: Xcode build-конфиг (Debug/Profile/Release)
- `ios/Flutter/Release.xcconfig`: Xcode build-конфиг (Debug/Profile/Release)
- `ios/Flutter/flutter_export_environment 2.sh`: скрипт экспортирования переменных окружения Flutter (артефакт)
- `ios/Flutter/flutter_export_environment 3.sh`: скрипт экспортирования переменных окружения Flutter (артефакт)
- `ios/Podfile`: CocoaPods конфигурация iOS (Pods, post_install патчи)
- `ios/Podfile 2.lock`: CocoaPods lockfile (версии Pods)
- `ios/Podfile.lock`: CocoaPods lockfile (версии Pods)
- `ios/PrivacyInfo/SentryPrivacyInfo.xcprivacy`: privacy manifest для Sentry (Apple requirements)
- `ios/README.md`: README по iOS-сборке/особенностям
- `ios/Runner.xcodeproj/project.pbxproj`: Xcode project (build settings, targets, build phases)
- `ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata`: Xcode project/workspace metadata
- `ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist`: Xcode project/workspace metadata
- `ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings`: Xcode project/workspace metadata
- `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`: Xcode scheme
- `ios/Runner.xcworkspace/contents.xcworkspacedata`: Xcode workspace metadata
- `ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings`: Xcode workspace metadata
- `ios/Runner/AppDelegate.swift`: AppDelegate (точка входа iOS; bridge/инициализация)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json`: каталог ассетов Xcode (описание наборов изображений)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-50x50@1x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-50x50@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-57x57@1x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-57x57@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-72x72@1x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-72x72@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json`: каталог ассетов Xcode (описание наборов изображений)
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png`: иконка/launch image (png)
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md`: README по LaunchImage
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`: Storyboard (LaunchScreen/Main)
- `ios/Runner/Base.lproj/Main.storyboard`: Storyboard (LaunchScreen/Main)
- `ios/Runner/BizPluginRegistrant.h`: кастомная регистрация плагинов (ленивая регистрация медиа/IAP)
- `ios/Runner/BizPluginRegistrant.m`: кастомная регистрация плагинов (ленивая регистрация медиа/IAP)
- `ios/Runner/FirebaseEarlyInit.m`: отключённый ранний init Firebase (защита от main-thread I/O и чёрного экрана)
- `ios/Runner/Info.plist`: iOS Info.plist (bundle ids, permissions, флаги)
- `ios/Runner/MainThreadIOMonitor.m`: swizzle-логгер main-thread I/O (диагностика блокировок старта)
- `ios/Runner/NativeBootstrapCoordinator.swift`: native bootstrap канал (lazy install StoreKit2/плагинов)
- `ios/Runner/Runner-Bridging-Header.h`: Bridging Header (ObjC ↔ Swift)
- `ios/Runner/Runner.entitlements`: entitlements (capabilities)
- `ios/Runner/SceneDelegate.swift`: SceneDelegate (life-cycle scenes)
- `ios/Runner/StoreKit2Bridge.swift`: StoreKit2 bridge (MethodChannel/EventChannel; продукты/покупка/restore/updates)
- `ios/Runner/main.m`: Objective-C main() (запуск UIApplicationMain)
- `ios/RunnerTests/RunnerTests.swift`: iOS unit tests (Xcode)
- `ios/analysis_options.yaml`: dart analyzer rules (вложенный flutter-проект внутри ios/)
- `ios/build/d82899a7b3650cba2649fd3844b9c596/_composite.stamp`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/d82899a7b3650cba2649fd3844b9c596/gen_dart_plugin_registrant.stamp`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/d82899a7b3650cba2649fd3844b9c596/gen_localizations.stamp`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/flutter_assets/AssetManifest.bin`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/flutter_assets/AssetManifest.bin.json`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/flutter_assets/AssetManifest.json`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/flutter_assets/FontManifest.json`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/flutter_assets/NOTICES`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/flutter_assets/fonts/MaterialIcons-Regular.otf`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/flutter_assets/packages/cupertino_icons/assets/CupertinoIcons.ttf`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/build/flutter_assets/shaders/ink_sparkle.frag`: артефакт сборки iOS (flutter build output; обычно не коммитится)
- `ios/lib/main.dart`: вложенный Flutter-проект внутри ios/ (скорее всего случайный scaffold)
- `ios/pubspec.lock`: pubspec вложенного Flutter-проекта внутри ios/
- `ios/pubspec.yaml`: pubspec вложенного Flutter-проекта внутри ios/
- `ios/test/widget_test.dart`: тесты вложенного Flutter-проекта внутри ios/
- `ios/web/favicon.png`: web-часть вложенного Flutter-проекта внутри ios/
- `ios/web/index.html`: web-часть вложенного Flutter-проекта внутри ios/
- `ios/web/manifest.json`: web-часть вложенного Flutter-проекта внутри ios/

</details>

<details>
<summary><code>web/</code> (10 файлов)</summary>

- `web/favicon.png`: favicon
- `web/hls_player.html`: встроенный HTML HLS-player (используется для Web HLS)
- `web/icons/Icon-192.png`: web icon (PWA)
- `web/icons/Icon-512.png`: web icon (PWA)
- `web/icons/Icon-maskable-192.png`: web icon (PWA)
- `web/icons/Icon-maskable-512.png`: web icon (PWA)
- `web/icons/logo_light-192.png`: web icon (PWA)
- `web/icons/logo_light-512.png`: web icon (PWA)
- `web/index.html`: точка входа Flutter Web (bootstrap)
- `web/manifest.json`: PWA manifest (name/icons/theme)

</details>

<details>
<summary><code>macos/</code> (29 файлов)</summary>

- `macos/.gitignore`: gitignore macOS-проекта
- `macos/Flutter/Flutter-Debug.xcconfig`: Xcode build-конфиг Flutter macOS
- `macos/Flutter/Flutter-Release.xcconfig`: Xcode build-конфиг Flutter macOS
- `macos/Flutter/GeneratedPluginRegistrant.swift`: генерируемая регистрация плагинов (macOS)
- `macos/Podfile`: CocoaPods конфиг для macOS
- `macos/Runner.xcodeproj/project.pbxproj`: Xcode project (macOS)
- `macos/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist`: Xcode workspace metadata (macOS)
- `macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`: Xcode scheme (macOS)
- `macos/Runner.xcworkspace/contents.xcworkspacedata`: Xcode workspace metadata (macOS)
- `macos/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist`: Xcode workspace metadata (macOS)
- `macos/Runner/AppDelegate.swift`: AppDelegate (macOS host)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json`: описание app iconset (macOS)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png`: иконка приложения (macOS)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png`: иконка приложения (macOS)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png`: иконка приложения (macOS)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png`: иконка приложения (macOS)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png`: иконка приложения (macOS)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png`: иконка приложения (macOS)
- `macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png`: иконка приложения (macOS)
- `macos/Runner/Base.lproj/MainMenu.xib`: главное меню macOS (xib)
- `macos/Runner/Configs/AppInfo.xcconfig`: Xcode configs (AppInfo/Debug/Release/Warnings)
- `macos/Runner/Configs/Debug.xcconfig`: Xcode configs (AppInfo/Debug/Release/Warnings)
- `macos/Runner/Configs/Release.xcconfig`: Xcode configs (AppInfo/Debug/Release/Warnings)
- `macos/Runner/Configs/Warnings.xcconfig`: Xcode configs (AppInfo/Debug/Release/Warnings)
- `macos/Runner/DebugProfile.entitlements`: entitlements (macOS)
- `macos/Runner/Info.plist`: Info.plist (macOS)
- `macos/Runner/MainFlutterWindow.swift`: окно Flutter (macOS)
- `macos/Runner/Release.entitlements`: entitlements (macOS)
- `macos/RunnerTests/RunnerTests.swift`: macOS unit tests (Xcode)

</details>

<details>
<summary><code>windows/</code> (18 файлов)</summary>

- `windows/.gitignore`: gitignore Windows-проекта
- `windows/CMakeLists.txt`: CMake конфиг Windows runner
- `windows/flutter/CMakeLists.txt`: CMake конфиг Windows runner
- `windows/flutter/generated_plugin_registrant.cc`: генерируемые файлы плагинов Flutter (Windows)
- `windows/flutter/generated_plugin_registrant.h`: генерируемые файлы плагинов Flutter (Windows)
- `windows/flutter/generated_plugins.cmake`: генерируемые файлы плагинов Flutter (Windows)
- `windows/runner/CMakeLists.txt`: CMake конфиг Windows runner
- `windows/runner/Runner.rc`: Windows resources script (version/icon)
- `windows/runner/flutter_window.cpp`: код runner (окно/инициализация Flutter engine)
- `windows/runner/flutter_window.h`: код runner (окно/инициализация Flutter engine)
- `windows/runner/main.cpp`: код runner (окно/инициализация Flutter engine)
- `windows/runner/resource.h`: ресурсы Windows (headers)
- `windows/runner/resources/app_icon.ico`: иконка приложения (Windows)
- `windows/runner/runner.exe.manifest`: manifest приложения (UAC/compat)
- `windows/runner/utils.cpp`: код runner (окно/инициализация Flutter engine)
- `windows/runner/utils.h`: код runner (окно/инициализация Flutter engine)
- `windows/runner/win32_window.cpp`: код runner (окно/инициализация Flutter engine)
- `windows/runner/win32_window.h`: код runner (окно/инициализация Flutter engine)

</details>

<details>
<summary><code>linux/</code> (10 файлов)</summary>

- `linux/.gitignore`: gitignore Linux-проекта
- `linux/CMakeLists.txt`: CMake конфиг Linux runner
- `linux/flutter/CMakeLists.txt`: CMake конфиг Linux runner
- `linux/flutter/generated_plugin_registrant.cc`: генерируемые файлы плагинов Flutter (Linux)
- `linux/flutter/generated_plugin_registrant.h`: генерируемые файлы плагинов Flutter (Linux)
- `linux/flutter/generated_plugins.cmake`: генерируемые файлы плагинов Flutter (Linux)
- `linux/runner/CMakeLists.txt`: CMake конфиг Linux runner
- `linux/runner/main.cc`: код runner (GTK приложение/инициализация Flutter)
- `linux/runner/my_application.cc`: код runner (GTK приложение/инициализация Flutter)
- `linux/runner/my_application.h`: код runner (GTK приложение/инициализация Flutter)

</details>

#### 5.5 `tool/`, `scripts/`, `integrations/`, `.github/` (tooling и автоматизация)

<details>
<summary><code>.github/</code> (1 файл)</summary>

- `.github/workflows/ci.yaml`: CI pipeline (GitHub Actions): tests + supabase advisors + sentry check

</details>

<details>
<summary><code>tool/</code> (18 файлов)</summary>

- `tool/apply_plugin_patches.dart`: Dart-скрипт: применяет патчи к Flutter plugins + host patches (Firebase gating, SignInWithApple, OneSignal, prune StoreKit1)
- `tool/plugin_patches/file_selector_ios/ios/file_selector_ios/Sources/file_selector_ios/FileSelectorPlugin.swift`: патч исходников плагина `file_selector_ios` (копируется в реальную директорию плагина)
- `tool/plugin_patches/firebase_core/ios/firebase_core/Sources/firebase_core/FLTFirebaseCorePlugin.m`: патч исходников плагина `firebase_core` (копируется в реальную директорию плагина)
- `tool/plugin_patches/firebase_messaging/ios/firebase_messaging/Sources/firebase_messaging/FLTFirebaseMessagingPlugin.m`: патч исходников плагина `firebase_messaging` (копируется в реальную директорию плагина)
- `tool/plugin_patches/flutter_local_notifications/ios/flutter_local_notifications/Sources/flutter_local_notifications/FlutterLocalNotificationsPlugin.m`: патч исходников плагина `flutter_local_notifications` (копируется в реальную директорию плагина)
- `tool/plugin_patches/google_sign_in_ios/darwin/google_sign_in_ios/Sources/google_sign_in_ios/FLTGoogleSignInPlugin.m`: патч исходников плагина `google_sign_in_ios` (копируется в реальную директорию плагина)
- `tool/plugin_patches/photo_manager/darwin/photo_manager.podspec`: патч исходников плагина `photo_manager` (копируется в реальную директорию плагина)
- `tool/plugin_patches/photo_manager/darwin/photo_manager/Sources/photo_manager/PMPlugin.m`: патч исходников плагина `photo_manager` (копируется в реальную директорию плагина)
- `tool/plugin_patches/photo_manager/darwin/photo_manager/Sources/photo_manager/core/PHAsset+PM_COMMON.m`: патч исходников плагина `photo_manager` (копируется в реальную директорию плагина)
- `tool/plugin_patches/photo_manager/darwin/photo_manager/Sources/photo_manager/core/PMMD5Utils.h`: патч исходников плагина `photo_manager` (копируется в реальную директорию плагина)
- `tool/plugin_patches/photo_manager/darwin/photo_manager/Sources/photo_manager/core/PMMD5Utils.m`: патч исходников плагина `photo_manager` (копируется в реальную директорию плагина)
- `tool/plugin_patches/photo_manager/darwin/photo_manager/Sources/photo_manager/core/PMManager.m`: патч исходников плагина `photo_manager` (копируется в реальную директорию плагина)
- `tool/plugin_patches/photo_manager/ios/photo_manager.podspec`: патч исходников плагина `photo_manager` (копируется в реальную директорию плагина)
- `tool/plugin_patches/sentry_flutter/ios/sentry_flutter/Sources/sentry_flutter/SentryFlutterPlugin.swift`: патч исходников плагина `sentry_flutter` (копируется в реальную директорию плагина)
- `tool/plugin_patches/sentry_flutter/ios/sentry_flutter/Sources/sentry_flutter_objc/SentryFlutterPlugin.h`: патч исходников плагина `sentry_flutter` (копируется в реальную директорию плагина)
- `tool/plugin_patches/url_launcher_ios/ios/url_launcher_ios/Sources/url_launcher_ios/URLLauncherPlugin.swift`: патч исходников плагина `url_launcher_ios` (копируется в реальную директорию плагина)
- `tool/plugin_patches/webview_flutter_wkwebview/darwin/webview_flutter_wkwebview/Sources/webview_flutter_wkwebview/SecTrustProxyAPIDelegate.swift`: патч исходников плагина `webview_flutter_wkwebview` (копируется в реальную директорию плагина)
- `tool/strip_iap_from_registrant.dart`: Dart-скрипт: удаляет регистрацию StoreKit1 (`in_app_purchase_storekit`) из iOS registrant

</details>

<details>
<summary><code>scripts/</code> (10 файлов)</summary>

- `scripts/README_case_indexing.md`: README по пайплайну мини-кейсов (индексация/структура)
- `scripts/debug_cases.py`: диагностика/валидатор контента мини-кейсов (скрипт)
- `scripts/index_cases.py`: индексация/подготовка мини-кейсов (скрипт)
- `scripts/lint_tokens.sh`: проверка/линт дизайн-токенов (скрипт)
- `scripts/requirements.txt`: Python dependencies для scripts/*.py
- `scripts/sentry_check.sh`: CI check: Sentry unresolved issues / gating
- `scripts/supabase_advisor_check.sh`: CI check: Supabase security advisors (RLS/policies)
- `scripts/test_rag_search.py`: скрипт тестирования качества RAG поиска
- `scripts/upload_from_drive.py`: скрипт импорта данных/контента из Google Drive
- `scripts/vercel_build.sh`: build-скрипт для Vercel (flutter build web + post-steps)

</details>

<details>
<summary><code>integrations/</code> (1 элемент)</summary>

- `integrations/app-store-connect-mcp-server`: git submodule: MCP сервер для App Store Connect (не развёрнут в этом репо)

</details>

<details>
<summary><code>gradle/</code> (2 файла)</summary>

- `gradle/wrapper/gradle-wrapper.jar`: Gradle Wrapper бинарник
- `gradle/wrapper/gradle-wrapper.properties`: Gradle Wrapper конфиг

</details>

<details>
<summary><code>.cursor/</code> (2 файла)</summary>

- `.cursor/rules/bizlevel-cursorrules.txt`: правила/инструкции для Cursor (AI)
- `.cursor/worktrees.json`: конфиг Cursor worktrees

</details>

<details>
<summary><code>.vscode/</code> (1 файл)</summary>

- `.vscode/settings.json`: конфиг VS Code

</details>

#### 5.6 `assets/` — ассеты приложения
- **Назначение**: статические ассеты (SVG/PNG), используемые UI и контентом (уровни/артефакты/кейсы).
- **Где что лежит**:
  - `assets/icons/`: SVG‑иконки интерфейса (кнопки/табы/бейджи).
    - `assets/icons/categories/`: SVG‑иконки категорий (используются в библиотеке/фильтрах).
  - `assets/images/`: изображения и иллюстрации.
    - `assets/images/avatars/`: аватары пользователя + аватары менторов (Leo/Max).
    - `assets/images/lvls/`: обложки уровней.
    - `assets/images/artefacts/`: карточки артефактов (front/back).
    - `assets/images/cases/`: иллюстрации мини‑кейсов.
    - `assets/images/street/`: иконки Main Street (карта/навигация).
- **Важно**: пути ассетов подключены в `pubspec.yaml`; часть ассетов адресуется шаблонами (например, по номеру уровня), поэтому пофайловой список здесь не ведём.

#### 5.7 `docs/` — документация
- **Назначение**: проектная документация (концепты/планы/аудиты/архивы/контент).
- **Где что лежит**:
  - `docs/`: «живые» документы по продукту и разработке (концепт, статус, спек‑наброски, планы).
  - `docs/archive/`: исторические заметки/аудиты/черновики (в т.ч. файлы с кириллицей).
  - `docs/bizlevel-implementations-plan-stages/`: поэтапные планы внедрения BizLevel (phases).
  - `docs/rag-json/`: legacy‑папка для прежнего пайплайна RAG (скрипты + данные уроков в JSON/JSONL).
- **Важно**: это не runtime‑часть приложения; список файлов в документе не поддерживаем, чтобы не «раздувать» структуру.

#### 5.8 `test/` — тесты

<details>
<summary><code>test/</code> (62 файла)</summary>

- `test/auth_flow_test.dart`: тест: `auth_flow_test.dart`
- `test/deep_link_test.dart`: тест: `deep_link_test.dart`
- `test/deep_links_test.dart`: тест: `deep_links_test.dart`
- `test/edge/leo_memory_function_test.md`: заметки/инструкции по тестированию Edge: `leo_memory_function_test.md`
- `test/flutter_test_config.dart`: глобальный конфиг Flutter tests (goldens/overrides)
- `test/infrastructure_integration_test.dart`: integration тест: `infrastructure_integration_test.dart`
- `test/infrastructure_test.dart`: тест: `infrastructure_test.dart`
- `test/integration/practice_log_max_comment_test.dart`: integration тест: `practice_log_max_comment_test.dart`
- `test/leo_integration_test.dart`: integration тест: `leo_integration_test.dart`
- `test/lesson_progress_persistence_test.dart`: тест: `lesson_progress_persistence_test.dart`
- `test/level_flow_test.dart`: тест: `level_flow_test.dart`
- `test/level_zero_flow_test.dart`: тест: `level_zero_flow_test.dart`
- `test/levels_system_test.dart`: тест: `levels_system_test.dart`
- `test/mocks.dart`: общие моки/фейки для тестов
- `test/profile_monetization_test.dart`: тест: `profile_monetization_test.dart`
- `test/providers/goals_providers_test.dart`: тест провайдеров Riverpod: `goals_providers_test.dart`
- `test/providers/provider_smoke_test.dart`: тест провайдеров Riverpod: `provider_smoke_test.dart`
- `test/providers/startup_performance_test.dart`: тест провайдеров Riverpod: `startup_performance_test.dart`
- `test/rag/rag_quality_test.dart`: тест: `rag_quality_test.dart`
- `test/repositories/goals_repository_progress_test.dart`: тест репозиториев (SWR/Hive/Supabase): `goals_repository_progress_test.dart`
- `test/repositories/goals_repository_test.dart`: тест репозиториев (SWR/Hive/Supabase): `goals_repository_test.dart`
- `test/repositories/lessons_repository_test.dart`: тест репозиториев (SWR/Hive/Supabase): `lessons_repository_test.dart`
- `test/repositories/levels_repository_test.dart`: тест репозиториев (SWR/Hive/Supabase): `levels_repository_test.dart`
- `test/repositories/library_repository_test.dart`: тест репозиториев (SWR/Hive/Supabase): `library_repository_test.dart`
- `test/repositories/practice_log_aggregate_test.dart`: тест репозиториев (SWR/Hive/Supabase): `practice_log_aggregate_test.dart`
- `test/routing/app_router_test.dart`: тест: `app_router_test.dart`
- `test/screens/auth/login_screen_test.dart`: widget/integration тест экранов: `login_screen_test.dart`
- `test/screens/auth/register_screen_test.dart`: widget/integration тест экранов: `register_screen_test.dart`
- `test/screens/checkpoint_l4_l7_buttons_test.dart`: widget/integration тест экранов: `checkpoint_l4_l7_buttons_test.dart`
- `test/screens/checkpoint_l7_cta_navigation_test.dart`: widget/integration тест экранов: `checkpoint_l7_cta_navigation_test.dart`
- `test/screens/checkpoint_l7_integration_test.dart`: widget/integration тест экранов: `checkpoint_l7_integration_test.dart`
- `test/screens/checkpoints_l4_l7_dialog_flow_test.dart`: widget/integration тест экранов: `checkpoints_l4_l7_dialog_flow_test.dart`
- `test/screens/goal_practice_aggregates_test.dart`: widget/integration тест экранов: `goal_practice_aggregates_test.dart`
- `test/screens/goal_screen_top_tools_test.dart`: widget/integration тест экранов: `goal_screen_top_tools_test.dart`
- `test/screens/goal_screen_zw_and_sticky_test.dart`: widget/integration тест экранов: `goal_screen_zw_and_sticky_test.dart`
- `test/screens/gp_store_screen_test.dart`: widget/integration тест экранов: `gp_store_screen_test.dart`
- `test/screens/home_continue_card_test.dart`: widget/integration тест экранов: `home_continue_card_test.dart`
- `test/screens/leo_dialog_screen_test.dart`: widget/integration тест экранов: `leo_dialog_screen_test.dart`
- `test/screens/level_detail_screen_quiz_flow_test.dart`: widget/integration тест экранов: `level_detail_screen_quiz_flow_test.dart`
- `test/screens/level_detail_screen_test.dart`: widget/integration тест экранов: `level_detail_screen_test.dart`
- `test/screens/library_screen_test.dart`: widget/integration тест экранов: `library_screen_test.dart`
- `test/screens/next_action_banner_test.dart`: widget/integration тест экранов: `next_action_banner_test.dart`
- `test/screens/profile_screen_integration_test.dart`: widget/integration тест экранов: `profile_screen_integration_test.dart`
- `test/screens/street_screen_test.dart`: widget/integration тест экранов: `street_screen_test.dart`
- `test/screens/tower_checkpoint_navigation_test.dart`: widget/integration тест экранов: `tower_checkpoint_navigation_test.dart`
- `test/screens/tower_map_screen_test.dart`: widget/integration тест экранов: `tower_map_screen_test.dart`
- `test/services/auth_service_test.dart`: тест сервисов (Auth/GP/Leo/Payment/...): `auth_service_test.dart`
- `test/services/gp_bonus_flow_test.dart`: тест сервисов (Auth/GP/Leo/Payment/...): `gp_bonus_flow_test.dart`
- `test/services/gp_service_cache_test.dart`: тест сервисов (Auth/GP/Leo/Payment/...): `gp_service_cache_test.dart`
- `test/services/gp_unlock_floor_flow_test.dart`: тест сервисов (Auth/GP/Leo/Payment/...): `gp_unlock_floor_flow_test.dart`
- `test/services/leo_service_gp_spend_test.dart`: тест сервисов (Auth/GP/Leo/Payment/...): `leo_service_gp_spend_test.dart`
- `test/services/payment_service_test.dart`: тест сервисов (Auth/GP/Leo/Payment/...): `payment_service_test.dart`
- `test/ui_text_scaling_test.dart`: тест: `ui_text_scaling_test.dart`
- `test/user_skills_increment_test.dart`: тест: `user_skills_increment_test.dart`
- `test/web_smoke_test.dart`: smoke тест: `web_smoke_test.dart`
- `test/widgets/donut_progress_test.dart`: widget тест виджетов UI: `donut_progress_test.dart`
- `test/widgets/goal_checkpoint_progress_test.dart`: widget тест виджетов UI: `goal_checkpoint_progress_test.dart`
- `test/widgets/home_quote_card_test.dart`: widget тест виджетов UI: `home_quote_card_test.dart`
- `test/widgets/leo_quiz_widget_test.dart`: widget тест виджетов UI: `leo_quiz_widget_test.dart`
- `test/widgets/notification_center_test.dart`: widget тест виджетов UI: `notification_center_test.dart`
- `test/widgets/skills_tree_view_test.dart`: widget тест виджетов UI: `skills_tree_view_test.dart`

</details>

#### 5.9 Служебные tracked‑артефакты (нетипично для репозитория)
> Эти файлы обычно генерируются локально и не должны быть в git, но сейчас они tracked — поэтому перечислены здесь.

<details>
<summary><code>.gradle/</code> (13 файлов)</summary>

- `.gradle/8.12/checksums/checksums.lock`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/8.12/executionHistory/executionHistory.bin`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/8.12/executionHistory/executionHistory.lock`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/8.12/fileChanges/last-build.bin`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/8.12/fileHashes/fileHashes.bin`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/8.12/fileHashes/fileHashes.lock`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/8.12/gc.properties`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/buildOutputCleanup/buildOutputCleanup.lock`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/buildOutputCleanup/cache.properties`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/buildOutputCleanup/outputFiles.bin`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/config.properties`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/file-system.probe`: артефакты/caches Gradle (обычно не коммитятся)
- `.gradle/vcs-1/gc.properties`: артефакты/caches Gradle (обычно не коммитятся)

</details>

<details>
<summary><code>.sentry-native/</code> (7 файлов)</summary>

- `.sentry-native/0eb2d50c-ec68-4682-905b-6662ab5605aa.run.lock`: локальные артефакты Sentry native SDK (обычно не коммитятся)
- `.sentry-native/0eb2d50c-ec68-4682-905b-6662ab5605aa.run/__sentry-breadcrumb1`: локальные артефакты Sentry native SDK (обычно не коммитятся)
- `.sentry-native/0eb2d50c-ec68-4682-905b-6662ab5605aa.run/__sentry-breadcrumb2`: локальные артефакты Sentry native SDK (обычно не коммитятся)
- `.sentry-native/0eb2d50c-ec68-4682-905b-6662ab5605aa.run/__sentry-event`: локальные артефакты Sentry native SDK (обычно не коммитятся)
- `.sentry-native/0eb2d50c-ec68-4682-905b-6662ab5605aa.run/session.json`: локальные артефакты Sentry native SDK (обычно не коммитятся)
- `.sentry-native/metadata`: локальные артефакты Sentry native SDK (обычно не коммитятся)
- `.sentry-native/settings.dat`: локальные артефакты Sentry native SDK (обычно не коммитятся)

</details>

<details>
<summary><code>coverage/</code> (1 файл)</summary>

- `coverage/lcov.info`: артефакты coverage (lcov)

</details>

<details>
<summary><code>.specstory/</code> (1 файл)</summary>

- `.specstory/.gitignore`: служебные файлы SpecStory/IDE истории

</details>


---

### 6) Легаси и лишнее (кандидаты на удаление)

Этот раздел отвечает на вопросы:
- **Что сейчас реально не используется** в приложении (runtime).
- **Что можно удалить безопасно** (без поломки сборки/тестов), и что потребует чистки тестов/исторического кода.

> Методика: статический анализ `import/export/part` по `lib/**.dart` + проверка реального роутинга в `lib/routing/app_router.dart` + поиск упоминаний по репозиторию.

#### 6.1 Можно удалить без последствий (не задействовано нигде в коде)

##### Dart‑код (полностью не подключён: нет импортов/экспортов на файл)
- `lib/compat/webview_stub.dart`
- `lib/models/core_goal_model.dart`
- `lib/models/motivational_quote_model.dart`
- `lib/models/reminder_check_model.dart`
- `lib/models/skill_model.dart`
- `lib/providers/theme_provider.dart`
- `lib/screens/auth/onboarding_screens.dart` (deprecated stub)
- `lib/screens/auth/onboarding_video_screen.dart` (deprecated stub)
- `lib/screens/goal/controller/goal_screen_controller.dart`
- `lib/screens/goal/widgets/checkin_form.dart`
- `lib/screens/payment_screen.dart`
- `lib/services/media_picker_service.dart`
- `lib/services/personalization_service.dart`
- `lib/services/push_service_platform.dart`
- `lib/services/push_service_android.dart`
- `lib/services/push_service_ios.dart`
- `lib/theme/dynamic_theme_builder.dart`
- `lib/theme/responsive.dart`
- `lib/utils/back_navigation_mixin.dart`
- `lib/utils/friendly_messages.dart`
- `lib/utils/responsive.dart`
- `lib/widgets/category_box.dart`
- `lib/widgets/common/bizlevel_progress_bar.dart`
- `lib/widgets/common/list_section_tile.dart`
- `lib/widgets/common/onboarding_tooltip.dart`
- `lib/widgets/common/success_indicator.dart`
- `lib/widgets/dev/theme_gallery.dart`
- `lib/widgets/feature_item.dart`
- `lib/widgets/floating_chat_bubble.dart`
- `lib/widgets/home/home_cta.dart`
- `lib/widgets/recommend_item.dart`
- `lib/widgets/setting_box.dart`
- `lib/widgets/setting_item.dart`
- `lib/widgets/stat_card.dart`

##### Generated‑части к legacy‑моделям (удалять вместе с соответствующей моделью)
- `lib/models/core_goal_model.freezed.dart`, `lib/models/core_goal_model.g.dart`
- `lib/models/motivational_quote_model.freezed.dart`, `lib/models/motivational_quote_model.g.dart`
- `lib/models/reminder_check_model.freezed.dart`, `lib/models/reminder_check_model.g.dart`
- `lib/models/skill_model.freezed.dart`, `lib/models/skill_model.g.dart`

##### Файлы‑спутники (используются только файлами из списка выше — удалять вместе)
> Эти файлы **не используются рантаймом и тестами**, но импортируются *внутри* уже «мёртвых»/неподключённых файлов.
- `lib/theme/design_tokens.dart` (импортируется только dev‑экраном `lib/widgets/dev/theme_gallery.dart`)
- `lib/providers/leo_unread_provider.dart` (импортируется только legacy‑виджетом `lib/widgets/floating_chat_bubble.dart`)

##### Pubspec зависимости (плагины), которые нигде не импортируются
> Эти зависимости присутствуют в `pubspec.yaml`, но по репозиторию нет ни одного `package:<dep>/...` импорта.  
> **Нюанс**: `cupertino_icons` обычно не импортируется напрямую; критерий — фактическое использование `CupertinoIcons` в Dart‑коде (в текущем репозитории `CupertinoIcons` **не встречается**).  
> Ещё нюанс: часть зависимостей может быть **транзитивной** (например, `flutter_cache_manager` тянется `cached_network_image`, а `json_annotation` — `freezed_annotation`). Это значит, что их можно убрать как *direct dependency*, но они всё равно останутся в `pubspec.lock`, пока вы используете зависимости, которые их тянут.
- `cupertino_icons` (можно убрать, если не используете `CupertinoIcons` — сейчас не используется)
- `dynamic_color` (не используется)
- `flutter_animate` (не используется)
- `flutter_cache_manager` (не используется напрямую; вероятно транзитивен через `cached_network_image`)
- `json_annotation` (не используется напрямую; транзитивен через `freezed_annotation`)

##### Нетипично закоммиченные артефакты/кеши (можно удалить из git)
- **Android**:
  - `local.properties` (содержит локальный путь `sdk.dir=...`; не должен быть в VCS)
  - `android/build/reports/problems/problems-report.html`
  - `.gradle/**` (кеш Gradle)
- **iOS**:
  - `ios/build/**` (Flutter build output)
  - `ios/lib/**`, `ios/pubspec.yaml`, `ios/pubspec.lock`, `ios/test/**`, `ios/web/**` (похоже на случайно добавленный вложенный Flutter scaffold внутри `ios/`)
  - дубликаты артефактов Flutter/CocoaPods (в проекте не referenced):
    - `ios/Flutter/Generated 2.xcconfig`, `ios/Flutter/Generated 3.xcconfig`
    - `ios/Flutter/flutter_export_environment 2.sh`, `ios/Flutter/flutter_export_environment 3.sh`
    - `ios/Flutter/Flutter 2.podspec`, `ios/Flutter/Flutter 3.podspec`
    - `ios/Podfile 2.lock`
- **Supabase**:
  - `supabase/.temp/**` (служебные файлы Supabase CLI)
- **Sentry / IDE**:
  - `.sentry-native/**`
  - `coverage/lcov.info`
  - `.specstory/**`
- **Flutter toolchain**:
  - `.flutter-plugins-dependencies 2`, `.flutter-plugins-dependencies 3`, `.flutter-plugins-dependencies 4` (нестандартные дубликаты; не используются инструментами)

#### 6.2 Легаси, не используемое рантаймом (удаление потребует чистки тестов и/или легаси‑кода)

Эти элементы **не используются текущим приложением** (не достижимы из `lib/main.dart`/`GoRouter`), но всё ещё встречаются в тестах или legacy‑контуре:

- **Legacy навигация/экраны**:
  - `lib/screens/root_app.dart` (используется в `test/profile_monetization_test.dart`)
  - `lib/screens/levels_map_screen.dart` (используется в `test/levels_system_test.dart`)
- **Legacy оплата**:
  - `lib/services/payment_service.dart` (используется в `test/services/payment_service_test.dart`)
  - `supabase/functions/create-checkout-session/index.ts` (вызывается из `PaymentService`; в текущем приложении не используется)
- **Legacy UI‑компоненты, которые встречаются только в тестах/legacy‑экранах**:
  - `lib/screens/goal/widgets/next_action_banner.dart` (используется в `test/screens/next_action_banner_test.dart`, но не импортируется в текущем Goal UI)
  - `lib/widgets/artifact_card.dart` (используется в `test/profile_monetization_test.dart`, но не импортируется в текущем Profile UI)
  - `lib/widgets/level_card.dart` (используется только из `LevelsMapScreen`)
  - `lib/widgets/notification_box.dart`, `lib/widgets/user_info_bar.dart` (legacy‑контур/тесты)

#### 6.3 Edge Functions: не вызываются текущим клиентом (удалять только при уверенности)

Эти функции **не вызываются текущим Flutter‑клиентом**, но могут быть нужны для backward compatibility/отладки/ручных операций:
- `supabase/functions/leo-rag/index.ts` (legacy RAG endpoint; текущий клиент использует `/leo-chat`)
- `supabase/functions/leo-test/index.ts` (тестовый endpoint)
- `supabase/functions/storage-integrity-check/index.ts` (сервисная проверка Storage; может запускаться вручную/в CI)


<details>
<summary><code>lib/constants/</code> (1 файл)</summary>

- `lib/constants/push_flags.dart`: флаги/константы, связанные с пуш‑инициализацией и экспериментами.

</details>

<details>
<summary><code>lib/compat/</code> (4 файла)</summary>

- `lib/compat/html_stub.dart`: заглушка для `dart:html` (не‑web платформы).
- `lib/compat/ui_stub.dart`: заглушка для web‑специфичного UI.
- `lib/compat/url_strategy_noop.dart`: no‑op стратегия URL (когда PathUrlStrategy недоступна/не нужна).
- `lib/compat/webview_stub.dart`: заглушка webview для платформ без реализации.

</details>

<details>
<summary><code>lib/models/</code> (26 файлов)</summary>

- `lib/models/core_goal_model.dart`: модель «цели» (CoreGoal) для goal‑флоу (**legacy/не используется**).
- `lib/models/core_goal_model.freezed.dart`: сгенерировано Freezed (immutable/data‑class, copyWith, equality).
- `lib/models/core_goal_model.g.dart`: сгенерировано `json_serializable` (JSON ↔ model).
- `lib/models/goal_update.dart`: DTO/модель обновления цели (payload для сохранения).
- `lib/models/lesson_model.dart`: модель урока (видео/квиз/метаданные).
- `lib/models/lesson_model.freezed.dart`: generated Freezed.
- `lib/models/lesson_model.g.dart`: generated JSON.
- `lib/models/level_model.dart`: модель уровня (номер/этаж/обложка/описание/контент).
- `lib/models/level_model.freezed.dart`: generated Freezed.
- `lib/models/level_model.g.dart`: generated JSON.
- `lib/models/motivational_quote_model.dart`: модель мотивационной цитаты (home‑карточка) (**legacy/не используется**).
- `lib/models/motivational_quote_model.freezed.dart`: generated Freezed.
- `lib/models/motivational_quote_model.g.dart`: generated JSON.
- `lib/models/reminder_check_model.dart`: модель «чека»/среза напоминаний (для UI/проверок) (**legacy/не используется**; в коде используются Map/DTO без модели).
- `lib/models/reminder_check_model.freezed.dart`: generated Freezed.
- `lib/models/reminder_check_model.g.dart`: generated JSON.
- `lib/models/reminder_prefs.dart`: модель настроек напоминаний пользователя.
- `lib/models/skill_model.dart`: модель навыка (дерево навыков, палитра) (**legacy/не используется**; используется `UserSkillModel`).
- `lib/models/skill_model.freezed.dart`: generated Freezed.
- `lib/models/skill_model.g.dart`: generated JSON.
- `lib/models/user_model.dart`: модель профиля пользователя (users table).
- `lib/models/user_model.freezed.dart`: generated Freezed.
- `lib/models/user_model.g.dart`: generated JSON.
- `lib/models/user_skill_model.dart`: модель навыка пользователя (прогресс/статус).
- `lib/models/user_skill_model.freezed.dart`: generated Freezed.
- `lib/models/user_skill_model.g.dart`: generated JSON.

</details>

<details>
<summary><code>lib/providers/</code> (18 файлов)</summary>

- `lib/providers/auth_provider.dart`: провайдеры Supabase/AuthState/currentUser/currentLevel (без блокировки cold‑start).
- `lib/providers/login_controller.dart`: контроллер логина/регистрации (UI actions + обработка ошибок).
- `lib/providers/theme_provider.dart`: **legacy/не используется** (провайдер темы не импортируется активным UI; кандидат на удаление).
- `lib/providers/reminder_prefs_provider.dart`: загрузка/сохранение настроек напоминаний (UI ↔ storage).
- `lib/providers/gp_providers.dart`: `gpServiceProvider` + `gpBalanceProvider` (SWR баланс GP).
- `lib/providers/leo_service_provider.dart`: DI‑провайдер `LeoService`.
- `lib/providers/leo_unread_provider.dart`: **legacy/не используется** (используется только в legacy‑виджетах; в активном UI не импортируется).
- `lib/providers/cases_repository_provider.dart`: DI‑провайдер `CasesRepository`.
- `lib/providers/cases_provider.dart`: `caseStatusProvider` + `caseActionsProvider` (start/skip/complete/hints).
- `lib/providers/levels_repository_provider.dart`: DI‑провайдер `LevelsRepository`.
- `lib/providers/levels_provider.dart`: провайдеры уровней/карты/продолжения/башни (данные для UI).
- `lib/providers/lessons_repository_provider.dart`: DI‑провайдер `LessonsRepository`.
- `lib/providers/lessons_provider.dart`: провайдеры списка уроков и прогресса.
- `lib/providers/lesson_progress_provider.dart`: локальный прогресс урока (SharedPreferences).
- `lib/providers/goals_repository_provider.dart`: DI‑провайдер `GoalsRepository`.
- `lib/providers/goals_providers.dart`: провайдеры цели/журнала/чекпоинтов (goal journey).
- `lib/providers/library_providers.dart`: провайдеры библиотеки (разделы/категории/избранное).
- `lib/providers/user_skills_provider.dart`: провайдеры дерева навыков пользователя.

</details>

<details>
<summary><code>lib/repositories/</code> (6 файлов)</summary>

- `lib/repositories/user_repository.dart`: чтение/обновление профиля пользователя (таблица `users`).
- `lib/repositories/levels_repository.dart`: загрузка уровней/прогресса + SWR‑кеш (Hive; web без кеша).
- `lib/repositories/lessons_repository.dart`: загрузка уроков по уровню + кеширование.
- `lib/repositories/goals_repository.dart`: работа с `user_goal`, `practice_log`, история цели.
- `lib/repositories/cases_repository.dart`: прогресс мини‑кейсов (`user_case_progress`) + SWR‑кеш.
- `lib/repositories/library_repository.dart`: библиотека (курсы/гранты/акселераторы/избранное) + SWR‑кеш.

</details>

<details>
<summary><code>lib/services/</code> (20 файлов)</summary>

- `lib/services/supabase_service.dart`: инициализация Supabase + доступ к PostgREST/Storage, signed URLs, ретраи.
- `lib/services/auth_service.dart`: обёртка Supabase Auth + типизация ошибок (`AuthFailure`).
- `lib/services/context_service.dart`: сборка `userContext`/`levelContext` для AI‑ботов.
- `lib/services/personalization_service.dart`: **legacy/не используется** (в активном коде не импортируется).
- `lib/services/leo_service.dart`: вызовы Edge `leo-chat`, сохранение истории, GP‑списания, recommended chips.
- `lib/services/gp_service.dart`: GP‑экономика (RPC balance/spend/bonus/unlock + Edge verify/init).
- `lib/services/iap_service.dart`: абстракция IAP (Android: `in_app_purchase`, iOS: StoreKit2).
- `lib/services/storekit2_service.dart`: iOS StoreKit2 bridge (MethodChannel/EventChannel).
- `lib/services/native_bootstrap.dart`: iOS lazy‑регистрация нативных плагинов (IAP/media) для ускорения старта.
- `lib/services/payment_service.dart`: legacy‑checkout через Edge `create-checkout-session` (**в рантайме не используется; используется только в тестах**).
- `lib/services/notifications_service.dart`: локальные уведомления (schedule/cancel), интеграция timezone.
- `lib/services/timezone_gate.dart`: lazy‑инициализация timezone (только когда нужно).
- `lib/services/push_service.dart`: OneSignal пуши (инициализация/токены/роутинг).
- `lib/services/push_service_platform.dart`: **legacy/не используется** (файл‑заготовка под platform abstraction; текущий `PushService` реализован в одном файле).
- `lib/services/push_service_android.dart`: **legacy/не используется**.
- `lib/services/push_service_ios.dart`: **legacy/не используется**.
- `lib/services/reminder_prefs_storage.dart`: хранение prefs напоминаний (SharedPreferences).
- `lib/services/reminder_prefs_cache.dart`: кеш/обёртка над prefs напоминаний.
- `lib/services/notification_log_service.dart`: локальный журнал баннеров/нотификаций (Hive).
- `lib/services/media_picker_service.dart`: **legacy/не используется** (локальный выбор медиа/файлов удалён из продукта).

</details>

<details>
<summary><code>lib/theme/</code> (18 файлов)</summary>

- `lib/theme/design_tokens.dart`: barrel export токенов/тем (единая точка импорта).
- `lib/theme/color.dart`: палитра и семантические цвета (brand + glass gradients).
- `lib/theme/spacing.dart`: spacing‑токены + утилиты отступов.
- `lib/theme/dimensions.dart`: размеры (радиусы/min sizes/elevations).
- `lib/theme/typography.dart`: типографика (TextTheme BizLevel).
- `lib/theme/app_theme.dart`: сборка ThemeData + доменные темы + темы компонентов.
- `lib/theme/dynamic_theme_builder.dart`: **legacy/не используется** (см. раздел Design System).
- `lib/theme/input_decoration_theme.dart`: единая тема полей ввода.
- `lib/theme/material_elevation.dart`: tonal elevation для surface.
- `lib/theme/effects.dart`: тени/глоу (в т.ч. glass shadow).
- `lib/theme/animations.dart`: токены длительностей/кривых.
- `lib/theme/chat_theme.dart`: ThemeExtension для чатов (bubble colors/style).
- `lib/theme/quiz_theme.dart`: ThemeExtension для квизов (option states).
- `lib/theme/gp_theme.dart`: ThemeExtension для GP (badge/positive/negative).
- `lib/theme/game_progress_theme.dart`: ThemeExtension прогресса (progress bar + milestone).
- `lib/theme/video_theme.dart`: ThemeExtension видео‑контролов (scrim/progress).
- `lib/theme/responsive.dart`: утилиты адаптивной вёрстки/брейкпоинты (**legacy/не используется**).
- `lib/theme/ui_strings.dart`: централизованные строки UI (где применимо).

</details>

<details>
<summary><code>lib/utils/</code> (11 файлов)</summary>

- `lib/utils/env_helper.dart`: чтение env из `.env`/`--dart-define` (единый API).
- `lib/utils/deep_link.dart`: обработка deep links (парсинг/маршрутизация).
- `lib/utils/hive_box_helper.dart`: безопасное открытие Hive box (в т.ч. для web‑ограничений).
- `lib/utils/friendly_messages.dart`: **legacy/не используется** (человекочитаемые сообщения ошибок; в активном UI не импортируется).
- `lib/utils/formatters.dart`: форматирование чисел/дат/строк.
- `lib/utils/date_picker.dart`: обёртки выбора дат (UX).
- `lib/utils/level_page_index.dart`: хелперы индексации страниц уровня (page‑flow).
- `lib/utils/max_context_helper.dart`: формирование контекста для Макса (цель/чекпоинты).
- `lib/utils/back_navigation_mixin.dart`: **legacy/не используется** (back‑guard mixin; в активном UI не импортируется).
- `lib/utils/constant.dart`: misc константы (legacy).
- `lib/utils/responsive.dart`: адаптивные утилиты (legacy/до рефакторинга в theme).

</details>

<details>
<summary><code>lib/screens/</code> (38 файлов)</summary>

- `lib/screens/app_shell.dart`: ShellRoute‑контейнер (4 таба `/home /tower /chat /profile`), синхронизация `GoRouter` ↔ `PageView`, desktop‑nav.
- `lib/screens/artifacts_screen.dart`: экран артефактов (grid 2–4 колонки), lock/unlock по прогрессу, full‑screen flip, “NEW” через Hive.
- `lib/screens/auth/login_screen.dart`: экран входа (email/password + провайдеры авторизации, обработка ошибок).
- `lib/screens/auth/onboarding_screens.dart`: **deprecated stub** (онбординг удалён из навигации; исходники перенесены в `docs/archive/`).
- `lib/screens/auth/onboarding_video_screen.dart`: **deprecated stub** (видео‑онбординг удалён из навигации; исходники перенесены в `docs/archive/`).
- `lib/screens/auth/register_screen.dart`: экран регистрации.
- `lib/screens/biz_tower_screen.dart`: экран «Башня» (рендер узлов уровней/кейсов/чекпоинтов, автоскролл, гейтинг этажей/GP).
- `lib/screens/checkpoints/checkpoint_screen.dart`: единый экран чекпоинтов L1/L4/L7 (Max bubble, CTA, контент по типу).
- `lib/screens/goal/controller/goal_screen_controller.dart`: **legacy/не используется** (контроллер/логика старой версии GoalScreen).
- `lib/screens/goal/widgets/checkin_form.dart`: **legacy/не используется** (форма чек‑ина старой версии).
- `lib/screens/goal/widgets/goal_compact_card.dart`: компактная карточка цели (для списков/превью).
- `lib/screens/goal/widgets/motivation_card.dart`: мотивационная карточка/поддержка (goal journey).
- `lib/screens/goal/widgets/next_action_banner.dart`: **legacy (используется в тестах, но не в текущем UI)**.
- `lib/screens/goal/widgets/practice_journal_section.dart`: секция журнала применений (последние записи, добавление).
- `lib/screens/goal_history_screen.dart`: экран истории целей (версии/переключение).
- `lib/screens/goal_screen.dart`: основной экран цели (цель + метрика + журнал + напоминания).
- `lib/screens/gp_store_screen.dart`: магазин GP (iOS StoreKit2 / Android Billing / Web checkout + verify).
- `lib/screens/leo_chat_screen.dart`: экран «Менторы» (список диалогов `leo_chats`, старт новых чатов Leo/Max).
- `lib/screens/leo_dialog_screen.dart`: экран диалога (пагинация `leo_messages`, подсказки‑chips, caseMode, embedded).
- `lib/screens/level_detail_screen.dart`: прохождение уровня блоками (Intro → Video → Quiz → Artifact/Goal/Profile), gating страниц и completion.
- `lib/screens/levels_map_screen.dart`: **legacy экран** карты уровней (не используется текущим `GoRouter`, но встречается в тестах).
- `lib/screens/library/library_screen.dart`: библиотека (2 таба: разделы/избранное).
- `lib/screens/library/library_section_screen.dart`: список ресурсов по типу (категории, expand/collapse, избранное).
- `lib/screens/main_street_screen.dart`: главная (home): quote/goal/continue/quick actions, refresh invalidation.
- `lib/screens/mini_case_screen.dart`: мини‑кейс (intro → видео → caseMode диалог; complete/skip, бонусы).
- `lib/screens/notifications_settings_screen.dart`: экран настроек напоминаний (обёртка вокруг `RemindersSettingsContent`).
- `lib/screens/payment_screen.dart`: legacy‑инструкция оплаты (Kaspi‑перевод; исторический экран).
- `lib/screens/profile_screen.dart`: профиль (аватар, about‑me редактор, skills tree, достижения, меню уведомлений/выхода).
- `lib/screens/root_app.dart`: legacy 3‑tab shell (LevelsMap/Chat/Profile) — **не используется текущим `GoRouter`**, но встречается в тестах/истории.
- `lib/screens/tower/tower_constants.dart`: `part of` башни — константы и конфиги layout.
- `lib/screens/tower/tower_extensions.dart`: `part of` башни — extension методы для node‑map (isMiniCase/isGoalCheckpoint/dataMap и т.д.).
- `lib/screens/tower/tower_floor_widgets.dart`: `part of` башни — UI‑виджеты этажей/подложек.
- `lib/screens/tower/tower_grid.dart`: `part of` башни — математика/верстка сетки (позиционирование узлов).
- `lib/screens/tower/tower_helpers.dart`: `part of` башни — хелперы (breadcrumbs, guards, расчёты).
- `lib/screens/tower/tower_painters.dart`: `part of` башни — кастомные painter’ы (линии/соединения).
- `lib/screens/tower/tower_tiles.dart`: `part of` башни — плитки узлов (level/checkpoint) и их состояния.

</details>

<details>
<summary><code>lib/widgets/</code> (62 файла)</summary>

- `lib/widgets/artifact_card.dart`: **legacy (используется в тестах; в текущем Profile UI не импортируется)**.
- `lib/widgets/artifact_viewer.dart`: просмотр/детальная карточка артефакта (full view).
- `lib/widgets/bottombar_item.dart`: элемент нижней навигации (иконка/лейбл/active).
- `lib/widgets/category_box.dart`: **legacy/не используется**.
- `lib/widgets/chat_item.dart`: карточка диалога в списке чатов (hover/notify/avatar).
- `lib/widgets/chat_notify.dart`: бейдж непрочитанных/уведомлений (цифра).
- `lib/widgets/custom_image.dart`: обёртка изображения (asset/network, radius/shadow).
- `lib/widgets/custom_textfield.dart`: кастомный текстовый инпут (старый/legacy базовый компонент).
- `lib/widgets/desktop_nav_bar.dart`: боковая навигация для desktop layout.
- `lib/widgets/feature_item.dart`: **legacy/не используется**.
- `lib/widgets/floating_chat_bubble.dart`: **legacy/не используется** (виджет overlay, не импортируется активным UI).
- `lib/widgets/leo_message_bubble.dart`: адаптер сообщения Leo/Max → `BizLevelChatBubble`.
- `lib/widgets/leo_quiz_widget.dart`: квиз‑виджет с Leo‑обратной связью (через Edge `leo-chat` mode=quiz).
- `lib/widgets/lesson_widget.dart`: проигрывание видео‑урока (video player wrapper + onWatched).
- `lib/widgets/level_card.dart`: **legacy** (используется только в `LevelsMapScreen`, который не используется текущим `GoRouter`).
- `lib/widgets/notification_box.dart`: **legacy** (не используется активным UI; встречается в legacy‑контуре/тестах).
- `lib/widgets/quiz_widget.dart`: базовый квиз‑виджет (вопросы/варианты/disabled состояния).
- `lib/widgets/recommend_item.dart`: **legacy/не используется**.
- `lib/widgets/reminders_settings_sheet.dart`: bottom‑sheet контент настроек напоминаний.
- `lib/widgets/setting_box.dart`: **legacy/не используется**.
- `lib/widgets/setting_item.dart`: **legacy/не используется**.
- `lib/widgets/skills_tree_view.dart`: визуализация дерева навыков пользователя.
- `lib/widgets/stat_card.dart`: **legacy/не используется**.
- `lib/widgets/typing_indicator.dart`: индикатор «печатает…» (3 точки).
- `lib/widgets/user_info_bar.dart`: **legacy** (не используется активным UI; встречается в legacy‑контуре/тестах).

- `lib/widgets/dev/theme_gallery.dart`: dev‑экран предпросмотра темы/токенов (**legacy/не используется**).

- `lib/widgets/home/home_continue_card.dart`: карточка «Продолжить обучение» (CTA).
- `lib/widgets/home/home_cta.dart`: домашний CTA‑блоки (быстрые действия) (**legacy/не используется**).
- `lib/widgets/home/home_goal_card.dart`: карточка «Моя цель» для home.
- `lib/widgets/home/home_quote_card.dart`: карточка «цитата/мотивация» для home.
- `lib/widgets/home/top_gp_badge.dart`: компактный бейдж баланса GP (home header).

- `lib/widgets/level/artifact_preview.dart`: превью артефакта в составе уровня.
- `lib/widgets/level/level_nav_bar.dart`: нижняя навигация уровня (back/next/discuss).
- `lib/widgets/level/level_progress_dots.dart`: прогресс‑точки (гориз/вертикальные) по блокам уровня.
- `lib/widgets/level/parallax_image.dart`: parallax‑изображение для интро/обложек.

- `lib/widgets/level/blocks/level_page_block.dart`: базовый интерфейс/абстракция «блок страницы уровня».
- `lib/widgets/level/blocks/intro_block.dart`: Intro‑блок уровня.
- `lib/widgets/level/blocks/lesson_block.dart`: видео‑блок урока (через `LessonWidget`).
- `lib/widgets/level/blocks/quiz_block.dart`: квиз‑блок урока (проверка ответов, событие onCorrect).
- `lib/widgets/level/blocks/artifact_block.dart`: блок выдачи/описания артефакта (после прохождения).
- `lib/widgets/level/blocks/goal_v1_block.dart`: блок «Семя» (цель v1) для уровня 1.
- `lib/widgets/level/blocks/profile_form_block.dart`: блок формы профиля (уровень 0).

- `lib/widgets/common/achievement_badge.dart`: бейдж достижения (rarity, иконка).
- `lib/widgets/common/app_icon_button.dart`: унифицированная икон‑кнопка с tooltip/семантикой.
- `lib/widgets/common/bizlevel_button.dart`: дизайн‑системная кнопка.
- `lib/widgets/common/bizlevel_card.dart`: дизайн‑системная карточка (glass).
- `lib/widgets/common/bizlevel_chat_bubble.dart`: дизайн‑системный chat‑bubble (user/assistant/system/error).
- `lib/widgets/common/bizlevel_empty.dart`: empty‑state компонент.
- `lib/widgets/common/bizlevel_error.dart`: error‑state компонент.
- `lib/widgets/common/bizlevel_loading.dart`: loading‑state компонент.
- `lib/widgets/common/bizlevel_modal.dart`: простой модал/алерт BizLevel.
- `lib/widgets/common/bizlevel_progress_bar.dart`: унифицированный progress bar (**legacy/не используется**).
- `lib/widgets/common/bizlevel_text_field.dart`: дизайн‑системное поле ввода.
- `lib/widgets/common/breadcrumb.dart`: breadcrumbs‑навигация.
- `lib/widgets/common/donut_progress.dart`: круговой прогресс (donut).
- `lib/widgets/common/gp_balance_widget.dart`: компактный виджет баланса GP (иконка/цифра).
- `lib/widgets/common/list_row_tile.dart`: строка списка (leading/title/subtitle/trailing).
- `lib/widgets/common/list_section_tile.dart`: заголовок/секция списков (**legacy/не используется**).
- `lib/widgets/common/milestone_celebration.dart`: UI «празднования» (награда GP, конфетти).
- `lib/widgets/common/notification_center.dart`: баннер‑уведомления (MaterialBanner wrapper).
- `lib/widgets/common/onboarding_tooltip.dart`: tooltip/подсказки для онбординга (**legacy/не используется**).
- `lib/widgets/common/success_indicator.dart`: индикатор успеха (галочка/анимация) (**legacy/не используется**).

</details>
