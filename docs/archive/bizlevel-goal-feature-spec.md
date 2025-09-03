# БизЛевел: Техническая спецификация фичи "Цель"

## 1. ОБЗОР ФИЧИ

### 1.1 Назначение
Система пошагового формирования бизнес-цели через 4 этапа кристаллизации с последующим 28-дневным трекингом прогресса. Сопровождение AI-трекером Максом, специализирующимся на целеполагании и мониторинге достижений.

### 1.2 Ключевые компоненты
- **Кристаллизация цели**: 4 версии формулировки (v1-v4)
- **Путь к цели**: 4 недели по 7 дней с трекингом
- **AI-трекер Макс**: узкоспециализированный бот для целей
- **Интеграция с уровнями**: привязка к прогрессу обучения

## 2. РОЛИ И ГРАНИЦЫ БОТОВ

### 2.1 Макс - Трекер целей

**Основная роль:**
- Помощь в формулировании измеримых целей
- Трекинг прогресса и напоминания
- Связывание инструментов курса с достижением цели
- Мотивация и поддержание фокуса на результате

**Что делает Макс:**
```
✅ Задает уточняющие вопросы по цели
✅ Помогает сделать цель измеримой (SMART)
✅ Отслеживает недельный прогресс
✅ Напоминает о чекинах и действиях
✅ Связывает артефакты уроков с целью
✅ Дает обратную связь по результатам недели
```

**Чего НЕ делает Макс:**
```
❌ Не обсуждает бизнес-стратегии (→ Лео)
❌ Не объясняет материалы уроков (→ Лео)
❌ Не дает советы вне контекста цели (→ Лео)
❌ Не консультирует по общим вопросам (→ Лео)
```

### 2.2 Примеры перенаправления к Лео

```yaml
Пользователь: "Расскажи подробнее про матрицу Эйзенхауэра"
Макс: "Матрица Эйзенхауэра отлично поможет приоритизировать задачи для вашей цели! Но за детальным разбором лучше обратиться к Лео - он эксперт по бизнес-инструментам. Я же помогу встроить эту матрицу в ваш недельный план. Хотите составим список приоритетов на эту неделю?"

Пользователь: "Как мне улучшить продажи?"
Макс: "Это важный вопрос для бизнеса! Лео даст вам экспертные советы по продажам. Я же могу помочь поставить конкретную измеримую цель по увеличению продаж. Например, 'увеличить конверсию с 2% до 3% за 30 дней'. Сформулируем вашу цель по продажам?"
```

## 3. СТРУКТУРА СТРАНИЦЫ "ЦЕЛЬ"

### 3.1 Компоненты экрана

```yaml
МобильныйЭкран_Цель:
  header:
    - title: "Цель"
    - avatar_user: справа
  
  sections:
    1_motivation_card:
      - source: motivational_quotes таблица
      - update: ежедневно по UTC
      - содержимое: цитата + автор
      
    2_goal_display:
      состояние_А_кристаллизация:
        - current_version: "v1" / "v2" / "v3"
        - progress_indicator: "Этап 2 из 4"
        - next_unlock: "Следующий этап после уровня X"
        
      состояние_Б_путь:
        - final_goal: текст цели v4
        - progress_circle: XX%
        - current_week: блок активной недели
        - timeline: 4 недели горизонтально
        
    3_action_buttons:
      - primary_cta: зависит от состояния
      - chat_with_max: всегда доступно
```

## 4. КРИСТАЛЛИЗАЦИЯ ЦЕЛИ: ДЕТАЛЬНАЯ ЛОГИКА

### 4.1 Версия 1: "Набросок цели" (конец уровня 1)

```yaml
trigger: 
  - lesson_completed: level_1_last_lesson
  - показать: goal_v1_form

интерфейс:
  тип: простая_форма
  поля:
    goal_draft:
      label: "Что я хочу достичь за 30 дней?"
      type: textarea
      max_length: 200
      required: true
      
    why_now:
      label: "Почему это важно именно сейчас?"
      type: textarea  
      max_length: 150
      required: true
      
    main_obstacle:
      label: "Главное препятствие на пути"
      type: text
      max_length: 100
      required: true

сохранение:
  table: core_goals
  data:
    user_id: current_user
    version: 'v1'
    goal_text: goal_draft
    version_data: {
      why_now: why_now,
      main_obstacle: main_obstacle,
      created_at: now()
    }
```

### 4.2 Версия 2: "Метрики" (после уровня 4)

```yaml
trigger:
  - checkpoint_after: level_4
  - open_chat: max_goal_v2

chat_flow_max:
  приветствие:
    text: "Привет, {user_name}! Помните вашу цель? [показ v1] После урока о финансах давайте добавим конкретные цифры!"
    chips: ["Давайте!", "Что такое метрики?"]
    
  выбор_метрики:
    text: "Какую метрику будем отслеживать для вашей цели?"
    chips: 
      - "💰 Выручка/доход"
      - "👥 Количество клиентов"  
      - "⏱ Время на задачи"
      - "📊 Конверсия %"
      - "✏️ Другое"
      
  ввод_текущего:
    text: "Отлично! Какое значение {metric_name} у вас сейчас?"
    input: number
    validation: positive_number
    
  ввод_целевого:
    text: "А какого значения хотите достичь за 30 дней?"
    input: number
    validation: 
      - positive_number
      - realistic_growth_check
      
  подтверждение:
    text: "Теперь ваша цель звучит так: {updated_goal}. Сохраняем?"
    chips: ["✅ Да, сохранить", "✏️ Изменить"]

валидация_макса:
  если_рост_больше_200%:
    text: "Wow! Рост в {percent}% за месяц - это очень амбициозно! Уверены? Может, начнем с 50-70%?"
    chips: ["Нет, я реалист - 50%", "Да, я уверен!"]
    
  если_нет_конкретики:
    text: "Нужны точные цифры. Сколько именно {metric_name}?"
    retry: true

сохранение:
  table: core_goals
  data:
    version: 'v2'
    goal_text: goal_with_metrics
    version_data: {
      metric_type: selected_metric,
      current_value: current,
      target_value: target,
      growth_percent: calculated,
      financial_goal: если_применимо
    }
```

### 4.3 Версия 3: "SMART-план" (после уровня 7)

```yaml
trigger:
  - checkpoint_after: level_7
  - open_chat: max_goal_v3

chat_flow_max:
  intro:
    text: "Вы изучили SMART! Разобьем вашу цель [{v2_goal}] на 4 недели"
    
  для_каждой_недели:
    week_goal:
      text: "Неделя {n}: Какая мини-цель приблизит вас к результату?"
      chips_suggestions:
        - "Подготовить базу"
        - "Запустить процесс"
        - "Масштабировать"
        - "Оптимизировать"
      input: text_or_chip
      
    week_actions:
      text: "Какие 2-3 конкретных действия для этого?"
      input: text
      validation: specific_actions
      
    week_metric:
      text: "Какой будет промежуточный показатель {metric_name}?"
      input: number

  smart_check:
    text: "Проверим по SMART:
          ✓ Specific - {check_specific}
          ✓ Measurable - {check_measurable}  
          ✓ Achievable - {check_achievable}
          ✓ Relevant - {check_relevant}
          ✓ Time-bound - {check_timebound}"
          
проблемы_и_коррекция:
  слишком_общие_действия:
    text: "'Улучшить продажи' слишком общо. Что конкретно? Может '10 холодных звонков в день'?"
    
  перегруз_недели:
    text: "Много задач на неделю {n}. Выберите 2-3 ключевых, остальные - на потом"
    
  нет_связи_недель:
    text: "Недели не связаны. Как результат недели {n} поможет в неделе {n+1}?"

сохранение:
  table: core_goals
  data:
    version: 'v3'
    goal_text: smart_formulated_goal
    version_data: {
      smart_formula: final_text,
      weekly_plans: [
        {week: 1, goal: text, actions: [], metric_target: number},
        {week: 2, goal: text, actions: [], metric_target: number},
        {week: 3, goal: text, actions: [], metric_target: number},
        {week: 4, goal: text, actions: [], metric_target: number}
      ]
    }
```

### 4.4 Версия 4: "Финальная готовность" (после уровня 10)

```yaml
trigger:
  - checkpoint_after: level_10
  - open_chat: max_goal_v4

chat_flow_max:
  celebration:
    text: "Поздравляю с завершением базового курса! Ваша цель: {final_goal_card}"
    
  readiness_check:
    text: "Насколько вы готовы начать? (1-10)"
    input: slider_1_to_10
    
  если_меньше_7:
    text: "Что вас смущает?"
    chips: 
      - "Слишком сложная цель"
      - "Мало времени"
      - "Нет ресурсов"
      - "Нужна поддержка"
    персонализированная_помощь: на_основе_выбора
    
  commitment:
    text: "Когда начинаем путь к цели?"
    chips: ["Завтра утром!", "Через 2-3 дня", "В понедельник"]
    
  final:
    text: "Отлично! Следующие 28 дней я буду рядом. Каждую неделю - чекины, каждый день - поддержка!"

сохранение:
  table: core_goals
  data:
    version: 'v4'
    goal_text: final_goal
    version_data: {
      readiness_score: score,
      start_date: selected_date,
      commitment_level: high/medium/low,
      final_formula: text
    }
```

## 5. ПУТЬ К ЦЕЛИ: НЕДЕЛЬНАЯ СИСТЕМА

### 5.1 Структура недельного цикла

```yaml
понедельник_утро:
  push_notification:
    time: "09:00"
    text: "Новая неделя, {name}! Готовы?"
    action: open_week_plan
    
  week_plan_dialog:
    макс: "Неделя {n}. Ваша цель: {week_goal}"
    показать: список_действий_недели
    вопрос: "Все актуально или нужно скорректировать?"
    chips: ["Все ок!", "Хочу изменить"]

среда_пульс:
  push_notification:
    time: "14:00"
    text: "Середина недели. Как дела?"
    
  mood_check:
    макс: "Как продвигается работа над целью?"
    emoji_selector: ["😔", "😐", "😊", "🚀"]
    
  если_плохо:
    макс: "Что мешает? Может, применить матрицу Эйзенхауэра для приоритизации?"
    chips: ["Покажи как", "Спасибо, справлюсь"]

пятница_напоминание:
  push_notification:
    time: "16:00"
    text: "2 дня до чекина. Что осталось?"

воскресенье_чекин:
  обязательный: true
  time_window: "10:00-22:00"
  повторы: 3 с интервалом 3 часа
```

### 5.2 Недельный чекин через Макса

```yaml
chat_flow_checkin:
  step_1_completion:
    макс: "Как прошла неделя {n}?"
    chips: ["✅ По плану", "⚠️ Частично", "❌ Сложно было"]
    
  step_2_metric:
    макс: "Текущее значение {metric_name}?"
    input: number
    автоматический_расчет: "Это {percent}% от недельной цели"
    
  step_3_artifacts:
    макс: "Какие инструменты из уроков применяли?"
    multi_select_chips:
      - "Матрица приоритетов"
      - "Финансовый учет"
      - "SMART-планирование"
      - "Техники из уроков"
      - "Не применял"
      
  step_4_insight:
    макс: "Главное открытие недели? (можно голосом)"
    input: text_or_voice
    max_length: 100
    
  step_5_feedback:
    персонализированный_ответ_на_основе:
      - процент_выполнения
      - использованные_артефакты
      - тренд_метрики
      - настроение_недели
      
    примеры:
      успех: "{name}, отличная неделя! +{percent}% к цели. Особенно помогла матрица приоритетов, продолжайте!"
      средне: "Неплохо! Вы на правильном пути. Попробуйте на следующей неделе технику X"
      сложно: "Бывает! Давайте упростим задачи на следующую неделю. Фокус на одном действии"

сохранение:
  table: weekly_progress
  data:
    week_number: n
    completion_status: full/partial/failed
    metric_value: number
    metric_progress_percent: calculated
    artifacts_used: array
    main_insight: text
    mood_average: calculated_from_daily
    max_feedback: generated_text
```

## 6. ПОВЕДЕНЧЕСКИЕ ПАТТЕРНЫ МАКСА

### 6.1 Основные принципы

```yaml
характер:
  роль: "Трекер целей и мотиватор"
  тон: "Дружелюбный, но фокусированный"
  фокус: "Всегда возвращает к цели"
  
стиль_общения:
  - использует_имя: каждое 3-е сообщение
  - длина_сообщений: макс 2-3 строки
  - эмодзи: 1-2 на сообщение, уместно
  - примеры: конкретные, из контекста пользователя

границы:
  перенаправляет_к_лео:
    - общие_вопросы_по_бизнесу
    - детальный_разбор_уроков
    - стратегические_консультации
    
  фокус_на_цели:
    - формулирование
    - измеримость
    - трекинг
    - связь_с_инструментами
```

### 6.2 Адаптивные ответы

```yaml
валидация_целей:
  нет_конкретики:
    пример: "хочу больше денег"
    макс: "Сколько конкретно? Если сейчас 500к, то сколько хотите через месяц?"
    
  нереалистично:
    пример: "10x рост за неделю"
    макс: "Амбициозно! Но давайте начнем с x2? Это уже отличный результат!"
    
  не_бизнес:
    пример: "похудеть на 10кг"
    макс: "Это важная личная цель! Но я специализируюсь на бизнес-целях. Может, 'снизить время на рутину на 2 часа в день'?"
    
  зависит_от_других:
    пример: "чтобы инвестор дал денег"
    макс: "Это зависит от других. Давайте сформулируем то, что в вашей власти: 'Подготовить питч и показать 10 инвесторам'?"

связь_с_уроками:
  пример_вопроса: "Как матрица Эйзенхауэра поможет моей цели?"
  макс: "Матрица поможет выделить 2-3 ключевых действия недели вместо 10! Это увеличит фокус на вашей цели [{goal}]. Давайте прямо сейчас определим, какие задачи важные и срочные для недели {n}?"

мотивация_по_ситуации:
  отличный_прогресс:
    - "Вау, {name}! Уже {percent}% от цели!"
    - "В таком темпе достигнете цели досрочно!"
    
  нормальный_прогресс:
    - "Хороший стабильный темп, {name}"
    - "Вы в графике, продолжайте!"
    
  отставание:
    - "Давайте скорректируем план"
    - "Что мешает? Уберем это препятствие"
    
  бездействие:
    день_1: "Не забыли про цель?"
    день_2: "{name}, все в порядке?"
    день_3: "Давайте упростим задачу. Одно малое действие сегодня?"
```

## 7. ТАБЛИЦЫ SUPABASE

### 7.1 Модификация core_goals

```sql
-- Существующая таблица core_goals
-- Необходимые изменения:

ALTER TABLE core_goals 
ADD COLUMN IF NOT EXISTS version_data JSONB;

-- Структура version_data для каждой версии:
-- v1: {
--   why_now: text,
--   main_obstacle: text,
--   created_at: timestamp
-- }
-- v2: {
--   metric_type: text,
--   current_value: numeric,
--   target_value: numeric,
--   growth_percent: numeric,
--   financial_goal: numeric nullable
-- }
-- v3: {
--   smart_formula: text,
--   weekly_plans: [{
--     week: integer,
--     goal: text,
--     actions: text[],
--     metric_target: numeric
--   }]
-- }
-- v4: {
--   readiness_score: integer,
--   start_date: date,
--   commitment_level: text,
--   final_formula: text
-- }
```

### 7.2 Таблица weekly_progress

```sql
CREATE TABLE weekly_progress (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  week_number INTEGER CHECK (week_number BETWEEN 1 AND 4),
  goal_version TEXT DEFAULT 'v4',
  
  -- План и выполнение
  planned_actions JSONB,
  completed_actions JSONB,
  completion_status TEXT CHECK (completion_status IN ('full', 'partial', 'failed')),
  
  -- Метрики
  metric_value NUMERIC,
  metric_progress_percent NUMERIC,
  
  -- Инструменты и инсайты
  artifacts_used TEXT[],
  main_insight TEXT,
  
  -- Трекинг настроения
  mood_tracking JSONB, -- {mon: 7, tue: 8, wed: 6, ...}
  mood_average NUMERIC,
  
  -- Обратная связь от Макса
  max_feedback TEXT,
  chat_session_id UUID,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Индексы
CREATE INDEX idx_weekly_progress_user_week ON weekly_progress(user_id, week_number);
```

### 7.3 Таблица daily_mood

```sql
CREATE TABLE daily_mood (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  date DATE,
  mood_score INTEGER CHECK (mood_score BETWEEN 1 AND 10),
  note TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  
  UNIQUE(user_id, date)
);
```

## 8. ИНТЕГРАЦИЯ С СУЩЕСТВУЮЩИМИ СИСТЕМАМИ

### 8.1 Связь с leo-chat

```yaml
edge_function_modifications:
  leo-chat:
    добавить_режим: 'goal_crystallization'
    
    параметры_для_макса:
      bot_type: 'max'
      allowed_topics:
        - goal_formulation
        - goal_tracking
        - weekly_checkin
        - artifact_application
        
      redirect_triggers:
        - business_strategy -> "Это к Лео"
        - lesson_explanation -> "Лео объяснит детально"
        - general_consulting -> "Обратитесь к Лео"
        
      system_prompt_additions: |
        Ты Макс - трекер целей. Твоя задача:
        1. Помогать формулировать измеримые цели
        2. Отслеживать прогресс по неделям
        3. Связывать инструменты курса с достижением цели
        4. Мотивировать и держать фокус
        Для общих вопросов отправляй к Лео.
```

### 8.2 Интеграция с user_progress

```yaml
checkpoints:
  after_level_1:
    trigger: goal_v1_form
    block_next_until: v1_completed
    
  after_level_4:
    trigger: max_chat_v2
    block_next_until: v2_completed
    
  after_level_7:
    trigger: max_chat_v3
    block_next_until: v3_completed
    
  after_level_10:
    trigger: max_chat_v4
    unlock: weekly_tracking_system
```

## 9. FLUTTER КОМПОНЕНТЫ

### 9.1 Страница Goal

```yaml
goal_page.dart:
  imports:
    - goal_crystallization_widget
    - weekly_tracking_widget
    - motivational_quote_widget
    - max_chat_launcher
    
  state_management:
    - riverpod: goalStateProvider
    - определяет: crystallization_phase или tracking_phase
    
  layout:
    - SafeArea
    - SingleChildScrollView
    - Column:
      - MotivationalQuoteCard
      - GoalDisplayCard (collapsed/expanded)
      - CurrentPhaseWidget (crystallization или tracking)
      - MaxChatFAB
```

### 9.2 Чат с Максом для целей

```yaml
max_goal_chat.dart:
  особенности:
    - chips_widget: быстрые варианты ответов
    - number_input_widget: для метрик
    - slider_widget: для оценок 1-10
    - voice_input_button: для инсайтов
    
  flow_controller:
    - определяет_текущий_этап: v1/v2/v3/v4/checkin
    - управляет_диалогом: по сценарию
    - сохраняет_в_supabase: после подтверждения
```

## 10. МЕТРИКИ УСПЕХА

```yaml
ключевые_метрики:
  engagement:
    - completion_rate_v1: % заполнивших первую версию
    - completion_rate_v4: % дошедших до финала
    - weekly_checkin_rate: % выполняющих чекины
    
  success:
    - goal_achievement_rate: % достигших >70% цели
    - avg_progress_percent: средний прогресс
    - artifacts_usage_rate: % использующих инструменты
    
  retention:
    - day_7_retention: активность через неделю
    - day_28_completion: % завершивших путь
    - post_28_engagement: продолжают после цикла
    
  satisfaction:
    - max_usefulness_score: оценка полезности Макса
    - goal_clarity_improvement: до/после по ясности цели
```

## 11. PUSH-УВЕДОМЛЕНИЯ

```yaml
notifications_schedule:
  понедельник:
    - 09:00: "Новая неделя! План готов?"
    
  среда:
    - 14:00: "Середина недели. Как прогресс?"
    
  пятница:
    - 16:00: "Подготовка к чекину"
    
  воскресенье:
    - 10:00: "Время недельного чекина!"
    - 13:00: если_не_заполнил
    - 18:00: последнее_напоминание
    
  ежедневно:
    - 20:00: опционально "Оцените день 1-10"
```

## 12. ДАЛЬНЕЙШИЕ УЛУЧШЕНИЯ

```yaml
phase_2:
  - интеграция_с_календарем: синхронизация задач
  - команды_и_соревнования: групповые цели
  - ai_insights: предиктивная аналитика прогресса
  
phase_3:
  - экспорт_отчетов: PDF с результатами
  - интеграция_с_crm: для B2B сегмента
  - расширенная_геймификация: achievements система
```

---

**Для разработчика в Cursor:**

1. Основные файлы для модификации:
   - `/lib/features/goal/` - вся логика целей
   - `/lib/features/chat/max_goal_chat.dart` - чат с Максом
   - `/supabase/migrations/` - изменения БД
   - `/supabase/functions/leo-chat/` - добавить режим goal

2. Ключевые изменения в Supabase:
   - Расширить core_goals.version_data
   - Создать weekly_progress таблицу
   - Модифицировать leo-chat для режима Макса

3. Приоритеты реализации:
   - Сначала: v1-v4 формы в чекпоинтах
   - Затем: чат-интерфейс с Максом
   - Потом: недельный трекинг
   - В конце: push-уведомления