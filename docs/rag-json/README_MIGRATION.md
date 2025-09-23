# Миграция RAG системы на JSON-основанную архитектуру

## 🎯 Цель проекта
Замена текущей RAG системы, основанной на таблице `documents` в Supabase, на новую JSON-основанную архитектуру с гибридным поиском (dense + BM25) для улучшения производительности, предсказуемости и снижения затрат.

## 📊 Проведенная работа

### 1. Анализ текущей системы
- **Проблема**: Текущая RAG система использует таблицу `documents` с неполными метаданными
- **Ограничения**: Данные привязаны к `level_id`, а не к `lesson_id`
- **Контент**: Найден в поле `quiz_questions` таблицы `lessons` (40 уроков, уровни 11-20)

### 2. Создание JSON-архитектуры
- **Экспорт данных**: 40 уроков с полным контентом из `quiz_questions`
- **Структурирование**: Создана иерархия `levels/{level_id}/lesson_{lesson_id}/`
- **Атомизация**: Генерация 200 фактов (по 5 на урок) с метаданными
- **Формат**: `lesson.json`, `facts.jsonl`, `README.md` для каждого урока

### 3. Подготовка инфраструктуры
- **Скрипты обработки**: `process_lessons.py`, `generate_facts.py`
- **Миграция**: `migrate_to_supabase.py` для полной миграции
- **Индексация**: `index_to_pgvector.py` для работы с pgvector
- **Документация**: Подробные инструкции и примеры использования

## 🚀 Ожидаемые результаты

### 1. Улучшение производительности
- **Быстрый поиск**: Векторные индексы pgvector для семантического поиска
- **Гибридный поиск**: Комбинация dense (OpenAI) + BM25 для точности
- **Фильтрация**: Эффективная фильтрация по `level_number` и `section`

### 2. Повышение качества ответов
- **Структурированные данные**: Четкая связь между уроками и фактами
- **Богатые метаданные**: Теги, темы, ключевые слова для контекста
- **Детерминизм**: Предсказуемые результаты поиска

### 3. Снижение затрат
- **Локальное хранение**: JSON файлы в репозитории
- **Версионирование**: Git-контроль изменений контента
- **Масштабируемость**: Легкое добавление новых уроков

## 📋 План миграции

### Этап 1: Подготовка (5 минут)
**Файлы**: `env_example.txt`, `.env`
```bash
# 1. Настройка переменных окружения
cp env_example.txt .env
# Заполнить SUPABASE_URL, SUPABASE_ANON_KEY, OPENAI_API_KEY
```

### Этап 2: Создание таблиц (2 минуты)
**Скрипт**: `migrate_to_supabase.py` (функция `create_tables()`)
```bash
python migrate_to_supabase.py --create-tables-only
```
**Результат**: Таблицы `lesson_facts`, `lesson_metadata` с индексами

### Этап 3: Загрузка метаданных (1 минута)
**Скрипт**: `migrate_to_supabase.py` (функция `load_lesson_metadata()`)
**Результат**: 40 записей в таблице `lesson_metadata`

### Этап 4: Индексация фактов (15-20 минут)
**Скрипт**: `index_to_pgvector.py`
```bash
python index_to_pgvector.py
```
**Результат**: 200 фактов с эмбеддингами в таблице `lesson_facts`

### Этап 5: Создание функций поиска (1 минута)
**Скрипт**: `migrate_to_supabase.py` (функция `create_search_functions()`)
**Результат**: Функции `search_lesson_facts()`, `search_by_level()`

### Этап 6: Обновление leo-chat (10 минут)
**Файлы**: `leo_chat_retriever.py`, `leo_chat_config.py`
- Реализация нового ретривера
- Настройка fallback на старую систему
- Тестирование интеграции

### Этап 7: Тестирование (5 минут)
**Скрипты**: `test_new_rag.py`, `test_fallback.py`
- Проверка поиска по уровням
- Тестирование fallback механизма
- Валидация качества ответов

## ⚠️ План отката на существующую систему

### Важно: Полный откат невозможен без резервной БД!
**Причина**: Изменения в структуре таблиц Supabase необратимы

### Варианты отката:

#### 1. Мягкий откат (рекомендуется)
**Время**: 2 минуты
**Действия**:
```bash
# 1. Отключить новый ретривер в leo-chat
# В файле leo_chat_config.py установить:
USE_NEW_RAG = False

# 2. Перезапустить сервис
# 3. Проверить работу старой RAG системы
```
**Результат**: Система работает на старой RAG, новые таблицы остаются

#### 2. Частичный откат
**Время**: 10 минут
**Действия**:
```sql
-- 1. Переименовать новые таблицы (не удалять!)
ALTER TABLE lesson_facts RENAME TO lesson_facts_backup;
ALTER TABLE lesson_metadata RENAME TO lesson_metadata_backup;

-- 2. Удалить новые функции
DROP FUNCTION IF EXISTS search_lesson_facts;
DROP FUNCTION IF EXISTS search_by_level;

-- 3. Восстановить старую RAG систему
```
**Результат**: Старая система работает, новые данные сохранены

#### 3. Экстренный откат (если система сломана)
**Время**: 30 минут
**Действия**:
```bash
# 1. Откатить код leo-chat на предыдущую версию
git checkout HEAD~1

# 2. Перезапустить все сервисы
# 3. Проверить работоспособность
# 4. Планировать повторную миграцию
```

### Рекомендации по безопасности:
1. **Тестирование**: Обязательно протестировать на dev-окружении
2. **Мониторинг**: Настроить алерты на ошибки RAG системы
3. **Документация**: Зафиксировать все изменения для быстрого отката
4. **Резервирование**: Создать backup текущего состояния БД перед миграцией

## 🚀 Запуск миграции

### 1. Установка зависимостей
```bash
pip install aiohttp openai
```

### 2. Настройка переменных окружения
Скопируйте `env_example.txt` в `.env` и заполните:
```bash
cp env_example.txt .env
```

Заполните переменные:
- `SUPABASE_URL` - URL вашего Supabase проекта
- `SUPABASE_ANON_KEY` - анонимный ключ Supabase
- `OPENAI_API_KEY` - ключ OpenAI API

### 3. Запуск миграции
```bash
python migrate_to_supabase.py
```

## 📊 Структура данных

### Таблица lesson_facts
```sql
CREATE TABLE lesson_facts (
    id TEXT PRIMARY KEY,                    -- fact_02_00_001
    content TEXT NOT NULL,                  -- текст факта
    lesson_id INTEGER NOT NULL,            -- ID урока
    level_number INTEGER NOT NULL,         -- номер уровня
    section TEXT NOT NULL,                 -- lesson_2
    title TEXT NOT NULL,                   -- название урока
    file_name TEXT NOT NULL,               -- lesson_2.json
    doc_id TEXT NOT NULL,                  -- lesson_2_11
    chunk_index INTEGER NOT NULL,          -- индекс чанка
    tags TEXT[] DEFAULT '{}',              -- теги
    topics TEXT[] DEFAULT '{}',            -- темы
    keywords TEXT[] DEFAULT '{}',          -- ключевые слова
    embedding VECTOR(1536),                -- эмбеддинг OpenAI
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Таблица lesson_metadata
```sql
CREATE TABLE lesson_metadata (
    lesson_id INTEGER PRIMARY KEY,         -- ID урока
    level_id INTEGER NOT NULL,             -- ID уровня
    title TEXT NOT NULL,                   -- название
    description TEXT NOT NULL,             -- описание
    video_url TEXT,                        -- ссылка на видео
    duration_minutes INTEGER,              -- длительность
    language TEXT NOT NULL,                -- язык (ru)
    version TEXT NOT NULL,                 -- версия (1.0)
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    checksum_sha256 TEXT NOT NULL,         -- контрольная сумма
    content JSONB NOT NULL                 -- контент урока
);
```

## 🔍 Примеры использования

### Поиск по уровню
```sql
SELECT * FROM search_by_level(11, 'цели мотивация', 5);
```

### Гибридный поиск
```sql
SELECT * FROM search_lesson_facts(
    'постановка целей',
    '[0.1, 0.2, ...]'::vector,  -- эмбеддинг запроса
    11,                          -- фильтр по уровню
    'lesson_2',                  -- фильтр по секции
    10                           -- лимит результатов
);
```

### Поиск по тегам
```sql
SELECT * FROM lesson_facts 
WHERE tags @> '["option"]' 
AND level_number = 11;
```

## ⚠️ Важные замечания

1. **Эмбеддинги**: Используется модель `text-embedding-3-small` (1536 измерений)
2. **Язык**: Все тексты на русском языке
3. **Индексы**: Созданы для быстрого поиска по уровням, секциям и векторам
4. **Fallback**: Система поддерживает fallback на текущую RAG

## 🐛 Устранение неполадок

### Ошибка подключения к Supabase
- Проверьте URL и ключ API
- Убедитесь, что проект активен

### Ошибка OpenAI API
- Проверьте ключ API
- Убедитесь, что есть кредиты на счету

### Ошибка создания таблиц
- Проверьте права доступа к базе
- Убедитесь, что pgvector установлен

## 📈 Мониторинг

После миграции проверьте:
```sql
-- Количество фактов по уровням
SELECT level_number, COUNT(*) FROM lesson_facts GROUP BY level_number;

-- Количество уроков
SELECT COUNT(*) FROM lesson_metadata;

-- Проверка эмбеддингов
SELECT id, array_length(embedding, 1) as embedding_size 
FROM lesson_facts LIMIT 5;
```
