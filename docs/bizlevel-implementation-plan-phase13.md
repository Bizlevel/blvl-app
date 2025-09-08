# Этап 45 — UX/UI консолидация и дизайн‑система (на основе design-optimization(after_st44).md)

### Задача 45.1: Дизайн‑токены и базовая тема
- Файлы: `lib/theme/typography.dart` (новый), `lib/theme/spacing.dart` (новый), `lib/theme/color.dart` (обновить), `lib/main.dart` (подключить тему).
- Что сделать:
  1) `typography.dart`: определить базовый `TextTheme` (display/headline/title/body/label, h1–h6, caption, button) с размерами и межстрочными интервалами.
  2) `spacing.dart`: токены `xs=4, sm=8, md=12, lg=16, xl=24, 2xl=32, 3xl=48` + утилиты `insets(all,h,v)` и `gap(height|width)`.
  3) `color.dart`: ввести семантические роли (`primary/success/warning/error/info/surface/onSurface/border/divider/shadow`), убрать прямые `Colors.*`, устранить дубли (warning=premium), централизовать `withOpacity/withValues`.
  4) Подключить `ThemeData` в `main.dart` (или существующем месте) и настроить `ElevatedButtonTheme`, `TextButtonTheme`, `InputDecorationTheme`, `SnackBarThemeData`.
- Критерии приёмки: сборка без регрессий, отсутствие прямых `Colors.*` в теме, линтеры чистые.

### Задача 45.2: Стандартизация кнопок (BizLevelButton)
- Файлы: `lib/widgets/common/bizlevel_button.dart` (новый), замены в: `lib/screens/level_detail_screen.dart`, `lib/screens/leo_dialog_screen.dart`, `lib/screens/gp_store_screen.dart`, `lib/screens/profile_screen.dart`.
- Что сделать:
  1) Создать `BizLevelButton` c вариантами `primary | secondary | outline | text | danger | link`, размерами `sm | md | lg` и токенами отступов.
  2) Заменить inline `ElevatedButton.styleFrom(...)` и прямые цвета на `BizLevelButton` в перечисленных файлах (CTA «Завершить уровень», «Обсудить с Лео», «Проверить покупку», кнопки профиля).
- Критерии приёмки: визуальный паритет, единые размеры/отступы, без дублирования стилей.

### Задача 45.3: Карточки (BizLevelCard)
- Файлы: `lib/widgets/common/bizlevel_card.dart` (новый), замены в: `lib/screens/library/library_screen.dart`, `lib/screens/gp_store_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/levels_map_screen.dart`, `lib/screens/main_street_screen.dart`.
- Что сделать:
  1) Создать `BizLevelCard` с преднастройками: radius, elevation, padding, тени по токенам.
  2) Заменить повторяющиеся `Container/Card` с одинаковыми стилями в указанных экранах.
- Критерии приёмки: визуальный паритет, снижение дублирования стилей.

### Задача 45.4: Единые состояния (Loading/Error/Empty)
- Файлы: `lib/widgets/common/bizlevel_loading.dart` (новый), `lib/widgets/common/bizlevel_error.dart` (новый), `lib/widgets/common/bizlevel_empty.dart` (новый);
  рефактор: `lib/screens/profile_screen.dart`, `lib/screens/levels_map_screen.dart`, `lib/screens/library/library_section_screen.dart`, `lib/screens/library/library_screen.dart`, `lib/screens/main_street_screen.dart`, `lib/screens/goal_checkpoint_screen.dart`, `lib/screens/leo_dialog_screen.dart`, `lib/screens/mini_case_screen.dart`.
- Что сделать:
  1) Ввести стандартные виджеты состояний: inline/fullscreen/sliver варианты загрузки; error с title/message/retry; empty с icon/title/subtitle/CTA.
  2) Заменить `.when(loading|error)` и `CircularProgressIndicator` на унифицированные компоненты.
- Критерии приёмки: единый стиль состояний, присутствует retry там, где есть загрузка из сети.

### Задача 45.5: Производительность списков (ListView.builder)
- Файлы: `lib/screens/library/library_screen.dart:202`, `lib/screens/gp_store_screen.dart:18`, `lib/widgets/leo_quiz_widget.dart:157`.
- Что сделать:
  1) Заменить `ListView(` → `ListView.builder` для потенциально длинных списков; исключение: короткие списки допускаются, но желательно унифицировать.
  2) Исключить изменения в auto‑generated файлах (`lib/models/lesson_model.freezed.dart`).
- Критерии приёмки: без регрессий скролла, нет лишних перерисовок.

### Задача 45.6: Accessibility и тестируемость (Semantics + Keys)
- Файлы: `lib/screens/levels_map_screen.dart`, `lib/screens/biz_tower_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/leo_dialog_screen.dart` и ключевые карточки/CTA.
- Что сделать:
  1) Добавить `Semantics`/`semanticsLabel` для карточек уровней, узлов башни (как кнопок), аватара/артефактов/GP‑баланса, кнопок чата.
  2) Добавить `Key(...)` для критичных элементов (корневые экраны, карточки, CTA‑кнопки) для тестов.
- Критерии приёмки: a11y‑аудит без явных пропусков, виджеты доступны по ключам в тестах.

### Задача 45.7: Навигация и breadcrumbs
- Файлы: `lib/widgets/common/breadcrumb.dart` (новый), интеграция: `lib/screens/level_detail_screen.dart`, `lib/screens/library/library_section_screen.dart`.
- Что сделать:
  1) Добавить простой `Breadcrumb` (root → раздел → текущая страница) и вывести его на глубинных экранах.
  2) Стандартизировать поведение back (AppBar/gesture) через утилиту/mixin.
  3) Валидация deep links в `utils/deep_link.dart` (unit‑тесты на корректную нормализацию).
- Критерии приёмки: breadcrumb отображается корректно, back‑UX консистентен, тесты для deep‑links проходят.

### Задача 45.8: Mobile‑first и адаптивность
- Файлы: `lib/utils/responsive.dart` (новый), правки: 
  `lib/screens/library/library_section_screen.dart` (width 120/180 → адаптивные),
  `lib/screens/goal/widgets/weeks_timeline_row.dart` (width 120 → адаптивно),
  `lib/screens/goal/widgets/motivation_card.dart` (width 120),
  `lib/screens/goal/widgets/crystallization_section.dart` (width 180),
  `lib/widgets/user_info_bar.dart` (width 120),
  `lib/widgets/recommend_item.dart` (width 300),
  а также фиксированные height 290/420/180/190 (заменить на зависимые от размеров экрана/constraints).
- Что сделать:
  1) Ввести helpers: `isMobile/tablet/desktop`, breakpoints (напр. 600/1024/1400).
  2) Перевести фиксированные размеры на расчетные (проценты/ограничения).
- Критерии приёмки: отсутствие overflow, читабельность на мобайл/таблет/десктоп.

### Задача 45.9: Башня — консолидация темы
- Файлы: `lib/screens/biz_tower_screen.dart`, `lib/screens/tower/tower_grid.dart`, `lib/screens/tower/tower_painters.dart`, `lib/screens/tower/tower_tiles.dart`, `lib/screens/tower/tower_floor_widgets.dart`, `lib/screens/tower/tower_constants.dart`.
- Что сделать:
  1) Централизовать цвета путей/точек/стен через `AppColor`/локальный `TowerTheme`.
  2) Связать `kPathStroke/kCornerRadius/kPathAlpha` с токенами темы; убедиться в `RepaintBoundary` там, где нужно.
  3) Добавить `const` к статичным узлам/текстам.
- Критерии приёмки: визуальный паритет, отсутствие лишних перерисовок.

### Задача 45.10: Метрики, документация и тесты
- Файлы: `docs/status.md`, тесты `test/**` (screens/widgets/routing).
- Что сделать:
  1) После внедрения — обновить метрики (Color(0x..)/Colors./TextStyle/EdgeInsets/Semantics) в `design-optimization(after_st44).md`.
  2) Добавить запись в `docs/status.md` «Задача 45: UX/UI консолидация…» (≤5 строк, формат проекта).
  3) Тесты: smoke на `/library`, `/levels/:id`, состояния Loading/Error/Empty, breadcrumb рендер; unit на deep‑links.
- Критерии приёмки: тесты зелёные локально/CI, метрики улучшаются согласно целям.

---

## План завершения (оставшиеся спринты и приоритеты)
- Высокий приоритет (Sprint H1): 45.11–45.18
- Средний приоритет (Sprint H2): 45.19–45.23
- Низкий приоритет (Sprint H3): 45.24–45.25

### Задача 45.11: Финальный проход по цветам и spacing
- Файлы: топ‑10 по вхождениям из `design-optimization(after_st44).md` (см. раздел B/C), в т.ч.: `lib/screens/profile_screen.dart`, `lib/screens/level_detail_screen.dart`, `lib/widgets/leo_quiz_widget.dart`, `lib/widgets/skills_tree_view.dart`, `lib/screens/goal/widgets/motivation_card.dart`, `lib/screens/goal_checkpoint_screen.dart`, `lib/screens/leo_chat_screen.dart`, `lib/screens/main_street_screen.dart`.
- Что сделать:
  1) Заменить остатки `Colors.*`/`Color(0x...)` → `AppColor.*`.
  2) Заменить inline `EdgeInsets`/`SizedBox` → токены `AppSpacing`/`insets`/`gap`.
  3) Заменить inline `TextStyle` → `Theme.of(context).textTheme.*`.
- Команды:
```bash
rg -n "Colors\.|Color\(0x" lib | wc -l
rg -n "EdgeInsets\.|SizedBox\(" lib | wc -l
rg -n "TextStyle\(" lib | wc -l
```
- Критерии приёмки: счётчики снижаются до целей метрик; `flutter analyze` без ошибок.

### Задача 45.12: Достандартизировать кнопки
- Файлы: `lib/screens/leo_dialog_screen.dart`, `lib/screens/profile_screen.dart`, остатки в `lib/screens/level_detail_screen.dart`.
- Что сделать:
  1) Перевести все CTA/Action на `BizLevelButton` (варианты/размеры из дизайна).
  2) Иконк‑кнопки — завести `BizLevelIconButton` или унифицировать стили через тему.
- Команды:
```bash
rg -n "ElevatedButton\.styleFrom|TextButton\.styleFrom|OutlinedButton\.styleFrom" lib
```
- Критерии приёмки: отсутствие ручных styleFrom; визуальный паритет.

### Задача 45.13: BizLevelTextField (валидации/состояния)
- Файлы: новый `lib/widgets/common/bizlevel_text_field.dart`; рефактор: `lib/widgets/custom_textfield.dart`, `lib/screens/goal/widgets/*`, `lib/screens/goal_checkpoint_screen.dart`, auth‑экраны.
- Что сделать:
  1) Создать обёртку с токенами отступов/цветов/типографики, состояниями (readOnly/invalid/disabled) и валидатором.
  2) Заменить локальные поля ввода на компонент, не меняя бизнес‑логику.
- Критерии приёмки: единый стиль, корректные ошибки/подсказки, линтер чистый.

### Задача 45.14: BizLevelProgressBar (уровни/навыки/цель)
- Файлы: `lib/widgets/common/bizlevel_progress_bar.dart` (новый); интеграция: `lib/widgets/skills_tree_view.dart`, `lib/screens/goal/widgets/progress_widget.dart`, места прогресса уровней.
- Что сделать:
  1) Унифицированный прогресс‑бар (линейный/круговой опционально) с токенами.
  2) Заменить локальные реализации, сохранив значения и подписи.
- Критерии приёмки: визуальный паритет, меньше дублирования.

### Задача 45.15: BizLevelModal (информационные/подтверждения)
- Файлы: `lib/widgets/common/bizlevel_modal.dart` (новый); рефактор вызовов диалогов: `lib/screens/tower/tower_tiles.dart` (unlock), `lib/screens/gp_store_screen.dart` (verify result), возможные confirm‑диалоги в профиле/целях.
- Что сделать: единый модальный компонент (icon/title/subtitle/actions), токены отступов/типографики/кнопок.
- Критерии приёмки: единый стиль модалок, сокращение дублирования кода.

### Задача 45.16: BizLevelChatBubble (Лео/Макс)
- Файлы: `lib/widgets/common/bizlevel_chat_bubble.dart` (новый); миграция: `lib/widgets/leo_message_bubble.dart`, часть `lib/widgets/leo_quiz_widget.dart`.
- Что сделать: единые стили бублов (assistant/user/system/error), аватары, цвета из темы.
- Критерии приёмки: визуальный паритет, упрощение кастомизаций (Leo/Max).

### Задача 45.17: Единый SnackBar и тексты UI
- Файлы: `lib/main.dart` (SnackBarThemeData донастройка), `lib/theme/ui_strings.dart` (новый).
- Что сделать: стандартизировать длительность/цвета/иконки; вынести часто используемые тексты ошибок/подсказок в `ui_strings.dart`.
- Команды:
```bash
rg -n "ScaffoldMessenger\.of\(.*\)\.showSnackBar" lib
```
- Критерии приёмки: единый стиль сообщений, отсутствие дублирующихся строк.

### Задача 45.18: Back‑UX и deep links
- Файлы: `lib/utils/back_navigator.dart` (новый mixin/утилита), `lib/utils/deep_link.dart` (тесты), `test/deep_links_test.dart` (новый).
- Что сделать: унифицировать поведение back (AppBar/gesture); покрыть парсинг/нормализацию deep links unit‑тестами.
- Команды:
```bash
flutter test -r expanded | cat
```
- Критерии приёмки: предсказуемый back‑UX, тесты DL зелёные.

### Задача 45.19: Success‑состояния (подтверждения и «что дальше»)
- Файлы: `lib/widgets/common/bizlevel_success.dart` (новый); интеграция: `lib/screens/gp_store_screen.dart` (verify), Tower‑unlock, сохранения цели/чек‑ина.
- Что сделать: единый success‑виджет (icon/title/subtitle/CTA), сценарии «продолжить путь» (к башне/следующему шагу).
- Критерии приёмки: консистентные success‑экраны, CTR по CTA измерим.

### Задача 45.20: Полный A11y‑проход
- Файлы: иконки AppBar/Popup/StatCard, списки в библиотеке/целях.
- Что сделать: Semantics для всех интерактивов, min touch‑targets ≥44×44; фокус‑контуры для web.
- Команды:
```bash
rg -n "Semantics\(|semanticsLabel:" lib | wc -l
```
- Критерии приёмки: ручная проверка экран‑ридером, нажатия по иконкам стабильны.

### Задача 45.21: Const/перерисовки/пейнтеры
- Файлы: `lib/screens/biz_tower_screen.dart`, `lib/screens/tower/*`, ключевые экраны со статичными элементами.
- Что сделать: добавить `const` к статик‑виджетам; убедиться в `RepaintBoundary` на тяжёлых слоях; не трогать поведение.
- Команды:
```bash
flutter analyze | cat
```
- Критерии приёмки: снижение предупреждений, отсутствие регрессов перерисовки.

### Задача 45.22: Списки — унификация builder/виртуализация
- Файлы: `lib/screens/gp_store_screen.dart` (короткий список — оставить/опционально builder), ревизия остальных списков.
- Что сделать: где длинные — `ListView.builder`/`Sliver*`, у коротких — оставить как есть.
- Критерии приёмки: отсутствие фризов на длинных списках, неизменённый UX коротких.

### Задача 45.23: Responsive‑доводка
- Файлы: `lib/screens/goal/widgets/*` (weeks_timeline_row, motivation_card, crystallization_section), `lib/widgets/user_info_bar.dart`, `lib/widgets/recommend_item.dart`.
- Что сделать: убрать фиксированные ширины/высоты (120/180/290/420/190) в пользу адаптивных через `Responsive`/constraints.
- Критерии приёмки: отсутствие overflow на узких экранах, читабельность.

### Задача 45.24: Библиотека — полный вывод данных и чистка UI
- Файлы: `lib/screens/library/library_screen.dart`, `lib/screens/library/library_section_screen.dart`, `lib/repositories/library_repository.dart`.
- Что сделать: отобразить всю ключевую информацию карточек (из провайдеров), унифицировать лейаут через `BizLevelCard`, обработать пустые/ошибочные состояния через общие компоненты.
- Критерии приёмки: карточки информативны, состояние покрыто, линтер чистый.

### Задача 45.25: Метрики/тесты/документация (финал)
- Файлы: `docs/design-optimization(after_st44).md`, `docs/status.md`, тесты `test/**`.
- Что сделать: обновить счётчики метрик; добавить финальные записи в статус; добить smoke‑тесты (breadcrumb, состояния, back‑UX, DL‑unit).
- Команды:
```bash
flutter analyze | cat
flutter test -r expanded | cat
rg -n "Colors\.|Color\(0x|TextStyle\(|EdgeInsets\.|SizedBox\(" lib | wc -l
```
- Критерии приёмки: цели метрик достигнуты; тесты зелёные; документация синхронизирована.

# Этап 46: Улучшение UX/UI

## Задача 46.1: Обновление цветовой палитры для профессиональной аудитории
**Файл для изменения:** `lib/theme/color.dart`
**Действия:**
1) Обновить основные цвета:
   - `primary` → `#2563EB`
   - `success` остаётся `#10B981`
   - `premium` → `#7C3AED`
   - `shadowColor` → `Color(0x08000000)` (мягкие тени на mobile)
2) Добавить градиенты‑токены:
   - `businessGradient = LinearGradient(colors: [#2563EB, #7C3AED])`
   - `growthGradient = LinearGradient(colors: [#10B981, #06B6D4])`
   - `achievementGradient = LinearGradient(colors: [#7C3AED, #EC4899])`
3) Подготовка к dark‑mode:
   - `surfaceDark = Color(0xFF1E293B)`, `textDark = Color(0xFFF1F5F9)`
4) Устранить дубли: удалить локальный `AppSpacing` из `color.dart` (оставить единственный в `lib/theme/spacing.dart`).
5) Синхронизировать `levelGradients` с новыми токенами (при необходимости).
**Обоснование:** Синий — доверие/стабильность, зелёный — рост, фиолетовый — инновации.
**Тестирование:** Визуальный проход основных экранов (чат/профиль/башня/логин), проверка контрастности.

## Задача 46.2: Анимированная кнопка (совместно с 46.13 Haptics)
**Создать файл:** `lib/widgets/common/animated_button.dart`
**Принцип:** композиция поверх `BizLevelButton`.
**Действия:**
1) `AnimatedScale` 200ms, масштаб 1.0→0.95, `RepaintBoundary`.
2) `variant=primary` — фон `businessGradient`, остальное — цвета темы.
3) Ripple через `InkWell`.
4) Haptics (light) безопасно, без web (см. 46.13).
5) Минимум 44×44 для всех размеров; довести `sm` до 44.
6) Опция `loading` (индикатор вместо текста).
7) Учитывать `isLowEndDevice` (см. 46.10).
**Тестирование:** iOS/Android — haptic/анимации без лагов; web — без ошибок.

## Задача 46.3: Редизайн чата с ИИ‑тренерами (реюз существующих компонентов)
**Файлы для изменения:** 
- `lib/screens/leo_dialog_screen.dart`
- `lib/widgets/chat_item.dart`
**Действия:**
1) `leo_dialog_screen.dart`:
   - Варианты: мини‑карточки в стиле `BizLevelCard` (padding 12, иконки `lightbulb`/`help`).
   - GP не показывать.
   - Typing: использовать `TypingIndicator` (есть в проекте).
   - Появление сообщений: fade+slide 300ms только для новых элементов.
2) `BizLevelChatBubble`/`LeoMessageBubble`:
   - Ассистент: светлый фон с оттенком `growthGradient` (низкая непрозрачность); на low‑end — сплошной светлый фон.
   - Padding 12–14 для мобильной читабельности.
**Обоснование:** Визуальное разделение ролей и анимации создают более живой и engaging опыт общения с ИИ.
**Тестирование:** Отправить несколько сообщений, проверить плавность анимаций и читаемость на маленьких экранах.

## Задача 46.4: Улучшение видеоплеера для mobile (оверлеи над Chewie/WebView)
**Файл для изменения:** `lib/widgets/lesson_widget.dart`
**Действия:**
1) Контролы (через `Stack` поверх плеера):
   - Минимум 44×44 у кнопок; нижний чёрный градиент 0→0.6 для читабельности;
   - Прогресс‑бар снизу; центральная play/pause с opacity ~0.8.
2) Жесты:
   - Double‑tap ±10 сек (лево/право);
   - Swipe вверх/вниз для громкости (только iOS/Android, без WebView);
   - Tap — показать/скрыть контролы.
3) Overlay‑информация:
   - Заголовок урока сверху (лёгкий градиент подложки);
   - «2/5» прогресс в правом верхнем углу;
   - Индикатор навыка (+1 при завершении) — лёгкая анимация.
4) Учитывать `isLowEndDevice`: упрощать/отключать тяжёлые эффекты.
**Тестирование:** Одноручное управление, контрастность и стабильный FPS, отсутствие конфликтов в WebView режиме.

## Задача 46.5: Анимированное дерево навыков в профиле (2 колонки, лёгкие анимации)
**Файлы:** `lib/widgets/skills_tree_view.dart`, `lib/screens/profile_screen.dart`
**Действия:**
1) `SkillsTreeView`:
   - Разметка: 2 колонки (`GridView`/`Wrap`) на mobile;
   - Индикаторы: `CircularProgressIndicator` или `CustomPaint` для градиента;
   - Staggered‑анимация одного контроллера (~1с);
   - «+1» всплывашка `Fade+Slide` в Overlay; на low‑end отключать.
2) `ProfileScreen`:
   - Поднять блок, добавить заголовок «Дерево навыков» с иконкой info;
   - По tap — bottom sheet с описанием.
**Тестирование:** Плавность и стабильный FPS на мобильных, корректный layout на узких экранах.

## Задача 46.6: Система визуальных наград (с учётом low‑end)
**Создать файлы:** `lib/widgets/common/achievement_badge.dart`, `lib/widgets/common/milestone_celebration.dart`
**Действия:**
1) `achievement_badge.dart`: 48×48 (список) и 80×80 (модалка), рамки по редкости, «shine» редкий (≤1 раз/3с), `RepaintBoundary`.
2) `milestone_celebration.dart`: overlay; конфетти через пакет `confetti` или упрощённый `CustomPainter` с ограничением частиц и длительности (≤2с); счётчик GP — IntTween; кнопка «Продолжить».
3) На low‑end отключать конфетти/shine, оставлять статические версии.
**Тестирование:** Плавность и отсутствие просадок FPS.

## Задача 46.7: GP баланс — общий виджет и интеграция
**Файлы:** `lib/widgets/common/gp_balance_widget.dart` (создать), `lib/screens/profile_screen.dart`, `lib/screens/biz_tower_screen.dart`
**Действия:**
1) Общий виджет: компакт 80×32; число через IntTween; иконка монеты с градиентом на базе `premium`/`achievementGradient`.
2) Интеграция: заменить локальный вывод GP в профиле/башне на общий виджет; «+X GP» — лёгкий overlay‑тост.
**Тестирование:** Единый вид, корректная анимация, адаптивность на узких экранах.

## Задача 46.8: Улучшение экрана входа (mobile‑first)
**Файл для изменения:** `lib/screens/login_screen.dart`
**Действия:**
1) Анимированный фон: `businessGradient` с медленной ротацией (~30с); лёгкие плавающие фигуры (без blur), параллакс только не на low‑end.
2) Форма:
   - Поля ввода ≥48 по высоте, иконки `prefixIcon`/`suffixIcon`;
   - Кнопка «Войти»: `AnimatedButton` (см. 46.2).
3) Social proof (без чисел): текст + логотипы (если есть) + цитата.
**Тестирование:** Читаемость на ярком солнце, скорость загрузки, плавность анимаций.

## Задача 46.9: Welcome tour для новых пользователей
**Создать файл:** `lib/widgets/common/onboarding_tooltip.dart`
**Действия:**
1) Система подсказок:
   - Overlay с вырезом под target, bubble с текстом и указателем;
   - Кнопки «Далее»/«Пропустить тур», индикатор прогресса;
   - Сохранение прогресса локально; на low‑end — без тяжёлых эффектов;
   - Разрешено использовать `showcaseview`/`tutorial_coach_mark` либо свой `OverlayEntry`.
2) 5 шагов тура:
   - «Это ваша Башня БизЛевел — карта вашего основного обучения»
   - «База тренеров — ваши персональные ИИ‑тренеры»
   - «Следите за прогрессом навыков в профиле»
   - «Growth Points (GP) — очки развития для открытия новых возможностей»
   - «Библиотека — бесплатные курсы, гранты и акселераторы для вашего бизнеса»
**Тестирование:** Полный проход, корректная привязка к виджетам на разных размерах экранов.

## Задача 46.10: Оптимизация анимаций для слабых устройств (сквозная)
**Файлы:** `lib/main.dart` и все места с анимациями
**Действия:**
1) В `main.dart`: провайдер/флаг `isLowEndDevice` (если `MediaQuery.devicePixelRatio < 2`).
2) Во всех анимациях:
   - Учитывать флаг, упрощая эффекты: −30% длительности, без parallax/particles/тяжёлых градиентов;
   - Оборачивать тяжёлые слои в `RepaintBoundary`.
**Тестирование:** Замер FPS (DevTools), smoke‑проверка ключевых экранов.

## Задача 46.11: Свайп‑навигация между экранами
**Файл для изменения:** `lib/screens/root_app.dart`
**Действия:**
1) Обернуть body в `PageView`, синхронизировать с `_rootTabProvider` и bottom bar.
2) Кэшировать страницы (оставлять созданные в памяти).
3) Haptic при смене страницы (см. 46.13).
4) Индикатор текущей страницы в bottom bar (опционально).
**Тестирование:** Плавность свайпа, синхронизация с навигацией.

## Задача 46.12: Улучшение Башни БизЛевел (минимально инвазивно)
**Файл для изменения:** `lib/screens/biz_tower_screen.dart`
**Действия:**
1) Усилить пульс текущего уровня (easeInOutCubic, цикл) — переиспользовать имеющуюся анимацию в `LevelCard`.
2) «Искры» на завершённых уровнях — лёгкие маркеры без Canvas‑частиц; включать только не на low‑end и кратко.
3) Автоскролл: сделать кривую плавнее (`Curves.easeInOutCubic`).
4) Заблокированные уровни: оставить полупрозрачный оверлей (без blur); при tap — `BizLevelModal` «Откройте за X GP» + прогресс до следующего этажа.
**Тестирование:** Без фризов при скролле/перерисовках, корректный UX модалок.

## Задача 46.13: Haptic feedback — централизовать и встроить в общие виджеты
**Где:** все интерактивные элементы
**Действия:**
1) Утилита `Haptics` (light/medium/selection/heavy) с безопасными вызовами (без web).
2) Встроить haptic (light) по умолчанию в `BizLevelButton` и `AnimatedButton`; для важных действий — `medium`/`heavy` локально.
3) Для toggle/checkbox — `selection`.
**Тестирование:** iOS/Android — наличие вибрации, отсутствие ошибок на web.

## Задача 46.14: Микроанимации успеха
**Создать файл:** `lib/widgets/common/success_indicator.dart`
**Действия:**
1) «Галочка» на `CustomPainter`, анимация 400ms; зелёный штрих с лёгким градиентом; размеры 24×24 и 48×48.
2) Использовать при завершении уровня, сохранении профиля, правильном ответе в квизе, достижении цели.
**Тестирование:** Плавность, чёткость на разных DPI; на low‑end — уменьшенная длительность.

## Задача 46.15: Улучшение доступности
**Где:** ключевые экраны и общие компоненты
**Действия:**
1) Semantics:
   - Кнопки — описания действий;
   - Изображения — alt‑тексты;
   - Прогресс‑бары — процент завершения.
2) Контрастность: ≥4.5:1 (обычный текст), ≥3:1 (крупный текст); добавить проверки в тесты.
3) Touch targets: минимум 44×44 для всех интерактивов.
**Тестирование:** Экран‑ридер iOS/Android, проверка читаемости и доступности элементов.