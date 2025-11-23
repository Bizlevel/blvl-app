# Draft 5 — StoreKit 2 проверка (23.11.2025)

Используйте этот файл для логов следующего прогона Release в Xcode (Stage 3).

## Что сохранить

1. Консоль Xcode (build): убедиться, что нет `SKPaymentQueue` до UI, а `StoreKit2Bridge` выводит `fetchProducts [requestId] completed`.
2. Консоль устройства (Console.app): кусок от запуска приложения до первых покупок.
3. Логи попыток покупки/restore (если StoreKit ответил пустым списком — зафиксируйте `requestId` и `invalidProductIds` из консоли).

> После заполнения перенесите краткий итог в `docs/status.md` и отметьте, какие productId уже доступны в App Store Connect.

