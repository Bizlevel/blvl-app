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

# Этап 40
> Инварианты этапа (не менять):
> - Порядок в чате: списание 1 GP выполняется ПЕРЕД запросом в Edge `/leo-chat` с детерминированным `Idempotency-Key`.
> - Сохраняем текущие контракты `LeoService` и `GpService` (списание/баланс) и dev‑fallback в `GpService` (только debug).
> - Не использовать `refreshSession()` внутри GP‑операций; ретраи ограничены и не приводят к двойным списаниям.
### Задача 40.1: Унификация RPC GP и контроль идемпотентности
- Файлы: `supabase/migrations/` (DDL при необходимости), аудит существующих функций `gp_*`.
- Что сделать:
  1) Подтвердить, что у RPC `gp_balance/gp_spend/gp_floor_unlock/gp_bonus_claim/gp_purchase_verify` выставлены `SECURITY DEFINER` и `SET search_path = public`, вызываются от роли `authenticated` (нет EXECUTE у `anon`).
  2) Проверить наличие индексов: `CREATE UNIQUE INDEX IF NOT EXISTS idx_gp_ledger_idem ON public.gp_ledger(idempotency_key)`, а также `CREATE INDEX IF NOT EXISTS idx_gp_ledger_user_created ON public.gp_ledger(user_id, created_at DESC)`.
  3) Зафиксировать единый контракт `gp_spend/gp_bonus_claim` на auth.uid() (варианты с `p_user_id` оставить временно для совместимости, пометить deprecated; удалить на этапе 40.10).
  4) Подтвердить owner‑only RLS на `gp_wallets/gp_ledger/gp_purchases/gp_bonus_grants/floor_access` (SELECT/INSERT/UPDATE строго по `auth.uid()`).
- Риски: нарушение прав EXECUTE у `authenticated`, отсутствие индекса идемпотентности → дубли в `gp_ledger`.
- Критерии приёмки: все RPC вызываются от `authenticated`, дубли по `idempotency_key` возвращают прежний `balance_after`, advisors (security/perf) без критичных WARN.

### Задача 40.2: Покупки GP — интеграция провайдера и авто‑верификация
- Файлы: `supabase/functions/create-checkout-session`, `lib/services/payment_service.dart` (если есть), `lib/screens/gp_store_screen.dart` (только UX, без ломки API).
- Что сделать:
  1) Edge: заменить mock‑URL на реальный провайдер (Kaspi/FreedomPay или текущий PaymentService), записывать `provider`, `provider_transaction_id` в `gp_purchases`.
  2) БД: добавить `UNIQUE(provider, provider_transaction_id)` в `gp_purchases` (миграция) во избежание дублей.
  3) Авто‑верификация: 
     - Web: после редиректа возвращаться с `purchase_id` в query и автоматически вызывать `/gp-purchase-verify`.
     - Mobile: поддержать deep‑link на экран магазина с `purchase_id` и автозапуск verify.
     - Fallback: опциональный короткий поллинг (<= 20 с) по `purchase_id`.
  4) Идемпотентность: подтверждён ключ `idempotency_key = 'purchase:'||purchase_id` в RPC, повторные вызовы безопасны.
  5) Тестовый режим (без провайдера):
     - Использовать текущий mock `payment_url` из `/gp-purchase-init` для ручного теста флоу (без реального банка).
     - E2E в DEV: сохранять возвращённый `purchase_id` на клиенте и выполнять авто‑верификацию после возврата в приложение (или по кнопке «Проверить»), вызывая `/gp-purchase-verify`.
     - Smoke‑тест: инициировать init → получить `purchase_id` → сразу вызвать verify (без открытия URL), убедиться, что баланс вырос ровно один раз (идемпотентность).
     - Никаких изменений ядра RPC/клиента не требуется — тестовый сценарий использует существующие Edge и RPC.
- Риски: двойное начисление при расхождении провайдера/клиента (снимается `UNIQUE` + идемпотентность), ошибки редиректа.
- Критерии приёмки: покупка проходит без ручного ввода `purchase_id`, повтор verify не меняет баланс, в журнале один `gp_ledger` на покупку.

### Задача 40.3: Бонусы — подключение точек выдачи и инвалидация кеша
- Файлы: клиентские места вызова (не меняем контракты сервисов): `main.dart` (первый вход), профайл/мини‑кейсы, `GpService` (уже есть), `gpBalanceProvider`.
- Что сделать:
  1) Точки вызова `claimBonus(ruleKey)`:
     - `signup_bonus` — при первом успешном входе; 
     - `profile_completed` — после сохранения профиля с заполненными `name/goal/about/avatar_id`;
     - `all_three_cases_completed` — после статуса `completed` по мини‑кейсам 1–3 (или `completed/skipped` по принятым правилам).
  2) После успешного `claimBonus` — фоновой рефетч `gpBalanceProvider` (кеш обновить через `GpService.saveBalanceCache`).
- Риски: повторные вызовы (снимается идемпотентностью и `gp_bonus_grants` PK).
- Критерии приёмки: повторные клики не меняют баланс; баланс обновляется в `UserInfoBar`/Башне без перезапуска.

### Задача 40.4: Магазин GP — безопасный UX без ручного `purchase_id`
- Файлы: `lib/screens/gp_store_screen.dart` (только UI‑изменения), роутинг (GoRouter) для callback.
- Что сделать:
  1) Убрать диалог ручного ввода `purchase_id`; заменить на состояние «Ожидание оплаты…» + авто‑проверка (см. 40.2.3).
  2) Добавить дружелюбные состояния: 
     - ошибка сети → «Повторить»;
     - `gp_invalid_package`/`gp_purchase_not_found` → подсказка перезапуска флоу.
  3) Добавить breadcrumbs: `gp_store_opened`, `gp_purchase_init`, `gp_purchase_verify`, `gp_purchase_failed`.
- Риски: преждевременный verify до редиректа; решается тайм‑аутом ожидания и кнопкой «Проверить позже».
- Критерии приёмки: UX магазина не требует ручного ввода; при успехе баланс обновлён, при ошибке понятные сообщения.

### Задача 40.5: Наблюдаемость и безопасность логов
- Файлы: `GpService`, `LeoService`, Edge `/gp-*`.
- Что сделать:
  1) Добавить/проверить breadcrumbs без PII: `gp_balance_loaded`, `gp_spent`, `gp_floor_unlocked`, `gp_bonus_granted`, ошибки `gp_insufficient_balance`, `gp_purchase_*`.
  2) Маскирование токенов/JWT/PII в логах Edge и клиента.
- Риски: утечка PII при расширенном логировании — запретить вывод секретов.
- Критерии приёмки: события видны в Sentry; нет PII/JWT в логах.

### Задача 40.6: Тестирование (unit/widget/smoke)
- Файлы: `test/services/gp_service_test.dart`, `test/screens/tower_unlock_test.dart`, `test/screens/leo_dialog_screen_test.dart` (или актуальные).
- Что сделать:
  1) Unit: мок `SupabaseClient.rpc` → `gp_balance/gp_spend/gp_bonus_claim/gp_floor_unlock`, позитивные/ошибочные кейсы (в т.ч. `gp_insufficient_balance`).
  2) Widget: 
     - чат — успешное списание и обработка `Недостаточно GP` без падений;
     - башня — unlock этажа (idempotencyKey) → инвалидация баланса и узлов.
  3) Smoke: покупка на Web — init → callback → verify, баланс увеличен один раз.
- Риски: флаки на сетевых ретраях — стабилизировать таймауты/моки.
- Критерии приёмки: тесты зелёные локально и в CI; регрессов чата/башни нет.

### Задача 40.7: Advisors/Security pass
- Файлы: миграции/функции.
- Что сделать: прогнать advisors (security/performance), устранить замечания (индексы/гранты/`search_path`), не меняя контракты.
- Критерии приёмки: нет критичных предупреждений.

### Задача 40.8: Rollback и фича‑флаги
- Файлы: конфиг (ENV/константы), `GpService` (без изменения API).
- Что сделать: предусмотреть переключатель (ENV/константа) для временного отключения списаний в чате при инцидентах (сообщение «Временно бесплатно»), dev‑fallback на Edge оставляем только в debug.
- Риски: рассинхронизация баланса при форс‑отключении — ограничить только клиент, без изменения серверной логики.
- Критерии приёмки: при включении флага чат работает без ошибок; при выключении — штатное списание.

### Задача 40.9: Документация
- Файлы: `README.md` (раздел GP), этот план.
- Что сделать: описать коды ошибок (`gp_insufficient_balance/gp_invalid_package/gp_purchase_not_found`), формат `Idempotency-Key`, источники истинности (RPC), флоу покупки и бонусов, места вызовов `claimBonus`.
- Критерии приёмки: документация актуальна и согласована с реализацией.

### Задача 40.10: Zero‑downtime чистка устаревших перегрузок RPC
- Файлы: миграции `supabase/migrations/`.
- Что сделать: по завершении 40.1–40.6 удалить перегрузки `gp_spend(p_user_id, ...)` и `gp_bonus_claim(p_user_id, ...)`, оставив только `auth.uid()`‑версии; подтвердить отсутствие вызовов этих перегрузок в Edge/клиенте.
- Риски: остаточные обращения из старого кода — перед удалением выполнить поиск и smoke‑проверку.
- Критерии приёмки: все вызовы идут через `auth.uid()`‑версии; Edge/клиент работают стабильно.

— Примечание по устойчивости чата (этап 39):
  - Списания выполняются до запроса в чат с детерминированным `Idempotency-Key` (зависит от пользователя/чата/контента), поведение сохраняем.
  - Не использовать `refreshSession()` внутри GP‑операций; сетевые ретраи ограничены и не приводят к двойным списаниям.
  - При ошибках `gp_insufficient_balance` — дружелюбный UX и переход в магазин, без падений чата.
