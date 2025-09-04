# BizLevel – образовательная платформа с уровнями

BizLevel — это мобильное и веб-приложение (Flutter + Supabase), где пользователи последовательно проходят уровни по бизнес-темам, смотрят короткие видео-уроки, решают квизы и общаются с AI-ментором Leo.

## Ключевые возможности

| Модуль | Описание |
|--------|----------|
| Карта уровней | 10+ уровней, открываются по порядку. Бесплатны первые 3, остальные доступны по подписке. |
| Видео-уроки | Вертикальный формат 9:16, офлайн-кэширование, безопасные signed URL из Supabase Storage. |
| Квизы | Проверка понимания материала, логика разблокировки следующего урока. |
| AI-ментор Leo | Edge Function + OpenAI, персональный контекст, лимиты сообщений по тарифу. |
| Профиль | Статистика прогресса, выбор аватара, скачивание артефактов уровня. |
| Growth Points (GP) | Внутренняя валюта: баланс/списание/этаж через RPC (`gp_*`), магазин и покупки через Edge `/gp-purchase-*`. |
| PWA/Web | Адаптивный layout (Responsive Framework), чистые URL, Lighthouse 90+. |
| Sentry & CI | Полный трейс в dev, 30 % в prod; GitHub Actions запускает тесты и nightly storage-integrity-check. |

## Технологии

* **Flutter 3.22** (Web, iOS, Android)
* **Supabase** (Postgres + Storage + Edge Functions)
* Riverpod 2, GoRouter, Hive, Sentry, mocktail
* CI — GitHub Actions с кешем Gradle/CocoaPods

## Быстрый старт

```bash
# 1. Клонируем репозиторий
git clone https://github.com/Yerlanalim/blvl-flutter-1007-2.git
cd blvl-flutter-1007-2

# 2. Устанавливаем зависимости
flutter pub get

# 3. Запускаем (выберите нужную платформу)
flutter run -d chrome     # Web
flutter run -d ios        # iOS
flutter run -d android    # Android
```

> Перед запуском убедитесь, что переменные окружения `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SENTRY_DSN` заданы через `.env` или `--dart-define`.

## Структура репозитория (выдержка)

```
lib/
  models/         – Freezed-модели
  services/       – Supabase, Auth, Payment, Leo
  providers/      – Riverpod-состояние
  repositories/   – Кэш + RLS-запросы
  screens/        – UI-экраны
  widgets/        – Переиспользуемые компоненты
supabase/
  functions/      – Edge Functions (leo-chat, create-checkout-session, storage-integrity-check)
## GP: текущее состояние

- Core‑операции (баланс, списание, открытие этажа, бонусы) переведены на Postgres RPC: `gp_balance`, `gp_spend`, `gp_floor_unlock`, `gp_bonus_claim`.
- Edge‑маршруты `/gp-balance`, `/gp-spend`, `/gp-floor-unlock`, `/gp-bonus-claim` помечены как deprecated и используются только как dev‑fallback.
- Покупки GP остаются на Edge: `/gp-purchase-init`, `/gp-purchase-verify`.
 
### GP: ошибки и идемпотентность

- Ошибки ядра:
  - `gp_insufficient_balance`: недостаточно GP для операции (клиент показывает дружелюбное сообщение).
  - `gp_invalid_package`: неверный пакет при инициации покупки.
  - `gp_purchase_not_found`: покупка не найдена при верификации.
- Идемпотентность:
  - Списание за сообщение: `Idempotency-Key = msg:<user_id>:<chat_id|new>:<hash(content)>`.
  - Бонус: `bonus:<rule_key>:<user_id>` (на стороне RPC один раз на правило).
  - Покупка: `purchase:<purchase_id>` (verify повторяем безопасно).
  - Открытие этажа: клиентский `Idempotency-Key` пробрасывается в RPC `gp_floor_unlock`.

### Бонусы: точки вызова
- `signup_bonus` — при первом успешном входе.
- `profile_completed` — после заполнения профиля (name/goal/about/avatar_id).
- Другие бонусы подключаются клиентом через `GpService.claimBonus(ruleKey)`.
  migrations/     – SQL-миграции схемы и безопасные функции
```

## Лицензия

MIT © BizLevel Team
