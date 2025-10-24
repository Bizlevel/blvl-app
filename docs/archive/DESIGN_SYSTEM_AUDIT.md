# Аудит дизайн-системы БизЛевел
Дата: 2025-10-23
Версия: 1.0.6+6

## 1. Общая информация
- **Фреймворк**: Flutter (SDK >= 3.0.0)
- **Основные платформы**: iOS, Android, Web
- **Breakpoints (ResponsiveFramework)**: 320 (MOBILE), 600 (TABLET, autoScale), 1024 (DESKTOP, autoScale)
- **Количество экранов**: 39 (см. Приложение C)
- **Количество кастомных компонентов**: 43 (см. Приложение B)

## 2. Цветовая система
Исходник: `lib/theme/color.dart`. Базовые токены и алиасы.

- **Primary colors**:
  - primary: `#2563EB` — кнопки, акценты, прогресс-бары, иконки активных вкладок (`AppShell`, `BizLevelButton`, `DesktopNavBar`).
  - primaryDark: (отдельного токена нет). В градиентах используется связка `#2563EB` → `#4338CA`/`#62B4FF`.
  - primaryLight: (не выделен отдельно). Фоновые градиенты содержат оттенки `#F0F4FF`/`#DDE8FF`.

- **Secondary colors**:
  - premium: `#7C3AED` — премиальные состояния, градиенты достижений/уровней.

- **Semantic colors**:
  - success: `#10B981` — индикаторы успеха, градиенты (`SuccessIndicator`, `growthGradient`).
  - warning: `#F59E0B` — предупреждения, градиенты уровней.
  - error: `#DC2626` — ошибки, тексты ошибок, варианты кнопок danger.
  - info: `#3B82F6` — информационные состояния, системные пузыри чата.

- **Background colors**:
  - appBackground/appBgColor: `#FAFBFC` — фон `Scaffold`/страниц.
  - surface: `#FFFFFF` — карточки, модальные окна, `DesktopNavBar`.
  - card: alias на `surface`.
  - bottomBarColor: alias на `surface`.
  - appBarColor: `#F1F5F9` — фон аппбара (прозрачен по теме, но токен присутствует).

- **Text colors**:
  - textPrimary/onSurface: `#0F172A` — основной текст.
  - textSecondary/onSurfaceSubtle/labelColor: `#94A3B8` — вторичный текст, подписи.
  - textDisabled: (отдельного токена нет). В коде часто используется `Colors.grey`.
  - onPrimary: `#FFFFFF` — текст/иконки на primary/опасных кнопках.
  - glassTextColor/glassLabelColor: `#FFFFFF` — для «стеклянных» поверхностей.

- **Borders/Dividers/Shadows**:
  - borderColor: `#CBD5E1`
  - dividerColor: `#E2E8F0`
  - shadowColor/shadow: `#08000000` (8% чёрный)

- **Градиенты и спец‑токены**:
  - bgGradient: `#F0F4FF → #DDE8FF` — глобальный фон приложения (в `main.dart`).
  - businessGradient: `#2563EB → #7C3AED` — primary‑кнопки (вариант в `AnimatedButton`).
  - growthGradient: `#10B981 → #06B6D4` — прогресс/рост.
  - achievementGradient: `#7C3AED → #EC4899` — эпические достижения.
  - levelCardBg: `#809FC5E8` (50% прозрачность) — фон карточек уровней.
  - levelGradients: пресеты для карточек уровней (см. файл).

- **Dark-mode подготовка**:
  - surfaceDark: `#1E293B`, textDark: `#F1F5F9` — токены есть, но dark theme не активна.

- **Жёстко заданные цвета вне темы** (неполный список):
  - `lib/screens/auth/login_screen.dart`: фоновые градиенты (`#F0F4FF/#DDE8FF`, `#E0F2FE/#EDE9FE`).
  - `lib/widgets/skills_tree_view.dart`: палитра навыков (`#7C3AED`, `#F59E0B`, `#FB923C`, `#3B82F6`, `#10B981`, `#6366F1`).
  - `lib/widgets/common/notification_center.dart`: фон баннеров (`#E6F6ED`, `#E8F0FE`, `#FFF4E5`, `#FFEBEE`).
  - `lib/widgets/common/achievement_badge.dart`: бордеры/градиенты (`#06B6D4`, `#9333EA`, белые маски).
  - `lib/screens/gp_store_screen.dart`: бордер `#E2E8F0`.
  - `lib/widgets/common/gp_balance_widget.dart`: бордер `#E5E7EB`.

## 3. Типографика
Исходник: `lib/theme/typography.dart`. Базовая система на `TextTheme` с системным шрифтом платформы (кастомные шрифты в `pubspec.yaml` не определены).

- **Шрифты**:
  - Основной шрифт: системный (iOS SF Pro / Android Roboto / Web platform default)
  - Дополнительные: отсутствуют (не подключены в `pubspec.yaml`).

- **Размеры текста и стили**:
  - h1 displayLarge: 34, w700, height 1.2
  - h2 displayMedium: 30, w700, 1.25
  - h3 displaySmall: 26, w700, 1.25
  - headlineLarge: 24, w600, 1.25
  - headlineMedium: 22, w600, 1.25
  - headlineSmall: 20, w600, 1.25
  - titleLarge: 18, w600, 1.3
  - titleMedium: 16, w600, 1.3
  - titleSmall: 14, w600, 1.3
  - bodyLarge: 16, w400, 1.5
  - bodyMedium: 14, w400, 1.5
  - bodySmall: 12, w400, 1.5
  - labelLarge: 14, w600, 1.2
  - labelMedium: 12, w600, 1.2
  - labelSmall: 11, w600, 1.2

- **Особенности**:
  - Desktop (>=1024px): в рантайме увеличиваются `displayLarge` (+2pt) и `bodyMedium` (+2pt) в `main.dart`.
  - Letter spacing явно не задан.

## 4. Библиотека компонентов
Каталог: `lib/widgets/**` и `lib/widgets/common/**`. Ниже — ключевые компоненты (полный перечень в Приложении B).

- **Компонент**: BizLevelButton
  - Файл: `lib/widgets/common/bizlevel_button.dart`
  - Описание: Единый API для кнопок (primary/secondary/outline/text/link/danger), размеры sm/md/lg, иконка, fullWidth.
  - Параметры стиля: minSize 44–56; padding 12–14 v, 12–20 h; radius 8; цвета из `AppColor` (primary/onPrimary, borderColor, surface); состояния disabled через Material.
  - Состояния: default/disabled; touch feedback через haptic в обёртках.
  - Где используется: глобально на экранах и в модалках.

- **Компонент**: AnimatedButton
  - Файл: `lib/widgets/common/animated_button.dart`
  - Описание: Анимированная кнопка с ScaleTransition и градиентной заливкой для primary.
  - Параметры стиля: gradient `businessGradient`; minHeight ≥44; padding 16×12; radius 8.
  - Состояния: loading (инлайн `CircularProgressIndicator`), нажатие с масштабированием.
  - Где используется: экраны авторизации и CTA.

- **Компонент**: BizLevelCard
  - Файл: `lib/widgets/common/bizlevel_card.dart`
  - Описание: Базовая карточка с семантикой и опциональным InkWell.
  - Параметры стиля: padding 16; radius 12; elevation 2; shadow `AppColor.shadow`; цвет `surface`; бордер опционально.
  - Состояния: hover/pressed через Material/InkWell.

- **Компонент**: BizLevelTextField / CustomTextBox
  - Файлы: `lib/widgets/common/bizlevel_text_field.dart`, `lib/widgets/custom_textfield.dart`
  - Описание: Лейбл + текстовое поле; собственный контейнер с фоном и тенью.
  - Параметры стиля: высота min 48; padding 12×10; radius 10; фон `textBoxColor` или `grey.shade100` в readOnly; тень 5% чёрного.
  - Состояния: readOnly (мягкий фон), ошибка (текст `AppColor.error`).

- **Компонент**: BizLevelModal
  - Файл: `lib/widgets/common/bizlevel_modal.dart`
  - Описание: AlertDialog с опциональной иконкой и primary‑кнопкой.
  - Параметры стиля: цвет иконки `primary`; заголовок w600.

- **Компонент**: BizLevelProgressBar
  - Файл: `lib/widgets/common/bizlevel_progress_bar.dart`
  - Описание: Линейный прогресс, анимируется через TweenAnimationBuilder.
  - Параметры стиля: minHeight 6; цвет по умолчанию `primary`, bg = 20% alpha.

- **Компонент**: BizLevelLoading
  - Файл: `lib/widgets/common/bizlevel_loading.dart`
  - Описание: Спиннеры fullscreen/inline/sliver.
  - Параметры стиля: фон экрана `appBgColor`.

- **Компонент**: BizLevelChatBubble
  - Файл: `lib/widgets/common/bizlevel_chat_bubble.dart`
  - Описание: Пузыри сообщений для ролей user/assistant/system/error.
  - Цвета: user — `primary/onPrimary`; assistant — `surface/onSurface`; system — `info` с 8%; error — `error` 8% bg/`error` fg.

- **Компонент**: BottomBarItem / DesktopNavBar
  - Файлы: `lib/widgets/bottombar_item.dart`, `lib/widgets/desktop_nav_bar.dart`
  - Описание: Элементы нижней навигации (моб.) и боковой NavigationRail (desktop).
  - Параметры стиля: barColor `surface`; activeColor `primary`; тени с `shadowColor`.
  - Особенности: blur в NavigationRail только на Web.

- Прочие: achievement_badge, success_indicator, notification_center, gp_balance_widget, level_card, typing_indicator, artifact_card/viewer, quiz/leo_quiz_widget и др. (см. Приложение B с путями).

## 5. Экраны и навигация
- **Тип навигации**: GoRouter с ShellRoute (табы) + PageView на базовых вкладках (моб.), NavigationRail (desktop).
- **Структура**:
  - Главные разделы (табы): `/home`, `/goal`, `/artifacts`, `/profile` в `AppShell`.
  - Вложенные экраны: уровни (`/levels/:id`), библиотека, чат Лео, башня, чекины, магазин GP и др.
  - Гейтинг доступа: `/goal` доступен при `currentLevel >= 2`.
- **Переходы**:
  - Глобально: FadeUpwards (обычно) или Zoom (на low-end девайсах, эвристика DPR/Accessibility).
  - Длительность: дефолт Material (не переопределяется явно).
- **Навигационные элементы**:
  - Mobile: Bottom bar с дополнительной плавающей кнопкой чата Лео.
  - Desktop: NavigationRail (blur на Web), контент справа.

Для каждого экрана — кратко (детали по коду):
- MainStreet (`lib/screens/main_street_screen.dart`): Домашняя сцена; сетка основных действий; фон — градиент `appBgColor` → 80%.
- LeoChat (`lib/screens/leo_chat_screen.dart`): Чат с ассистентом; пузыри ролей; индикатор печати.
- Goal (`lib/screens/goal_screen.dart`): Работа с целью; виджеты: checkin_form, motivation_card, practice_journal_section.
- GoalHistory, GoalCheckpoint: истории и версии/контрольные точки.
- BizTower (`lib/screens/biz_tower_screen.dart` + `tower/*`): Карта уровней; собственные painters, tiles, grid, constants.
- LevelDetail: просмотр уровня и уроков (включая `LessonWidget`).
- Artifacts: артефакты, просмотрщик (`artifact_viewer`).
- Library/LibrarySection: библиотека контента.
- Profile: профиль пользователя и настройки.
- NotificationsSettings: лист с настройкой напоминаний (bottom sheet).
- Auth: login/register/onboarding.
- GP Store: покупки монет.
- Mini Case: мини‑кейсы.

## 6. Визуальные ассеты
- **Набор иконок**: `flutter_svg` + `assets/icons/*.svg` (включая `goal.svg`, `home.svg`, `chat.svg`, и др.).
- **Кастомные иконки**: есть, лежат в `assets/icons/` и вложенных папках.
- **Размеры иконок**: часто 24–26dp (bottom bar), 64dp (карточки). Не централизовано.
- **Изображения**: форматы PNG и SVG (аватары, артефакты, улица, уровни); локальные ассеты.
- **Оптимизация**:
  - Сетевые изображения — через `cached_network_image` (в проекте имеется зависимость; фактическое использование точечно).
  - Лоадеры/скелетоны — `shimmer`.

## 7. Анимации
- **Микроанимации**:
  - Кнопки: нажатие (Scale, 200ms, easeOut) в `AnimatedButton`.
  - Прогресс: tween 600ms easeOut в `BizLevelProgressBar`.
  - Иконка успеха: 400ms easeOutCubic в `SuccessIndicator`.
  - Бейдж достижения: shine 800ms easeOutCubic один раз.
  - BottomBarItem: AnimatedContainer 300ms fastOutSlowIn.
  - Разное: AnimatedOpacity/AnimatedScale в ряде виджетов.
- **Переходы между экранами**: Material FadeUpwards/Zoom (см. раздел Навигация).
- **Loading states**: `BizLevelLoading` (fullscreen/inline/sliver), `CircularProgressIndicator` в кнопках/контенте.

## 8. Spacing и Layout
Исходник: `lib/theme/spacing.dart`.
- **Токены**:
  - xs: 4
  - sm: 8
  - md: 12
  - lg: 16
  - xl: 24
  - 2xl: 32 (x2l)
  - 3xl: 48 (x3l)
- **Утилиты**: `insetsAll`, `insetsSymmetric`, `gapH`, `gapW`.
- **Применение**: используются частично; много мест применяют «магические» значения (например, 12/16/24 локально без токенов).

## 9. Уникальные элементы БизЛевел
- **GP индикаторы**: `GpBalanceWidget` (80×32, border `#E5E7EB`, svg монеты, анимируемый счёт).
- **Прогресс уровней**: `BizLevelProgressBar` и визуал в `tower/*` с градиентами уровня, тенью и бордерами.
- **Башня**: собственные painters/tiles/grid; константы размеров и стилей в `tower_constants.dart` (радиусы, тени, толщины путей, альфы).
- **Чат интерфейс**: `BizLevelChatBubble` с различными ролями и цветами; `typing_indicator` присутствует.

## 10. Проблемы консистентности
- **Несоответствия в цветах**:
  - Смешение `AppColor.*` и жёстко заданных HEX в экранах (`login_screen`, `skills_tree_view`, баннеры уведомлений, бордеры в GP).
  - Вторичный текст часто через `Colors.grey` вместо `AppColor.labelColor`.
- **Несоответствия в размерах**:
  - Иконки в bottom bar (26dp) vs. карточки (64dp) — допустимо, но нет токенов размеров иконок.
- **Несоответствия в отступах**:
  - Во многих местах отступы как «магические» значения (например, 12/16/24), хотя есть `AppSpacing`.
- **Дублирование стилей**:
  - Кнопки: `AnimatedButton` и `BizLevelButton` пересекаются по ответственности; градиент для primary реализован отдельно.
  - Поля ввода: `BizLevelTextField` + `CustomTextBox` с собственной рамкой/фоном, частично дублируя `Theme.inputDecorationTheme`.

## 11. Technical Debt в дизайне
- **Хардкод стилей**:
  - Градиенты/HEX вне темы: см. список в Цветовой системе.
  - `CustomTextBox`: цвета/тени и placeholder через `Colors.grey`.
- **Неиспользуемые/редко используемые токены**:
  - `AppColor.appBarColor` почти не применяется, так как AppBar прозрачный.
  - `surfaceDark/textDark` не используются (нет dark theme).
- **TODO/FIXME, дизайн‑заметки**:
  - По коду явных TODO/FIXME по дизайну не найдено (поиском).
- **Тема**:
  - Нет явного `ThemeData.dark`; часть тёмных токенов подготовлена.
  - Отсутствуют централизованные размеры иконок/радиусов (кроме башни).

## 12. Рекомендации для дизайн‑аудита
Основные области для улучшения:
1. Вынести все HEX/градиенты в `AppColor` и использовать только токены (устранить хардкод).
2. Централизовать размеры: ввести токены для размеров иконок, карточек, кнопок; усилить применение `AppSpacing`.
3. Свести кнопки к одной реализации: объединить `AnimatedButton` с `BizLevelButton` (вариант стилей «gradientPrimary»).
4. Унифицировать текстовые поля: опереться на `InputDecorationTheme` и минимизировать собственные контейнеры.
5. Добавить поддержку Dark Theme (на основе существующих `surfaceDark/textDark`) и проверить контрасты.
6. Описать анимационные токены (длительности, кривые) и применить их единообразно.
7. Документировать и закрепить правила для Desktop/Web (масштаб шрифтов, blur‑эффекты) и mobile.

## Приложения
### A. Список всех файлов стилей
- `lib/theme/color.dart`
- `lib/theme/typography.dart`
- `lib/theme/spacing.dart`
- `lib/theme/ui_strings.dart`

### B. Список всех компонентов (основные)
- См. `lib/widgets/**` и `lib/widgets/common/**` (всего ~43):
  - `common/`: achievement_badge.dart, animated_button.dart, bizlevel_button.dart, bizlevel_card.dart, bizlevel_chat_bubble.dart, bizlevel_empty.dart, bizlevel_error.dart, bizlevel_loading.dart, bizlevel_modal.dart, bizlevel_progress_bar.dart, bizlevel_text_field.dart, breadcrumb.dart, gp_balance_widget.dart, milestone_celebration.dart, notification_center.dart, onboarding_tooltip.dart, success_indicator.dart
  - Корень `widgets/`: artifact_card.dart, artifact_viewer.dart, bottombar_item.dart, category_box.dart, chat_item.dart, chat_notify.dart, custom_image.dart, custom_textfield.dart, desktop_nav_bar.dart, feature_item.dart, floating_chat_bubble.dart, goal_version_form.dart, leo_message_bubble.dart, leo_quiz_widget.dart, lesson_widget.dart, level_card.dart, notification_box.dart, quiz_widget.dart, recommend_item.dart, reminders_settings_sheet.dart, setting_box.dart, setting_item.dart, skills_tree_view.dart, stat_card.dart, typing_indicator.dart, user_info_bar.dart

### C. Карта экранов
- `lib/routing/app_router.dart` — GoRouter, ShellRoute, редиректы, гейтинг.
- Экраны (39): `app_shell.dart`, `main_street_screen.dart`, `leo_chat_screen.dart`, `goal_screen.dart`, `goal_history_screen.dart`, `goal_checkpoint_screen.dart`, `biz_tower_screen.dart` (+ `tower/*`), `level_detail_screen.dart`, `levels_map_screen.dart`, `artifacts_screen.dart`, `library/library_screen.dart`, `library/library_section_screen.dart`, `profile_screen.dart`, `gp_store_screen.dart`, `notifications_settings_screen.dart`, `mini_case_screen.dart`, `auth/login_screen.dart`, `auth/register_screen.dart`, `auth/onboarding_*`, `payment_screen.dart`, `root_app.dart`, и др. по списку `lib/screens/**`.

— Конец отчёта —


