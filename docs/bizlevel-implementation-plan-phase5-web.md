# План реализации BizLevel v2.1 – Фаза 19: Web UI и Responsive Design

Цель этапа 19 — превратить текущую «растянутую мобильную» версию в полноценное современное веб-приложение, не затрагивая сборки iOS/Android. Все изменения ограничиваются Flutter-Web таргетом и слоем представления. Задачи разбиты на атомарные операции по аналогии с предыдущими фазами.

## Этап 19: Улучшение Web-версии

### Задача 19.1: Введение `ResponsiveLayout` и брейк-поинтов
- **Файлы:** новый `lib/responsive/responsive_layout.dart`, `lib/main.dart`
- **Компоненты:** `ResponsiveLayout`, `MaterialApp`
- **Что делать:**
  1. Создать виджет `ResponsiveLayout` со статическими брейк-поинтами `mobile < 600`, `tablet 600–1024`, `desktop > 1024`.
  2. Виджет должен выбирать child (`mobile`, `tablet`, `desktop`) на основе `MediaQuery.size.width`.
  3. Обернуть корневой `MaterialApp` в `ResponsiveLayout`, прокинув подходящий layout-builder вниз по дереву через `InheritedWidget`.
- **Почему это важно:** Создаёт фундамент для дальнейших адаптивных изменений без дублирования кода.
- **Проверка результата:** На разных ширинах эмулятора выводится текст «mobile / tablet / desktop» (временные заглушки).

### Задача 19.2: Адаптация `RootApp` под desktop (NavigationRail + TopBar)
- **Файлы:** `lib/screens/root_app.dart`, новый `lib/widgets/desktop_nav_bar.dart`
- **Компоненты:** `NavigationRail`, `BottomNavigationBar`
- **Что делать:**
  1. В `RootApp` определить два layout-варианта: `mobile` — как есть, `desktop` — с `NavigationRail` или верхним `MenuBar`.
  2. Использовать значение из `ResponsiveLayout.of(context)` для выбора варианта.
  3. Вынести десктоп-навигацию в отдельный виджет `DesktopNavBar`.
- **Почему это важно:** Десктоп-пользователи ожидают боковую/верхнюю навигацию вместо mobile bottom bar.
- **Проверка результата:** При ширине окна > 1024 px отображается `NavigationRail`, а нижняя панель скрывается.

### Задача 19.3: Конвертация `LevelsMapScreen` в `SliverGrid`
- **Файлы:** `lib/screens/levels_map_screen.dart`
- **Зависимости:** 19.1
- **Компоненты:** `CustomScrollView`, `SliverGrid`, `SliverGridDelegateWithFlexibleCrossAxisCount`
- **Что делать:**
  1. Заменить существующий `SliverList` на `SliverGrid`.
  2. Количество столбцов рассчитывать от ширины: 1 (mobile), 2 (tablet), 3–4 (desktop, >1400 px).
- **Почему это важно:** Сетка лучше использует горизонтальное пространство на web и выглядит современно.
- **Проверка результата:** Карточки уровней автоматически перестраиваются при изменении ширины окна.

### Задача 19.4: Сделать `LevelCard` адаптивным и добавить hover-эффект
- **Файлы:** `lib/widgets/level_card.dart`
- **Зависимости:** 19.3
- **Компоненты:** `MouseRegion`, `AnimatedContainer`
- **Что делать:**
  1. Изменить конструктор: `width` и `height` → необязательные, по умолчанию 100% ширины ячейки.
  2. При `kIsWeb` и `hover` применять увеличение тени и лёгкий масштаб `scale: 1.03`.
  3. Добавить `cursor: SystemMouseCursors.click`.
- **Почему это важно:** Hover-обратная связь критична для UX на десктопе.
- **Проверка результата:** Наведя курсор на карточку в браузере, пользователи видят анимацию.

### Задача 19.5: Глобальная типографика и spacing для desktop
- **Файлы:** `lib/theme/color.dart`, `lib/main.dart` (ThemeData)
- **Компоненты:** `ThemeData.textTheme`
- **Что делать:**
  1. В `ThemeData` создать расширения `displayLargeDesktop`, `bodyMediumDesktop`.
  2. При `desktop` брейк-поинте увеличивать базовый `fontSize` на 2 pt.
  3. Внести переменные отступов `AppSpacing.small/medium/large` и заменить жёсткие `EdgeInsets` в 3-4 ключевых виджетах.
- **Почему это важно:** Делает интерфейс пропорциональным и читабельным на больших экранах.
- **Проверка результата:** При переключении брейк-поинтов шрифты и отступы плавно меняются.

### Задача 19.6: Чистые URL и стратегия путей для Web
- **Файлы:** `lib/main.dart`, `lib/routing/app_router.dart`, `pubspec.yaml`
- **Компоненты:** `go_router`, `setPathUrlStrategy`
- **Что делать:**
  1. Импортировать `package:flutter_web_plugins/url_strategy.dart` и вызвать `setPathUrlStrategy()` в `main()` только для web.
  2. Убедиться, что `GoRouter` использует `path` URL без `#`.
- **Почему это важно:** SEO-дружественные и чистые URL — стандарт де-факто для веб-приложений.
- **Проверка результата:** Открывая `/levels/3` в браузере, пользователь видит контент без хэша.

### Задача 19.7: PWA-метаданные и manifest обновление
- **Файлы:** `web/manifest.json`, `web/index.html`
- **Компоненты:** PWA manifest, meta-теги
- **Что делать:**
  1. Добавить `description`, `theme_color`, `background_color`, иконки 512 px.
  2. Вставить meta-теги `viewport`, `og:` для соц-шеринга.
  3. Проверить через Lighthouse и добиться PWA score > 90.
- **Почему это важно:** Улучшает возможности установки приложения и повышает рейтинг Lighthouse.
- **Проверка результата:** Lighthouse PWA аудит показывает зелёные галочки по манифесту.
