# Этап 38: Обновление Цель и Мотивация с Максом 
 
### Задача 38.1: Чекпоинт кристаллизации цели (v2–v4) — 2 блока + встроенный чат Макса
- Файлы: `lib/screens/goal_checkpoint_screen.dart`, `lib/screens/leo_dialog_screen.dart` (или новый виджет), `lib/widgets/goal_version_form.dart`.
- Что сделать:
  1) Перестроить чекпоинты Кристализация цели в 2 блока:
     - Блок 1 (Intro): картинка + краткий текст по версии (v2 Метрики / v3 SMART / v4 Финал) + кнопка «Далее».
     - Блок 2 (Диалог с Максом): встроенный чат внутри экрана (не bottom sheet/overlay).
  2) Вынести ядро чата в переиспользуемый виджет `LeoChatView` (без Scaffold/AppBar; явные контроллеры списка/инпута, автоскролл при новых сообщениях). В `LeoDialogScreen` добавить параметр `embedded` для совместимости.
  3) Передавать `bot='max'`, `systemPrompt` и контекст версии (v1/v2/v3/v4) в чат. По завершению шага — возможность префилл формы `GoalVersionForm` из ответа.
  4) Сохранение версии цели остаётся через `GoalsRepository` (кнопка «Сохранить» внизу чекпоинта); по успешному сохранению — инвалидация `goalLatestProvider/goalVersionsProvider` и провайдеров недельного прогресса, затем возврат на `/tower?scrollTo=<next>`.
- Критерии приёмки: на `/goal-checkpoint/2|3|4` чётко видны 2 блока; чат встроен (scroll не конфликтует), работает ввод и подсказки; сохранение версии проходит; возврат на башню корректный.
 
### Задача 38.2: Чипы быстрых ответов для чата Макса (свободный ввод сохраняется)
- Файлы: `lib/screens/leo_dialog_screen.dart`, (опц.) `lib/widgets/chat_input.dart`.
- Что сделать:
  1) Добавить ряд «chips» над полем ввода: набор контекстных подсказок по сценарию (v2: выбор метрики/диапазона; v3: примеры недельных целей/действий; v4: варианты готовности/старт-даты).
  2) Тап по chip вставляет текст в инпут и только подставляет (не отправляет автоматически); при этом всегда доступен ручной ввод, клавиатура не блокируется.
  3) UI чипов адаптивный (перенос в две строки при узких экранах), без блокировки клавиатуры.
  4) Клиентский фолбэк: если сервер не вернул `recommended_chips`, формировать пресеты локально по текущему этапу (v2/v3/v4), чтобы UI всегда работал.
- Критерии приёмки: чипы отображаются, выбор работает, свободный ввод не ограничен, верстка не даёт overflow.
 
### Задача 38.3: Обновление `GoalScreen` (режим просмотра) — новая структура
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать (без изменения блока «Цитата» — оставить как есть вверху):
  1) «Компактная карточка цели» (свернуто по умолчанию):
     - Заголовок: текст цели (v4, иначе — актуальная последняя версия);
     - Прогресс-бар % (по данным «Путь к цели», расчет ниже);
     - Метрика (например: «Сейчас: X → Цель: Y») — если известна из v2 (иначе скрыть);
     - «Дней осталось»: n/28 — если известна дата старта из v4 (иначе скрыть).
     - По тапу — разворот: недельный план (из v3), ключевые действия, кнопка «Обсудить с Максом» (открывает встроенный чат Макса в полноэкранном диалоге).
  2) «Прогресс-виджет»: большой CircularProgressIndicator c % в центре, цвет по диапазону (красный/желтый/зеленый) + 3 мини‑метрики (серия дней, рост %, темп).
  3) «Текущая неделя»: карточка с целью недели, чек‑листом задач и мини‑графиком тренда (базовая визуализация, без сложной статистики).
  4) «Timeline недель» (горизонтальный скролл): 1..4, статусы (✅ завершена, 🔄 активная, 🔒 заблокирована).
  5) Расчет прогресса: использовать `weekly_progress.metric_progress_percent`; при отсутствии — суррогат: доля завершённых недель/задач.
  6) Read‑only: формы версий на странице «Цель» остаются в режиме просмотра; редактирование версий выполняется через чекпоинты.
- Критерии приёмки: без overflow на мобильных/desktop, разворот карточки стабилен, кнопка «Обсудить с Максом» работает, данные берутся из репозитория.
 
### Задача 38.4: Репозиторий и схема БД — выравнивание под «Путь к цели» (без daily_mood)
- Файлы: `supabase/migrations/`, `lib/repositories/goals_repository.dart`.
- Что сделать (разрешено переименование/чистка устаревшего):
  1) В `weekly_progress` расширить структуру: `planned_actions JSONB`, `completed_actions JSONB`, `completion_status TEXT check ('full','partial','failed')`, `metric_value NUMERIC`, `metric_progress_percent NUMERIC`, `mood_tracking JSONB` (опц.), `mood_average NUMERIC` (опц.), `max_feedback TEXT`, `chat_session_id UUID`, `updated_at timestamptz default now()` + триггер `updated_at`. Сохранить существующие поля (этап 32.14–32.15): `artifacts_details`, `consulted_benefit`, `techniques_details` — не удалять.
  2) Переименовать `sprint_number` → `week_number` (и индексы) — обновить обращения в репозитории/UI. Переименование провести мягко: в коде оставить deprecated‑обёртки на старые методы/поля до полной миграции.
  3) Обновить `GoalsRepository`:
     - `fetchSprint` → `fetchWeek`, `upsertSprint` → `upsertWeek` (с обратной совместимостью через deprecated‑обёртки);
     - поддержка новых опциональных полей при upsert/update;
     - добавить `updateWeek(...)` для редактирования без дубликатов записей;
     - инвалидации: после апдейтов обновлять кэш недельного прогресса, помимо `goalLatest/goalVersions`.
  4) Проверить RLS/триггеры owner‑only, индексы производительности; advisors — без критики.
- Критерии приёмки: миграции применяются, репозиторий компилируется, старый код не падает, новые поля читаются/записываются.
 
### Задача 38.5: Встроенный чат Макса в чекпоинтах и на странице «Цель»
- Файлы: `lib/screens/leo_dialog_screen.dart`, `lib/screens/goal_checkpoint_screen.dart`, `lib/screens/goal_screen.dart`.
- Что сделать:
  1) Вынести `LeoChatView` (core UI сообщений + input) для встраивания в любые экраны; `LeoDialogScreen` использует его внутри (embedded/fullscreen режимы).
  2) На странице «Цель» добавить кнопку «Обсудить с Максом» в раскрытой карточке цели → открывать полноэкранный диалог с `LeoDialogScreen(bot='max')`.
  3) В чекпоинтах использовать именно встроенный `LeoChatView` как второй блок.
- Критерии приёмки: чат корректно встраивается/открывается, автоскролл списка сообщений работает; лимиты сообщений — стандартные (как в чате), исключение — только для режимов case/quiz.
 
### Задача 38.6: Push‑уведомления (MVP)
- Файлы: `pubspec.yaml`, `ios/`/`android/` настройки, `lib/services/notifications_service.dart` (новый), `lib/main.dart` (инициализация).
- Что сделать:
  1) Интегрировать `flutter_local_notifications` для локальных напоминаний (без сервера/FCM на этом этапе):
     - iOS: разрешение, категории; Android: канал, иконка, importance.
     - Расписание: Пн 09:00 (старт недели), Ср 14:00 (пульс), Пт 16:00 (напоминание), Вс 10:00/13:00/18:00 (чекин, до 3 повторов) — локально по времени устройства.
  2) Хранилище состояния (Hive): исключать повторные нотификации, отмечать выполненные «дни»/чекины.
  3) Подготовить основу для FCM (без включения в этом этапе): конфиги, ключи в `.env`, заглушка сервиса; план на Edge‑cron отправки добавим в следующий этап.
- Критерии приёмки: нотификации показываются на iOS/Android при открытом/закрытом приложении; страницы «Цель» обновляются после отметки событий.
 
### Задача 38.7: Серверная логика Макса (минимальные правки)
- Файлы: `supabase/functions/leo-chat/`.
- Что сделать:
  1) Улучшить system‑prompt Макса для сценариев v2/v3/v4 (валидация конкретики/реалистичности, короткие ответы ≤2–3 строк, эмодзи умеренно, при оффтопе — вежливое перенаправление к Лео).
  2) (Опц.) Добавить возвращаемые «recommended_chips` (массив строк) по текущему шагу — клиент покажет их как chips; контракт ответа остаётся обратно‑совместимым. Клиент обязан иметь локальный фолбэк и не зависеть от сервера.
- Критерии приёмки: чат с Максом остаётся стабильным, при отсутствии chips клиент работает как раньше.
 
### Задача 38.8: Тесты, линтер и наблюдаемость
- Файлы: `test/`.*
- Что сделать:
  1) Обновить/добавить тесты: `goal_checkpoint_screen_test` (2 блока + встроенный чат), `goal_screen_readonly_test` (новые секции, smoke), юнит‑тесты репозитория недельного прогресса (новые поля), e2e smoke на web (рендер embed‑чата).
  2) `flutter analyze` должен быть без новых ошибок; CI включает тесты и суперадвайзоры для БД.
  3) Добавить Sentry breadcrumbs для событий: `goal_card_expand`, `max_chat_embedded_opened`, `week_timeline_tap`, `checkin_saved`.
- Критерии приёмки: тесты зелёные локально и в CI, Sentry не показывает новые критические ошибки.
 
### Задача 38.9: Миграции и проверки безопасности/производительности
- Файлы: `supabase/migrations/`.
- Что сделать:
  1) Применить миграции через supabase‑mcp; проверить advisors (security/performance) — исправить замечания.
  2) Обновить индексы (`weekly_progress(user_id, week_number desc)`), убедиться в корректности RLS и триггеров.
- Критерии приёмки: advisors — без критичных предупреждений; запросы к недельному прогрессу работают быстро.

### Задача 38.10: Хедер страницы «Цель» — заголовок по центру и аватар справа
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать:
  1) Добавить верхний хедер: заголовок «Цель» по центру, аватар пользователя справа (из текущего профиля), лёгкий градиент фона (как в дизайне). 2) Хедер не ломает существующий layout и адаптивен (mobile/desktop).
- Критерии приёмки: на /goal заголовок по центру, аватар справа, градиентный фон виден; overflow нет.

### Задача 38.11: Индикатор кристаллизации 4‑сегментный + «Этап N из 4»
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать:
  1) В секции «Кристаллизация цели» отобразить 4 сегмента (v1–v4) с текущим этапом, 2) Подпись «Этап N из 4: …» (по актуальной версии), 3) Данные брать из `goalLatestProvider/goalVersionsProvider`.
- Критерии приёмки: сегменты корректно подсвечиваются по завершённым версиям; подпись меняется согласно данным.

### Задача 38.12: Компактная карточка цели — collapsed/expanded, готовность/статус
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать:
  1) В collapsed: заголовок цели, прогресс‑бар, метрика «Сейчас → Цель» (из v2), дедлайн/«осталось дней» (из v4), «Готовность X/10», «Статус»; 2) В expanded: недельный план (v3) + кнопка «Обсудить с Максом»; 3) Кнопка «История» (раскрывает раздел ниже).
- Критерии приёмки: карточка сворачивается/разворачивается без артефактов; поля скрываются, если данных нет; кнопка чата работает.

### Задача 38.13: Раздел «История» — вертикальный timeline v1–v4
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать:
  1) По кнопке «История» раскрывать вертикальный timeline версий v1→v4 с краткими полями из `version_data` (семя/метрики/SMART/финал); 2) Кнопка «Свернуть историю».
- Критерии приёмки: блок корректно раскрывается/сворачивается; тексты отображаются; overflow нет.

### Задача 38.14: «Прогресс‑виджет» — значения, динамика, прогноз
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать:
  1) Под большим кругом вывести строки: «X из Y …» (текущее значение/цель), «Динамика: +N% за M недель», «Прогноз: K% …»; 2) Брать данные из `weekly_progress.metric_value/metric_progress_percent` с суррогатными фолбэками; 3) При отсутствии данных строки скрывать.
- Критерии приёмки: блок рендерится без ошибок и корректно реагирует на отсутствие данных.

### Задача 38.15: «Текущая неделя» — реальные данные
- Файлы: `lib/screens/goal_screen.dart`, (опц.) `lib/repositories/goals_repository.dart` (только при необходимости маппинга без DDL).
- Что сделать:
  1) Вывести текущую неделю (1..4), цель недели (из v3), краткий чек‑лист/мини‑график (можно placeholder‑спарклайн при наличии данных); 2) CTA «Отметить день» скроллит к форме чек‑ина текущей недели.
- Критерии приёмки: карточка заполняется данными; скролл к чек‑ину работает; overflow нет.

### Задача 38.16: Горизонтальный «Timeline недель» 1..4
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать:
  1) Реализовать горизонтальную ленту недель 1..4 с индикаторами статуса (✅ завершена, ⚡ активная, ⏳ заблокирована) и краткими цифрами недели; 2) Тап по карточке — скроллит к форме соответствующей недели (если доступна).
- Критерии приёмки: лента скроллится горизонтально; статусы отражаются корректно; тап работает.

### Задача 38.17: Чек‑ин недели — выравнивание и чат Макса после сохранения
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать:
  1) Привести лейблы чек‑ина к описанию (текущий показатель/применённые техники/инсайт/сохранить), 2) После успешного сохранения открывать чат Макса в полноэкранном режиме с системным контекстом «итоги недели».
- Критерии приёмки: форма сохраняется как раньше; после сохранения открывается чат Макса с коротким комментарием.

### Задача 38.18: Наблюдаемость — breadcrumbs
- Файлы: `lib/screens/goal_screen.dart`.
- Что сделать:
  1) Добавить Sentry breadcrumbs: `goal_header_avatar_tap`, `goal_history_toggle`, `goal_stage_chip_tap`, `week_timeline_tap`, `week_checkin_saved`.
- Критерии приёмки: breadcrumbs отправляются; новых критичных ошибок в Sentry нет.

### Задача 38.19: Тесты страницы «Цель»
- Файлы: `test/screens/goal_screen_readonly_test.dart` (+при необходимости новые тесты).
- Что сделать:
  1) Расширить smoke‑тест: проверка наличия меток «Этап N из 4», кнопки «История» и её раскрытия, горизонтальной ленты недель; 2) Убедиться, что старые тесты зелёные.
- Критерии приёмки: тесты проходят локально и в CI; анализатор без новых ошибок.

### Задача 38.20: Контроль совместимости и производительности
- Файлы: `lib/screens/goal_screen.dart`, `lib/repositories/goals_repository.dart` (без DDL), Advisors.
- Что сделать:
  1) Подтвердить отсутствие необходимости новых миграций; 2) Проверить Advisors — без критичных; 3) Пройтись по производительности (без тяжёлых операций в build; данные по возможности через существующие провайдеры/кеш SWR).
- Критерии приёмки: миграции не требуются; Advisors без критичных предупреждений; UI плавный, overflow нет.


# Этап 39: Переход на Growth Points (GP)

### Задача 39.1: Полный отказ от подписок и суточных лимитов сообщений
- Файлы: `lib/providers/subscription_provider.dart`, `lib/screens/premium_screen.dart`, `lib/screens/payment_screen.dart`, `lib/providers/levels_provider.dart`, `lib/routing/app_router.dart`, тесты `test/**`.
- Что сделать:
  1) Удалить провайдер и UI подписки, убрать маршруты и переходы на Premium.
  2) Удалить использование флагов подписки в логике доступа уровней; оставить бесплатными только уровни 0–3.
  3) Перевести гейтинг уровней на схему GP (открытие этажей за GP) — временно закрыть доступ >3 уровней до внедрения 39.7.
  4) Убрать дневные лимиты Лео/Макса: удалить проверки `checkMessageLimit/decrementMessageCount` и весь связанный UI.
- БД (миграция):
  - Удалить таблицу `subscriptions` и колонку `users.is_premium` (если не используется нигде в коде после шага 39.1.2).
  - Удалить колонки `users.leo_messages_total`, `users.leo_messages_today`, `users.leo_reset_at` и зависимые триггеры/функции.
  - Проверить, что `payments` останется для GP‑покупок (без логики подписок).
- Критерии приёмки: проект компилируется, уровни >3 недоступны без GP, в коде нет упоминаний подписок/лимитов.
- Примечание к 39.1 (подписки/лимиты): все текущие пользователи — тестовые, поэтому можно удалять `subscriptions` и колонки лимитов (`users.is_premium`, `users.leo_messages_total/leo_messages_today/leo_reset_at`) в одной миграции без поэтапного софт‑лоунча.

### Задача 39.2: Схема GP (ядро)
- БД (миграции, RLS owner-only):
  - `gp_wallets(user_id uuid PK REFERENCES auth.users(id),
      balance int NOT NULL DEFAULT 0 CHECK (balance >= 0),
      total_earned int NOT NULL DEFAULT 0,
      total_spent int NOT NULL DEFAULT 0,
      updated_at timestamptz NOT NULL DEFAULT now())`.
  - `gp_ledger(id uuid PK,
      user_id uuid NOT NULL REFERENCES auth.users(id),
      amount int NOT NULL CHECK (amount <> 0),
      type enum('purchase','spend_message','spend_floor','bonus','refund','adjustment') NOT NULL,
      reference_id uuid/text,
      metadata jsonb,
      idempotency_key text NOT NULL,
      created_at timestamptz NOT NULL DEFAULT now())`.
  - `gp_purchases(id uuid PK, user_id uuid NOT NULL REFERENCES auth.users(id), package_id text, amount_kzt int, amount_gp int,
      provider enum('apple','google','epay','kaspi'),
      provider_transaction_id text,
      status enum('pending','completed','failed','refunded'),
      created_at timestamptz NOT NULL DEFAULT now())`.
  - `floor_access(user_id uuid REFERENCES auth.users(id),
      floor_number smallint NOT NULL CHECK (floor_number >= 0),
      unlocked_at timestamptz NOT NULL DEFAULT now(),
      PRIMARY KEY(user_id, floor_number))`.
- Индексы:
  - `gp_ledger(user_id, created_at DESC)`  -- отдельный для `floor_access` не нужен из-за PK
- Инвариант: обновление `gp_wallets` выполнять ТОЛЬКО через серверную функцию в транзакции, суммирующую `gp_ledger` и проверяющую, что баланс не уходит < 0.
### Задача 39.3: Edge Functions для GP
- Эндпоинты:
  - `GET /gp/balance` → `{balance, total_earned, total_spent}` (кэш 5 секунд)
  - `POST /gp/spend {type, amount, reference_id, idempotency_key}` → SERIALIZABLE транзакция; проверка баланса; запись в `gp_ledger` и обновление `gp_wallets`; возврат `{balance_after}`
  - `POST /gp/purchase/init {package_id, provider}` → создаёт `gp_purchases(status=pending)`; для Web возвращает `payment_url`
  - `POST /gp/purchase/verify {purchase_id, receipt?}` → верификация провайдера, идемпотентное начисление через `gp_ledger/gp_wallets`, обновление `gp_purchases(status=completed)`
  - `POST /gp/floor/unlock {floor_number, idempotency_key}` → проверка доступа; списание 1000 GP (или из конфигурации); upsert в `floor_access`; возврат `{balance_after}`
- Требования:
  - Только `authenticated` JWT; логи без PII
  - Идемпотентность через заголовок `Idempotency-Key`; повтор запроса возвращает прежний результат
  - Единый формат ошибок: `gp_insufficient_balance`, `gp_invalid_package`, `gp_already_processed`
### Задача 39.4: Система бонусов GP (настраиваемая)
- БД:
  - `gp_bonus_rules(rule_key text PK, amount int, active bool, description text)`.
  - `gp_bonus_grants(user_id uuid, rule_key text, granted_at timestamptz, PK(user_id, rule_key))`.
- Edge:
  - `POST /gp/bonus/claim {rule_key}`: сервер в одной транзакции SERIALIZABLE: проверяет условия → INSERT `gp_bonus_grants` (PK(user_id, rule_key)) → INSERT `gp_ledger` (idempotency_key = 'bonus:'||rule_key||':'||user_id) → UPDATE `gp_wallets`. Повторные вызовы отдаются из кэша по PK/идемпотентности.
- Правила (сид):
  - `signup_bonus` (+30 GP), `profile_completed` (+50 GP при заполнении name/goal/about/avatar_id), `all_three_cases_completed` (+200 GP при status='completed' для cases 1–3).
    - `signup_bonus` (+30 GP) — выдавать через `/gp/bonus/claim` при первом входе.
  - `profile_completed` (+50 GP) — при заполненных `name/goal/about/avatar_id`.
  - Для тестовой команды допускается разовая выдача через `gp_bonus_grants`.
- Критерии приёмки: повторный вызов не даёт дублей, правила можно выключать/менять без правок клиента.
- БД:
  - `gp_bonus_rules(rule_key text PK, amount int, active bool, description text)`.
  - `gp_bonus_grants(user_id uuid, rule_key text, granted_at timestamptz, PK(user_id, rule_key))`.
- Edge:
  - `POST /gp/bonus/claim {rule_key}`: сервер проверяет условия и идемпотентно начисляет бонус через `gp_ledger/gp_wallets`, пишет в `gp_bonus_grants`.
- Правила (сид):
  - `signup_bonus` (+30 GP), `profile_completed` (+50 GP при заполнении name/goal/about/avatar_id), `all_three_cases_completed` (+200 GP при status='completed' для cases 1–3).
    - `signup_bonus` (+30 GP) — выдавать через `/gp/bonus/claim` при первом входе.
  - `profile_completed` (+50 GP) — при заполненных `name/goal/about/avatar_id`.
  - Для тестовой команды допускается разовая выдача через `gp_bonus_grants`.
- Критерии приёмки: повторный вызов не даёт дублей, правила можно выключать/менять без правок клиента.

### Задача 39.5: Клиент — сервис и баланс
- Создать `GpService` (Dio/Edge): `getBalance`, `spend`, `initPurchase`, `verifyPurchase` с retry/идемпотентностью.
- Провайдер `gpBalanceProvider` (SWR + Hive): инвалидация после списаний/покупок/бонусов.
- UI (только где нужно показывать баланс):
  - Верхний AppBar на `MainStreetScreen` и `BizTowerScreen` («⬡ X GP», по тапу — магазин).
  - `ProfileScreen`: «⬡ X GP (−1 за сообщение)» вместо «Х сообщений Лео».
- Не показывать баланс в чате.
  - `gpBalanceProvider` — SWR + Hive; инвалидация после `spend/purchase/bonus`.
  - UI: баланс только в AppBar (главная/башня) и на странице Профиль; в чате баланс не показывать.
- Критерии приёмки: баланс корректно обновляется, в чате баланс отсутствует.

### Задача 39.6: Списания GP за сообщения Лео/Максу
- `LeoService.sendMessage`: перед отправкой — `GpService.spend(type='spend_message', amount=1, reference_id=chat_id, idempotency_key)`. На "insufficient" — модалка «Пополнить GP» → переход в магазин и повтор.
- Удалить старые проверки лимитов и связанные тексты/ошибки.
  - Перед отправкой: `POST /gp/spend` c `type='spend_message'`, `amount=1`,
      `reference_id=<message_id>`, `idempotency_key=<message_id>`.
    Клиент генерирует `message_id` (UUID v4) ДО отправки сообщения и переиспользует при ретраях.
  - На `gp_insufficient_balance` — модалка «Пополнить GP» → переход в магазин (preset `gp_1200`).
- Критерии приёмки: при достаточном балансе сообщение уходит; при недостаточном — корректный UX без отображения баланса в чате.
### Задача 39.7: Открытие этажей за GP
- Гейтинг уровней: заменить подписку на проверку `floor_access` (этаж 1 = уровни 1–10 и т.д.).
- UI: при попытке открыть платный этаж — полноэкранный модал «Стоимость: 1000 GP (у вас X)»; 
  если хватает — вызвать `POST /gp/floor/unlock {floor_number, idempotency_key}`.
  На сервере в одной транзакции: проверка доступа → списание (ledger+wallet) →
  upsert в `floor_access` → возврат нового баланса. Идемпотентность по (user_id, floor_number).
  если нет — магазин с пресетом `gp_1200`.
- `levels_provider`: учитывать `floor_access` и бесплатность 0–3 уровней.
  - Этаж 1 = 1000 GP; уровни 0–3 бесплатные без изменений.
### Задача 39.8: Магазин GP и платежи
- Экран `GpStoreScreen` с 3 пакетами (300/1200/2500 GP), выделение среднего.
- Интеграция с существующим `PaymentService` для Web (redirect-flow), после возврата — `verify` и инвалидация баланса.
  - Пакеты: `gp_300`, `gp_1200` (badge «ПОПУЛЯРНЫЙ»), `gp_2500` — конфиг хранить на клиенте и валидировать на сервере
    (сервер — единственный источник истины по цене/GP).
    В БД: UNIQUE(provider, provider_transaction_id).
  - Web: redirect через существующий `PaymentService` → `/gp/purchase/verify`.
  - iOS/Android: заглушки SDK (вне MVP), интерфейсы подготовить.
- Подготовить интерфейсы для мобильных сторах (без реализации в этом этапе).
- Критерии приёмки: на Web покупка завершает начислением GP и обновлением баланса.
  - iOS/Android: заглушки SDK (вне MVP), интерфейсы подготовить.
- Подготовить интерфейсы для мобильных сторах (без реализации в этом этапе).
- Критерии приёмки: на Web покупка завершает начислением GP и обновлением баланса.

### Задача 39.9: Чистка, тесты и наблюдаемость
- Удалить/обновить тесты, завязанные на подписки/лимиты.
- Добавить юнит‑тесты `GpService` и виджет‑тесты (чаты: списание/insufficient; башня: открытие этажа).
- Sentry breadcrumbs: `gp_spent`, `gp_insufficient`, `gp_store_opened`, `gp_purchase_*`.
- Скрипт сверки: при расхождении `wallets.balance` и суммы `ledger` — алерт и автокоррекция (опц.).
  - Удалить/обновить тесты, завязанные на подписки/лимиты.
  - Добавить тесты: списание/insufficient, открытие этажа, покупка на Web, инвалидация баланса.
  - Sentry breadcrumbs: `gp_spent`, `gp_insufficient`, `gp_store_opened`, `gp_purchase_*`.
- Критерии приёмки: тесты зелёные, Sentry без новых критичных ошибок.

### Задача 39.10: Данные и обратная совместимость
- Применить welcome‑бонус существующим пользователям один раз через `gp_bonus_grants`.
- Подтвердить, что в `subscriptions` нет активных данных; если есть — согласовать конверсию в `floor_access`.
  - Так как пользователи тестовые, можно сразу удалять подписки/лимиты без маппинга. При необходимости — выдать `floor_access` вручную тем, кто уже имеет доступ >3.
- Критерии приёмки: у существующих пользователей баланс ≥ 30 GP, доступы соответствуют правилам GP.

### Задача 39.11: Техдолг и безопасность
- Сначала проверить, потом устранить дубликаты индексов (например, `core_goals_user_updated_idx` vs `idx_core_goals_user_updated`, `lessons_level_id_order_key` vs `uniq_lessons_level_order`).
- Зафиксировать `search_path = public` в новых функциях и триггерах (SQL/Edge), привести к рекомендациям advisors.

### Задача 39.12: Smoke‑фаза GP
- Задеплоить `/gp/balance` и `/gp/spend` в песочнице; провести ручные проверки идемпотентности и RLS.
- После успешной проверки включить списание GP в клиенте для чатов (канареечный запуск).

### Задача 39.13: Документация и курс
- Описать формат `Idempotency-Key` и коды ошибок в README (раздел GP).
- Зафиксировать источник курса GP↔₸ (константа на клиенте + валидация на сервере или `app_settings`).

### Задача 39.14: Бэкенд (RPC) — серверные функции GP с идемпотентностью
- Файлы: `supabase/migrations/` (новая миграция с SQL функциями и индексами).
- Что сделать:
  1) Создать RPC-функции в `public` с `SECURITY DEFINER`, `SET search_path = public`, транзакцией `SERIALIZABLE`:
     - `gp_balance()` → `RETURNS TABLE(balance int, total_earned int, total_spent int)`; берёт данные из `gp_wallets` по `auth.uid()` (если записи нет — 0/0/0).
     - `gp_spend(p_type text, p_amount int, p_reference_id text, p_idempotency_key text)` → `RETURNS TABLE(balance_after int)`; в транзакции: валидирует `p_amount>0`, тип в белом списке; вставляет в `gp_ledger` (idempotency_key уникальный); пересчитывает/обновляет `gp_wallets` и проверяет, что баланс ≥0.
     - `gp_floor_unlock(p_floor smallint, p_idempotency_key text)` → `RETURNS TABLE(balance_after int)`; если `floor_access` уже есть — идемпотентно возвращает текущий баланс; иначе в транзакции списывает фиксированную сумму (1000 GP), затем upsert в `floor_access`.
     - `gp_bonus_claim(p_rule_key text)` → `RETURNS TABLE(balance_after int)`; проверяет активность правила в `gp_bonus_rules`, один раз пишет в `gp_bonus_grants` (PK(user_id, rule_key)), затем INSERT в `gp_ledger` (idempotency_key = 'bonus:'||rule_key||':'||user_id) и обновляет `gp_wallets`.
  2) Идемпотентность/индексы: `CREATE UNIQUE INDEX IF NOT EXISTS idx_gp_ledger_idem ON public.gp_ledger(idempotency_key);` Убедиться, что есть `gp_ledger(user_id, created_at DESC)`.
  3) Права: `GRANT EXECUTE ON FUNCTION ... TO authenticated;` и `REVOKE ALL ON FUNCTION ... FROM anon;`.
- Критерии приёмки: функции вызываются через PostgREST от роли `authenticated`, RLS не нарушен; дубли по `idempotency_key` возвращают прежний `balance_after`; advisors (security/performance) — без критичных предупреждений.

### Задача 39.15: Клиент — перевод GpService на RPC (вместо Edge) для core-операций
- Файлы: `lib/services/gp_service.dart`.
- Что сделать:
  1) Заменить HTTP-вызовы на `SupabaseClient.rpc`:
     - `getBalance()` → `rpc('gp_balance')` c маппингом в `{balance,total_earned,total_spent}`.
     - `spend(type,amount,referenceId,idempotencyKey)` → `rpc('gp_spend', params: {...})`, возвращать `balance_after`.
     - `unlockFloor(floorNumber,idempotencyKey)` → `rpc('gp_floor_unlock', params: {...})`.
     - `claimBonus(ruleKey)` → `rpc('gp_bonus_claim', params: {...})`.
  2) Сохранить: экспоненциальный retry без `refreshSession()` внутри; Hive‑кеш; конверсию ошибок в `GpFailure('Недостаточно GP')/другое`.
  3) Оставить без изменений: `initPurchase/verifyPurchase` (остаются Edge, как есть).
- Критерии приёмки: сборка проходит; 401/Invalid JWT на `/functions/v1/gp-*` больше не возникают; кэш/инвалидации работают.

### Задача 39.16: Интеграция Leo/Башня — использовать RPC через GpService
- Файлы: `lib/services/leo_service.dart`, `lib/screens/tower/tower_tiles.dart` (или текущие точки вызова `unlockFloor`).
- Что сделать:
  1) `LeoService.sendMessage/sendMessageWithRAG` продолжает вызывать `gp.spend(...)` (теперь RPC); `skipSpend` в мини‑кейсах оставить без изменений.
  2) В башне `unlockFloor` остаётся через `GpService` (теперь RPC) с тем же `idempotencyKey`.
- Критерии приёмки: списание 1 GP перед сообщением стабильно; «Недостаточно GP» обрабатывается корректно; открытие этажа — без регрессий.

### Задача 39.17: Провайдеры/кеш — валидация работы с RPC
- Файлы: `lib/providers/gp_providers.dart`, `lib/widgets/user_info_bar.dart`, `lib/screens/biz_tower_screen.dart`, `lib/screens/profile_screen.dart`.
- Что сделать:
  1) Убедиться, что гейт по `currentSession` сохранён; провайдеры не делают `refreshSession()`.
  2) Баланс читается из `gpBalanceProvider` (RPC), кеш Hive сохраняется; фоновые рефетчи не инициируют редиректы.
- Критерии приёмки: ранние 401 отсутствуют; баланс обновляется и показывается в AppBar/Профиле.

### Задача 39.18: Тесты GP для RPC
- Файлы: `test/services/gp_service_test.dart`, `test/screens/leo_dialog_screen_test.dart`, `test/screens/tower_unlock_test.dart` (или существующие аналогичные).
- Что сделать:
  1) Юнит‑тесты GpService с моками `SupabaseClient.rpc` (успех/ошибки/идемпотентность).
  2) Виджет‑тесты: чат (списание/insufficient) и башня (unlock→инвалидации баланса/узлов).
- Критерии приёмки: тесты зелёные локально и в CI.

### Задача 39.19: Роллаут‑страховка (dev) — временный fallback на Edge
- Файлы: `lib/services/gp_service.dart` (только dev/debug).
- Что сделать:
  1) Если `rpc('gp_*')` даёт `function not found`/`PGRST...`, логировать в Sentry и один раз попробовать прежний Edge‑вызов (только в debug); в prod fallback отключён.
- Критерии приёмки: на dev возможно параллельное тестирование до полной доставки миграций; в prod — только RPC.

### Задача 39.20: Advisors/Security — проверка функций и индексов
- Файлы: `supabase/migrations/`.
- Что сделать:
  1) Запустить advisors (security/performance); проверить `SECURITY DEFINER`, `search_path = public`, гранты, индексы.
  2) Устранить замечания (без изменения контрактов RPC).
- Критерии приёмки: критичных предупреждений нет.

### Задача 39.21: Сверка балансов и консистентность
- Файлы: `supabase/migrations/` (опц. SQL‑скрипт), внутренние процедуры.
- Что сделать:
  1) Выполнить сверку `gp_wallets.balance` vs сумма `gp_ledger.amount` по `user_id`; логировать расхождения.
  2) При расхождении — корректирующая транзакция (INSERT в `gp_ledger` с `type='adjustment'` и объяснением) + пересчёт `gp_wallets`.
- Критерии приёмки: расхождений нет либо исправлены атомарно.

### Задача 39.22: Документация/чистка Edge‑маршрутов
- Файлы: `README.md`, (опц.) `supabase/functions/*`.
- Что сделать:
  1) Пометить `/gp-balance`, `/gp-spend`, `/gp-floor-unlock`, `/gp-bonus-claim` как deprecated (переведены в RPC). Оставить Edge только для `/gp-purchase-*`.
  2) Обновить раздел GP: идемпотентность через `idempotency_key`, список типов, коды ошибок.
- Критерии приёмки: документация актуальна; команда следует новому флоу.

### Задача 39.23: Наблюдаемость (Sentry) для RPC‑пути
- Файлы: `lib/services/gp_service.dart`, `lib/services/leo_service.dart`.
- Что сделать:
  1) Добавить breadcrumbs без PII: `gp_balance_loaded`, `gp_spent`, `gp_insufficient`, `gp_floor_unlocked`, `gp_bonus_granted`.
  2) Проверить, что в логи не попадает JWT/личные данные.
- Критерии приёмки: события видны в Sentry; новых критичных ошибок нет.