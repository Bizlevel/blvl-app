Я помогу вам разработать оптимальную систему памяти для ботов в приложении Бизлевел. Сначала изучу структуру проекта, чтобы понять текущую реализацию.Изучив архитектуру BizLevel и диалог о настройке памяти, предлагаю **гибридное решение**, которое объединяет лучшие практики и учитывает специфику вашего приложения:

## 🎯 Оптимальная стратегия формирования памяти для BizLevel

### 1. **Трехуровневая система памяти**

#### **Уровень 1: Оперативная память (Hot Memory)**
- **Хранение**: Таблица `user_memories` 
- **Объем**: До 50 фактов на пользователя
- **Содержание**: Критически важные факты о бизнесе, целях, текущих проблемах
- **Использование**: Загружается в каждый диалог с Лео/Максом

#### **Уровень 2: Контекстная память (Warm Memory)**  
- **Хранение**: Поле `persona_summary` в таблице `users`
- **Объем**: 1500-2000 символов JSON
- **Содержание**: Обобщенный профиль предпринимателя
- **Обновление**: Раз в неделю через LLM-суммаризацию

#### **Уровень 3: Архивная память (Cold Memory)**
- **Хранение**: Новая таблица `memory_archive`
- **Объем**: Неограниченно
- **Содержание**: Исторические факты, прошлые цели, завершенные проекты
- **Использование**: Только при явном запросе контекста

### 2. **Улучшенная фильтрация и обработка**

```typescript
// Обновленная функция extractAndUpsertMemoriesForUser
async function extractAndUpsertMemoriesForUser(
  userId: string,
  chatMessages: Array<{ role: string; content: string }>,
  maxMemories: number
): Promise<number> {
  
  // 1. Фильтрация качества сообщений
  const meaningfulMessages = chatMessages.filter((m) => {
    const content = m.content?.trim() || '';
    return content.length >= 50 && // минимум 50 символов
           !content.match(/^(да|нет|ок|спасибо|привет)/i) && // не односложные
           m.role === 'user'; // фокус на сообщениях пользователя
  });

  // 2. Извлечение фактов с приоритетами
  const extractPrompt = `Ты аналитик BizLevel. Извлеки ${maxMemories} БИЗНЕС-фактов о предпринимателе.
  
  ПРИОРИТЕТ 1 (обязательно сохранить):
  - Название и сфера бизнеса
  - Текущая выручка/обороты  
  - Главная бизнес-цель на месяц
  - Количество сотрудников
  - Основная проблема/боль
  
  ПРИОРИТЕТ 2 (важно):
  - Целевая аудитория
  - Конкуренты
  - Планы развития
  - Используемые инструменты
  - Опыт в бизнесе
  
  ПРИОРИТЕТ 3 (дополнительно):
  - Стиль работы
  - Предпочтения в обучении
  - Прошлые достижения
  
  Формат: ["факт 1", "факт 2", ...]
  Каждый факт - законченное предложение с контекстом.
  
  Диалог: ${transcript}`;

  // 3. Проверка лимитов перед сохранением
  const currentCount = await checkUserMemoryCount(userId);
  if (currentCount >= 50) {
    await archiveOldMemories(userId); // перенос в архив
  }
  
  // ... остальная логика сохранения
}
```

### 3. **Система весов и актуальности**

```sql
-- Добавляем колонки для управления актуальностью
ALTER TABLE user_memories ADD COLUMN IF NOT EXISTS 
  relevance_score FLOAT DEFAULT 1.0,
  last_accessed TIMESTAMPTZ DEFAULT NOW(),
  access_count INT DEFAULT 0;

-- Функция деградации памяти
CREATE OR REPLACE FUNCTION degrade_memory_relevance()
RETURNS void AS $$
BEGIN
  -- Снижаем релевантность старых неиспользуемых фактов
  UPDATE user_memories 
  SET relevance_score = relevance_score * 0.9
  WHERE last_accessed < NOW() - INTERVAL '7 days'
    AND relevance_score > 0.1;
    
  -- Архивируем неактуальные факты
  INSERT INTO memory_archive (user_id, content, created_at)
  SELECT user_id, content, created_at 
  FROM user_memories 
  WHERE relevance_score < 0.3;
  
  -- Удаляем архивированные
  DELETE FROM user_memories WHERE relevance_score < 0.3;
END;
$$ LANGUAGE plpgsql;
```

### 4. **Еженедельная суммаризация персоны**

```typescript
// Edge Function: update-persona-summary (запускается по cron)
async function updatePersonaSummary(userId: string) {
  // Собираем все данные о пользователе
  const memories = await getTopMemories(userId, 30);
  const recentChats = await getRecentChatSummaries(userId, 5);
  const userProfile = await getUserProfile(userId);
  const goals = await getUserGoals(userId);
  
  const summaryPrompt = `Создай JSON-профиль предпринимателя для BizLevel.
  
  Структура:
  {
    "business": {
      "name": "название компании",
      "sphere": "сфера деятельности", 
      "stage": "идея|стартап|рост|масштабирование",
      "team_size": число,
      "monthly_revenue": "диапазон в тенге"
    },
    "entrepreneur": {
      "experience_years": число,
      "strengths": ["навык1", "навык2"],
      "weaknesses": ["слабость1", "слабость2"],
      "learning_style": "визуал|аудиал|кинестетик|логик"
    },
    "current_focus": {
      "main_goal": "цель на месяц",
      "key_metric": "метрика",
      "main_challenge": "главная проблема",
      "next_milestone": "ближайшая веха"
    },
    "communication": {
      "preferred_tone": "формальный|дружеский|мотивирующий",
      "topics_of_interest": ["тема1", "тема2"],
      "avoid_topics": ["тема1"]
    }
  }
  
  Данные:
  - Факты: ${memories}
  - Недавние темы: ${recentChats}
  - Профиль: ${userProfile}
  - Цели: ${goals}`;
  
  const personaSummary = await generateWithGPT(summaryPrompt);
  
  // Сохраняем в users.persona_summary
  await updateUserPersona(userId, personaSummary);
}
```

### 5. **Оптимизированное использование памяти ботами**

```typescript
// В leo-chat/index.ts - улучшенная загрузка контекста
async function loadUserContext(userId: string, query: string) {
  // 1. Всегда загружаем персону (кэшируется)
  const persona = await getUserPersona(userId);
  
  // 2. Релевантные воспоминания через семантический поиск
  const relevantMemories = await searchMemories(userId, query, limit=5);
  
  // 3. Последние темы для континуитета
  const recentTopics = await getRecentTopics(userId, limit=3);
  
  return {
    persona, // структурированный JSON
    memories: relevantMemories, // топ-5 релевантных фактов
    recentContext: recentTopics // для продолжения диалога
  };
}
```

### 6. **План внедрения**

#### **Фаза 1 (Быстрый старт - 1 день)**
1. Добавить фильтрацию 50+ символов в `leo-memory` 
2. Установить лимит 50 записей на пользователя
3. Создать бэкап текущей БД
4. Очистить мусорные записи (короткие, дубликаты)

#### **Фаза 2 (Оптимизация - 3 дня)**  
1. Внедрить систему весов релевантности
2. Создать таблицу `memory_archive`
3. Настроить еженедельную суммаризацию персоны
4. Реализовать семантический поиск по памяти

#### **Фаза 3 (Масштабирование - 1 неделя)**
1. Добавить cron для деградации памяти
2. Внедрить метрики использования памяти
3. A/B тестирование качества ответов
4. Оптимизация промптов для извлечения фактов

### 7. **Ключевые метрики успеха**

- **Размер БД**: <10 МБ на 1000 пользователей
- **Скорость ответа**: <2 сек с загрузкой контекста  
- **Релевантность**: 80%+ пользователей отмечают улучшение персонализации
- **Retention**: +15% к недельному удержанию

### 8. **Критические улучшения для промптов**

```typescript
// Обновленный системный промпт для Лео
const leoSystemPrompt = `Ты Лео - AI бизнес-ментор в BizLevel.

ПЕРСОНАЛЬНЫЙ КОНТЕКСТ ПОЛЬЗОВАТЕЛЯ:
${persona ? `Профиль: ${JSON.stringify(persona)}` : ''}
${memories ? `Ключевые факты:\n${memories.join('\n')}` : ''}

ПРАВИЛА ИСПОЛЬЗОВАНИЯ ПАМЯТИ:
1. Обращайся к пользователю с учетом его опыта и стадии бизнеса
2. Ссылайся на прошлые достижения и цели естественно
3. НЕ повторяй факты дословно - используй их для контекста
4. Если информации недостаточно - задай уточняющий вопрос

Помни: ты не просто отвечаешь, ты выстраиваешь долгосрочные отношения с предпринимателем.`;
```

Это решение обеспечит масштабируемость до 10,000+ пользователей, сохранит релевантность памяти и улучшит персонализацию диалогов в BizLevel.