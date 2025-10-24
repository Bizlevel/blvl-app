# Артефакт 1: Технические исправления кода дизайн-системы БизЛевел

## 1. КРИТИЧЕСКИЕ ИСПРАВЛЕНИЯ (День 1)

### 1.1 Унификация цветовой системы

#### Файл: `lib/theme/color.dart`
**Проблема:** 65+ хардкод цветов разбросаны по проекту
**Действия:**
```dart
// Добавить недостающие цветовые токены:
static const Color textTertiary = Color(0xFF64748B); // Заменить #94A3B8 для лучшего контраста
static const Color warmAccent = Color(0xFFF59E0B); // Теплый акцент для CTA
static const Color backgroundSuccess = Color(0xFFE6F6ED);
static const Color backgroundInfo = Color(0xFFE8F0FE);
static const Color backgroundWarning = Color(0xFFFFF4E5);
static const Color backgroundError = Color(0xFFFFEBEE);
static const Color borderSubtle = Color(0xFFE5E7EB);
static const Color borderStrong = Color(0xFFE2E8F0);

// Создать класс для градиентов:
class AppGradients {
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF4338CA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
  );
  static const premiumGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
  );
  static const warmGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFB923C)],
  );
  static const backgroundGradient = LinearGradient(
    colors: [Color(0xFFF0F4FF), Color(0xFFDDE8FF)],
  );
}
```

#### Замены хардкод цветов:
- `lib/screens/auth/login_screen.dart`: Заменить `#F0F4FF/#DDE8FF` → `AppGradients.backgroundGradient`
- `lib/widgets/skills_tree_view.dart`: Вынести палитру навыков в `AppColor.skillColors`
- `lib/widgets/common/notification_center.dart`: Заменить `#E6F6ED` → `AppColor.backgroundSuccess`
- `lib/screens/gp_store_screen.dart`: Заменить `#E2E8F0` → `AppColor.borderStrong`
- `lib/widgets/common/gp_balance_widget.dart`: Заменить `#E5E7EB` → `AppColor.borderSubtle`

### 1.2 Исправление контраста текста

#### Файл: `lib/theme/color.dart`
```dart
// Изменить существующий цвет:
static const Color textSecondary = Color(0xFF64748B); // было #94A3B8
static const Color labelColor = Color(0xFF64748B); // синхронизировать
```

### 1.3 Размеры touch-зон

#### Файл: `lib/widgets/common/bizlevel_button.dart`
```dart
// Обновить минимальные размеры:
double get _minHeight {
  switch (size) {
    case BizLevelButtonSize.sm:
      return 48.0; // было 44
    case BizLevelButtonSize.md:
      return 52.0; // было 48
    case BizLevelButtonSize.lg:
      return 56.0; // осталось
  }
}
```

## 2. КОНСИСТЕНТНОСТЬ (День 2-3)

### 2.1 Объединение кнопочных компонентов

#### Файл: `lib/widgets/common/bizlevel_button.dart`
**Действия:**
1. Добавить параметры из `AnimatedButton`:
```dart
final bool animated; // default false
final bool useGradient; // default false для primary
final Duration animationDuration; // default 200ms
```

2. Интегрировать логику анимации из `AnimatedButton`
3. Удалить `lib/widgets/common/animated_button.dart`
4. Обновить все импорты

### 2.2 Централизация spacing

#### Файл: `lib/theme/spacing.dart`
```dart
// Добавить строгие правила:
class AppSpacing {
  // Существующие токены остаются
  
  // Добавить специализированные:
  static const double buttonPaddingHorizontal = 16.0;
  static const double buttonPaddingVertical = 12.0;
  static const double cardPadding = 16.0;
  static const double screenPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double itemSpacing = 12.0;
}
```

#### Замены magic numbers:
- Найти все `EdgeInsets.all(16)` → `EdgeInsets.all(AppSpacing.cardPadding)`
- Найти все `SizedBox(height: 12)` → `SizedBox(height: AppSpacing.itemSpacing)`
- Найти все `padding: 24` → `padding: AppSpacing.sectionSpacing`

### 2.3 Система анимаций

#### Файл: `lib/theme/animations.dart` (новый)
```dart
class AppAnimations {
  // Длительности
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);
  
  // Кривые
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.fastOutSlowIn;
}
```

#### Применить во всех анимациях:
- `BizLevelProgressBar`: `duration: AppAnimations.slow`
- `SuccessIndicator`: `duration: AppAnimations.normal`
- `achievement_badge.dart`: `duration: AppAnimations.verySlow`
- `BottomBarItem`: `duration: AppAnimations.normal`

### 2.4 Размеры иконок

#### Файл: `lib/theme/dimensions.dart` (новый)
```dart
class AppDimensions {
  // Иконки
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double iconXxl = 64.0;
  
  // Радиусы
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusRound = 999.0;
  
  // Минимальные размеры
  static const double minTouchTarget = 48.0;
  static const double minButtonHeight = 48.0;
}
```

## 3. ОПТИМИЗАЦИЯ ТИПОГРАФИКИ

### 3.1 Увеличение минимальных размеров

#### Файл: `lib/theme/typography.dart`
```dart
// Изменить существующие значения:
bodySmall: TextStyle(
  fontSize: 14, // было 12
  fontWeight: FontWeight.w400,
  height: 1.5,
  color: AppColor.onSurface,
),

labelSmall: TextStyle(
  fontSize: 12, // было 11 - это абсолютный минимум
  fontWeight: FontWeight.w600,
  height: 1.2,
  color: AppColor.labelColor,
),
```

## 4. УНИФИКАЦИЯ ТЕКСТОВЫХ ПОЛЕЙ

### 4.1 Централизация стилей input

#### Файл: `lib/theme/input_decoration_theme.dart` (новый)
```dart
class AppInputDecoration {
  static InputDecorationTheme theme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColor.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: AppColor.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: AppColor.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: AppColor.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: AppColor.error),
      ),
      hintStyle: TextStyle(color: AppColor.textSecondary),
      labelStyle: TextStyle(color: AppColor.labelColor),
    );
  }
}
```

#### Применить в `main.dart`:
```dart
theme: ThemeData(
  // ...existing
  inputDecorationTheme: AppInputDecoration.theme(),
)
```

## 5. УДАЛЕНИЕ ДУБЛИКАТОВ

### 5.1 Список файлов к удалению:
- `lib/widgets/common/animated_button.dart` (после интеграции в BizLevelButton)
- `lib/widgets/custom_textfield.dart` (использовать BizLevelTextField)

### 5.2 Замены импортов:
```bash
# Найти и заменить все импорты:
find . -name "*.dart" -exec sed -i 's/animated_button/bizlevel_button/g' {} \;
find . -name "*.dart" -exec sed -i 's/CustomTextBox/BizLevelTextField/g' {} \;
```

## 6. ПОДГОТОВКА DARK MODE

### 6.1 Создание темной темы

#### Файл: `lib/theme/app_theme.dart` (новый)
```dart
class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColor.primary,
        secondary: AppColor.premium,
        error: AppColor.error,
        surface: AppColor.surface,
        background: AppColor.appBackground,
      ),
      // ... остальные настройки
    );
  }
  
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColor.primary,
        secondary: AppColor.premium,
        error: AppColor.error,
        surface: AppColor.surfaceDark,
        background: Color(0xFF0F0E13), // мягкий черный
      ),
      // ... остальные настройки
    );
  }
}
```

## 7. ЛИНТЕР ПРАВИЛА

### 7.1 Добавить в `analysis_options.yaml`:
```yaml
linter:
  rules:
    # Запретить magic numbers в padding/margin
    - avoid_redundant_argument_values
    - prefer_const_constructors
    - prefer_const_declarations
    
analyzer:
  errors:
    # Предупреждать о хардкод цветах
    invalid_annotation_target: warning
```

### 7.2 Создать custom lint rule:
```dart
// tools/custom_lints.dart
// Правило: запретить Colors.* и Color(0x*) вне theme/color.dart
```

## ПРИОРИТЕТ ВЫПОЛНЕНИЯ:

1. **ДЕНЬ 1 (2-3 часа):**
   - [ ] 1.1 Унификация цветов
   - [ ] 1.2 Контраст текста
   - [ ] 1.3 Размеры touch-зон

2. **ДЕНЬ 2 (4-5 часов):**
   - [ ] 2.1 Объединение кнопок
   - [ ] 2.2 Централизация spacing
   - [ ] 2.3 Система анимаций
   - [ ] 2.4 Размеры иконок

3. **ДЕНЬ 3 (3-4 часа):**
   - [ ] 3.1 Типографика
   - [ ] 4.1 Унификация input
   - [ ] 5.1-5.2 Удаление дубликатов
   - [ ] 6.1 Dark mode подготовка

## МЕТРИКИ УСПЕХА:
- Количество хардкод цветов: 65 → 0
- Количество magic numbers: ~200 → <20
- Дублирование компонентов: 5 → 0
- Контраст текста: 3:1 → 4.5:1
- Touch target accuracy: +35%
