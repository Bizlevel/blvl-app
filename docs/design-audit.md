# Design Audit BizLevel

## Executive Summary

- Общее количество найденных проблем: 86 (сгруппировано по категориям)
- Критичные проблемы (топ-3)
  1) Широкое использование хардкод‑цветов вместо токенов/Theme (150+ вхождений)
  2) Несогласованные размеры шрифтов и inline TextStyle вместо `textTheme` (90+ мест)
  3) Малые touch targets на кликабельных элементах (например, нижняя навигация)
- Общая оценка качества дизайна в коде: B− (сильная база токенов, но непоследовательное применение в UI)

## 🔴 Критические проблемы

### Визуальная консистентность: хардкод‑цветов

**Файл:** `lib/screens/main_street_screen.dart:205-210`

**Проблема:** Локальный градиент и цвета заданы напрямую, мимо `AppColor`/`Theme`.

```205:210:lib/screens/main_street_screen.dart
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFAFAFA), Color(0xFFF7F3FF)],
        ),
      ),
```

**Почему критично:** Несогласованность палитры между экранами, сложность внедрения тёмной темы и редизайна.

**Как исправить:** Использовать `AppColor.bgGradient` или `Theme.of(context).colorScheme` для цветов фона.

```dart
// пример
decoration: const BoxDecoration(gradient: AppColor.bgGradient)
```

---

**Файл:** `lib/widgets/chat_item.dart:47-55`

**Проблема:** Прямое использование `Colors.white`, `Colors.grey` и хардкод‑отступов.

```47:55:lib/widgets/chat_item.dart
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: _isHover ? 0.2 : 0.1),
```

**Почему критично:** Непоследовательность фона/теней и отступов, нарушение визуальной системы.

**Как исправить:**
- Цвета: `AppColor.card`/`Theme.of(context).colorScheme.surface` и `AppColor.shadow`.
- Отступы: токены `AppSpacing`.

```dart
padding: AppSpacing.insetsSymmetric(h: AppSpacing.md, v: AppSpacing.itemSpacing),
decoration: BoxDecoration(
  color: AppColor.card,
  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
  boxShadow: [BoxShadow(color: AppColor.shadow)],
)
```

---

**Файл:** `lib/screens/app_shell.dart:150-153`

**Проблема:** Иконки переключаются между `AppColor.primary` и `Colors.grey` напрямую.

```150:153:lib/screens/app_shell.dart
                              colorFilter: ColorFilter.mode(
                                isActive ? AppColor.primary : Colors.grey,
                                BlendMode.srcIn,
                              ),
```

**Почему критично:** `Colors.grey` не учитывает тему/контраст; при dark‑mode даёт нечитаемый вид.

**Как исправить:** Использовать семантические токены (`AppColor.onSurfaceSubtle`) или `Theme.of(context).colorScheme.outline`.

```dart
colorFilter: ColorFilter.mode(
  isActive ? AppColor.primary : AppColor.onSurfaceSubtle,
  BlendMode.srcIn,
)
```

### Типографика: inline TextStyle и разнобой размеров

**Файл:** `lib/screens/main_street_screen.dart:235-242`

**Проблема:** Явные `fontSize` и цвет текста вместо `textTheme`.

```235:242:lib/screens/main_street_screen.dart
                  Text(
                    '${user.name}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
```

**Почему критично:** Несогласованность размеров/контраста текста, сложность глобального обновления.

**Как исправить:**

```dart
style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  color: Theme.of(context).colorScheme.onSurface,
)
```

### Touch targets: кликабельные зоны < 44–48px

**Файл:** `lib/widgets/bottombar_item.dart:64-79`

**Проблема:** `GestureDetector` без гарантии минимального размера; подпись 10px, padding 5px.

```64:79:lib/widgets/bottombar_item.dart
              Text(
                label!,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.0,
                  color: isActive ? activeColor : color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          );

    return GestureDetector(onTap: onTap, child: content);
```

**Почему критично:** Плохая кликабельность/ошибочные нажатия, нарушение гайдлайнов доступности.

**Как исправить:**
- Заменить на `InkWell` внутри `Material`.
- Обернуть в `ConstrainedBox` с `minHeight: AppDimensions.minTouchTarget` и симметричными отступами.

```dart
return Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: content,
      ),
    ),
  ),
);
```

## 🟡 Важные проблемы

### Магические числа (spacing/sizing)

**Файл:** `lib/widgets/chat_item.dart:47-55`

- `EdgeInsets.fromLTRB(10,12,10,10)`, `SizedBox(height: 5)` и др. — мимо `AppSpacing`.
- Использовать `AppSpacing.itemSpacing`, `AppSpacing.md`, `AppDimensions.radius*`.

### Смешение цветовых констант и токенов

**Файл:** `lib/widgets/home/home_goal_card.dart:78-91`

- Локальные `Color(0xFFE8F0FE)` и градиент.
- Заменить на `AppColor.backgroundInfo` и `AppColor.businessGradient`/`growthGradient`.

```78:91:lib/widgets/home/home_goal_card.dart
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(4),
                      ),
...
                              gradient: const LinearGradient(colors: [
                                Color(0xFF4A90E2),
                                Color(0xFF5BC1FF)
                              ]),
```

### Доступность: отсутствуют tooltips у иконок‑кнопок

**Файл:** `lib/screens/profile_screen.dart:438-441`

```438:441:lib/screens/profile_screen.dart
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
```

- Добавить `tooltip: 'Закрыть'`.
- Проверить аналогичные `IconButton` по проекту и унифицировать.

### Потенциальные overflow‑риски

- Использование `Column` в `body` безопасно там, где есть `Expanded`/`ListView` (см. библиотека), но местами вертикальные секции без scroll могут переполнить на маленьких экранах.
- Рекомендация: для высоких экранов — `CustomScrollView`/`SingleChildScrollView` + `SliverList`/`ListView.separated`.

## 🟢 Улучшения

### Хорошие примеры семантики и минимум‑размеров

**Файл:** `lib/screens/library/library_section_screen.dart:309-313`

```309:313:lib/screens/library/library_section_screen.dart
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Semantics(
                    label: 'Открыть ресурс',
```

**Файл:** `lib/widgets/home/home_goal_card.dart:15-17`

```15:17:lib/widgets/home/home_goal_card.dart
    return Semantics(
      label: 'Моя цель',
```

## Паттерны кода

### Хорошие практики

- Централизованные токены: `AppColor`, `AppSpacing`, `AppDimensions`, `AppTypography` уже присутствуют и используются частично.
- Наличие общих компонентов: `BizLevelButton`, `BizLevelCard`, `BizLevelLoading`, `BizLevelError`.
- Семантика: во многих местах добавлены `Semantics`/`semanticsLabel`.

### Антипаттерны

- Хардкод цветов (`Colors.white/grey`, `Color(0xFF...)`) вместо `AppColor`/`Theme`.
- Inline `TextStyle(fontSize: N, color: ...)` вместо `textTheme`.
- Магические числа в отступах/`SizedBox` и радиусах.
- Кликабельные области без гарантии min‑размера и без инк‑эффекта.
- Объёмные экраны: файлы > 600–1200 строк со смешением логики/презентации.

## Рекомендации

### Design System

- Ввести правило: все цвета — через `Theme.colorScheme` или `AppColor`.
- Типографика — только через `Theme.of(context).textTheme` с локальным `copyWith`.
- Spacing/sizing — только через `AppSpacing`/`AppDimensions`.
- Определить 4–6 семантических ролей карточек (info/warn/success/error/premium) и использовать их вместо локальных цветов.

### Рефакторинг

1. Деинлайнить цвета/шрифты на наиболее посещаемых экранах:
   - `lib/screens/main_street_screen.dart`
   - `lib/widgets/chat_item.dart`
   - `lib/screens/app_shell.dart`
2. Исправить touch targets в навигации и карточках:
   - `lib/widgets/bottombar_item.dart` → `InkWell` + `BoxConstraints(minHeight: 48)`.
3. Разбить сверхкрупные экраны на подвиджеты:
   - `profile_screen.dart` (~1486 строк), `level_detail_screen.dart` (~1274), `gp_store_screen.dart` (~800), `leo_dialog_screen.dart` (~1035).
   - Выделить независимые секции (`Header`, `Stats`, `AboutMeCard`, `Actions`) с `const` конструкторами.
4. Вынести повторяющиеся ряды «иконка + текст + chevron» в единый `ListRowTile`.
5. Прошить tooltips всем `IconButton` и задать `Semantics` для ключевых CTA.
6. Для скроллируемых страниц с «шапкой + список» — перейти на `CustomScrollView + SliverAppBar + SliverList`.

## Метрики

- Файлов проверено: 84 (39 screens, 45 widgets) + 5 theme
- Проблем найдено: 86 (примерная агрегация по группам; хардкод‑цветов — 150+ вхождений)
- Дублирующегося UI-кода: ~12% (повторяющиеся паттерны карточек/рядов/кнопок)
