# Схема базы данных BizLevel v2.0 (Supabase)

## 📊 Структура таблиц

### 1. `users` - Пользователи
| Столбец | Тип | Описание | По умолчанию | Обязательно |
|---------|-----|----------|--------------|-------------|
| id | uuid | ID от Supabase Auth | auth.uid() | ✓ |
| email | text | Email пользователя | - | ✓ |
| name | text | Имя для отображения | - | ✓ |
| avatar_url | text | URL аватара | null | ✗ |
| about | text | О себе (контекст для Leo) | null | ✗ |
| goal | text | Цель обучения | null | ✗ |
| is_premium | boolean | Статус подписки | false | ✓ |
| current_level | integer | Текущий уровень | 1 | ✓ |
| leo_messages_total | integer | Всего сообщений (для Free) | 30 | ✓ |
| leo_messages_today | integer | Сообщений сегодня (для Premium) | 30 | ✓ |
| leo_reset_at | timestamp | Когда сбросить дневной лимит | now() | ✓ |
| onboarding_completed | boolean | Прошел онбординг | false | ✓ |
| created_at | timestamp | Дата регистрации | now() | ✓ |
| updated_at | timestamp | Последнее обновление | now() | ✓ |

**Индексы:**
- PRIMARY KEY (id)
- INDEX ON (email)
- INDEX ON (is_premium)

### 2. `levels` - Уровни
| Столбец | Тип | Описание | По умолчанию | Обязательно |
|---------|-----|----------|--------------|-------------|
| id | serial | ID уровня | auto | ✓ |
| number | integer | Порядковый номер (1-10) | - | ✓ |
| title | text | Название уровня | - | ✓ |
| description | text | Краткое описание | - | ✓ |
| image_url | text | URL обложки | - | ✓ |
| is_free | boolean | Бесплатный уровень | false | ✓ |
| artifact_title | text | Название артефакта | - | ✓ |
| artifact_description | text | Описание артефакта | - | ✓ |
| artifact_url | text | URL файла в Storage | - | ✓ |
| created_at | timestamp | Дата создания | now() | ✓ |

**Индексы:**
- PRIMARY KEY (id)
- UNIQUE INDEX ON (number)
- INDEX ON (is_free)

### 3. `lessons` - Уроки
| Столбец | Тип | Описание | По умолчанию | Обязательно |
|---------|-----|----------|--------------|-------------|
| id | serial | ID урока | auto | ✓ |
| level_id | integer | ID уровня | - | ✓ |
| order | integer | Порядок в уровне (1-5) | - | ✓ |
| title | text | Заголовок урока | - | ✓ |
| description | text | Текстовое описание | - | ✓ |
| video_url | text | Ссылка на Vimeo | - | ✓ |
| duration_minutes | integer | Длительность видео | - | ✓ |
| quiz_questions | jsonb | Массив вопросов | - | ✓ |
| correct_answers | jsonb | Массив правильных ответов | - | ✓ |
| created_at | timestamp | Дата создания | now() | ✓ |

**Индексы:**
- PRIMARY KEY (id)
- FOREIGN KEY (level_id) REFERENCES levels(id)
- UNIQUE INDEX ON (level_id, order)

**Формат quiz_questions:**
```json
[
  {
    "question": "Текст вопроса",
    "options": ["Вариант 1", "Вариант 2", "Вариант 3", "Вариант 4"]
  }
]
```

**Формат correct_answers:**
```json
[0] // Массив индексов правильных ответов (0-3)
```

### 4. `user_progress` - Прогресс пользователей
| Столбец | Тип | Описание | По умолчанию | Обязательно |
|---------|-----|----------|--------------|-------------|
| user_id | uuid | ID пользователя | - | ✓ |
| level_id | integer | ID уровня | - | ✓ |
| current_lesson | integer | Текущий урок (1-5) | 1 | ✓ |
| is_completed | boolean | Уровень завершен | false | ✓ |
| started_at | timestamp | Когда начал | now() | ✓ |
| completed_at | timestamp | Когда завершил | null | ✗ |

**Индексы:**
- PRIMARY KEY (user_id, level_id)
- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
- FOREIGN KEY (level_id) REFERENCES levels(id)

### 5. `leo_chats` - История диалогов с Leo
| Столбец | Тип | Описание | По умолчанию | Обязательно |
|---------|-----|----------|--------------|-------------|
| id | uuid | ID диалога | gen_random_uuid() | ✓ |
| user_id | uuid | ID пользователя | - | ✓ |
| title | text | Заголовок (первое сообщение) | - | ✓ |
| message_count | integer | Количество сообщений | 0 | ✓ |
| created_at | timestamp | Дата создания | now() | ✓ |
| updated_at | timestamp | Последнее обновление | now() | ✓ |

**Индексы:**
- PRIMARY KEY (id)
- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
- INDEX ON (user_id, created_at DESC)

**Формат messages:**
```json
[
  {
    "role": "user",
    "content": "Текст сообщения",
    "timestamp": "2024-01-20T10:30:00Z"
  },
  {
    "role": "assistant",
    "content": "Ответ Leo",
    "timestamp": "2024-01-20T10:30:15Z"
  }
]
```

### 5a. `leo_messages` - Сообщения диалогов Leo
| Столбец | Тип | Описание | По умолчанию | Обязательно |
|---------|-----|----------|--------------|-------------|
| id | uuid | ID сообщения | gen_random_uuid() | ✓ |
| chat_id | uuid | ID диалога | - | ✓ |
| user_id | uuid | ID пользователя (для RLS) | - | ✓ |
| role | text | user/assistant/system | - | ✓ |
| content | text | Текст сообщения | - | ✓ |
| token_count | integer | Токены OpenAI | 0 | ✓ |
| created_at | timestamp | Дата создания | now() | ✓ |

**Индексы:**
- PRIMARY KEY (id)
- FOREIGN KEY (chat_id) REFERENCES leo_chats(id) ON DELETE CASCADE
- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
- INDEX ON (chat_id, created_at)

### 6. `payments` - Платежи
| Столбец | Тип | Описание | По умолчанию | Обязательно |
|---------|-----|----------|--------------|-------------|
| id | serial | ID платежа | auto | ✓ |
| user_id | uuid | ID пользователя | - | ✓ |
| amount | decimal(10,2) | Сумма в тенге | - | ✓ |
| status | text | pending/confirmed/rejected | pending | ✓ |
| payment_method | text | kaspi/manual | - | ✓ |
| bill_id | text | ID счёта Kaspi | null | ✗ |
| bill_url | text | Прямая ссылка на оплату | null | ✗ |
| confirmed_by | uuid | ID админа (если manual) | null | ✗ |
| created_at | timestamp | Дата создания | now() | ✓ |
| confirmed_at | timestamp | Дата подтверждения | null | ✗ |

**Индексы:**
- PRIMARY KEY (id)
- FOREIGN KEY (user_id) REFERENCES users(id)
- INDEX ON (status)
- INDEX ON (created_at DESC)

## 🔗 Связи между таблицами

```
users (1) ──── (N) user_progress
  │                     │
  │                     └─── levels (1)
  │
  └──── (N) leo_chats
  │
  └──── (N) payments

levels (1) ──── (N) lessons
```

## 🔒 Row Level Security (RLS) политики

### Включение RLS для всех таблиц:
```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE leo_chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE leo_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
```

### 1. Политики для `users`:
```sql
-- Пользователи видят только свой профиль
CREATE POLICY "Users can view own profile" 
ON users FOR SELECT 
USING (auth.uid() = id);

-- Пользователи могут обновлять свой профиль
CREATE POLICY "Users can update own profile" 
ON users FOR UPDATE 
USING (auth.uid() = id);

-- Новые пользователи могут создавать профиль
CREATE POLICY "Users can insert own profile" 
ON users FOR INSERT 
WITH CHECK (auth.uid() = id);
```

### 2. Политики для `levels`:
```sql
-- Все авторизованные видят все уровни
CREATE POLICY "Public can view levels" 
ON levels FOR SELECT 
USING (auth.uid() IS NOT NULL);
```

### 3. Политики для `lessons`:
```sql
-- Все авторизованные видят все уроки
CREATE POLICY "Public can view lessons" 
ON lessons FOR SELECT 
USING (auth.uid() IS NOT NULL);
```

### 4. Политики для `user_progress`:
```sql
-- Пользователи видят только свой прогресс
CREATE POLICY "Users can view own progress" 
ON user_progress FOR SELECT 
USING (auth.uid() = user_id);

-- Пользователи могут создавать свой прогресс
CREATE POLICY "Users can insert own progress" 
ON user_progress FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- Пользователи могут обновлять свой прогресс
CREATE POLICY "Users can update own progress" 
ON user_progress FOR UPDATE 
USING (auth.uid() = user_id);
```

### 5. Политики для `leo_chats`:
```sql
-- Пользователи видят только свои диалоги
CREATE POLICY "Users can view own chats" 
ON leo_chats FOR SELECT 
USING (auth.uid() = user_id);

-- Пользователи могут создавать диалоги
CREATE POLICY "Users can create chats" 
ON leo_chats FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- Пользователи могут обновлять свои диалоги
CREATE POLICY "Users can update own chats" 
ON leo_chats FOR UPDATE 
USING (auth.uid() = user_id);
```

### 5b. Политики для `leo_messages`:
```sql
-- Пользователи видят только сообщения своих чатов
CREATE POLICY "Users can view own chat messages"
ON leo_messages FOR SELECT
USING (auth.uid() = user_id);

-- Пользователи могут вставлять сообщения в свои чаты
CREATE POLICY "Users can insert own chat messages"
ON leo_messages FOR INSERT
WITH CHECK (auth.uid() = user_id);
```

### 6. Политики для `payments`:
```sql
-- Пользователи видят только свои платежи
CREATE POLICY "Users can view own payments" 
ON payments FOR SELECT 
USING (auth.uid() = user_id);

-- Пользователи могут создавать платежи
CREATE POLICY "Users can create payments" 
ON payments FOR INSERT 
WITH CHECK (auth.uid() = user_id);
```

## 🪣 Supabase Storage структура

### Buckets:
1. **avatars** (публичный)
   - Путь: `{user_id}/avatar.jpg`
   - Максимальный размер: 5MB
   
2. **artifacts** (приватный)
   - Путь: `level_{number}/{filename}.pdf`
   - Доступ через signed URLs

### Storage политики:
```sql
-- Пользователи могут загружать свои аватары
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Публичный доступ к аватарам
CREATE POLICY "Public avatar access"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

-- Доступ к артефактам для premium или завершивших уровень
CREATE POLICY "Artifact access for eligible users"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'artifacts' AND
  EXISTS (
    SELECT 1 FROM users u
    WHERE u.id = auth.uid() AND (
      u.is_premium = true OR
      EXISTS (
        SELECT 1 FROM user_progress up
        JOIN levels l ON l.id = up.level_id
        WHERE up.user_id = auth.uid()
        AND up.is_completed = true
        AND storage.filename(name) LIKE 'level_' || l.number || '%'
      )
    )
  )
);
```

## 🚀 Начальные данные

### Вставка первых 3 бесплатных уровней:
```sql
INSERT INTO levels (number, title, description, image_url, is_free, artifact_title, artifact_description, artifact_url) VALUES
(1, 'Основы бизнеса', 'Что такое бизнес и зачем он нужен', 'https://url.com/level1.jpg', true, 'Чек-лист идеи', 'Шаблон для проверки бизнес-идеи', 'level_1/checklist.pdf'),
(2, 'Поиск идеи', 'Как найти прибыльную идею', 'https://url.com/level2.jpg', true, 'Карта рынка', 'Шаблон анализа конкурентов', 'level_2/market_map.xlsx'),
(3, 'Первая продажа', 'Как продать без вложений', 'https://url.com/level3.jpg', true, 'Скрипты продаж', '10 готовых скриптов', 'level_3/scripts.pdf');

-- Остальные платные уровни
INSERT INTO levels (number, title, description, image_url, is_free, artifact_title, artifact_description, artifact_url) VALUES
(4, 'Команда мечты', 'Как найти и мотивировать людей', 'https://url.com/level4.jpg', false, 'HR чек-лист', 'Процесс найма сотрудников', 'level_4/hr_checklist.pdf'),
-- ... до 10 уровня
```

### Вставка уроков для первого уровня:
```sql
INSERT INTO lessons (level_id, order, title, description, video_url, duration_minutes, quiz_questions, correct_answers) VALUES
(1, 1, 'Что такое бизнес', 'Разбираемся в основах', 'https://vimeo.com/123456', 7, 
'[{"question": "Что главное в бизнесе?", "options": ["Деньги", "Решение проблем", "Связи", "Удача"]}]', '[1]'),
(1, 2, 'Виды бизнеса', 'B2B, B2C и другие', 'https://vimeo.com/123457', 5,
'[{"question": "Что означает B2B?", "options": ["Бизнес для бизнеса", "Бизнес для людей", "Большой бизнес", "Быстрый бизнес"]}]', '[0]');
```

## 🔧 Триггеры и функции

### Автоматическое обновление updated_at:
```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_leo_chats_updated_at BEFORE UPDATE ON leo_chats
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### Сброс дневного лимита Leo:
```sql
CREATE OR REPLACE FUNCTION reset_daily_leo_messages()
RETURNS void AS $$
BEGIN
    UPDATE users
    SET leo_messages_today = 30,
        leo_reset_at = NOW() + INTERVAL '24 hours'
    WHERE is_premium = true
    AND leo_reset_at < NOW();
END;
$$ language 'plpgsql';

-- Вызывать через cron job каждый час
```

### Автоматическое подтверждение Kaspi платежей:
```sql
CREATE OR REPLACE FUNCTION confirm_kaspi_payment(p_transaction_id text)
-- DEPRECATED. Используйте confirm_kaspi_bill(p_bill_id text)

CREATE OR REPLACE FUNCTION confirm_kaspi_bill(p_bill_id text)
RETURNS void AS $$
DECLARE
    v_user_id uuid;
BEGIN
    -- Находим платеж
    SELECT user_id INTO v_user_id
    FROM payments
    WHERE bill_id = p_bill_id
    AND status = 'pending';
    
    -- Обновляем статус
    UPDATE payments
    SET status = 'confirmed',
        confirmed_at = NOW()
    WHERE bill_id = p_bill_id;
    
    -- Делаем пользователя Premium
    UPDATE users
    SET is_premium = true
    WHERE id = v_user_id;
END;
$$ language 'plpgsql';
```

## 📈 Оптимизация производительности

### Материализованное представление для статистики:
```sql
CREATE MATERIALIZED VIEW user_stats AS
SELECT 
    u.id,
    u.current_level,
    COUNT(DISTINCT up.level_id) as completed_levels,
    COUNT(DISTINCT lc.id) as total_chats,
    SUM(lm_cnt.cnt) as total_messages
FROM users u
LEFT JOIN user_progress up ON u.id = up.user_id AND up.is_completed = true
LEFT JOIN leo_chats lc ON u.id = lc.user_id
LEFT JOIN (
  SELECT chat_id, COUNT(*) as cnt
  FROM leo_messages
  GROUP BY chat_id
) lm_cnt ON lm_cnt.chat_id = lc.id
GROUP BY u.id;

-- Обновлять раз в час
REFRESH MATERIALIZED VIEW user_stats;
```

## 🔍 Полезные запросы

### Получить доступные уровни для пользователя:
```sql
SELECT l.*, 
       up.is_completed,
       up.current_lesson,
       CASE 
           WHEN l.is_free THEN true
           WHEN u.is_premium THEN true
           WHEN up.is_completed THEN true
           ELSE false
       END as is_accessible
FROM levels l
CROSS JOIN users u
LEFT JOIN user_progress up ON l.id = up.level_id AND up.user_id = u.id
WHERE u.id = auth.uid()
ORDER BY l.number;
```

### Проверить лимит сообщений Leo:
```sql
SELECT 
    CASE 
        WHEN is_premium AND leo_reset_at < NOW() THEN 30
        WHEN is_premium THEN leo_messages_today
        ELSE leo_messages_total
    END as messages_left
FROM users
WHERE id = auth.uid();
```