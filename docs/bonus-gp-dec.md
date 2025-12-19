### Отчет: бонусы GP (Growth Points) в BizLevel

- **Дата**: 2025-12-17
- **Supabase Project ID**: `acevqbdpzgbtqznbpgzr`
- **Скоуп документа**: только **бонусы GP** (не покупки/не списания). За покупками/списаниями см. `docs/payment-gp-dec.md`.

---

### TL;DR (как это работает в одном абзаце)

- **Правила бонусов** живут в `public.gp_bonus_rules` и включаются флагом `active`.
- **Разовые бонусы** (signup/profile/3 кейса) выдаются через RPC **`public.gp_bonus_claim(p_rule_key)`**:
  - сервер проверяет условия (если есть),
  - пишет факт в `public.gp_bonus_grants`,
  - пишет транзакцию в `public.gp_ledger` с уникальным `idempotency_key`,
  - пересчитывает `public.gp_wallets` из `gp_ledger`.
- **Ежедневный бонус за практику** выдается через RPC **`public.gp_claim_daily_application()`**:
  - **только если** есть запись в `public.practice_log` за текущий **local-day** пользователя,
  - **не больше 1 раза в день** за счет `idempotency_key = bonus:daily_application:<YYYY-MM-DD>:<user_id>`.
- **Local-day считается по IANA таймзоне пользователя**, которая хранится в `public.users.timezone` и синхронизируется клиентом через `public.user_set_timezone()`.

---

### Текущие бонусы (конфигурация)

> Источник истины: `public.gp_bonus_rules`.

- **`signup_bonus`**: +30 GP, разово.
- **`profile_completed`**: +50 GP, разово (при заполнении `name + goal + about + avatar_id`).
- **`all_three_cases_completed`**: +200 GP, разово (когда 3 кейса `case_id in (1,2,3)` имеют `status='completed'`).
- **`daily_application`**: +5 GP, **раз в день** (при наличии практики в журнале “Цель” за local-day).

---

### Серверная часть (Supabase): таблицы и связи

#### 1) Таблицы-ядро GP

- **`public.gp_bonus_rules`** — справочник правил бонусов:
  - `rule_key text` — ключ правила (например `signup_bonus`)
  - `amount int` — сколько GP начислять
  - `active bool` — включено/выключено (используется в `gp_bonus_claim`)
  - `is_active bool` — легаси-флаг; синхронизируется с `active` (см. ниже)
  - `description text` — опционально
- **`public.gp_bonus_grants`** — “маркёр” выданных разовых бонусов (1 раз на пользователя на правило):
  - ключевой смысл: обеспечить **разовую выдачу** (`ON CONFLICT (user_id, rule_key) DO NOTHING`)
- **`public.gp_ledger`** — журнал транзакций (источник истины для пересчета кошелька):
  - важное поле: `idempotency_key text`
  - в БД есть **уникальный индекс** на `idempotency_key` → основа идемпотентности
- **`public.gp_wallets`** — текущий баланс (кеш/материализация):
  - есть CHECK `balance >= 0`
  - баланс пересчитывается из `gp_ledger` функцией `public._gp_compute_wallet(p_user_id)`

#### 2) Таблицы условий бонусов

- **`public.users`** (профиль + timezone):
  - `name text NOT NULL` (может быть пустой строкой)
  - `goal/about/avatar_id` — участвуют в `profile_completed`
  - `timezone text` — IANA TZ пользователя (например `Asia/Almaty`)
- **`public.practice_log`** (журнал практики на экране “Цель”):
  - `user_id uuid`
  - `applied_at timestamptz` — используется для определения “есть ли практика за local-day”
- **`public.user_case_progress`** (прогресс мини‑кейсов):
  - `user_id uuid`
  - `case_id int`
  - `status text` (для условия бонуса важен `status='completed'`)

---

### Серверная часть (Supabase): функции/RPC и триггеры

#### 1) `public.gp_bonus_claim(p_rule_key text)`

- **Назначение**: выдать разовый бонус по правилу из `gp_bonus_rules`.
- **Идемпотентность**:
  - `v_idem := 'bonus:'||p_rule_key||':'||auth.uid()`
  - если `gp_ledger` уже содержит эту строку → функция просто возвращает текущий баланс
  - дополнительно фиксируется `gp_bonus_grants` (unique `(user_id, rule_key)`)
- **Побочные эффекты**:
  - вставляет строку в `gp_ledger` (`type='bonus'`, `amount=+v_amount`, `reference_id=p_rule_key`)
  - пересчитывает `gp_wallets` через `_gp_compute_wallet`
- **Условия (серверные проверки)**:
  - `profile_completed`: проверяет заполненность `users.name/goal/about/avatar_id`
  - `all_three_cases_completed`: проверяет 3 строки `user_case_progress` со статусом `completed` для `case_id in (1,2,3)`
  - для остальных — без дополнительных условий
- **Права**: EXECUTE только для `authenticated` (и `service_role`), публичному `anon` не доступно.

#### 2) `public.gp_claim_daily_application()`

- **Назначение**: выдать ежедневный бонус `daily_application` (**1 раз в local-day**).
- **Ключевые требования**:
  - бонус **не выдаётся**, если за local-day **нет** записи в `practice_log`
  - бонус **не выдаётся** больше 1 раза в local-day
- **Как считается local-day**:
  - берется IANA timezone из `public.users.timezone`
  - если timezone не задана/невалидна → fallback **`Asia/Almaty`**
- **Проверка “есть запись сегодня”**:
  - строятся границы local-day в UTC:
    - `day_start := local_day::timestamp at time zone tz`
    - `day_end := day_start + interval '1 day'`
  - затем ищется `practice_log` по `applied_at`:
    - `applied_at >= day_start AND applied_at < day_end`
- **Идемпотентность**:
  - `idempotency_key = bonus:daily_application:<YYYY-MM-DD>:<user_id>`
  - строка пишется **в `gp_ledger`** (для daily не используется `gp_bonus_grants`, т.к. он “one-off”)
- **Права**: EXECUTE только для `authenticated`.

#### 3) `public.user_set_timezone(p_timezone text)`

- **Назначение**: сохранить IANA timezone пользователя (например `Asia/Almaty`) в `public.users.timezone`.
- **Валидация**: `p_timezone` проверяется через `pg_timezone_names`.
- **Очистка**: можно передать пустое значение → timezone будет `NULL`.
- **Права**: EXECUTE только для `authenticated`.

#### 4) `public._gp_resolve_user_timezone(p_user_id uuid)`

- **Назначение**: серверный helper для получения TZ пользователя с fallback.
- **Важно**: используется внутри `gp_claim_daily_application()`.

#### 5) Auth-триггеры (важно для стартового состояния)

На `auth.users` в проде есть два триггера:

- **`on_auth_user_created` → `public.handle_new_user()`**
  - создаёт строку в `public.users (id, email, name)` (name = пустая строка).
- **`trg_create_wallet_on_signup` → `public.tg_create_wallet_on_signup()`**
  - создаёт строку в `public.gp_wallets` с **`balance=30, total_earned=30`**.
  - важно: для консистентности экономики GP рекомендуется “материализовать” signup‑бонус через `gp_bonus_claim('signup_bonus')` (см. клиентскую логику ниже), чтобы стартовые 30 GP также были отражены в `gp_ledger`.

---

### Клиентская часть (Flutter): где и когда клеймятся бонусы

> Важно: большинство вызовов сделаны **best-effort** (ошибки ловятся и не ломают UX).

#### 1) Signup bonus (`signup_bonus`)

- **Файл**: `lib/services/auth_service.dart`
- **Точки**:
  - `signIn(email/password)` → `GpService.claimBonus('signup_bonus')`
  - `signInWithApple()` (iOS) → `GpService.claimBonus('signup_bonus')`
  - `signInWithGoogle()` (mobile) → `GpService.claimBonus('signup_bonus')`
- **Замечание про Web OAuth**:
  - методы `signInWithOAuth(...)` на Web уходят в редирект и возвращают пустой `AuthResponse`.
  - бонус/таймзону на web корректнее клеймить/синхронизировать в обработчике `onAuthStateChange` (если web станет поддерживаемым сценарием).

#### 2) Бонус за заполнение профиля (`profile_completed`)

- **Файл**: `lib/services/auth_service.dart`
- **Точка**: `updateProfile(...)` после update делает SELECT нужных полей и при полном профиле клеймит `profile_completed`.

#### 3) Daily бонус за практику (`daily_application`)

- **Файл**: `lib/repositories/goals_repository.dart`
- **Точки**:
  - после успешного insert в `practice_log` (`addPracticeEntry`) вызывается `_claimDailyBonusAndRefresh()`
  - после транзакционного RPC `log_practice_and_update_metric` также вызывается `_claimDailyBonusAndRefresh()`
- **Важно про UI**:
  - на экране цели сейчас показывается SnackBar `“+5 GP…”` оптимистично — это не подтверждение начисления.
  - источник истины — `gp_ledger` / `gp_wallets`.

#### 4) Бонус за 3 кейса (`all_three_cases_completed`)

- **Файл**: `lib/screens/mini_case_screen.dart`
- **Точка**: `_complete()` после `caseActionsProvider.complete(...)` вызывает RPC:
  - `client.rpc('gp_bonus_claim', params: {'p_rule_key': 'all_three_cases_completed'})`
- **Проверка “ново выдан”**:
  - сравнивает наличие строки в `gp_bonus_grants` **для текущего user** до/после RPC и показывает `MilestoneCelebration`, если бонус выдан впервые.

#### 5) Синхронизация таймзоны пользователя

- **Файлы**:
  - `lib/services/timezone_gate.dart` — лёгкое получение IANA TZ (`FlutterTimezone.getLocalTimezone().identifier`)
  - `lib/services/auth_service.dart` — best-effort вызов `user_set_timezone(...)` после успешного входа
- **Почему это важно**:
  - daily‑бонус на сервере считает local-day именно по `public.users.timezone`.

---

### Идемпотентность (как защищаемся от дублей)

- **Разовые бонусы**:
  - `gp_bonus_grants` гарантирует “1 раз на правило”
  - `gp_ledger.idempotency_key = bonus:<rule_key>:<user_id>` гарантирует идемпотентность транзакции
- **Daily бонус**:
  - `gp_ledger.idempotency_key = bonus:daily_application:<YYYY-MM-DD>:<user_id>` гарантирует “1 раз в local-day”
- **Глобально**:
  - в `gp_ledger` есть unique index на `idempotency_key` → защита от гонок/повторов запросов

---

### Как быстро проверить в Supabase (SQL-шпаргалка)

```sql
-- 1) Какие бонусы активны
select rule_key, amount, active, is_active
from public.gp_bonus_rules
order by rule_key;

-- 2) Таймзона пользователя
select id, email, timezone
from public.users
where id = '<USER_UUID>';

-- 3) Был ли выдан разовый бонус
select rule_key, granted_at
from public.gp_bonus_grants
where user_id = '<USER_UUID>'
order by granted_at desc;

-- 4) Транзакции бонусов в ledger
select created_at, reference_id, amount, idempotency_key, metadata
from public.gp_ledger
where user_id = '<USER_UUID>' and type = 'bonus'
order by created_at desc;

-- 5) Daily: есть ли запись практики за текущий local-day (пример через границы)
with d as (
  select '<USER_UUID>'::uuid as uid,
         public._gp_resolve_user_timezone('<USER_UUID>'::uuid) as tz,
         (now() at time zone public._gp_resolve_user_timezone('<USER_UUID>'::uuid))::date as local_day
),
bounds as (
  select uid,
         (local_day::timestamp at time zone tz) as day_start,
         (local_day::timestamp at time zone tz) + interval '1 day' as day_end
  from d
)
select count(*) as practice_today
from public.practice_log pl
join bounds b on b.uid = pl.user_id
where pl.applied_at >= b.day_start and pl.applied_at < b.day_end;
```

---

### Как добавить новый бонус (рекомендованный чеклист)

- **1) Определить тип бонуса**:
  - **one-off** (1 раз на пользователя) → добавляем в `gp_bonus_rules` и в `gp_bonus_claim` условия/валидации (если нужны)
  - **per-day/per-event** → отдельный RPC/trigger, который пишет в `gp_ledger` с собственным `idempotency_key`
- **2) Добавить правило** в `gp_bonus_rules` (и включить `active=true`).
- **3) Обеспечить идемпотентность** через `gp_ledger.idempotency_key`.
- **4) Добавить client-trigger** (best-effort) там, где событие реально происходит.
- **5) Добавить SQL/тесты** на регрессию: “не начисляется дважды” и “не начисляется без условия”.







