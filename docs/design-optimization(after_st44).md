## СТРУКТУРА UI КОМПОНЕНТОВ (Этап 1)

## АНАЛИЗ НАВИГАЦИИ И СОСТОЯНИЙ (Этап 7)

### Навигационная структура
**Маршруты:**
- Основные routes (см. `lib/routing/app_router.dart`):
  - `/login`, `/register` (публичные)
  - ShellRoute → `/home`, `/chat`, `/goal`, `/profile`, `/tower`, `/levels/:id?num=`, `/case/:id`, `/goal-checkpoint/:version`, `/gp-store`, `/library`, `/library/:type`
- Deep links: поддерживаются query (`/tower?scrollTo=`) и path params (`/levels/:id`, `/library/:type`). Есть `utils/deep_link.dart` для трансформации URI.
- Breadcrumbs: отсутствуют (используется back‑навигация/иконки в AppBar).

### Состояния приложения
**Loading states:**
- Использования `CircularProgressIndicator`/`.when(loading:)`: обнаружены в `profile_screen.dart`, `levels_map_screen.dart`, `library_*`, `main_street_screen.dart`, `goal_checkpoint_screen.dart`, `leo_dialog_screen.dart` и др. (см. греп‑выдержку).
- Консистентность: средняя — стили и позиции индикаторов различаются.
- Проблемы: inline индикаторы без унифицированного виджета; местами пустые `SizedBox` в loading.

**Error states:**
- Обработка ошибок часто через `when(error:)` → `Text('Ошибка ...')` или SnackBar.
- Пользовательские сообщения: разнородные, отсутствует единый стиль/CTA.
- Retry механизмы: точечно (напр. башня — кнопка «Повторить»), не везде присутствуют.

**Empty states:**
- Покрытие: низкое — чаще показывается список без явного пустого состояния (исключение: `LeoChatScreen` — «История диалогов пуста»).
- Call-to-action: отсутствует в большинстве пустых состояний.

### Рекомендации:
- [ ] Стандартизировать loading states: `BizLevelLoading` (inline, fullscreen, sliver)
- [ ] Улучшить error handling: `BizLevelError` с retry и лейаутом (inline/fullscreen)
- [ ] Добавить breadcrumb navigation на глубинных экранах (`/levels/:id`, `/library/:type`)
- [ ] Создать единые empty states с CTA: `BizLevelEmpty` (icon+title+subtitle+action)

## MOBILE-FIRST АНАЛИЗ (Этап 8)

### Адаптивность
**Responsive компоненты:**
- Присутствуют `MediaQuery`/`LayoutBuilder` в ключевых экранах (`levels_map_screen.dart`, `biz_tower_screen.dart`, `library_section_screen.dart`, `gp_store_screen.dart`, `app_shell.dart`).
- Breakpoints: локальные условия (600, 1024, 1400) в `levels_map_screen.dart`.
- Проблемы: точечные фиксированные размеры (width/height: 120/180/300, 290/420) — требуется перевести в адаптивные/зависимые от ширины.

### Touch targets
**Минимальные размеры:**
- Много кнопок высотой 48 (соответствует требованиям 44+).
- Проблемные элементы: иконки в AppBar/PopupMenu/StatCard — проверить ≥48 touch area.

### Рекомендации:
- [ ] Проверить все интерактивные элементы ≥44px (иконки, action‑chip’ы)
- [ ] Вынести breakpoints (xs/sm/md/lg/xl) и функции `isMobile|isTablet|isDesktop`
- [ ] Оптимизировать reachability для одной руки (нижние CTA, FAB размещение)

## ТЕСТИРУЕМОСТЬ И ДОКУМЕНТАЦИЯ (Этап 9)

### Тестируемость
**Widget keys:**
- Явных `Key(...)` немного (пример: `LevelsMapScreen` имеет `key: const Key('levels_map_screen')`). Остальные критичные экраны без явных ключей элементов.
- Критичные виджеты без ключей: карточки уровней, узлы башни, элементы списка библиотек.

### Документация
**Код документация:**
- Dartdoc `///` встречается (router, экраны, провайдеры), но не везде.
- TODO/FIXME: явных TODO немного, долг‑комментарии отсутствуют.

### Рекомендации:
- [ ] Добавить keys для тестирования: корневые экраны, карточки, CTA‑кнопки
- [ ] Документировать публичные виджеты/компоненты (dartdoc) и провайдеры
- [ ] Добавить style guide и гайды по состояниям/навигации

## ПЛАН ПОЭТАПНОГО ИСПРАВЛЕНИЯ (Пофайлово + приоритеты)

### Этап A: Дизайн‑токены и базовая тема (высокий приоритет)
- [ ] Создать `lib/theme/typography.dart`: определить `TextTheme` (display, headline, title, body, label), веса/межстрочные для h1–h6, body, caption, button.
- [ ] Создать `lib/theme/spacing.dart`: токены `xs=4, sm=8, md=12, lg=16, xl=24, 2xl=32, 3xl=48` и фабрики `insets(all,h,v)`, `gap(height|width)`.
- [ ] Обновить `lib/theme/color.dart`: разнести роли (primary/success/warning/error/info/background/surface/border/text/subtleText/shadow), убрать дубли `warning=premium`. Добавить `AppColor.gray` шкалу (50..900) при необходимости.
- [ ] Завести `ThemeData` (если отсутствует централизованный builder) с `ButtonTheme`, `TextButtonTheme`, `ElevatedButtonTheme`, `InputDecorationTheme`.

### Этап B: Замена цветов (высокий приоритет)
- [ ] Заменить `Color(0x...)` и `Colors.*` → `AppColor.*` (или новый токен), начиная с топ‑файлов по количеству вхождений:
  - [ ] `lib/screens/profile_screen.dart` — Colors.*: 15, EdgeInsets: 11, SizedBox: 14.
  - [ ] `lib/screens/level_detail_screen.dart` — Colors.*: 8, EdgeInsets: 11, SizedBox: 20.
  - [ ] `lib/widgets/leo_quiz_widget.dart` — Colors.*: 12, EdgeInsets: 10, SizedBox: 4.
  - [ ] `lib/widgets/skills_tree_view.dart` — Colors.*: 11, EdgeInsets: 2, SizedBox: 5.
  - [ ] `lib/screens/goal/widgets/motivation_card.dart` — Colors.*: 10, Color(0x..): 2, SizedBox: 9.
  - [ ] `lib/screens/main_street_screen.dart` — Colors.*: 9, EdgeInsets: 5, SizedBox: 6.
  - [ ] `lib/screens/goal_checkpoint_screen.dart` — Colors.*: 9, Color(0x..): 2, EdgeInsets: 6, SizedBox: 7.
  - [ ] `lib/screens/auth/login_screen.dart` — Colors.*: 9, Color(0x..): 2, EdgeInsets: 5, SizedBox: 5.
  - [ ] `lib/screens/goal/widgets/sprint_section.dart` — Colors.*: 8, EdgeInsets: 4, SizedBox: 5.
  - [ ] `lib/screens/leo_chat_screen.dart` — Colors.*: 8, EdgeInsets: 5, SizedBox: 4.
  - [ ] `lib/screens/auth/onboarding_video_screen.dart` — Colors.*: 8.
  - [ ] `lib/widgets/level_card.dart` — Colors.*: 7, EdgeInsets: 6, SizedBox: 2.
  - [ ] `lib/screens/tower/tower_tiles.dart` — Colors.*: 6, Color(0x..): 1, EdgeInsets: 2.
  - [ ] `lib/screens/library/library_screen.dart` — Colors.*: 3, EdgeInsets: 3, SizedBox: 10, ListView: 1 (см. Этап G).
  - [ ] `lib/screens/gp_store_screen.dart` — Colors.*: 3, EdgeInsets: 4, SizedBox: 15, ListView: 1 (см. Этап G).
  - [ ] `lib/screens/biz_tower_screen.dart` — Colors.*: 3, EdgeInsets: 3, SizedBox: 5.
  - [ ] `lib/theme/color.dart` — Colors.*: 7 (привести к само‑ссылкам на токены, убрать прямые `Colors.white`/`black12` и т.п.).
  - [ ] `lib/screens/tower/tower_constants.dart` — Color(0x..): 2.
  - [ ] `lib/screens/tower/tower_floor_widgets.dart` — Color(0x..): 1, EdgeInsets: 3.
  - [ ] `lib/screens/tower/tower_tiles.dart` — Color(0x..): 1, EdgeInsets: 2.

Примечание: `lib/models/lesson_model.freezed.dart` — auto‑generated; не редактировать вручную.

### Этап C: Spacing и типографика (высокий приоритет)
- [ ] Заменить inline `EdgeInsets.*` → токены `AppSpacing.*`/утилиты из `spacing.dart` в файлах:
  - Пакет 1 (экраны с наибольшими вхождениями): `profile_screen.dart` (11), `level_detail_screen.dart` (11), `leo_quiz_widget.dart` (10), `crystallization_section.dart` (7), `leo_dialog_screen.dart` (7).
  - Пакет 2: `level_card.dart` (6), `goal_checkpoint_screen.dart` (6), `main_street_screen.dart` (5), `leo_chat_screen.dart` (5), `auth/register_screen.dart` (5), `auth/login_screen.dart` (5).
- [ ] Заменить частые `SizedBox(height|width:)` → `gap(AppSpacing.x)` или константы из `spacing.dart` (см. B‑список, напр. `level_detail_screen.dart` — 20, `gp_store_screen.dart` — 15, `library_screen.dart` — 10 и т.д.).
- [ ] Внедрить `TextTheme` из `typography.dart` и заменить inline `TextStyle(...)` (в первую очередь в `level_detail_screen.dart`, `profile_screen.dart`, `leo_dialog_screen.dart`).

### Этап D: Кнопки (высокий приоритет)
- [ ] Создать `lib/widgets/common/bizlevel_button.dart` с вариантами: `primary | secondary | outline | text | danger | link` и размерами: `sm | md | lg`.
- [ ] Массовая замена inline `ElevatedButton.styleFrom(...)` и ручных цветов на `BizLevelButton` в:
  - `level_detail_screen.dart` (CTA «Завершить уровень», «Обсудить с Лео»),
  - `leo_dialog_screen.dart` (кнопки отправки, bottom sheets CTA),
  - `gp_store_screen.dart` (выбор пакета, «Проверить покупку»),
  - `profile_screen.dart` (аватар, «Войти», «Обновить», меню — частично через `ButtonTheme`).

### Этап E: Карточки (средний приоритет)
- [ ] Создать `lib/widgets/common/bizlevel_card.dart` (radius, elevation, padding, тени по токенам).
- [ ] Заменить повторяющиеся `Container/Card` с белым фоном/тенями в:
  - `library_screen.dart`, `gp_store_screen.dart`, `profile_screen.dart`, `levels_map_screen.dart`, `main_street_screen.dart`.

### Этап F: Башня (средний приоритет)
- [ ] В `lib/screens/biz_tower_screen.dart` и `lib/screens/tower/*`:
  - Централизовать цвета путей/точек/стен через `AppColor`/`TowerTheme`.
  - Проверить `CustomPainter.shouldRepaint` (уже корректно), обернуть фоновые слои в `const`/`RepaintBoundary` (частично есть).
  - Вынести толщины, радиусы, альфы в константы темы (`kPathStroke`, `kCornerRadius`, `kPathAlpha`) — уже есть, связать с токенами.

### Этап G: Производительность и списки (высокий приоритет)
- [ ] Проверить и при необходимости заменить `ListView(` → `ListView.builder`:
  - `lib/screens/library/library_screen.dart:202` — заменить на builder (список разделов/книг).
  - `lib/screens/gp_store_screen.dart:18` — список блоков можно оставить (короткий), но предпочтителен builder для унификации.
  - `lib/widgets/leo_quiz_widget.dart:157` — убедиться в небольшом количестве элементов; при росте — builder.
  - `lib/models/lesson_model.freezed.dart:294,303` — сгенерированный код, не править.
- [ ] Добавить `const` к статичным `Text`, `Icon`, `SizedBox`, `EdgeInsets` фабрикам в перечисленных ключевых файлах (особенно `level_detail_screen.dart`, `profile_screen.dart`, `biz_tower_screen.dart`).

### Этап H: Accessibility (средний приоритет)
- [ ] Добавить `Semantics`/`semanticsLabel` для:
  - `levels_map_screen.dart` (карточки уровней),
  - `biz_tower_screen.dart` (узлы уровня/чекпоинты как кнопки),
  - `profile_screen.dart` (аватар, артефакты, GP‑баланс),
  - `leo_dialog_screen.dart` (кнопка отправки, сообщения — роль/направление).
- [ ] Проверить touch‑targets ≥ 48x48 (иконки AppBar, popup‑меню в профиле, иконки в картах).

### Этап I: Навигация и UX‑мелочи (низкий приоритет)
- [ ] Единые подсказки/тексты для ошибок загрузки; вынести в `ui_strings.dart`.
- [ ] Стандартизировать SnackBar (длительность, цвета) через `SnackBarThemeData`.

---

## Чек‑листы по конкретным файлам (быстрые заметки)

- [ ] `lib/screens/profile_screen.dart`
  - Colors.* → AppColor.*, EdgeInsets → AppSpacing, SizedBox → gap, const для статичных виджетов.
  - Semantics: аватар (кнопка смены), карточки статистики/артефактов.

- [ ] `lib/screens/level_detail_screen.dart`
  - Цвета/spacing/typography по токенам; CTA через BizLevelButton.
  - PageView/навигация — оставить; const для статичных текстов.

- [ ] `lib/screens/gp_store_screen.dart`
  - Цвета/spacing; заменить кнопки на BizLevelButton; карточки на BizLevelCard.
  - ListView → builder (опционально, но желательно).

- [ ] `lib/screens/leo_dialog_screen.dart`
  - Цвета/spacing/typography; кнопка отправки → BizLevelButton (иконка/label).
  - Semantics для сообщений и FAB.

- [ ] `lib/screens/levels_map_screen.dart`
  - Цвета/spacing; карточки уровня → BizLevelCard; Semantics на карточки.

- [ ] `lib/screens/biz_tower_screen.dart` + `lib/screens/tower/*`
  - Цвета путей/точек/стен → TowerTheme/AppColor.
  - Проверка const и RepaintBoundary, токенизация толщин/радиусов.

- [ ] `lib/screens/library/library_screen.dart`
  - Цвета/spacing; ListView → builder; карточки → BizLevelCard.

- [ ] `lib/widgets/skills_tree_view.dart`
  - Цвета графиков → AppColor; spacing/const; Semantics для строк навыков.

- [ ] `lib/widgets/leo_quiz_widget.dart`
  - Цвета/spacing; ListView — проверить размер, при необходимости builder.

- [ ] `lib/theme/color.dart`
  - Убрать прямые `Colors.white/black*`, ввести семантические токены `surface`, `onSurfaceSubtle`, `shadow`.

# ФИНАЛЬНЫЙ ОТЧЕТ: UX/UI ОПТИМИЗАЦИЯ BIZLEVEL (Этап 6)

## EXECUTIVE SUMMARY
**Общая оценка:** 7.5/10
**Ключевые проблемы:**
1. Неконсистентность палитры: `AppColor` vs `Colors.*` vs `Color(0x...)` (миксы).
2. Отсутствует типографика и расширенная spacing-система (много inline размеров).
3. Повтор стилей карточек/кнопок, низкое покрытие Semantics.

## ПРИОРИТИЗИРОВАННЫЙ ПЛАН ДЕЙСТВИЙ

### 🔴 ВЫСОКИЙ ПРИОРИТЕТ (1–2 недели)

#### 1. Создать единую систему дизайна
- [ ] Файл: `lib/theme/typography.dart` — базовый `TextTheme`, стили h1..label.
- [ ] Файл: `lib/theme/spacing.dart` — токены XS=4, S=8, M=12, L=16, XL=24, XXL=32.
- [ ] Обновить `lib/theme/color.dart`: описать роли (primary/success/...); убрать дубли warning=premium.

#### 2. Стандартизировать кнопки
- [ ] Файл: `lib/widgets/common/bizlevel_button.dart` (primary/secondary/outline/text/danger/link).
- [ ] Пройтись по 10–15 ключевым экранам и заменить inline стили.

#### 3. Исправить критические проблемы производительности
- [ ] В `lib/screens/biz_tower_screen.dart` вынести статические элементы в `const`, централизовать цвета путей в `AppColor`.
- [ ] Проверить 5 случаев `ListView(` на соответствие объёму данных; где длинные списки — заменить на `ListView.builder`.

### 🟡 СРЕДНИЙ ПРИОРИТЕТ (2–4 недели)

#### 1. Переиспользуемые компоненты
- [ ] `BizLevelCard` (варианты: level/stat/info/warning) и замена дублированных `Container/Card`.
- [ ] `BizLevelTextField` и общий валидатор.

#### 2. Улучшить навигацию
- [ ] Единый back-UX на ключевых экранах, подсказки в чатах, deep-links в башне.

### 🟢 НИЗКИЙ ПРИОРИТЕТ (1–2 месяца)
- [ ] Анимации и микроинтеракции (hover/focus/press для web/desktop).
- [ ] Dark theme.
- [ ] Расширенная accessibility (контраст, читабельность, навигируемость).

### 🟡 ДОПОЛНЕНИЯ К СРЕДНЕМУ ПРИОРИТЕТУ

#### 3. Mobile-first оптимизация
- [ ] Проверить touch targets ≥44px везде (иконки AppBar/Popup/StatCard)
- [ ] Добавить responsive breakpoints и helpers (`isMobile/tablet/desktop`)
- [ ] Оптимизация для thumb navigation (CTA ниже, FAB)

#### 4. Тестируемость
- [ ] Добавить widget keys для критичных элементов
- [ ] Настроить integration test infra (go_router + провайдеры)

## МЕТРИКИ ДЛЯ ОТСЛЕЖИВАНИЯ
- [ ] Hardcoded `Color(0x...)`: 41 → ≤5
- [ ] Использования `Colors.*`: 226 → ≤50
- [ ] Inline `TextStyle(...)`: 93 → ≤15
- [ ] Inline `EdgeInsets`/`SizedBox`: 156/211 → −30%
- [ ] Semantics: 7 → 40+

## КОНКРЕТНЫЕ ФАЙЛЫ ДЛЯ ИЗМЕНЕНИЯ
1. Создать: `lib/theme/typography.dart`, `lib/theme/spacing.dart`, `lib/widgets/common/bizlevel_button.dart`, `lib/widgets/common/bizlevel_card.dart`.
2. Refactor: `lib/screens/biz_tower_screen.dart` (+ `tower_*`), `lib/screens/levels_map_screen.dart`, `lib/screens/level_detail_screen.dart`, `lib/screens/leo_dialog_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/gp_store_screen.dart` — заменить цвета/spacing на токены, добавить const.
3. Удалить: дублирующиеся inline стили (заменяются на токены), устаревшие локальные тени/радиусы.

### 🔴 ДОПОЛНЕНИЯ К ВЫСОКОМУ ПРИОРИТЕТУ

#### 4. Стандартизировать состояния приложения
- [ ] Создать `lib/widgets/common/bizlevel_loading.dart` (inline/fullscreen/sliver)
- [ ] Создать `lib/widgets/common/bizlevel_error.dart` (title, message, retry)
- [ ] Создать `lib/widgets/common/bizlevel_empty.dart` (icon+title+subtitle+CTA)

#### 5. Улучшить навигацию
- [ ] Добавить breadcrumb для `/levels/:id`, `/library/:type`
- [ ] Стандартизировать поведение back (AppBar/gesture) через mixin/утилиту
- [ ] Валидация deep links (`utils/deep_link.dart` → покрыть тестами)

## АНАЛИЗ ПЕРЕИСПОЛЬЗУЕМЫХ КОМПОНЕНТОВ (Этап 4)

### Кнопки
**Текущее состояние:**
- Общее количество использований кнопок (`Elevated|Text|Outlined`): 53.
- Уникальные стили: много inline `styleFrom(...)`, цвета/размеры не унифицированы.
- Дублирующиеся паттерны: CTA с `AppColor.primary`, одинаковые высоты (48), иконки слева.

**Рекомендации:**
- [ ] Создать `widgets/common/bizlevel_button.dart` c вариантами: primary, secondary, outline, text, danger, link.
- [ ] Стандартизировать высоты (40, 48, 56) и паддинги через токены.
- [ ] Вынести `ElevatedButtonTheme`/`TextButtonTheme` в `ThemeData`.

### Карточки
**Текущее состояние:**
- Частые `Container`/`Card` с белым фоном, скруглениями 12–20, boxShadow.
- Повторяющиеся стили в `levels_map`, `gp_store`, `profile`.

**Рекомендации:**
- [ ] Создать `widgets/common/bizlevel_card.dart` с преднастройками: elevation, radius, padding.
- [ ] Варианты: level, stat, info, warning.

### Формы
**Текущее состояние:**
- Полей ввода немного: `TextField` найден в 2 местах, есть `CustomTextBox`.
- Валидации локальные и разрозненные.

**Рекомендации:**
- [ ] `BizLevelTextField` на базе `CustomTextBox` с токенами отступов/цветов.
- [ ] Единый хелпер для валидации и сообщений об ошибке.

## АНАЛИЗ ПРОИЗВОДИТЕЛЬНОСТИ И ACCESSIBILITY (Этап 5)

### Производительность
**Потенциальные проблемы:**
- [ ] Виджеты без const: оценочно — десятки мест (статичные `Text`, `SizedBox`).
- [ ] ListView без builder: 5 случаев (нужно проверить на краткие списки).
- [ ] Избыточные rebuilds: слушатели `PageController`/провайдеров без локального `Consumer`/`Selector`.

### Accessibility
**Текущее состояние:**
- `Semantics|semanticsLabel`: 7 вхождений (низкое покрытие).
- Ручные цвета текста/иконок местами — риск контрастности.

**Рекомендации:**
- [ ] Добавить Semantics для ключевых кнопок, аватаров, карточек уровней.
- [ ] Проверить min touch target 48x48, особенно для иконок в AppBar/StatCard.
- [ ] Вынести контрастные цвета в тему и избегать полупрозрачных серых для текста.

## АНАЛИЗ КЛЮЧЕВЫХ ЭКРАНОВ (Этап 3)

### Экран: "Башня BizLevel"
**Файл:** lib/screens/biz_tower_screen.dart (+ part-файлы в `lib/screens/tower/`)
**Архитектурные проблемы:**
- [ ] Жёстко заданные цвета (`Colors.black26`, `Colors.black.withValues`) — обойти через `AppColor`.
- [ ] Много `Positioned`/`Stack`/`CustomPaint` без мемоизации — риск лишних перерисовок.
- [ ] Смешение UI и вычислений сетки в одном файле (частично вынесено, но `_placeItems`/`_buildSegments` можно покрыть тестами отдельно).

**Переиспользуемость:**
- Дублируются стили меток/линий дорожек.
- Потенциал: выделить `TowerTheme` (цвета путей, толщины, радиусы).

**Производительность:**
- Потенциальные bottlenecks: частые rebuild при изменении провайдера и автоскролле; `CustomPaint` без RepaintBoundary на всех слоях (частично стоит).
- Рекомендации: обернуть тяжёлые слои в `const` где возможно, убедиться в корректности `shouldRepaint`, вынести сегменты в `Listenable`/`ValueListenableBuilder` при необходимости.

### Экран: "Карта уровней"
**Файл:** lib/screens/levels_map_screen.dart
**Архитектурные проблемы:**
- [ ] Стили shimmer и карт повторяются.
- [ ] Inline размеры/spacing.

**Переиспользуемость:**
- Можно вынести `LevelGrid` и shimmer-карточку в отдельные виджеты.

**Производительность:**
- Нормально: используется `SliverGrid` и провайдер.

### Экран: "Детали уровня"
**Файл:** lib/screens/level_detail_screen.dart
**Архитектурные проблемы:**
- [ ] Большой stateful с множеством блоков в одном файле.
- [ ] Inline стили для текста/кнопок.

**Переиспользуемость:**
- Блоки `_IntroBlock`/`_LessonBlock`/`_QuizBlock` можно вынести в отдельные файлы.

**Производительность:**
- `PageView` с `NeverScrollableScrollPhysics` ок; следить за setState при `_pageController` listener.

### Экран: "Чат интерфейсы"
**Файл:** lib/screens/leo_chat_screen.dart, lib/screens/leo_dialog_screen.dart
**Архитектурные проблемы:**
- [ ] Стили карточек/кнопок и отступы inline.
- [ ] Логика пагинации и UI смешаны (частично оправдано).

**Переиспользуемость:**
- Вынести chat header, chip row, message bubble уже выделены; продолжить унификацию (кнопки, цвета).

**Производительность:**
- `ListView.builder` используется (хорошо). Есть `SingleChildScrollView` (в `LeoChatScreen`) — ок, т.к. мало элементов.

### Экран: "Профиль и навыки"
**Файл:** lib/screens/profile_screen.dart, `lib/widgets/skills_tree_view.dart`
**Архитектурные проблемы:**
- [ ] Много inline цветов/отступов.

**Переиспользуемость:**
- `StatCard`, `SkillsTreeView` уже выделены. Вынести «артефакты» в общий модальный компонент.

**Производительность:**
- Используются `Sliver*`, мемоизация не критична. Можно добавить `const` на статические элементы.

### Экран: "GP система"
**Файл:** lib/screens/gp_store_screen.dart
**Архитектурные проблемы:**
- [ ] Много inline `Container` со стилями.

**Переиспользуемость:**
- Вынести `GpPlanCard` уже есть, дополнить токенами стилей.

**Производительность:**
- Низкая сложность; достаточно добавить `const` и токены.

## АНАЛИЗ ДИЗАЙН СИСТЕМЫ (Этап 2)

### Цветовая палитра
**Текущее состояние:**
- Основные цвета (из `lib/theme/color.dart`): primary `0xFF1995F0`, success `0xFF10B981`, premium `0xFFF59E0B`, error `0xFFDC2626`, info `0xFF3B82F6`, warning `0xFFF59E0B`, text `0xFF0F172A`, label `0xFF94A3B8`, border `0xFFCBD5E1`, divider `0xFFE2E8F0`, appBg `0xFFFAFBFC`, appBar `0xFFF1F5F9`.
- Градиенты: `bgGradient` (F0F4FF→DDE8FF), `levelGradients` (5 вариантов для карточек уровней).
- Hardcoded цвета в коде: 41 использований `Color(0x...)` (разбросаны по экранам/виджетам).
- Использования `Colors.*`: 226.
- Использования `AppColor.*`: 151 (хороший показатель централизации).

**Проблемы:**
- Смешанное использование `AppColor.*`, `Colors.*` и прямых `Color(0x...)` → неконсистентность.
- Дублирование оттенков (напр., warning=premium по hex), возможна путаница в семантике.
- Нет явной документации по назначению цветов и токенов состояния.

### Типографика
**Текущее состояние:**
- Файл типографики отсутствует.
- Встречаются inline `TextStyle(...)`: 93 вхождения.
- Использования `Theme.of`: 59 (есть попытки централизовать стили через тему, но не системно).

**Проблемы:**
- Нет единого `TextTheme`/наборов стилей (h1–h6, subtitle, body, caption, button).
- Риск разнородных размеров и весов шрифтов по экранам.

### Spacing система
**Текущее состояние:**
- Есть `AppSpacing` с тремя значениями: 8/16/24.
- Использования `AppSpacing.*`: 30.
- Использования `EdgeInsets.*`: 156; `SizedBox(height|width:)`: 211 (много inline-отступов).

**Проблемы:**
- Недостаточное покрытие токенами (нужны XS/XL/XXL и т.п.).
- Много инлайновых `EdgeInsets` и `SizedBox`, что снижает консистентность.

### Экраны (lib/screens/ или lib/pages/)
- [ ] Файл: lib/screens/app_shell.dart - Оболочка приложения и вкладки
- [ ] Файл: lib/screens/auth/login_screen.dart - Экран входа
- [ ] Файл: lib/screens/auth/onboarding_screens.dart - Онбординг (многоэкранный)
- [ ] Файл: lib/screens/auth/onboarding_video_screen.dart - Онбординг с видео
- [ ] Файл: lib/screens/auth/register_screen.dart - Экран регистрации
- [ ] Файл: lib/screens/biz_tower_screen.dart - Башня BizLevel (основной прогресс)
- [ ] Файл: lib/screens/goal_checkpoint_screen.dart - Чекпоинты цели
- [ ] Файл: lib/screens/goal_screen.dart - Экран цели
- [ ] Файл: lib/screens/goal/controller/goal_screen_controller.dart - Контроллер экрана цели
- [ ] Файл: lib/screens/gp_store_screen.dart - Магазин GP валюты
- [ ] Файл: lib/screens/leo_chat_screen.dart - Чат с ИИ тренером
- [ ] Файл: lib/screens/leo_dialog_screen.dart - Диалог с ИИ
- [ ] Файл: lib/screens/level_detail_screen.dart - Детали уровня
- [ ] Файл: lib/screens/levels_map_screen.dart - Карта уровней
- [ ] Файл: lib/screens/library/library_screen.dart - Библиотека
- [ ] Файл: lib/screens/library/library_section_screen.dart - Раздел библиотеки
- [ ] Файл: lib/screens/main_street_screen.dart - Главная улица
- [ ] Файл: lib/screens/mini_case_screen.dart - Мини-кейсы
- [ ] Файл: lib/screens/payment_screen.dart - Оплата/подписка
- [ ] Файл: lib/screens/profile_screen.dart - Профиль пользователя
- [ ] Файл: lib/screens/root_app.dart - Корневой экран навигации
- [ ] Файл: lib/screens/tower/tower_constants.dart - Константы башни
- [ ] Файл: lib/screens/tower/tower_extensions.dart - Расширения для башни
- [ ] Файл: lib/screens/tower/tower_floor_widgets.dart - Виджеты этажей башни
- [ ] Файл: lib/screens/tower/tower_grid.dart - Сетка башни
- [ ] Файл: lib/screens/tower/tower_helpers.dart - Хелперы башни
- [ ] Файл: lib/screens/tower/tower_painters.dart - Рисовальщики (CustomPainter) башни
- [ ] Файл: lib/screens/tower/tower_tiles.dart - Плитки/элементы башни

### Виджеты (lib/widgets/)
- [ ] Файл: lib/screens/goal/widgets/checkin_form.dart - Форма чек-ина по цели
- [ ] Файл: lib/screens/goal/widgets/crystallization_section.dart - Блок кристаллизации цели
- [ ] Файл: lib/screens/goal/widgets/goal_compact_card.dart - Компактная карточка цели
- [ ] Файл: lib/screens/goal/widgets/motivation_card.dart - Карточка мотивации
- [ ] Файл: lib/screens/goal/widgets/progress_widget.dart - Прогресс по цели
- [ ] Файл: lib/screens/goal/widgets/sprint_section.dart - Секция спринта
- [ ] Файл: lib/screens/goal/widgets/weeks_timeline_row.dart - Таймлайн недель
- [ ] Файл: lib/widgets/artifact_card.dart - Карточка артефакта
- [ ] Файл: lib/widgets/bottombar_item.dart - Элемент нижней панели
- [ ] Файл: lib/widgets/category_box.dart - Блок категории
- [ ] Файл: lib/widgets/chat_item.dart - Элемент списка чатов
- [ ] Файл: lib/widgets/chat_notify.dart - Нотификация чата
- [ ] Файл: lib/widgets/custom_image.dart - Кастомное изображение
- [ ] Файл: lib/widgets/custom_textfield.dart - Кастомное поле ввода
- [ ] Файл: lib/widgets/desktop_nav_bar.dart - Десктопная навигационная панель
- [ ] Файл: lib/widgets/feature_item.dart - Элемент фичи
- [ ] Файл: lib/widgets/floating_chat_bubble.dart - Плавающее окно чата
- [ ] Файл: lib/widgets/goal_version_form.dart - Форма версии цели
- [ ] Файл: lib/widgets/leo_message_bubble.dart - Сообщение чата Лео
- [ ] Файл: lib/widgets/leo_quiz_widget.dart - Квиз-виджет Лео
- [ ] Файл: lib/widgets/lesson_widget.dart - Виджет урока
- [ ] Файл: lib/widgets/level_card.dart - Карточка уровня
- [ ] Файл: lib/widgets/notification_box.dart - Блок уведомления
- [ ] Файл: lib/widgets/quiz_widget.dart - Квиз-виджет общий
- [ ] Файл: lib/widgets/recommend_item.dart - Элемент рекомендаций
- [ ] Файл: lib/widgets/setting_box.dart - Блок настроек
- [ ] Файл: lib/widgets/setting_item.dart - Элемент настроек
- [ ] Файл: lib/widgets/skills_tree_view.dart - Дерево навыков
- [ ] Файл: lib/widgets/stat_card.dart - Статистическая карточка
- [ ] Файл: lib/widgets/typing_indicator.dart - Индикатор набора
- [ ] Файл: lib/widgets/user_info_bar.dart - Панель информации пользователя

### Темы и стили
- [ ] Файл: lib/theme/color.dart - Палитра цветов приложения
- [ ] Отсутствуют явные файлы типографики/spacing: рекомендовано создать `lib/theme/typography.dart`, `lib/theme/spacing.dart`


