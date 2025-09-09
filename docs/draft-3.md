# Покупки GP: как это работает сейчас (DEV/mock)

## Компоненты клиента
- `lib/screens/gp_store_screen.dart`: экран магазина (кнопки пакетов, Verify).
- `lib/services/gp_service.dart`: методы `initPurchase(packageId, provider)` и `verifyPurchase(purchaseId)`; сохранение `last_purchase_id` в Hive; корректные заголовки для Edge (`Authorization/apikey=ANON`, `x-user-jwt=session.accessToken`).
- `lib/providers/gp_providers.dart`: `gpBalanceProvider` (SWR‑кеш баланса; инвалидация после успешной покупки).
- Навигация на магазин: `UserInfoBar` (тап по балансу) и `BizTowerScreen` (кнопка/ссылка «Магазин GP»).

## Edge Functions (Supabase)
- `gp-purchase-init`:
  - CORS: `Access-Control-Allow-Headers` включает `authorization, x-client-info, apikey, content-type, x-user-jwt`.
  - Аутентификация: читает пользовательский JWT из `x-user-jwt` (предпочтительно) или из `Authorization: Bearer <userJWT>`; admin‑fallback на случай валидации.
  - Действия: создаёт запись в `gp_purchases` с `user_id`, `package_id`, `amount_kzt`, `amount_gp`, `provider`, `status='pending'` и возвращает:
    - `{ purchase_id, payment_url }`, где `payment_url` в DEV — mock `https://payments.example.com/pay?purchase_id=...`.
- `gp-purchase-verify`:
  - Такие же CORS/заголовки и валидация JWT.
  - Действия: вызывает RPC `gp_purchase_verify(p_user_id, p_purchase_id)`; по успешной верификации возвращает `{ balance_after }`.

## RPC / БД
- Таблица `gp_purchases`: `id (uuid)`, `user_id`, `package_id`, `amount_kzt`, `amount_gp`, `provider`, `status` (pending/paid/failed), `created_at`.
- RPC `gp_purchase_verify` (идемпотентно):
  - Проверяет `purchase_id` и владельца.
  - Если ещё не зачислено — создаёт запись в `gp_ledger` с типом `purchase` и обновляет `gp_wallets`.
  - Идемпотентность по ключу `purchase:<purchase_id>` (повторный `verify` не меняет баланс).

## Пакеты (конфигурация в Edge `gp-purchase-init`)
- `gp_300`: 300 GP за 3000 KZT
- `gp_1200`: 1400 GP за 9960 KZT (текущая dev‑настройка)
- `gp_2500`: 3000 GP за 25000 KZT

## Клиентский флоу
1) Пользователь жмёт «Купить» на пакете.
   - Клиент вызывает `initPurchase(packageId)` с заголовками:
     - `Authorization: Bearer <SUPABASE_ANON_KEY>`
     - `apikey: <SUPABASE_ANON_KEY>`
     - `x-user-jwt: <session.accessToken>`
   - В ответ получает `{ purchase_id, payment_url }` и сохраняет `purchase_id` в Hive (`last_purchase_id`).

2) DEV/mock:
   - Если `payment_url` указывает на mock‑хост, клиент сразу вызывает `verifyPurchase(purchase_id)` (auto‑verify).

3) PROD (будущее подключение провайдера):
   - Клиент открывает `payment_url` во внешнем браузере.
   - После возврата пользователь жмёт «Проверить» — кнопка читает `last_purchase_id` и вызывает `verifyPurchase(purchase_id)`.

4) Verify:
   - Клиент отправляет `purchase_id` на `gp-purchase-verify` с теми же заголовками (`ANON + x-user-jwt`).
   - В ответ приходит `{ balance_after }`.
   - Клиент инвалидацирует `gpBalanceProvider` (баланс обновляется в шапке/башне/профиле).

## Обработка ошибок
- `401 unauthorized`: отсутствует/некорректен `x-user-jwt` или просроченная сессия — перелогин/обновить страницу.
- `gp_invalid_package (400)`: неверный `package_id`.
- `gp_purchase_not_found`/`internal (500)`: неверный/неожиданный `purchase_id`.
- Повторный `verify` с тем же `purchase_id` — безопасен (идемпотентность), баланс не изменится.

## Итог
- Кнопка «Купить» в DEV возвращает валидный `purchase_id` и mock `payment_url`. Клиент либо auto‑verify (mock), либо открывает платёж и затем вручную «Проверить». Покупка увеличивает баланс один раз благодаря идемпотентности `purchase:<purchase_id>`; все запросы подписываются `ANON` + `x-user-jwt`.

