# Техническая спецификация: Внедрение Growth Points (GP) в БизЛевел

## 1. ОБЗОР СИСТЕМЫ

### Цель документа
Предоставить Cursor AI полную спецификацию для анализа существующего кода Flutter-приложения БизЛевел и реализации системы внутренней валюты Growth Points (GP).

### Ключевые принципы MVP
- **Минимальная сложность**: 3 пакета, 2 основных способа траты
- **Безопасность**: идемпотентность транзакций, защита от двойных списаний
- **Кроссплатформенность**: единая логика для iOS/Android/Web
 - **Без подписок**: доступ к контенту и сообщениям регулируется только через GP

## 2. ЭКОНОМИКА GP

### 2.1 Базовые правила
```yaml
Курс:
  - 1 GP = 15 ₸ (базовый курс)
  - Отображение: всегда "XXX GP"

Расход:
  - 1 сообщение Лео/Максу = 1 GP
  - Открытие этажа (10 уровней, 4 кейса, 28 дней на выполнение первой цели) = 1000 GP
  - Чат-тесты в уроках = 0 GP (бесплатно)
  - Кейсы внутри уроков = 0 GP (бесплатно)

Начальный баланс:
  - Новый пользователь = 30 GP (бонус регистрации)

Прочее:
  - Лимиты сообщений по времени отсутствуют; контроль — только через баланс GP
```

### 2.2 Пакеты для покупки (MVP - только 3)
```yaml
starter_pack:
  id: "gp_300"
  title: "Стартовый"
  gp_amount: 300
  price_kzt: 3000
  price_usd: ?  # для App Store/Google Play
  description: "Хватит на 300 сообщений тренеру"
  
optimal_pack:
  id: "gp_1200"
  title: "Оптимальный"
  gp_amount: 1200
  bonus_gp: 200  # +17% бонус
  total_gp: 1400
  price_kzt: 9960
  price_usd: ?
  description: "Откройте этаж, достигните первой цели + 400 GP на тренеров"
  badge: "ПОПУЛЯРНЫЙ"
  
pro_pack:
  id: "gp_2500"
  title: "Профессиональный"
  gp_amount: 2500
  bonus_gp: 500  # +20% бонус
  total_gp: 3000
  price_kzt: 25000
  price_usd: ?
  description: "Для активного обучения"
```

## 3. РАЗМЕЩЕНИЕ В UI

### 3.1 Отображение баланса
```yaml
Где_показывать_баланс:

  AppBar_Главная_улица:
    позиция: справа от аватара пользователя
    формат: "⬡ 1,240 GP"
    действие_по_тапу: открыть магазин GP

  AppBar_Башня:
    позиция: справа от аватара пользователя
    формат: "⬡ 1,240 GP"
    действие_по_тапу: открыть магазин GP

  Экран_Профиль:
    позиция: вместо блока "Х сообщений Лео"
    формат: "⬡ 1,240 GP (−1 за сообщение)"

  Модал_открытия_этажа (первые 3 уровня бесплатны):
    формат: "Стоимость: 1000 GP (у вас 1,240 GP)"
    цвет: зеленый если хватает, красный если нет
```

### 3.2 Магазин GP
```yaml
Расположение_магазина:
  
  Основной_вход:
    - Через тап на баланс в AppBar
    - Кнопка "Пополнить" на странице Профиль
    - При недостатке GP (модал предложения)
    
  Структура_экрана:
    заголовок: "Пополнить Growth Points"
    подзаголовок: "Используйте GP для общения с тренерами и открытия новых уровней"
    
    секция_пакетов:
      layout: вертикальный список карточек
      порядок: от меньшего к большему
      выделение: средний пакет с badge "ПОПУЛЯРНЫЙ"
      
    информация_о_покупке:
      - "Безопасная оплата"
      - "Моментальное зачисление"
```

### 3.3 Точки входа в покупку
```yaml
Триггеры_покупки:
  
  при_недостатке_баланса:
    условие: попытка отправить сообщение при балансе < 1 GP
    ui: модал с предложением пополнить
    cta: "Пополнить и продолжить"
    
  при_блокировке_этажа:
    условие: попытка открыть платный уровень
    ui: полноэкранный модал с benefits
    cta: "Открыть за 1000 GP"
    fallback: если < 1000 GP → магазин с пресетом 1200 GP
    
  в_конце_бесплатного_контента:
    условие: завершен 3-й уровень (последний бесплатный)
    ui: celebration screen + предложение продолжить
    cta: "Продолжить обучение"
```

## 4. ПЛАТЕЖНАЯ ИНТЕГРАЦИЯ

### 4.1 Способы оплаты
```yaml
Mobile_iOS:
  provider: Apple In-App Purchase
  products: создать в App Store Connect
  важно: цены в USD, Apple конвертирует сам
  комиссия: 30% (15% после первого года)
  
Mobile_Android:
  provider: Google Play Billing
  products: создать в Google Play Console
  важно: цены в USD, Google конвертирует
  комиссия: 30% (15% после первого года)
  
Web_версия:
  primary: Halyk Epay
  secondary: Kaspi QR
  важно: прямые цены в KZT
  комиссия: ~2-3%
  redirect_flow: true
```

### 4.2 Процесс покупки
```yaml
Шаг_1_Выбор_пакета:
  - Пользователь выбирает пакет
  - Показываем loading state
  - Запрос к Supabase Edge Function: init_purchase
  
Шаг_2_Оплата:
  mobile:
    - Вызов нативного SDK (StoreKit/Play Billing)
    - Показ системного диалога оплаты
    - Ожидание callback
    
  web:
    - Редирект на страницу банка
    - Callback URL: /payment/callback
    - Проверка статуса через webhook
    
Шаг_3_Подтверждение:
  - Верификация покупки на сервере
  - Начисление GP в транзакции
  - Обновление UI
  - Показ success animation
```

## 5. БЕЗОПАСНОСТЬ И FALLBACKS

### 5.1 Защита от ошибок
```yaml
Идемпотентность:
  - Каждая покупка имеет уникальный idempotency_key
  - Повторные запросы с тем же ключом = тот же результат
  - Хранение ключей 30 дней
  
Двойные_списания:
  - Проверка баланса перед списанием
  - Транзакционное списание (SERIALIZABLE)
  - Лог всех операций в gp_ledger
  
Сетевые_ошибки:
  - Retry с exponential backoff (3 попытки)
  - Offline queue для сообщений
  - Optimistic UI с rollback при ошибке
```

### 5.2 Fallback сценарии
```yaml
Платеж_не_прошел:
  - Показать понятную ошибку
  - Предложить альтернативный способ оплаты
  - Сохранить выбранный пакет для retry
  
Баланс_не_обновился:
  - Pull-to-refresh на экране баланса
  - Кнопка "Проверить статус покупки"
  - Support chat для разрешения
  
Недоступен_платежный_провайдер:
  mobile: fallback на web-view с web-оплатой
  web: показать все доступные методы
  
Несоответствие_баланса:
  - Пересчет из gp_ledger как source of truth
  - Алерт в Sentry при расхождении
  - Автоматическая коррекция
```

## 6. БАЗА ДАННЫХ (Supabase)

### 6.1 Основные таблицы
```yaml
gp_wallets:
  описание: Текущий баланс пользователя (кэш)
  поля:
    - user_id (PK, FK → auth.users)
    - balance (integer, >= 0)
    - total_earned (integer)
    - total_spent (integer)
    - updated_at (timestamp)
  
gp_ledger:
  описание: Все транзакции (source of truth)
  поля:
    - id (UUID, PK)
    - user_id (FK)
    - amount (integer, может быть < 0)
    - type (enum: purchase, spend_message, spend_floor, bonus)
    - reference_id (UUID | TEXT, nullable)
    - metadata (JSONB)
    - idempotency_key (TEXT, unique)
    - created_at (timestamp)
    
gp_purchases:
  описание: История покупок
  поля:
    - id (UUID, PK)
    - user_id (FK)
    - package_id (string)
    - amount_kzt (integer)
    - amount_gp (integer)
    - provider (enum: apple, google, epay, kaspi)
    - provider_transaction_id (string)
    - status (enum: pending, completed, failed, refunded)
    - created_at (timestamp)

floor_access:
  описание: Доступ пользователя к этажам
  поля:
    - user_id (UUID, FK)
    - floor_number (smallint)
    - unlocked_at (timestamp)
  PK: (user_id, floor_number)

gp_bonus_rules:
  описание: Настраиваемые правила бонусов
  поля:
    - rule_key (TEXT, PK)
    - amount (integer)
    - active (boolean)
    - description (TEXT)

gp_bonus_grants:
  описание: Выданные бонусы (идемпотентность на пользователя/правило)
  поля:
    - user_id (UUID, FK)
    - rule_key (TEXT)
    - granted_at (timestamp)
  PK: (user_id, rule_key)
```

### 6.2 Edge Functions
```yaml
Функции_для_реализации:
  
  /gp/balance:
    метод: GET
    возвращает: {balance, total_earned, total_spent}
    кэширование: 5 секунд
    
  /gp/purchase/init:
    метод: POST
    параметры: {package_id, provider}
    возвращает: {purchase_id, payment_url?}
    действия: создает pending purchase
    
  /gp/purchase/verify:
    метод: POST
    параметры: {purchase_id, receipt}
    действия: верифицирует и начисляет GP
    транзакция: SERIALIZABLE
    
  /gp/spend:
    метод: POST
    параметры: {type, amount, reference_id, idempotency_key}
    проверки: достаточность баланса
    транзакция: SERIALIZABLE

  /gp/bonus/claim:
    метод: POST
    параметры: {rule_key}
    действия: проверяет условия, идемпотентно начисляет бонус, пишет в gp_bonus_grants
```

## 7. АНАЛИТИКА

### 7.1 События для отслеживания
```yaml
Воронка_покупки:
  - gp_store_opened: {source}
  - gp_package_selected: {package_id, price}
  - gp_purchase_initiated: {package_id, provider}
  - gp_purchase_completed: {package_id, amount_gp}
  - gp_purchase_failed: {package_id, error}
  
Использование:
  - gp_spent: {type, amount, balance_after}
  - gp_insufficient: {attempted_action}
  - floor_unlocked: {floor_id, method}
  - gp_bonus_granted: {rule_key, amount}
  
Ключевые_метрики:
  - Conversion to first purchase
  - Average purchase value
  - GP burn rate (spent/day)
  - Message volume после покупки
```

## 8. МИГРАЦИЯ И ЗАПУСК

### 8.1 Этапы внедрения
```yaml
Фаза_1_Подготовка:
  - Создание таблиц в Supabase
  - Настройка RLS политик
  - Edge Functions для базовых операций
  - Интеграция платежных SDK
  
Фаза_2_UI:
  - Добавление баланса в AppBar
  - Экран магазина
  - Модалы недостатка GP
  - Анимации списания/начисления
  
Фаза_3_Тестирование:
  - Sandbox режим для платежей
  - A/B тест на 5% пользователей
  - Мониторинг ошибок
  
Фаза_4_Запуск:
  - Начальный бонус 20 GP всем
  - Промо первой покупки
  - Постепенный rollout
```

### 8.2 Обратная совместимость
```yaml
Для_существующих_пользователей:
  - Welcome bonus ≥ 30 GP при первом входе (если баланс ниже)
  - Уведомление об изменениях
  
Переходный_период:
  - Soft launch: GP начисляются, но не тратятся
  - Обучающие подсказки в UI
  - Возможность отката если критические баги
```

## 9. ЧЕКЛИСТ ДЛЯ CURSOR AI

### Что проверить в существующем коде:
1. **Структура чатов** - где происходит отправка сообщений Лео/Максу
2. **Система уровней** - как блокируются платные уровни
3. **Навигация** - где добавить точки входа в магазин
4. **State management** - как обновлять баланс реактивно
5. **Supabase интеграция** - существующие Edge Functions и RLS

### Ключевые файлы для модификации:
```yaml
UI_компоненты:
  - /lib/widgets/app_bar.dart - добавить баланс
  - /lib/features/chat/ - логика списания GP
  - /lib/features/levels/ - блокировка этажей
  
Новые_экраны:
  - /lib/features/shop/gp_store_screen.dart
  - /lib/features/shop/purchase_modal.dart
  
Сервисы:
  - /lib/services/gp_service.dart - вся логика GP
  - /lib/services/payment_service.dart - интеграция оплат
  
Supabase:
  - /supabase/migrations/ - SQL для таблиц
  - /supabase/functions/ - Edge Functions
```

## 10. КРИТИЧЕСКИЕ ТРЕБОВАНИЯ

### Must Have для MVP:
1. **Прозрачность цен** - всегда показывать ₸ рядом с GP
2. **Защита от двойных списаний** - идемпотентность
3. **Graceful degradation** - работа при сбоях платежей
4. **Instant feedback** - моментальное обновление баланса
5. **Clear messaging** - понятные ошибки и инструкции

### Метрики успеха MVP:
- Технические: <1% failed transactions, <100ms latency
- Бизнес: 10% conversion to purchase, 1400₸ average transaction
- UX: <5% support tickets, >4.0 rating

---

**Для Cursor AI:** Этот документ содержит полную спецификацию для внедрения системы GP. Проанализируйте существующий код приложения БизЛевел и предложите пошаговый план реализации с учетом текущей архитектуры Flutter + Riverpod + Supabase.