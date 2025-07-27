# План реализации BizLevel v2.1 – Фаза 19: Web UI и Responsive Design

Цель этапа 19 — превратить текущую «растянутую мобильную» версию в полноценное современное веб-приложение, не затрагивая сборки iOS/Android. Все изменения ограничиваются Flutter-Web таргетом и слоем представления. Задачи разбиты на атомарные операции по аналогии с предыдущими фазами.

## Этап 19: Улучшение Web-версии

### Задача 19.1: Адаптация `ResponsiveFramework` и брейк-поинтов
- **Файлы:** `lib/main.dart`
- **Компоненты:** `ResponsiveWrapper`, `MaterialApp`
- **Что делать:**
  1. Удалить ограничение `maxWidth: 480` в конфигурации `ResponsiveWrapper.builder`.
  2. Задать новые брейк-поинты: `mobile < 600`, `tablet 600–1024`, `desktop > 1024` (использовать `ResponsiveBreakpoint.resize/autoScale`).
  3. При необходимости прокинуть текущий breakpoint вниз по дереву через `InheritedWidget`/провайдер, **без** создания отдельного `ResponsiveLayout` виджета.
- **Почему это важно:** Позволяет активировать desktop-layout без дублирования логики и конфликтов с уже используемым `responsive_framework`.
- **Проверка результата:** При изменении ширины окна `LevelsMapScreen` меняет количество колонок, а в debug-overlay `ResponsiveFramework` отображается корректное название breakpoint.

### Задача 19.2: Адаптация `RootApp` под desktop (NavigationRail + TopBar)
- **Файлы:** `lib/screens/root_app.dart`, новый `lib/widgets/desktop_nav_bar.dart`
- **Компоненты:** `NavigationRail`, `BottomNavigationBar`
- **Что делать:**
  1. В `RootApp` определить два layout-варианта: `mobile` — как есть, `desktop` — с `NavigationRail` или верхним `MenuBar`.
  2. Использовать `ResponsiveBreakpoint.of(context).name` (или провайдер из 19.1) для выбора варианта.
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


---

## Этап 20: Имплементация по результатам аудита

Этот этап направлен на устранение проблем и реализацию улучшений, выявленных в ходе полного технического аудита проекта. Задачи сгруппированы по приоритету.

#### Задача 20.1: Создание юнит-теста для `PaymentService`
- **Файлы:** `test/services/payment_service_test.dart` (новый)
- **Компоненты:** `PaymentService`, `mocktail`
- **Что делать:**
  1. Создать моки для `SupabaseClient` и `FunctionsClient`.
  2. Написать тест для `startCheckout`, который проверяет:
     - Вызов Edge Function `create-checkout-session` с корректными параметрами.
     - Возврат `PaymentRedirect` при успешном выполнении.
     - Генерацию `PaymentFailure` при ошибке.
- **Почему это важно:** Покрытие тестами критически важной логики монетизации.
- **Проверка результата:** `flutter test test/services/payment_service_test.dart` выполняется успешно.

#### Задача 20.2: Удаление неиспользуемых ассетов
- **Файлы:** все файлы в `assets/icons/` и `assets/icons/categories/`
- **Что делать:**
  1. Удалить все неиспользуемые SVG-иконки, перечисленные в отчете `КОД_АНАЛИЗ.md`.
  2. Удалить файл `lib/utils/data.dart`, который содержит тестовые данные.
  3. Выполнить `flutter pub get`.
- **Почему это важно:** Уменьшение размера приложения и устранение "мусора" из проекта перед рефакторингом.
- **Проверка результата:** Проект компилируется, тесты проходят. Поиск удаленных файлов ничего не находит.

#### Задача 20.3: Переименование пакета в `pubspec.yaml` и обновление импортов
- **Файлы:** `pubspec.yaml`, все `*.dart` файлы в `lib/` и `test/`
- **Что делать:**
  1. В `pubspec.yaml` изменить `name: online_course` на `name: bizlevel`.
  2. Выполнить `flutter pub get`.
  3. Используя IDE, выполнить глобальный поиск и замену `package:online_course/` на `package:bizlevel/`.
- **Почему это важно:** Центральный шаг для переименования Flutter-пакета.
- **Проверка результата:** `flutter analyze` и `flutter test` проходят без ошибок.

#### Задача 20.4: Переименование `applicationId` и `namespace` для Android
- **Файлы:** `android/app/build.gradle`
- **Что делать:**
  1. Изменить `namespace "com.sangvaleap.online_course"` на `namespace "kz.bizlevel.app"`.
  2. Изменить `applicationId "com.sangvaleap.online_course"` на `applicationId "kz.bizlevel.app"`.
- **Почему это важно:** Приведение идентификатора Android-приложения в соответствие с новым брендом.
- **Проверка результата:** Приложение запускается на Android-эмуляторе.

#### Задача 20.5: Рефакторинг пути и контента `MainActivity.kt`
- **Файлы:** `android/app/src/main/kotlin/com/sangvaleap/online_course/MainActivity.kt`
- **Что делать:**
  1. Переместить `MainActivity.kt` в новую директорию: `android/app/src/main/kotlin/kz/bizlevel/app/`.
  2. В `MainActivity.kt` изменить объявление пакета на `package kz.bizlevel.app`.
- **Почему это важно:** Путь к файлу и объявление пакета должны соответствовать `applicationId`.
- **Проверка результата:** Проект успешно собирается для Android.

#### Задача 20.6: Обновление остальных конфигураций Android и iOS
- **Файлы:** `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`, `android/app/proguard-rules.pro`
- **Что делать:**
  1. В `AndroidManifest.xml` изменить `android:label="online_course"` на `android:label="BizLevel"`.
  2. В `ios/Runner/Info.plist` изменить значение `CFBundleName` на `BizLevel`.
  3. В `android/app/proguard-rules.pro` обновить правило: `-keep class kz.bizlevel.app.** { *; }`.
- **Почему это важно:** Финализация переименования на нативных платформах.
- **Проверка результата:** Название приложения "BizLevel" корректно отображается на обоих устройствах.

#### Задача 20.7: Расширение тестового покрытия для репозиториев
- **Файлы:** `test/repositories/levels_repository_test.dart`, `test/repositories/lessons_repository_test.dart` (новые)
- **Что делать:**
  1. Создать юнит-тесты для `LevelsRepository` и `LessonsRepository`.
  2. Использовать `mocktail` для моков `SupabaseClient` и `Hive`.
  3. Проверить корректность получения данных и взаимодействия с локальным кешем.
- **Почему это важно:** Обеспечение надежности слоя данных, включая логику кеширования.
- **Проверка результата:** Новые тесты успешно проходят.

#### Задача 20.8: Оптимизация конфигурации Sentry
- **Файлы:** `lib/main.dart`
- **Что делать:**
  1. Внутри `SentryFlutter.init` изменить `..tracesSampleRate = 1.0` на `..tracesSampleRate = kReleaseMode ? 0.3 : 1.0`.
- **Почему это важно:** Снижение затрат на Sentry в production, сохраняя полную трассировку для разработки.
- **Проверка результата:** Изменение внесено корректно.

## Этап 21: Визуальный ребрендинг BizLevel

Этот этап посвящён внедрению фирменного стиля BizLevel (цвета, логотип, графика) без изменения UX-флоу. Все задачи основаны на рекомендациях UI-ревью.

#### Задача 21.1: Обновление палитры и ThemeData
- **Файлы:** `lib/theme/color.dart`, `lib/main.dart`
- **Компоненты:** `AppColor`, `ThemeData`, `ElevatedButtonTheme`, `SnackBarTheme`
- **Что делать:**
  1. Переписать значения констант в `AppColor` под новую палитру:
     - `primary = #4338CA` (индиго)
     - `success = #10B981` (изумрудный)
     - `premium = #F59E0B` (янтарно-золотой)
     - `error = #DC2626`, `info = #3B82F6`, `warning = #F59E0B`
     - Фоны: `#FAFBFC`, `#F1F5F9`, `#E2E8F0`
     - Текст: `#0F172A`, `#475569`, `#94A3B8`
     - Границы/делители: `#CBD5E1`, `#E2E8F0`
  2. Добавить `levelGradients` (6 LinearGradient) в `color.dart`, используя новую схему (см. задачу 21.2).
  3. В `main.dart` обновить `ThemeData` (ElevatedButtonTheme, SnackBarTheme) под новые цвета, убедиться, что контрастность WCAG AA.
- **Почему это важно:** Премиальная палитра усиливает бренд-идентичность и снижает визуальную усталость.
- **Проверка результата:** После перекомпиляции все экраны используют новую цветовую схему.

#### Задача 21.2: Градиенты карточек уровней
- **Файлы:** `lib/widgets/level_card.dart`, `lib/theme/color.dart`
- **Компоненты:** `LevelCard`, `levelGradients`
- **Что делать:**
  1. Наполнить `levelGradients` следующими значениями:
     - Бесплатные уровни: `LinearGradient(135°, #4338CA → #5B21B6)`
     - Продвинутые (4-10):
       - `#4338CA → #2563EB`
       - `#2563EB → #3B82F6`
       - `#3B82F6 → #06B6D4`
     - Премиум-уровни: `#F59E0B → #EF4444`
  2. В `LevelCard` выбрать градиент по индексу либо по флагу `isPremium`.
- **Почему это важно:** Приглушённые, но насыщенные градиенты подчёркивают прогрессию и премиум-уровни.
- **Проверка результата:** Карта уровней демонстрирует обновлённые градиенты без потери читаемости.

#### Задача 21.3: Обложки уровней в Supabase Storage
- **Файлы:** миграция `supabase/migrations/20250801_add_cover_path_to_levels.sql`, `lib/repositories/levels_repository.dart`
- **Компоненты:** таблица `levels.cover_path`, bucket `level_covers`
- **Что делать:**
  1. Добавить колонку `cover_path TEXT` и RLS-правила.
  2. Загрузить изображения `level_<id>.jpg` в bucket `level_covers`.
  3. В `LevelsRepository` запрашивать подписанный URL для `cover_path`.
- **Почему это важно:** Визуальное различие уровней и привлекательность контента.
- **Проверка результата:** На карте уровней отображаются реальные обложки.

#### Задача 21.4: Выбор аватара из набора
- **Файлы:** `assets/images/avatars/` (10 PNG/SVG), `pubspec.yaml`, `lib/screens/profile_screen.dart`, `lib/services/auth_service.dart`, миграция Supabase (`avatar_id` INT)
- **Компоненты:** сетка выбора, сохранение ID
- **Что делать:**
  1. Подготовить 10 иллюстративных аватаров (например, generatedavatars.io / DiceBear) и положить в `assets/images/avatars/` с именами `avatar_0.png` … `avatar_9.png`; добавить в `pubspec.yaml`.
  2. В `ProfileScreen` отобразить модальное окно/BottomSheet с `GridView` аватаров; выбранный отмечается рамкой.
  3. При выборе сохранять `avatar_id` (0–9) в колонку `users.avatar_id` (INT) вместо загрузки файла.
  4. При отображении профиля показывать картинку по `avatar_id`; если null — показывать placeholder.
- **Почему это важно:** Избавляет от сложностей загрузки файлов и даёт быстрый выбор, подходящий для MVP.
- **Проверка результата:** Пользователь выбирает один из 10 аватаров, изображение сохраняется и отображается после перезапуска.

#### Задача 21.5: Интеграция логотипа BizLevel
- **Файлы:** `assets/images/logo_dark.png`, `assets/images/logo_light.png`, `pubspec.yaml`, `lib/screens/auth/login_screen.dart`, `lib/screens/root_app.dart`, `android/app/src/main/res/drawable-v21/launch_background.xml`, `ios/Runner/Assets.xcassets/LaunchImage.imageset`
- **Компоненты:** логотип на сплэш, в AppBar и Login
- **Что делать:**
  1. Добавить логотипы в assets и подключить в `pubspec.yaml`.
  2. Заменить плейсхолдер на логотип на экране Login.
  3. В AppBar карты уровней отрисовать мини-версию логотипа слева.
  4. Обновить launch screen для iOS/Android.
- **Почему это важно:** Закрепляет идентичность бренда при первом контакте.
- **Проверка результата:** Логотип виден на сплэше и ключевых экранах.

#### Задача 21.6: Рефакторинг иконок
- **Файлы:** `assets/icons/`, скрипт перекраски (опционально), `lib/widgets/*`
- **Компоненты:** SVG-иконки
- **Что делать:**
  1. Перекрасить актуальные SVG-иконки в `currentColor` или прямой цвет Primary.
  2. Удалить папку `assets/icons/categories` и неиспользуемые файлы.
  3. При необходимости применить `colorFilter` для адаптации под тему.
- **Почему это важно:** Консистентность и уменьшение размера приложения.
- **Проверка результата:** Все иконки имеют единый стиль, ненужные ресурсы отсутствуют.

---
