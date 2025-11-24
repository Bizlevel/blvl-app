# Спецификация главного экрана БизЛевел для Flutter

## Общие принципы
- Используй существующий дизайн-код БизЛевел (цвета, типографику, компоненты из `/lib/core/theme/`)
- Не хардкодь значения - используй theme constants
- Все отступы кратны 4px (используй SizedBox и Padding с theme spacing)
- Страница должна быть в SingleChildScrollView с SafeArea

## Структура экрана (сверху вниз)

### 1. HEADER SECTION
**Container с градиентным фоном:**
- Градиент: от `theme.colors.surface` к белому (вертикальный)
- Padding: horizontal: 20, vertical: 16
- BorderRadius: только bottom - circular(24)

**Содержимое (Row с MainAxisAlignment.spaceBetween):**

**Левая часть (Row):**
- CircleAvatar:
  - radius: 24
  - backgroundColor: theme.colors.primaryLight с opacity 0.1
  - child: аватар пользователя или иконка из существующих аватаров
- SizedBox(width: 12)
- Column(crossAxisAlignment.start):
  - Text: имя пользователя
    - style: theme.textTheme.titleMedium
    - fontWeight: FontWeight.w500
  - Text: "Уровень ${currentLevel}"
    - style: theme.textTheme.bodySmall
    - color: theme.colors.textSecondary

**Правая часть (Container):**
- decoration: BoxDecoration с theme.colors.warning.withOpacity(0.1)
- borderRadius: 20
- padding: horizontal: 12, vertical: 6
- Row:
  - Icon: Icons.monetization_on (size: 16, color: theme.colors.warning)
  - SizedBox(width: 4)
  - Text: число GP
    - style: theme.textTheme.titleSmall
    - fontWeight: FontWeight.w600

### 2. GOAL CARD (Основной фокус)
**Позиционирование:**
- Margin: top: 24, horizontal: 20
- Использовать существующий CardContainer из дизайн-системы

**Container спецификация:**
- decoration: BoxDecoration:
  - color: белый
  - borderRadius: 16
  - boxShadow: [
    - offset: (0, 2)
    - blurRadius: 8
    - color: Colors.black.withOpacity(0.06)
  ]
- padding: all 20

**Содержимое:**
- Text "Моя цель":
  - style: theme.textTheme.titleSmall
  - color: theme.colors.textSecondary
  - marginBottom: 12

- Text (цель пользователя):
  - style: theme.textTheme.bodyLarge
  - maxLines: 2
  - overflow: ellipsis
  - lineHeight: 1.4

- SizedBox(height: 16)

- Row(mainAxisAlignment.spaceBetween):
  - **Левая часть - CustomPaint гексагон:**
    - size: 72x72
    - strokeWidth: 2
    - strokeColor: theme.colors.primary
    - fillColor для прогресса: theme.colors.success с opacity по проценту
    - В центре Text с процентом:
      - style: theme.textTheme.headlineSmall
      - fontWeight: bold
      - color: theme.colors.primary
  
  - **Правая часть - Column:**
    - Row с иконкой календаря (size: 14) + Text дедлайна
      - style: theme.textTheme.bodySmall
      - color: theme.colors.textSecondary
    - SizedBox(height: 8)
    - Row из двух кнопок:
      - OutlinedButton "Прогресс":
        - borderColor: theme.colors.border
        - textColor: theme.colors.textSecondary
        - borderRadius: 8
        - padding: horizontal: 12, vertical: 6
      - SizedBox(width: 8)
      - ElevatedButton "Макс":
        - backgroundColor: theme.colors.primary
        - borderRadius: 8
        - padding: horizontal: 16, vertical: 6

### 3. CONTINUE LEARNING CARD
**Позиционирование:**
- Margin: top: 20, horizontal: 20
- Animated при появлении (fadeIn + slideUp)

**Container:**
- decoration: BoxDecoration:
  - gradient: LinearGradient:
    - begin: topLeft, end: bottomRight
    - colors: [theme.colors.primaryLight, theme.colors.primary]
  - borderRadius: 16
- height: 140
- clipBehavior: Clip.antiAlias

**Stack содержимое:**
- **Positioned.right(-20) - Картинка уровня:**
  - Image.asset из assets/images/lvls/
  - width: 140
  - opacity: 0.9
  - fit: BoxFit.contain

- **Padding(all: 20) - Контент:**
  - Column(crossAxisAlignment.start):
    - Text "Уровень ${nextLevel}":
      - style: theme.textTheme.bodySmall
      - color: белый с opacity 0.9
    - SizedBox(height: 4)
    - Text (название уровня):
      - style: theme.textTheme.titleMedium
      - color: белый
      - fontWeight: bold
    - Spacer()
    - ElevatedButton:
      - backgroundColor: белый
      - foregroundColor: theme.colors.primary
      - label: Row [Icon play_arrow + SizedBox(4) + Text "Продолжить"]
      - borderRadius: 12
      - padding: horizontal: 16, vertical: 10
      - elevation: 2

### 4. QUICK STATS ROW
**Позиционирование:**
- Margin: top: 24, horizontal: 20

**Row из 3-х элементов (Expanded + separators):**

Каждый элемент - Column(center):
- Icon (size: 24, color: theme.colors.primary.withOpacity(0.7))
- SizedBox(height: 4)
- Text (число):
  - style: theme.textTheme.titleMedium
  - fontWeight: bold
- Text (подпись):
  - style: theme.textTheme.bodySmall
  - color: theme.colors.textSecondary

**Данные:**
1. Icon: trending_up / "5" / "дней подряд"
2. Icon: school / "10" / "уроков пройдено"  
3. Icon: emoji_events / "3" / "навыка освоено"

**Separators:**
- Container(width: 1, height: 40, color: theme.colors.border.withOpacity(0.3))

### 5. BOTTOM NAVIGATION CARDS
**Позиционирование:**
- Margin: top: 24, bottom: 20, horizontal: 20
- Gap между карточками: 12

**Row из 2-х Expanded карточек:**

**Каждая карточка - InkWell с Container:**
- decoration: BoxDecoration:
  - color: theme.colors.surface
  - borderRadius: 12
  - border: Border.all(color: theme.colors.border, width: 1)
- padding: all 16
- height: 80

**Содержимое карточки (Column center):**
- Icon (size: 28, color: theme.colors.textSecondary)
- SizedBox(height: 8)
- Text (название):
  - style: theme.textTheme.bodyMedium
  - fontWeight: w500
- Text (количество):
  - style: theme.textTheme.bodySmall
  - color: theme.colors.textSecondary

**Данные:**
1. Icons.menu_book / "Библиотека" / "57 материалов"
2. Icons.folder_special / "Артефакты" / "11 инструментов"

## Анимации и взаимодействия

### При загрузке страницы:
1. Header - fadeIn (200ms)
2. Goal Card - slideInFromBottom + fadeIn (300ms, delay 100ms)
3. Continue Card - slideInFromBottom + fadeIn (400ms, delay 200ms)
4. Stats - fadeIn (500ms, delay 300ms)
5. Bottom Cards - fadeIn (600ms, delay 400ms)

### При нажатиях:
- Все кнопки: scale 0.95 при нажатии (duration 100ms)
- Continue Card: легкая пульсация тени каждые 3 секунды
- Goal percentage: анимированное заполнение при первом появлении

### Pull to refresh:
- Использовать стандартный RefreshIndicator с theme.colors.primary

## Адаптивность

### Для планшетов (width > 600):
- maxWidth контейнера: 500
- Центрировать все содержимое

### Для маленьких экранов (height < 600):
- Уменьшить высоту Continue Card до 120
- Уменьшить вертикальные отступы на 20%

## Состояния

### Если нет активной цели:
- Goal Card показывает:
  - Иллюстрацию target
  - Text: "Поставьте первую цель"
  - ElevatedButton: "Создать цель"

### Если все уровни пройдены:
- Continue Card показывает:
  - Поздравительную иллюстрацию
  - Text: "Вы прошли все уровни!"
  - OutlinedButton: "Смотреть достижения"

## Важные детали

1. **Используй FutureBuilder** для загрузки данных пользователя
2. **Shimmer эффект** при загрузке (используй существующий ShimmerLoading виджет)
3. **Error state** - показать friendly сообщение с кнопкой retry
4. **Все тексты** должны быть обернуты в Flexible где необходимо для избежания overflow
5. **Hero анимация** для аватара при переходе в профиль
6. **Haptic feedback** (HapticFeedback.lightImpact) при нажатии на основные кнопки

## Проверка реализации

После создания страницы проверь:
- [ ] Работает на iPhone SE (маленький экран)
- [ ] Работает на iPad
- [ ] Нет overflow ошибок при длинных текстах
- [ ] Smooth scrolling без лагов
- [ ] Все цвета из theme, не захардкожены
- [ ] Pull to refresh обновляет данные
- [ ] Навигация на все linked страницы работает
