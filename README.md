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
  migrations/     – SQL-миграции схемы и безопасные функции
```

## Лицензия

MIT © BizLevel Team
