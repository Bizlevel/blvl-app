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
