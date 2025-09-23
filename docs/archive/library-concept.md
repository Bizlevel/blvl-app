# Концепция Библиотеки Бизлевел

## 1. Краткое описание

**Библиотека Бизлевел** — это бесплатный информационный центр внутри приложения, предоставляющий доступ к образовательным ресурсам и программам поддержки для предпринимателей Казахстана. 

### Цель
Дать пользователям возможность самостоятельного развития через качественные бесплатные курсы и помочь найти финансовую поддержку для развития бизнеса.

### Что внутри:
- **36 бесплатных курсов** по основам бизнеса, финансам, маркетингу, продажам и управлению
- **14 программ грантов и поддержки** от государства и международных организаций  
- **13 акселераторов** — локальных и международных программ развития стартапов
- **Избранное** — персональная подборка сохраненных материалов

---

## 2. Структура библиотеки

```
📚 БИБЛИОТЕКА
├── 📖 Курсы (36 программ)
│   ├── Основы предпринимательства (5)
│   ├── Финансы (5)
│   ├── Маркетинг и SMM (5)
│   ├── Продажи (4)
│   ├── Маркетплейсы (5)
│   └── Управление командой (6)
│
├── 💰 Гранты и поддержка (14 программ)
│   ├── Государственные программы (4)
│   ├── Для женщин и молодежи (4)
│   ├── Отраслевые программы (4)
│   └── Международные (2)
│
├── 🚀 Акселераторы (13 программ)
│   ├── Локальные казахстанские (4)
│   ├── Международные (5)
│   └── Корпоративные (4)
│
└── ⭐ Избранное
    └── Сохраненные карточки
```

---

## 3. UX описание страниц

### 3.1. Главный экран "Библиотека"

**Структура экрана (сверху вниз):**

1. **Заголовок с описанием**
   ```
   📚 БИБЛИОТЕКА
   
   Бесплатные ресурсы для развития вашего бизнеса.
   Курсы, гранты и акселераторы — всё в одном месте.
   ```

2. **Три блока-карточки разделов**
   ```
   ┌─────────────────────────────────┐
   │ 📖 КУРСЫ                        │
   │ 36 бесплатных программ          │
   │ ────────────────────            │
   │ От основ бизнеса до управления  │
   │ командой. Все курсы на русском  │
   │ языке или с субтитрами.         │
   │                    [Открыть →]  │
   └─────────────────────────────────┘

   ┌─────────────────────────────────┐
   │ 💰 ГРАНТЫ И ПОДДЕРЖКА           │
   │ 14 актуальных программ          │
   │ ────────────────────            │
   │ Государственные и международные │
   │ программы финансовой поддержки  │
   │ для бизнеса в Казахстане.       │
   │                    [Открыть →]  │
   └─────────────────────────────────┘

   ┌─────────────────────────────────┐
   │ 🚀 АКСЕЛЕРАТОРЫ                 │
   │ 13 программ развития            │
   │ ────────────────────            │
   │ Бесплатные программы ускорения  │
   │ для стартапов. От локальных до  │
   │ международных акселераторов.    │
   │                    [Открыть →]  │
   └─────────────────────────────────┘
   ```

3. **Вкладка "Избранное"** (внизу экрана)
   ```
   ⭐ Избранное (3)
   ```
   При нажатии показывает сохраненные карточки

---

### 3.2. Экран "Курсы"

**Структура:**

1. **Навигация**
   ```
   [← Библиотека]         КУРСЫ
   ```

2. **Категории (карточки)**
   ```
   ┌──────────────┐ ┌──────────────┐
   │ 🎯           │ │ 💳           │
   │ Основы       │ │ Финансы      │
   │ бизнеса      │ │              │
   │ 5 курсов     │ │ 5 курсов     │
   └──────────────┘ └──────────────┘

   ┌──────────────┐ ┌──────────────┐
   │ 📱           │ │ 💼           │
   │ Маркетинг    │ │ Продажи      │
   │ и SMM        │ │              │
   │ 5 курсов     │ │ 4 курса      │
   └──────────────┘ └──────────────┘
   ```

3. **Список курсов** (после выбора категории)
   
   **Свернутая карточка:**
   ```
   ┌─────────────────────────────────┐
   │ Основы бизнеса              [⭐] │
   │ Открытое образование • 10 недель│
   │ ─────────────────────────────   │
   │ Курс с фокусом на практику...   │
   │                           [▼]   │
   └─────────────────────────────────┘
   ```

   **Развернутая карточка (по тапу):**
   ```
   ┌─────────────────────────────────┐
   │ Основы бизнеса              [⭐] │
   │ Открытое образование • 10 недель│
   │ ─────────────────────────────   │
   │ Описание:                       │
   │ Уникальный курс с фокусом на    │
   │ практику. Поможет организовать  │
   │ новое предприятие и избежать    │
   │ основных ошибок на старте.      │
   │                                 │
   │ Для кого:                       │
   │ Начинающим предпринимателям и   │
   │ тем, кто хочет систематизировать│
   │ имеющиеся знания.               │
   │                                 │
   │ Язык: Русский                   │
   │                                 │
   │ [Перейти к курсу ↗]        [△]  │
   └─────────────────────────────────┘
   ```

**Функции:**
- ⭐ — добавить/убрать из избранного
- ▼/△ — развернуть/свернуть карточку
- [Перейти к курсу ↗] — открыть внешнюю ссылку

---

### 3.3. Экран "Гранты и поддержка"

**Структура аналогична курсам:**

1. **Категории:**
   - Государственные программы
   - Для женщин и молодежи  
   - Отраслевые программы
   - Международные

2. **Карточка гранта (развернутая):**
   ```
   ┌─────────────────────────────────┐
   │ Дорожная карта бизнеса      [⭐] │
   │ Фонд "Даму"                     │
   │ ─────────────────────────────   │
   │ Тип: Грант, субсидирование      │
   │ Сумма: До 5 млн тенге           │
   │ Дедлайн: Постоянный прием       │
   │                                 │
   │ Описание:                       │
   │ Комплексная программа поддержки │
   │ МСП через удешевление кредитов, │
   │ гарантии и гранты.              │
   │                                 │
   │ Для кого:                       │
   │ Субъекты МСП, начинающие и      │
   │ молодые предприниматели.        │
   │                                 │
   │ [Подробнее на сайте ↗]     [△]  │
   └─────────────────────────────────┘
   ```

---

### 3.4. Экран "Акселераторы"

**Категории:**
- Локальные казахстанские
- Международные  
- Корпоративные

**Карточка акселератора (развернутая):**
```
┌─────────────────────────────────┐
│ Silkway Accelerator         [⭐] │
│ Astana Hub + Google             │
│ ─────────────────────────────   │
│ Формат: Офлайн/Гибрид           │
│ Длительность: 3 месяца          │
│ Язык: Английский                │
│ Условия: Бесплатно              │
│                                 │
│ Что дают:                       │
│ • Менторство от Google          │
│ • Подготовка к инвестициям      │
│ • PR и нетворкинг               │
│                                 │
│ Для кого:                       │
│ Стартапы на стадии MVP с        │
│ первыми продажами.              │
│                                 │
│ [Подать заявку ↗]          [△]  │
└─────────────────────────────────┘
```

---

### 3.5. Вкладка "Избранное"

**Отображение:**
- Список всех сохраненных карточек
- Группировка по типам (Курсы / Гранты / Акселераторы)
- Возможность удалить из избранного
- Счетчик избранных элементов

---

## 4. Организация в Supabase

### 4.1. Структура таблиц

```sql
-- 1. Таблица курсов
CREATE TABLE library_courses (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  category VARCHAR(100) NOT NULL,
  title VARCHAR(255) NOT NULL,
  platform VARCHAR(100) NOT NULL,
  description TEXT,
  target_audience TEXT,
  language VARCHAR(50) DEFAULT 'Русский',
  duration VARCHAR(100),
  url TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Таблица грантов
CREATE TABLE library_grants (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  category VARCHAR(100) NOT NULL,
  title VARCHAR(255) NOT NULL,
  organizer VARCHAR(255) NOT NULL,
  support_type VARCHAR(100),
  amount VARCHAR(255),
  target_audience TEXT,
  description TEXT,
  deadline VARCHAR(255),
  url TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Таблица акселераторов
CREATE TABLE library_accelerators (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  category VARCHAR(100) NOT NULL,
  title VARCHAR(255) NOT NULL,
  organizer VARCHAR(255) NOT NULL,
  format VARCHAR(100),
  duration VARCHAR(100),
  language VARCHAR(100),
  benefits TEXT,
  target_audience TEXT,
  description TEXT,
  requirements TEXT,
  url TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Таблица избранного
CREATE TABLE library_favorites (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  resource_type VARCHAR(50) NOT NULL, -- 'course', 'grant', 'accelerator'
  resource_id UUID NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, resource_type, resource_id)
);
```

### 4.2. Индексы для производительности

```sql
-- Индексы для быстрой фильтрации
CREATE INDEX idx_courses_category ON library_courses(category);
CREATE INDEX idx_grants_category ON library_grants(category);
CREATE INDEX idx_accelerators_category ON library_accelerators(category);
CREATE INDEX idx_favorites_user ON library_favorites(user_id);
```

### 4.3. RLS политики

```sql
-- Политики для чтения (все могут читать)
ALTER TABLE library_courses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Courses are viewable by everyone" 
  ON library_courses FOR SELECT 
  USING (true);

ALTER TABLE library_grants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Grants are viewable by everyone" 
  ON library_grants FOR SELECT 
  USING (true);

ALTER TABLE library_accelerators ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Accelerators are viewable by everyone" 
  ON library_accelerators FOR SELECT 
  USING (true);

-- Политики для избранного (только свои записи)
ALTER TABLE library_favorites ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own favorites" 
  ON library_favorites FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own favorites" 
  ON library_favorites FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites" 
  ON library_favorites FOR DELETE 
  USING (auth.uid() = user_id);
```

### 4.4. Примеры запросов

```javascript
// Получить курсы по категории
const { data: courses } = await supabase
  .from('library_courses')
  .select('*')
  .eq('category', 'Основы предпринимательства и бизнес-планирование')
  .eq('is_active', true)
  .order('sort_order');

// Добавить в избранное
const { error } = await supabase
  .from('library_favorites')
  .insert({
    user_id: userId,
    resource_type: 'course',
    resource_id: courseId
  });

// Получить избранное пользователя
const { data: favorites } = await supabase
  .from('library_favorites')
  .select(`
    *,
    course:library_courses(*),
    grant:library_grants(*),
    accelerator:library_accelerators(*)
  `)
  .eq('user_id', userId);
```

---

## 5. Ключевые особенности

### Простота
- Минималистичный дизайн без лишних элементов
- Четкая структура и навигация
- Быстрый доступ к внешним ресурсам

### Польза
- Только проверенные и актуальные программы
- Фокус на казахстанском рынке
- Бесплатные ресурсы для саморазвития

### Персонализация
- Избранное для сохранения интересных программ
- Категоризация для быстрого поиска
- Компактные и развернутые виды карточек

### Масштабируемость
- Легко добавлять новые программы через Supabase
- Готовая структура для будущих улучшений (поиск, фильтры, AI-консультант)
- Возможность добавления отзывов и рейтингов