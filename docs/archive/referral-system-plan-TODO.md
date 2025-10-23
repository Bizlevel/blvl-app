# План разработки реферальной системы BizLevel

## 1. АРХИТЕКТУРА БАЗЫ ДАННЫХ

### 1.1 Создание таблиц в Supabase

#### Таблица `referral_codes`
**Расположение**: `supabase/migrations/[timestamp]_create_referral_system.sql`

**Структура**:
- `id` UUID PRIMARY KEY DEFAULT gen_random_uuid()
- `user_id` UUID REFERENCES auth.users(id) ON DELETE CASCADE
- `code` TEXT UNIQUE NOT NULL
- `short_link` TEXT
- `is_active` BOOLEAN DEFAULT true
- `regeneration_count` INTEGER DEFAULT 0
- `created_at` TIMESTAMPTZ DEFAULT now()
- `regenerated_at` TIMESTAMPTZ
- `stats_cache` JSONB DEFAULT '{}'::jsonb

**Индексы**:
- UNIQUE INDEX на `code`
- INDEX на `user_id`
- INDEX на `is_active, created_at DESC`

#### Таблица `referral_invitations`
**Структура**:
- `id` UUID PRIMARY KEY DEFAULT gen_random_uuid()
- `referrer_id` UUID REFERENCES auth.users(id)
- `referee_id` UUID REFERENCES auth.users(id)
- `referral_code` TEXT REFERENCES referral_codes(code)
- `source` TEXT CHECK (source IN ('whatsapp', 'telegram', 'instagram', 'email', 'link', 'other'))
- `status` TEXT CHECK (status IN ('pending', 'registered', 'profile_completed', 'first_level_completed'))
- `device_fingerprint` TEXT
- `ip_address` INET
- `user_agent` TEXT
- `registered_at` TIMESTAMPTZ
- `profile_completed_at` TIMESTAMPTZ
- `first_level_completed_at` TIMESTAMPTZ
- `metadata` JSONB DEFAULT '{}'::jsonb
- `created_at` TIMESTAMPTZ DEFAULT now()

**Индексы**:
- INDEX на `referrer_id, status`
- INDEX на `referee_id`
- INDEX на `referral_code`
- INDEX на `created_at DESC`

#### Таблица `referral_rewards`
**Структура**:
- `id` UUID PRIMARY KEY DEFAULT gen_random_uuid()
- `invitation_id` UUID REFERENCES referral_invitations(id)
- `recipient_id` UUID REFERENCES auth.users(id)
- `milestone` TEXT CHECK (milestone IN ('registration', 'profile_completed', 'first_level', 'special'))
- `gp_amount` INTEGER NOT NULL CHECK (gp_amount > 0)
- `idempotency_key` TEXT UNIQUE NOT NULL
- `metadata` JSONB DEFAULT '{}'::jsonb
- `created_at` TIMESTAMPTZ DEFAULT now()

**Индексы**:
- UNIQUE INDEX на `idempotency_key`
- INDEX на `recipient_id, created_at DESC`
- INDEX на `invitation_id`

#### Таблица `referral_analytics`
**Структура**:
- `id` UUID PRIMARY KEY DEFAULT gen_random_uuid()
- `date` DATE NOT NULL
- `referrer_id` UUID REFERENCES auth.users(id)
- `clicks` INTEGER DEFAULT 0
- `registrations` INTEGER DEFAULT 0
- `activations` INTEGER DEFAULT 0
- `gp_earned` INTEGER DEFAULT 0
- `metadata` JSONB DEFAULT '{}'::jsonb
- `created_at` TIMESTAMPTZ DEFAULT now()
- `updated_at` TIMESTAMPTZ DEFAULT now()

**Индексы**:
- UNIQUE INDEX на `date, referrer_id`
- INDEX на `referrer_id, date DESC`

### 1.2 RLS политики

#### Для `referral_codes`:
- **SELECT**: `auth.uid() = user_id OR EXISTS (SELECT 1 FROM referral_invitations WHERE referee_id = auth.uid())`
- **INSERT**: `auth.uid() = user_id`
- **UPDATE**: `auth.uid() = user_id AND auth.uid() = OLD.user_id`
- **DELETE**: Запрещено

#### Для `referral_invitations`:
- **SELECT**: `auth.uid() IN (referrer_id, referee_id)`
- **INSERT**: Только через RPC функции
- **UPDATE**: Только через RPC функции
- **DELETE**: Запрещено

#### Для `referral_rewards`:
- **SELECT**: `auth.uid() = recipient_id`
- **INSERT/UPDATE/DELETE**: Только через RPC функции

### 1.3 RPC функции в Supabase

#### Функция `get_or_create_referral_code()`
**Расположение**: `supabase/functions/_shared/referral_functions.sql`

**Логика**:
1. Проверка существующего активного кода пользователя
2. Генерация уникального кода формата "BL-XXXXX-YYY"
3. Создание короткой ссылки через URL shortener
4. Сохранение в таблицу с retry при коллизии
5. Возврат объекта с кодом и ссылкой

#### Функция `process_referral_registration(p_code TEXT, p_source TEXT, p_fingerprint TEXT)`
**Логика**:
1. Валидация входных параметров
2. Проверка активности кода
3. Проверка на самореферал
4. Проверка лимитов (device fingerprint, IP)
5. Создание записи в referral_invitations
6. Вызов функции начисления бонусов
7. Возврат статуса операции

#### Функция `claim_referral_milestone(p_user_id UUID, p_milestone TEXT)`
**Логика**:
1. Поиск invitation где referee_id = p_user_id
2. Проверка, не был ли уже выдан бонус за этот milestone
3. Обновление статуса invitation
4. Начисление GP через существующую систему gp_bonus_claim
5. Создание записи в referral_rewards
6. Обновление кеша статистики в referral_codes

#### Функция `get_referral_stats(p_user_id UUID)`
**Логика**:
1. Агрегация данных из referral_invitations
2. Подсчет по статусам
3. Суммирование заработанных GP
4. Формирование JSON ответа со статистикой

### 1.4 Триггеры

#### Триггер `on_user_registered`
**Файл**: `supabase/migrations/[timestamp]_referral_triggers.sql`
**Срабатывает**: После INSERT в auth.users
**Действия**:
- Проверка наличия pending invitation для этого email
- Обновление referee_id в invitation
- Вызов claim_referral_milestone('registration')

#### Триггер `on_profile_completed`
**Срабатывает**: После UPDATE users когда все обязательные поля заполнены
**Действия**:
- Проверка completeness профиля
- Вызов claim_referral_milestone('profile_completed')

#### Триггер `on_level_completed`
**Срабатывает**: После UPDATE user_progress когда level_id = 1 и is_completed = true
**Действия**:
- Вызов claim_referral_milestone('first_level')

### 1.5 Edge Functions

#### Функция `referral-link-generator`
**Расположение**: `supabase/functions/referral-link-generator/index.ts`
**Назначение**: Генерация коротких ссылок и QR-кодов
**Интеграция**: С сервисом сокращения ссылок (bit.ly/custom)

## 2. FLUTTER АРХИТЕКТУРА

### 2.1 Сервисный слой

#### ReferralService
**Расположение**: `lib/services/referral_service.dart`
**Зависимости**: 
- SupabaseClient из `lib/main.dart`
- GpService из `lib/services/gp_service.dart`

**Методы**:
- `getMyReferralCode()` - получение кода текущего пользователя
- `regenerateCode()` - генерация нового кода
- `validateReferralCode(String code)` - проверка валидности кода
- `applyReferralCode(String code)` - применение кода при регистрации
- `getReferralStats()` - получение статистики
- `getReferralHistory()` - история приглашенных

**Кеширование**:
- Использует Hive box 'referral_cache'
- TTL для кода: 24 часа
- TTL для статистики: 5 минут

#### ShareService
**Расположение**: `lib/services/share_service.dart`
**Зависимости**:
- share_plus: ^7.2.1
- url_launcher: ^6.2.1
- flutter_branch_sdk: ^7.0.1

**Методы**:
- `shareViaWhatsApp(String message, String link)`
- `shareViaTelegram(String message, String link)`
- `shareViaInstagram(String imageUrl, String link)`
- `shareViaEmail(String subject, String body, String link)`
- `shareGeneric(String text, String? link)`
- `copyToClipboard(String text)`

**Шаблоны сообщений**:
- Хранятся в `lib/constants/share_templates.dart`
- Поддержка локализации (ru/kz)
- Персонализация через placeholders

### 2.2 State Management (Riverpod)

#### Провайдеры
**Расположение**: `lib/providers/referral_providers.dart`

**referralCodeProvider**:
- Тип: FutureProvider<ReferralCode>
- Зависит от: authStateProvider
- Обновление: при изменении auth state
- Кеширование через referralService

**referralStatsProvider**:
- Тип: FutureProvider<ReferralStats>
- Auto-refresh каждые 30 секунд на активном экране
- Зависит от: referralCodeProvider

**pendingReferralProvider**:
- Тип: StateProvider<String?>
- Хранит код из deep link
- Очищается после применения

**referralHistoryProvider**:
- Тип: FutureProvider<List<ReferralInvitation>>
- Пагинация по 20 записей
- Сортировка по дате

### 2.3 Модели данных

**Расположение**: `lib/models/referral_models.dart`

**ReferralCode**:
- Freezed модель
- Поля: id, code, shortLink, isActive, createdAt

**ReferralStats**:
- totalInvited, registered, profileCompleted, firstLevelCompleted
- totalGpEarned, lastWeekInvited, conversionRate

**ReferralInvitation**:
- refereeInfo (name, avatar), status, registeredAt, gpEarned

### 2.4 UI компоненты

#### ReferralScreen
**Расположение**: `lib/screens/referral_screen.dart`
**Компоненты**:
- AppBar с GpBalanceWidget
- ReferralCodeCard - отображение кода
- ShareButtonsGrid - сетка кнопок шаринга
- ReferralStatsWidget - статистика
- ReferralHistoryList - список приглашенных

**Навигация**:
- Доступ через MainStreet или профиль
- Route: `/referral`

#### ReferralCodeCard
**Расположение**: `lib/widgets/referral/referral_code_card.dart`
**Функционал**:
- Отображение кода крупным шрифтом
- Кнопка копирования с анимацией
- Кнопка регенерации (с подтверждением)
- QR-код (опционально)

#### ShareBottomSheet
**Расположение**: `lib/widgets/referral/share_bottom_sheet.dart`
**Платформы**:
- WhatsApp (зеленая иконка)
- Telegram (синяя иконка)
- Instagram Stories (градиент)
- Email (иконка конверта)
- Другие (системный share)
- Копировать ссылку

#### ReferralOnboardingStep
**Расположение**: `lib/widgets/onboarding/referral_step.dart`
**Интеграция**: В существующий OnboardingFlow
**Функционал**:
- TextField для ввода кода
- Автозаполнение из pendingReferralProvider
- Валидация в реальном времени
- Показ бонуса (+50 GP)
- Кнопка "Пропустить"

### 2.5 Навигация и Deep Linking

#### Настройка GoRouter
**Файл**: `lib/router/app_router.dart`
**Добавить маршруты**:
- `/referral` - основной экран
- `/invite/:code` - deep link handler

#### Deep Link Handler
**Файл**: `lib/utils/deep_link_handler.dart`
**Логика**:
1. Парсинг URL и извлечение кода
2. Сохранение в pendingReferralProvider
3. Редирект на регистрацию если не авторизован
4. Показ уведомления если уже зарегистрирован

## 3. ИНТЕГРАЦИЯ С СУЩЕСТВУЮЩИМИ СИСТЕМАМИ

### 3.1 GP система

#### Изменения в gp_bonus_rules
**Файл миграции**: `supabase/migrations/[timestamp]_referral_bonuses.sql`
**Новые правила**:
- `referral_welcome` - 50 GP новому пользователю
- `referral_inviter_registration` - 100 GP приглашающему
- `referral_inviter_profile` - 50 GP за профиль друга
- `referral_inviter_level` - 100 GP за уровень друга

#### Модификация GpService
**Файл**: `lib/services/gp_service.dart`
**Добавить метод**: `claimReferralBonus(String milestone, String invitationId)`
**Идемпотентность**: Ключ `ref:{userId}:{invitationId}:{milestone}`

### 3.2 Аутентификация

#### Модификация AuthService
**Файл**: `lib/services/auth_service.dart`
**Изменения в методе `signUp()`:
1. Проверка pendingReferralProvider
2. Передача referral_code в metadata
3. Вызов process_referral_registration после успешной регистрации

#### Изменения в профиле
**Файл**: `lib/screens/profile_screen.dart`
**Добавить**: Кнопка/карточка "Пригласить друзей"
**Навигация**: На `/referral`

### 3.3 Уведомления

#### Новые типы уведомлений
**Файл**: `lib/models/notification_model.dart`
**Типы**:
- `referral_friend_joined`
- `referral_bonus_received`
- `referral_milestone_achieved`

#### Push notification handler
**Файл**: `lib/services/notification_service.dart`
**Обработка**:
- Показ in-app баннера
- Обновление gpBalanceProvider
- Навигация на экран рефералов

## 4. НАСТРОЙКА ВНЕШНИХ СЕРВИСОВ

### 4.1 WhatsApp Business API

#### Настройка Meta Business
1. Создать Meta Business аккаунт
2. Зарегистрировать WhatsApp Business аккаунт
3. Получить Phone Number ID и Access Token
4. Настроить webhook для статусов сообщений

#### Интеграция в приложении
**Метод шаринга**:
- Использовать URL схему: `whatsapp://send?text={encoded_message}`
- Для WhatsApp Business: `https://wa.me/?text={encoded_message}`
- Fallback на браузер если приложение не установлено

#### Шаблоны сообщений
**Требования WhatsApp**:
- Максимум 1024 символа
- URL должен быть в конце сообщения
- Эмодзи поддерживаются

### 4.2 Telegram

#### Bot API Setup
1. Создать бота через @BotFather
2. Получить Bot Token
3. Настроить команды бота (/start с параметром кода)
4. Webhook для отслеживания переходов

#### Интеграция
**URL схема**: `tg://msg_url?url={encoded_url}&text={encoded_text}`
**Web fallback**: `https://t.me/share/url?url={url}&text={text}`

#### Telegram Web App
**Опционально**: Создать Web App для регистрации прямо в Telegram

### 4.3 Instagram

#### Instagram Sharing
**Требования**:
- Только изображения/stories, текст нельзя предзаполнить
- Нужно создать изображение с кодом/QR

#### Настройка iOS (Info.plist)
```
LSApplicationQueriesSchemes:
- instagram
- instagram-stories
```

#### Настройка Android (AndroidManifest.xml)
```
<queries>
  <package android:name="com.instagram.android" />
</queries>
```

#### Генерация изображения
**Библиотека**: screenshot или widgets_to_image
**Шаблон**: Создать виджет с брендингом и QR-кодом

### 4.4 Email

#### Настройка почтового сервиса
**Supabase Auth SMTP**:
- Использовать существующие настройки
- Добавить шаблон для реферального приглашения

#### Email шаблон
**Расположение**: `supabase/email_templates/referral_invite.html`
**Переменные**:
- {referrer_name}
- {referral_code}
- {referral_link}
- {bonus_amount}

### 4.5 iOS настройки

#### Info.plist
**Файл**: `ios/Runner/Info.plist`
**Добавить**:
```
CFBundleURLTypes - для deep links
LSApplicationQueriesSchemes - для проверки установленных приложений
NSPhotoLibraryUsageDescription - для сохранения QR-кодов
```

#### Associated Domains
**Настройка**: Universal Links для bizlevel.kz
**Файл**: `apple-app-site-association`
**Разместить**: На сервере в `.well-known/`

### 4.6 Android настройки

#### AndroidManifest.xml
**Файл**: `android/app/src/main/AndroidManifest.xml`
**Intent filters**:
- Для deep links с схемой bizlevel://
- Для App Links с доменом bizlevel.kz

#### Digital Asset Links
**Файл**: `assetlinks.json`
**Разместить**: `https://bizlevel.kz/.well-known/assetlinks.json`
**Содержимое**: SHA256 отпечатки приложения

### 4.7 Web настройки

#### Open Graph теги
**Для лендинга**: `web/index.html`
**Метатеги**:
- og:title - "Присоединяйтесь к BizLevel"
- og:description - с упоминанием бонуса
- og:image - брендированное изображение
- og:url - с параметром кода

#### PWA манифест
**Файл**: `web/manifest.json`
**Добавить**: share_target для Web Share API

## 5. АНАЛИТИКА И МОНИТОРИНГ

### 5.1 События для трекинга

#### Mixpanel/Amplitude события
**Файл**: `lib/services/analytics_service.dart`

**События**:
- `referral_code_viewed`
- `referral_code_copied`
- `referral_shared` (с параметром platform)
- `referral_code_applied`
- `referral_bonus_earned`
- `referral_friend_registered`

### 5.2 Sentry breadcrumbs

**Добавить в существующие breadcrumbs**:
- `referral_flow_started`
- `referral_code_generated`
- `referral_share_failed`
- `referral_validation_error`

### 5.3 Суперадмин дашборд

#### Новая вкладка в админке
**Метрики**:
- Общее количество рефералов
- Conversion rate по источникам
- Средний LTV реферальных пользователей
- ROI программы (потраченные GP vs revenue)
- Топ рефереров
- Подозрительная активность

## 6. БЕЗОПАСНОСТЬ

### 6.1 Rate Limiting

#### На уровне Supabase
**RPC функции**: Использовать плагин pg_ratelimit
**Лимиты**:
- get_or_create_referral_code: 1/минута
- regenerate_code: 3/день
- get_referral_stats: 6/минута

#### На уровне приложения
**Использовать**: flutter_rate_limiter
**Для действий**: share, copy, regenerate

### 6.2 Fraud Prevention

#### Device Fingerprinting
**Библиотека**: device_info_plus
**Собирать**: model, OS version, screen size
**Хешировать**: SHA256 перед отправкой

#### IP проверки
**Edge Function**: referral-fraud-check
**Проверки**:
- Максимум 5 регистраций с IP в день
- Блокировка VPN/Proxy (опционально)
- Geolocation проверка

### 6.3 Валидация

#### На backend
- Проверка формата кода (regex)
- Проверка активности кода
- Проверка на самореферал
- Проверка лимитов

#### На frontend
- Предварительная валидация формата
- Debounce при вводе
- Показ понятных ошибок

## 7. ТЕСТИРОВАНИЕ

### 7.1 Unit тесты

**Файлы для тестирования**:
- `test/services/referral_service_test.dart`
- `test/providers/referral_providers_test.dart`
- `test/utils/share_utils_test.dart`

**Покрытие**:
- Генерация и валидация кодов
- Применение кодов
- Расчет статистики
- Формирование share ссылок

### 7.2 Integration тесты

**Файл**: `integration_test/referral_flow_test.dart`
**Сценарии**:
- Полный флоу от генерации до применения
- Обработка ошибок
- Deep link обработка
- Начисление бонусов

### 7.3 E2E тесты

**Сценарии**:
- Регистрация с реферальным кодом
- Шаринг через разные платформы
- Получение бонусов
- Просмотр статистики

## 8. МИГРАЦИЯ И РАЗВЕРТЫВАНИЕ

### 8.1 Порядок развертывания

1. **База данных**:
   - Выполнить миграции таблиц
   - Создать RPC функции
   - Настроить RLS политики
   - Добавить триггеры

2. **Edge Functions**:
   - Деплой referral-link-generator
   - Деплой referral-fraud-check
   - Обновить leo-chat для контекста рефералов

3. **Приложение**:
   - Обновить зависимости в pubspec.yaml
   - Добавить новые сервисы и провайдеры
   - Интегрировать UI компоненты
   - Настроить deep links

4. **Внешние сервисы**:
   - Настроить WhatsApp Business
   - Создать Telegram бота
   - Настроить Universal/App Links
   - Подготовить email шаблоны

### 8.2 Feature Flags

**Использовать**: Существующую систему feature flags
**Флаги**:
- `referral_system_enabled` - общий переключатель
- `referral_instagram_enabled` - Instagram шаринг
- `referral_fraud_check_enabled` - проверки мошенничества
- `referral_bonus_amounts` - размеры бонусов (A/B тест)

### 8.3 Rollback план

**В случае проблем**:
1. Отключить feature flag
2. Скрыть UI компоненты
3. Остановить начисление бонусов
4. Сохранить накопленные данные для анализа

## 9. ДОКУМЕНТАЦИЯ

### 9.1 Для разработчиков

**Создать файлы**:
- `docs/referral_system_architecture.md`
- `docs/referral_api_reference.md`
- `docs/referral_troubleshooting.md`

### 9.2 Для пользователей

**In-app подсказки**:
- Onboarding для реферальной системы
- Tooltips на экране рефералов
- FAQ секция

### 9.3 Для поддержки

**Инструкции**:
- Как проверить реферальный код
- Как решить проблемы с бонусами
- Как обрабатывать жалобы на мошенничество