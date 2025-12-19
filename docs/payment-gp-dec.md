### Отчет: оплата и GP (Growth Points) в приложении BizLevel

- **Дата отчета**: 17.12.25
- **Скоуп**: **мобильные приложения iOS/Android**. Web‑оплата/веб‑флоу считаются **неподдерживаемыми** (могут оставаться в коде/бэкенде как легаси).

---

### 1) Термины и общая идея

- **GP (Growth Points)**: внутренняя валюта приложения.
- **Баланс GP**: хранится в таблице `public.gp_wallets`.
- **История операций (ledger)**: таблица `public.gp_ledger` (каждая операция — строка с `amount`, `type`, `idempotency_key`).
- **IAP** (In‑App Purchases):
  - iOS: **StoreKit 2** через нативный мост (`StoreKit2Bridge.swift`).
  - Android: **Google Billing** через пакет `in_app_purchase`.
- **Верификация покупки**: делается на сервере (Supabase Edge Function `gp-purchase-verify`), после чего начисление GP выполняется через RPC `gp_iap_credit(...)`.

---

### 2) Быстрый TL;DR по текущей архитектуре

- **Экран магазина GP** (клиент): `lib/screens/gp_store_screen.dart`
  - Загружает список товаров из стора (`gp_300/gp_1000/gp_2000`)
  - Покупает и отправляет токен/receipt на серверную верификацию
  - Обновляет баланс после подтверждения
- **Сервер (Supabase)**:
  - Edge: `gp-purchase-verify` (**версия 73**, `verify_jwt=true`) — подтверждение IAP
  - DB RPC:
    - `gp_iap_credit(text, integer)` — начисление (идемпотентно)
    - `gp_balance()` — запрос баланса
    - `gp_spend(...)`, `gp_package_buy(...)`, `gp_bonus_claim(...)` — списания/пакеты/бонусы
  - Таблицы:
    - `gp_wallets`, `gp_ledger`, `store_pricing`, `iap_verify_logs`

---

### 3) SKU/пакеты GP и прайсинг

#### 3.1) Канонические SKU (используются в мобильном коде)
- `gp_300` → **300 GP**
- `gp_1000` → **1400 GP** (1000 + 400 бонус)
- `gp_2000` → **3000 GP** (2000 + 1000 бонус)

#### 3.2) `store_pricing` (Supabase) — фоллбэк‑цены для UI

Таблица `public.store_pricing` (PK: `product_id`) используется клиентом, чтобы:
- показывать цену, если стор не вернул `displayPrice/price`
- отображать название пакета (`title`)

На дату отчета строки (активные):
- `gp_300`: 3000 ₸, 300 GP, bonus 0, title “СТАРТ”
- `gp_1000`: 9990 ₸, 1400 GP, bonus 400, title “РАЗГОН”
- `gp_2000`: 19990 ₸, 3000 GP, bonus 1000, title “ТРАНСФОРМАЦИЯ”

#### 3.3) Легаси SKU (алиасы)

В Edge `gp-purchase-verify` остаются алиасы, чтобы не ломать старые билды:
- `bizlevelgp_300/bizlevelgp_1000/bizlevelgp_2000`
- `gp_1400/gp_3000` (алиасы под “итоговые” суммы)

Факт использования (по логам Supabase):
- `bizlevelgp_*`: **12** записей в `iap_verify_logs` (последний раз **2025‑11‑11**), и **7** начислений в `gp_ledger` с `idempotency_key like 'iap:%bizlevelgp_%'` (последний раз **2025‑11‑11**).
- `gp_1400/gp_3000`: **0** следов в `iap_verify_logs` (не встречались).

Рекомендации по чистке — см. раздел **12**.

---

### 4) Как это работает у пользователя (сквозной сценарий)

#### 4.1) Открытие магазина GP
Файл: `lib/screens/gp_store_screen.dart`

1) UI вызывает `_loadServerPricing()`:
- запрос `select * from store_pricing where is_active=true` (через `supabase_flutter`)

2) UI вызывает `_loadIapProducts()` (только когда экран видимый):
- iOS: `StoreKit2Service.instance.fetchProducts(['gp_300','gp_1000','gp_2000'])`
- Android: `IapService.instance.queryProducts({'gp_300','gp_1000','gp_2000'})`

3) Отображение цены:
- iOS: `StoreKitProduct.displayPrice`
- Android: `ProductDetails.price`
- fallback: `store_pricing.amount_kzt`

#### 4.2) Покупка на iOS (StoreKit 2)
Файлы/узлы:
- `lib/services/iap_service.dart` → `buyStoreKitProduct`
- `lib/services/storekit2_service.dart` → MethodChannel `bizlevel/storekit2`
- `ios/Runner/NativeBootstrapCoordinator.swift` → `installStoreKit2Bridge`
- `ios/Runner/StoreKit2Bridge.swift` → `fetchProducts/purchase/restore`
- `lib/services/gp_service.dart` → `verifyIapPurchase(...)`
- Edge `gp-purchase-verify` → Apple verifyReceipt → `gp_iap_credit(...)`

Поток:
1) Пользователь нажимает “Купить” → `_handleIosPurchase`.
2) `IapService.buyStoreKitProduct(productId)` → `StoreKit2Service.purchase(productId)`.
3) `StoreKit2Service` лениво устанавливает мост (`installStoreKit2Bridge`) через `bizlevel/native_bootstrap`.
4) Нативный StoreKit 2 возвращает транзакцию + `appStoreReceipt` (base64) / `jwsRepresentation`.
5) Клиент отправляет в Edge `gp-purchase-verify`:
- `platform='ios'`, `product_id`, `token`
6) Edge верифицирует receipt, формирует `purchaseId='ios:<product_id>:<transactionId>'`, начисляет GP через `gp_iap_credit`.
7) Клиент обновляет баланс (`gpBalanceProvider`) и показывает статус.

#### 4.3) Покупка на Android (Google Billing)
Файлы/узлы:
- `lib/services/iap_service.dart` (Android покупка + `purchaseStream`)
- `android/app/src/main/AndroidManifest.xml` (`com.android.vending.BILLING`)
- `android/app/build.gradle.kts` (`applicationId=kz.bizlevel.bizlevel`)
- `lib/services/gp_service.dart` (`verifyIapPurchase`)
- Edge `gp-purchase-verify` → Google Play Developer API → `gp_iap_credit`

Поток:
1) Пользователь нажимает “Купить” → `_handleAndroidPurchase`.
2) `IapService.buyConsumableOnce(ProductDetails)`:
- слушает `purchaseStream`
- вызывает `completePurchase` (если требуется)
3) Клиент берет `purchaseToken` из `purchase.verificationData.serverVerificationData`
4) Клиент отправляет в Edge `gp-purchase-verify`:
- `platform='android'`, `product_id`, `token=purchaseToken`, `package_name='kz.bizlevel.bizlevel'`
5) Edge:
- получает OAuth токен через `GOOGLE_SERVICE_ACCOUNT_JSON`
- проверяет покупку через Android Publisher API (purchaseState==0)
- формирует `purchaseId='android:<product_id>:<orderId>'`
- вызывает `gp_iap_credit(p_purchase_id, amount_gp)` и возвращает `balance_after`
6) Клиент обновляет баланс и показывает подтверждение.

---

### 5) Клиент (Flutter): задействованные файлы/сервисы

#### 5.1) Основной UI магазина
- `lib/screens/gp_store_screen.dart`
  - `_loadServerPricing()` — читает `store_pricing`
  - `_loadIapProducts()` — fetchProducts/queryProducts
  - `_handleIosPurchase(...)` / `_handleAndroidPurchase(...)`
  - `_describePurchaseError(...)` — перевод ошибок в понятные сообщения

#### 5.2) IAP слой
- `lib/services/iap_service.dart`
  - На iOS **не использует** `InAppPurchase` (StoreKit 1), чтобы не поднимать очередь StoreKit1.
  - На Android использует `in_app_purchase` и `purchaseStream`.

#### 5.3) StoreKit2 мост (Dart)
- `lib/services/storekit2_service.dart`
  - `MethodChannel('bizlevel/storekit2')`
  - `EventChannel('bizlevel/storekit2/transactions')`
  - `MethodChannel('bizlevel/native_bootstrap')` для `installStoreKit2Bridge`

#### 5.4) GP сервис (Supabase/Edge/RPC)
- `lib/services/gp_service.dart`
  - RPC: `gp_balance`, `gp_spend`, `gp_package_buy`, `gp_bonus_claim`
  - Edge: `/functions/v1/gp-purchase-verify` для IAP verify
  - Локальный кеш баланса (Hive) + Sentry breadcrumbs

#### 5.5) iOS build‑особенности (важно для IAP)
- `tool/strip_iap_from_registrant.dart`
  - удаляет регистрацию `InAppPurchasePlugin` из `ios/Runner/GeneratedPluginRegistrant.m`
  - цель: исключить StoreKit 1 путь на iOS
- `ios/Runner/NativeBootstrapCoordinator.swift`
  - лениво подключает StoreKit2 bridge на первом обращении

---

### 6) Supabase: проект, Edge функции, таблицы, RPC

#### 6.1) Проект
- **Project ID**: `acevqbdpzgbtqznbpgzr`
- **API URL**: `https://acevqbdpzgbtqznbpgzr.supabase.co`

#### 6.2) Edge Functions (релевантные для GP/оплаты)

Список (часть):
- `gp-purchase-verify` (**v73**, `verify_jwt=true`) — IAP verify + начисление GP
- `gp-purchase-init` (v62) — web‑легаси init
- `gp-balance` (v57) — edge‑обертка (используется как fallback/диагностика)
- `gp-spend` (v57) — edge‑обертка (fallback/диагностика)
- `gp-floor-unlock` (v57) — edge‑обертка/endpoint
- `gp-bonus-claim` (v57) — edge‑обертка/endpoint
- `diag-gp-purchase-verify` (v12) — диагностическая функция (не обязательна для штатного сценария)

#### 6.3) Таблицы (ядро GP/оплаты)

**`public.gp_wallets`**
- `user_id uuid PK` (FK → `auth.users`)
- `balance int not null default 0` (**CHECK balance>=0**)
- `total_earned int default 0`
- `total_spent int default 0`
- `updated_at timestamptz default now()`

**`public.gp_ledger`**
- `id uuid PK default gen_random_uuid()`
- `user_id uuid not null` (FK → `auth.users`)
- `amount int not null` (**покупка: +**, списание: **-**)
- `type public.gp_transaction_type not null` (enum)
- `reference_id text null`
- `metadata jsonb not null default '{}'`
- `idempotency_key text null` (**уникальность для идемпотентности**)
- `created_at timestamptz default now()`

**`public.iap_verify_logs`**
- `id uuid PK`
- `created_at timestamptz default now()`
- `user_id uuid not null default auth.uid()`
- `platform text`, `product_id text`, `package_name text`
- `token_prefix text`, `token_hash text`
- `step text`, `http_status int`, `error text`
- `google_payload jsonb`

**`public.store_pricing`**
- `product_id text PK`
- `amount_kzt int CHECK(amount_kzt>0)`
- `amount_gp int CHECK(amount_gp>0)`
- `bonus_gp int default 0`
- `title text null`
- `is_active bool default true`
- `updated_at timestamptz default now()`

**`public.gp_purchases`** (web‑легаси платежи)
- `id uuid PK`
- `user_id uuid not null` (FK → `auth.users`)
- `package_id text not null`
- `amount_kzt int not null`
- `amount_gp int not null`
- `provider public.gp_provider not null` (enum)
- `provider_transaction_id text null`
- `status public.gp_purchase_status not null default 'pending'`
- `created_at timestamptz default now()`

Связанные таблицы, влияющие на расход/доступ:
- `public.packages` (каталог пакетов/этажей)
- `public.user_packages` (что купил пользователь)
- `public.floor_access` (доступ к этажам)
- `public.gp_bonus_rules`, `public.gp_bonus_grants` (правила/выданные бонусы)

#### 6.4) Enum типы (DB)
- `public.gp_transaction_type`: `{purchase, spend_message, spend_floor, bonus}`
- `public.gp_purchase_status`: `{pending, completed, failed, refunded}`
- `public.gp_provider`: `{apple, google, epay, kaspi}`

#### 6.5) Индексы (ключевые)
- `gp_wallets_pkey` по `user_id`
- `gp_ledger`: есть **2 unique индекса** по `idempotency_key`:
  - `idx_gp_ledger_idem` (unique)
  - `gp_ledger_idempotency_key_idx` (unique, partial `WHERE idempotency_key IS NOT NULL`)
  - плюс `idx_gp_ledger_user_created_desc (user_id, created_at desc)`
- `gp_purchases_provider_tx_uidx` (unique `(provider, provider_transaction_id)` where not null)
- `store_pricing_pkey` по `product_id`
- `iap_verify_logs`: только PK (`iap_verify_logs_pkey`) — специализированных индексов под аналитику нет

#### 6.6) RLS политики (релевантные)

**Доступ к данным GP**
- `gp_wallets_select` (roles `{public}`): `auth.uid() = user_id`
- `gp_ledger_select` (roles `{public}`): `auth.uid() = user_id`

**Покупки (web‑легаси)**
- `gp_purchases_select` (roles `{public}`): `auth.uid() = user_id`
- `gp_purchases_insert` (roles `{authenticated}`): with_check `auth.uid() = user_id`

**Диагностические логи IAP**
- `iap_verify_logs_select_own` (roles `{public}`): `auth.uid() = user_id`
- `iap_verify_logs_insert_own` (roles `{authenticated}`): with_check `auth.uid() = user_id`

**Прайсинг**
- `store_pricing_select` (roles `{public}`): `true`

---

### 7) Серверная логика GP (RPC) — что делает каждая функция

#### 7.1) `gp_balance()`
- Возвращает баланс из `gp_wallets` (если кошелька нет — нули).
- `SECURITY DEFINER`, `search_path='public'`.

#### 7.2) `gp_iap_credit(p_purchase_id text, p_amount_gp int)`
- **Начисление GP после успешной верификации IAP.**
- Идемпотентность: `idempotency_key = 'iap:' || p_purchase_id`.
- Вставляет строку в `gp_ledger` (type=`purchase`, amount=`+p_amount_gp`) и обновляет `gp_wallets`.
- Возвращает `balance_after`.

#### 7.3) `gp_spend(p_type gp_transaction_type, p_amount int, p_reference_id text, p_idempotency_key text)`
- **Списание GP** (например, сообщение/этаж).
- Идемпотентность по `idempotency_key` (если ключ уже был — возвращает текущий баланс без ошибки).
- Проверяет достаточность баланса и пишет отрицательную сумму в `gp_ledger`.
- Кошелек пересчитывает через `_gp_compute_wallet` и апсертит в `gp_wallets`.

#### 7.4) `gp_package_buy(p_package_code text, p_idempotency_key text)`
- Покупка “пакета” из таблицы `packages` (напр. этаж).
- Делает списание через `gp_spend(spend_floor, price_gp, reference, idempotency)`.
- Записывает, что пакет выдан, в `user_packages` (идемпотентно по уникальности `(user_id, package_id)` и `idempotency_key`).

#### 7.5) `gp_bonus_claim(p_rule_key text)`
- Начисляет бонус GP по правилам (`gp_bonus_rules`) и условиям (например, заполненность профиля).
- Идемпотентность: `idempotency_key = 'bonus:<rule_key>:<user_id>'`.
- Пишет `gp_ledger` (type=`bonus`, amount=`+v_amount`) и пересчитывает кошелек.

#### 7.6) `gp_purchase_verify(...)` (web‑легаси)
- Подтверждает `gp_purchases`, делает начисление по `idempotency_key='purchase:<purchase_id>'`.
- Для mobile IAP сейчас не является основным механизмом (IAP идет через `gp_iap_credit`).

---

### 8) Edge `gp-purchase-verify`: как устроена верификация IAP

Файл: `supabase/functions/gp-purchase-verify/index.ts` (задеплоено как `gp-purchase-verify` v73)

Что делает:
1) Принимает `platform/product_id/token/(package_name)`.
2) Находит начисление GP по `product_id` через `PRODUCT_TO_GP`.
3) Верифицирует покупку:
   - **iOS**: Apple verifyReceipt (prod → sandbox fallback)
   - **Android**: Google Play Developer API (OAuth service account)
4) Собирает `purchaseId = <platform>:<product_id>:<transactionId>` и вызывает `rpc gp_iap_credit(purchaseId, amount_gp)`.
5) Возвращает `balance_after`.
6) Пишет диагностические события в `iap_verify_logs` (минимум: `start`, на ошибке: `error`; после начисления ожидается `credited` в новых покупках).

Важно:
- Для `iap_verify_logs` у `user_id` default `auth.uid()` → Edge должен передавать user JWT. Клиент делает это через `x-user-jwt`.

---

### 9) Наблюдаемость и как дебажить “неправильную” оплату

#### 9.1) Где искать правду о начислении
- **Начисление прошло** ⇢ в `gp_ledger` есть строка:
  - `type='purchase'`
  - `idempotency_key like 'iap:%'`
  - `reference_id = '<platform>:<product_id>:<txId>'`
- **Баланс обновился** ⇢ `gp_wallets.updated_at` и `balance` изменились.

#### 9.2) `iap_verify_logs`: что реально есть в данных
По истории логов:
- всего записей: **56**
- ошибок: **16**
- `credited`: **0** (исторически; после обновления Edge v73 ожидается появление `credited` на новых покупках)
- платформы:
  - `android`: `start`=27, `error`=14
  - `ios`: **0** (в логах пока не было iOS‑верификаций)

#### 9.3) Топ ошибок в `iap_verify_logs` (исторически)
- `rpc_no_balance` — 7 раз (ложное “ошибка” при успешном начислении; исправлено в Edge v73)
- `Date.Now is not a function` — 3 раза (ошибка старой версии Edge; в v73 не должна повторяться)
- `google_purchase_failed:401 ... permissionDenied` — 3 раза (не хватает прав у service account)

#### 9.4) Сверка Android кейса “списали деньги, GP начислены, UI показал ошибку”
Факт из БД:
- В `iap_verify_logs` фиксировался `rpc_no_balance`,
- Но в `gp_ledger` в те же минуты уже есть `type='purchase'` и `idempotency_key iap:...`,
то есть начисление было сделано, а ошибка была “на уровне ответа/парсинга”.

---

### 10) Где что настраивается (карта ответственности)

#### 10.1) iOS (App Store Connect / Xcode)
- В App Store Connect создаются IAP‑товары (SKU должны совпадать с кодом: `gp_*`).
- В Xcode/проекте:
  - `Bundle ID`: `bizlevel.kz`
  - StoreKit 2 мост: `StoreKit2Bridge.swift`
  - Bootstrap‑канал: `NativeBootstrapCoordinator.swift`
  - Важно: StoreKit1 плагин вычищается скриптом `tool/strip_iap_from_registrant.dart`

#### 10.2) Android (Google Play Console / Gradle)
- В Gradle:
  - `applicationId`: `kz.bizlevel.bizlevel`
- В AndroidManifest:
  - `com.android.vending.BILLING`
- В Google Play Console:
  - должны существовать In‑App Products с SKU `gp_300/gp_1000/gp_2000`
  - service account должен иметь доступ к Android Publisher API (иначе будет `401 permissionDenied`)

#### 10.3) Supabase (Edge + DB)
- `store_pricing` — фоллбэк‑прайсинг/названия пакетов
- Edge Secrets:
  - `GOOGLE_SERVICE_ACCOUNT_JSON` (**секрет**)
  - `ANDROID_PACKAGE_NAME` (fallback)
  - `SUPABASE_URL`, `SUPABASE_ANON_KEY`
  - `SUPABASE_SERVICE_ROLE_KEY` (используется в некоторых внутренних запросах/фоллбэках)
- DB:
  - RLS политики на GP таблицах
  - RPC функции (security definer) для баланса/списаний/начислений

---

### 11) Риски/конфликты (что важно держать под контролем)

#### 11.1) Несовпадение SKU между клиентом и сторами
- Клиент ожидает `gp_300/gp_1000/gp_2000`.
- Любые другие SKU приведут к `unknown_product` на сервере или к пустому списку товаров в StoreKit.

#### 11.2) Права Google service account
- Исторические ошибки `google_purchase_failed:401 ... permissionDenied` уже были.
- Без прав верификация может падать, но Google может списать деньги — UX будет “плохо”.

#### 11.3) Идемпотентность и двойные начисления
- Идемпотентность обеспечена `gp_iap_credit` через `gp_ledger.idempotency_key`.
- В `gp_ledger` два unique индекса по `idempotency_key` — это избыточно (технический долг), но дубли начислений не видно (дубликатов `iap:%` не найдено).

#### 11.4) Производительность логов
- `iap_verify_logs` не имеет индексов по `(user_id, created_at)` — при росте логов может потребоваться индексация.

---

### 12) Чистка легаси SKU: анализ и план

#### Факты
- `bizlevelgp_*` встречались в реальных покупках Android до 2025‑11‑11.
- `gp_1400/gp_3000` не встречались в IAP‑верификации (по имеющимся логам).

#### Рекомендация
- **Не удалять `bizlevelgp_*` прямо сейчас** — есть риск сломать старые сборки/старые SKU в Google Play.
- `gp_1400/gp_3000` можно удалить с низким риском, но лучше делать это пакетом, после контрольной даты и проверки по Play Console.

---

### 13) Supabase Advisors (замечания, не блокируют оплату напрямую)

Security:
- [RLS Disabled in Public](https://supabase.com/docs/guides/database/database-linter?lint=0013_rls_disabled_in_public): `public.internal_usage_stats` без RLS
- [Extension in Public](https://supabase.com/docs/guides/database/database-linter?lint=0014_extension_in_public): `pg_net` в `public`
- [Auth OTP long expiry](https://supabase.com/docs/guides/platform/going-into-prod#security)
- [Leaked Password Protection Disabled](https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection)
- [Postgres upgrade](https://supabase.com/docs/guides/platform/upgrading)

Performance:
- [Auth RLS init plan](https://supabase.com/docs/guides/database/database-linter?lint=0003_auth_rls_initplan) для ряда таблиц (в т.ч. `iap_verify_logs`, `gp_wallets`, `gp_ledger`)

---

### 14) Приложение: “как проверить руками” (чек‑лист)

#### Android
- Убедиться, что `package_name` в запросе — `kz.bizlevel.bizlevel` (в логах он такой).
- Проверить доступ service account к Android Publisher API (иначе будет 401).
- Сделать тестовую покупку:
  - Ожидаем `gp-purchase-verify` вернуть `balance_after`
  - В `iap_verify_logs` должен появиться `credited` (после фикса v73)

#### iOS
- Дождаться статусов IAP/версии в App Store Connect (сейчас `WAITING_FOR_REVIEW` / версия `REJECTED`).
- После разблокировки статусов:
  - StoreKit должен вернуть товары (иначе UI покажет “App Store пока не возвращает товары”)
  - Дальше верификация пойдет через тот же `gp-purchase-verify`

---

### 15) Appendix: ключевые определения RPC (выжимка)

Ниже — выдержки из `pg_get_functiondef(...)` на момент отчета (17.12.25).

```sql
-- public.gp_balance()
CREATE OR REPLACE FUNCTION public.gp_balance()
 RETURNS TABLE(balance integer, total_earned integer, total_spent integer)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_user uuid := auth.uid();
  v_balance int := 0;
  v_earned int := 0;
  v_spent int := 0;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'not_authenticated' USING ERRCODE = '28000';
  END IF;

  SELECT w.balance, w.total_earned, w.total_spent
    INTO v_balance, v_earned, v_spent
  FROM public.gp_wallets w
  WHERE w.user_id = v_user;

  IF NOT FOUND THEN
    v_balance := 0; v_earned := 0; v_spent := 0;
  END IF;

  RETURN QUERY SELECT v_balance, v_earned, v_spent;
END;
$function$;
```

```sql
-- public._gp_compute_wallet(p_user_id uuid)
CREATE OR REPLACE FUNCTION public._gp_compute_wallet(p_user_id uuid)
 RETURNS TABLE(balance integer, total_earned integer, total_spent integer)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT
    COALESCE(SUM(amount)::int, 0) AS balance,
    COALESCE(SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END)::int, 0) AS total_earned,
    COALESCE(ABS(SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END))::int, 0) AS total_spent
  FROM public.gp_ledger
  WHERE user_id = p_user_id;
$function$;
```

```sql
-- public.gp_spend(p_type gp_transaction_type, p_amount integer, p_reference_id text, p_idempotency_key text)
CREATE OR REPLACE FUNCTION public.gp_spend(p_type gp_transaction_type, p_amount integer, p_reference_id text, p_idempotency_key text)
 RETURNS TABLE(balance_after integer)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_user uuid := auth.uid();
  v_balance int;
  v_earned int;
  v_spent int;
  v_rows int := 0;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'not_authenticated' USING ERRCODE = '28000';
  END IF;
  IF p_amount IS NULL OR p_amount <= 0 THEN
    RAISE EXCEPTION 'gp_invalid_amount';
  END IF;
  IF p_idempotency_key IS NULL OR length(p_idempotency_key) = 0 THEN
    RAISE EXCEPTION 'gp_missing_idempotency_key';
  END IF;

  -- If duplicate, return current wallet without error
  IF EXISTS (SELECT 1 FROM public.gp_ledger WHERE idempotency_key = p_idempotency_key) THEN
    SELECT w.balance, w.total_earned, w.total_spent
      INTO v_balance, v_earned, v_spent
    FROM public.gp_wallets w WHERE w.user_id = v_user;
    IF NOT FOUND THEN
      SELECT balance, total_earned, total_spent
        INTO v_balance, v_earned, v_spent
      FROM public._gp_compute_wallet(v_user);
    END IF;
    RETURN QUERY SELECT v_balance;
  END IF;

  -- Check sufficiency before first insert
  SELECT w.balance INTO v_balance FROM public.gp_wallets w WHERE w.user_id = v_user;
  IF NOT FOUND THEN
    SELECT balance INTO v_balance FROM public._gp_compute_wallet(v_user);
  END IF;
  IF v_balance < p_amount THEN
    RAISE EXCEPTION 'gp_insufficient_balance';
  END IF;

  -- Try insert idempotently; if conflict (race), treat as success
  INSERT INTO public.gp_ledger(id, user_id, amount, type, reference_id, metadata, idempotency_key, created_at)
  VALUES (gen_random_uuid(), v_user, -p_amount, p_type, NULLIF(p_reference_id, ''), '{}'::jsonb, p_idempotency_key, now())
  ON CONFLICT (idempotency_key) DO NOTHING;
  GET DIAGNOSTICS v_rows = ROW_COUNT;

  -- Recompute wallet (inserted or duplicate)
  SELECT balance, total_earned, total_spent
    INTO v_balance, v_earned, v_spent
  FROM public._gp_compute_wallet(v_user);

  INSERT INTO public.gp_wallets(user_id, balance, total_earned, total_spent, updated_at)
  VALUES (v_user, v_balance, v_earned, v_spent, now())
  ON CONFLICT (user_id) DO UPDATE
    SET balance = EXCLUDED.balance,
        total_earned = EXCLUDED.total_earned,
        total_spent = EXCLUDED.total_spent,
        updated_at = now();

  RETURN QUERY SELECT v_balance;
END;
$function$;
```

```sql
-- public.gp_package_buy(p_package_code text, p_idempotency_key text)
CREATE OR REPLACE FUNCTION public.gp_package_buy(p_package_code text, p_idempotency_key text)
 RETURNS TABLE(balance_after integer, granted boolean, package_code text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_user uuid := auth.uid();
  v_pkg_id bigint;
  v_price int;
  v_kind text;
  v_granted boolean := false;
  v_balance int := 0;
  v_rows int := 0;
  v_tx_type public.gp_transaction_type := 'spend_floor';
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_package_code is null or length(p_package_code) = 0 then
    raise exception 'gp_invalid_package';
  end if;
  if p_idempotency_key is null or length(p_idempotency_key) = 0 then
    raise exception 'gp_missing_idempotency_key';
  end if;

  select id, price_gp, kind into v_pkg_id, v_price, v_kind
  from public.packages
  where code = p_package_code and active = true
  limit 1;

  if v_pkg_id is null then
    raise exception 'gp_invalid_package';
  end if;

  -- choose transaction type based on kind (use existing enum values)
  if v_kind = 'floor' then
    v_tx_type := 'spend_floor';
  else
    -- fallback to a safe existing type; adjust later for bundles
    v_tx_type := 'spend_floor';
  end if;

  -- Spend GP (idempotent inside gp_spend)
  select s.balance_after into v_balance
  from public.gp_spend(v_tx_type, v_price, ('package:'||p_package_code)::text, p_idempotency_key) as s;

  -- Grant package (idempotent on unique(user_id, package_id))
  insert into public.user_packages(user_id, package_id, idempotency_key, gp_spent, source)
  values (v_user, v_pkg_id, p_idempotency_key, v_price, 'app')
  on conflict (user_id, package_id) do nothing;

  get diagnostics v_rows = row_count;
  v_granted := v_rows > 0;

  return query select v_balance, v_granted, p_package_code;
end;
$function$;
```

```sql
-- public.gp_bonus_claim(p_rule_key text)
CREATE OR REPLACE FUNCTION public.gp_bonus_claim(p_rule_key text)
 RETURNS TABLE(balance_after integer)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_user uuid := auth.uid();
  v_amount int;
  v_balance int;
  v_earned int;
  v_spent int;
  v_idem text;
  v_ok boolean := true;
  v_meta jsonb := '{}'::jsonb;
  v_completed_cases int := 0;
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_rule_key is null or length(p_rule_key) = 0 then
    raise exception 'gp_invalid_bonus_rule';
  end if;

  select amount into v_amount from public.gp_bonus_rules where rule_key = p_rule_key and active = true;
  if not found or v_amount is null or v_amount <= 0 then
    raise exception 'gp_invalid_bonus_rule';
  end if;

  -- server-side conditions per rule
  if p_rule_key = 'profile_completed' then
    perform 1 from public.users u
      where u.id = v_user
        and coalesce(nullif(u.name, ''), '') <> ''
        and coalesce(nullif(u.goal, ''), '') <> ''
        and coalesce(nullif(u.about, ''), '') <> ''
        and u.avatar_id is not null;
    if not found then
      raise exception 'gp_condition_not_met_profile';
    end if;
    v_meta := jsonb_build_object('rule_key', p_rule_key, 'source', 'rpc', 'fields', jsonb_build_array('name','goal','about','avatar_id'));
  elsif p_rule_key = 'all_three_cases_completed' then
    select count(*) into v_completed_cases
    from public.user_case_progress p
    where p.user_id = v_user
      and p.case_id in (1,2,3)
      and p.status = 'completed';
    if v_completed_cases < 3 then
      raise exception 'gp_condition_not_met_cases';
    end if;
    v_meta := jsonb_build_object('rule_key', p_rule_key, 'source', 'rpc', 'cases', jsonb_build_array(1,2,3));
  else
    -- default meta
    v_meta := jsonb_build_object('rule_key', p_rule_key, 'source', 'rpc');
  end if;

  v_idem := 'bonus:'||p_rule_key||':'||v_user::text;
  perform 1 from public.gp_ledger where idempotency_key = v_idem;
  if found then
    select w.balance into v_balance from public.gp_wallets w where w.user_id = v_user;
    if not found then
      select balance into v_balance from public._gp_compute_wallet(v_user);
    end if;
    return query select v_balance;
  end if;

  insert into public.gp_bonus_grants(user_id, rule_key, granted_at)
  values (v_user, p_rule_key, now())
  on conflict (user_id, rule_key) do nothing;

  insert into public.gp_ledger(id, user_id, amount, type, reference_id, metadata, idempotency_key, created_at)
  values (gen_random_uuid(), v_user, v_amount, 'bonus'::public.gp_transaction_type, p_rule_key, v_meta, v_idem, now())
  on conflict (idempotency_key) do nothing;

  select balance, total_earned, total_spent into v_balance, v_earned, v_spent
  from public._gp_compute_wallet(v_user);

  insert into public.gp_wallets(user_id, balance, total_earned, total_spent, updated_at)
  values (v_user, v_balance, v_earned, v_spent, now())
  on conflict (user_id) do update
    set balance = excluded.balance,
        total_earned = excluded.total_earned,
        total_spent = excluded.total_spent,
        updated_at = now();

  return query select v_balance;
end;
$function$;
```

```sql
-- public.gp_purchase_verify(p_purchase_id uuid)
CREATE OR REPLACE FUNCTION public.gp_purchase_verify(p_purchase_id uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  return public.gp_purchase_verify((select auth.uid()), p_purchase_id);
end;
$function$;
```

```sql
-- public.gp_purchase_verify(p_user_id uuid, p_purchase_id uuid)
CREATE OR REPLACE FUNCTION public.gp_purchase_verify(p_user_id uuid, p_purchase_id uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_purchase record;
  v_balance integer;
  v_idem text;
BEGIN
  SELECT * INTO v_purchase FROM public.gp_purchases WHERE id = p_purchase_id AND user_id = p_user_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'gp_purchase_not_found';
  END IF;

  -- If already completed, return current balance
  IF v_purchase.status = 'completed'::public.gp_purchase_status THEN
    SELECT balance INTO v_balance FROM public.gp_wallets WHERE user_id = p_user_id;
    RETURN COALESCE(v_balance, 0);
  END IF;

  -- Mark as completed
  UPDATE public.gp_purchases SET status = 'completed'::public.gp_purchase_status WHERE id = p_purchase_id;

  -- Ensure wallet exists and lock it
  INSERT INTO public.gp_wallets(user_id, balance, total_earned, total_spent)
  VALUES (p_user_id, 0, 0, 0)
  ON CONFLICT (user_id) DO NOTHING;

  SELECT balance INTO v_balance FROM public.gp_wallets WHERE user_id = p_user_id FOR UPDATE;

  -- Idempotent credit using purchase-based idempotency
  v_idem := 'purchase:' || p_purchase_id::text;
  IF NOT EXISTS (SELECT 1 FROM public.gp_ledger WHERE idempotency_key = v_idem) THEN
    INSERT INTO public.gp_ledger(user_id, amount, type, reference_id, idempotency_key)
    VALUES (p_user_id, v_purchase.amount_gp, 'purchase', p_purchase_id::text, v_idem);

    UPDATE public.gp_wallets
    SET balance = balance + v_purchase.amount_gp,
        total_earned = total_earned + v_purchase.amount_gp,
        updated_at = now()
    WHERE user_id = p_user_id;
  END IF;

  SELECT balance INTO v_balance FROM public.gp_wallets WHERE user_id = p_user_id;
  RETURN COALESCE(v_balance, 0);
END;
$function$;
```

```sql
-- public.gp_iap_credit(p_purchase_id text, p_amount_gp integer)
CREATE OR REPLACE FUNCTION public.gp_iap_credit(p_purchase_id text, p_amount_gp integer)
 RETURNS TABLE(balance_after integer)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_user uuid := (select auth.uid());
  v_balance int;
  v_earned int;
  v_spent int;
  v_idem text := 'iap:' || coalesce(p_purchase_id, '');
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_amount_gp is null or p_amount_gp <= 0 then
    raise exception 'gp_invalid_amount';
  end if;
  if p_purchase_id is null or length(p_purchase_id) = 0 then
    raise exception 'gp_invalid_purchase_id';
  end if;

  insert into public.gp_wallets(user_id, balance, total_earned, total_spent)
  values (v_user, 0, 0, 0)
  on conflict (user_id) do nothing;

  if not exists (select 1 from public.gp_ledger where idempotency_key = v_idem) then
    insert into public.gp_ledger(id, user_id, amount, type, reference_id, metadata, idempotency_key, created_at)
    values (gen_random_uuid(), v_user, p_amount_gp, 'purchase', p_purchase_id, '{}'::jsonb, v_idem, now());

    update public.gp_wallets
      set balance = balance + p_amount_gp,
          total_earned = total_earned + p_amount_gp,
          updated_at = now()
    where user_id = v_user;
  end if;

  select balance, total_earned, total_spent
    into v_balance, v_earned, v_spent
  from public.gp_wallets where user_id = v_user;

  return query select v_balance;
end;
$function$;
```

