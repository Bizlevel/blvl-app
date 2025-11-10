# Спецификация главного экрана БизЛевел для Flutter

## Инструкции для Cursor IDE

**ВАЖНО:** Используй существующую дизайн-систему БизЛевел из проекта. Не хардкодь цвета, размеры и стили. Все компоненты должны быть адаптивными и следовать Material 3 гайдлайнам.

## Структура экрана

```
HomeScreen
├── SafeArea
│   └── CustomScrollView
│       ├── SliverAppBar (collapsed)
│       └── SliverList
│           ├── HeaderSection (профиль + GP)
│           ├── GoalSection (карточка цели)
│           ├── ContinueLearningSection (главный CTA)
│           ├── QuickActionsSection (библиотека + артефакты)
│           └── BottomPadding
```

## Детальная реализация компонентов

### 1. HeaderSection
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  child: Row(
    children: [
      // Аватар с гексагоном
      Stack(
        children: [
          // Гексагон-контейнер - используй CustomPainter
          HexagonContainer(
            size: 56,
            borderColor: AppColors.primary.withOpacity(0.2),
            borderWidth: 2,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Image.asset(
                'assets/avatars/${user.avatarId}.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      SizedBox(width: 12),
      
      // Информация пользователя
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: AppTextStyles.headingSmall, // 18px medium
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Уровень ${user.currentLevel}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Вертикальный разделитель
      Container(
        height: 32,
        width: 1,
        color: AppColors.divider,
        margin: EdgeInsets.symmetric(horizontal: 16),
      ),
      
      // GP баланс
      GpBalanceWidget(
        balance: gpBalance,
        // Используй существующий виджет из проекта
        // Добавь subtle анимацию при изменении
      ),
    ],
  ),
)
```

### 2. GoalSection
```dart
Container(
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.divider),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Заголовок с иконкой
      Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.target, // или кастомная иконка
              size: 20,
              color: AppColors.error,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Моя Цель',
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      
      SizedBox(height: 16),
      
      // Контент цели
      Row(
        children: [
          // Текст цели
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.text ?? 'Установите вашу первую цель',
                  style: AppTextStyles.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                
                // Дата и прогресс-бар
                if (goal.deadline != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'до ${DateFormat('dd.MM.yyyy').format(goal.deadline)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Мини прогресс-бар
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: goal.progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.success,
                              AppColors.success.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(width: 16),
          
          // Гексагон с процентом
          HexagonProgress(
            size: 80,
            progress: goal.progress ?? 0,
            strokeWidth: 2,
            backgroundColor: AppColors.divider,
            progressColor: AppColors.success,
            child: Text(
              '${(goal.progress * 100).toInt()}%',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      
      SizedBox(height: 12),
      
      // Кнопки действий
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/goal/progress'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8),
                side: BorderSide(color: AppColors.divider),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Прогресс',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _openMaxChat(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.08),
                foregroundColor: AppColors.primary,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Макс',
                style: AppTextStyles.button.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
)
```

### 3. ContinueLearningSection
```dart
Container(
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Заголовок секции
      Text(
        'Продолжить обучение',
        style: AppTextStyles.headingSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 12),
      
      // Карточка текущего уровня
      InkWell(
        onTap: () => _continueLevel(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.primary.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Информация об уровне
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Уровень ${currentLevel.number}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      currentLevel.title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '~${currentLevel.estimatedMinutes} минут',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '+${currentLevel.skillPoints} очков',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Превью изображение уровня
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppColors.primary.withOpacity(0.05),
                  child: Image.asset(
                    'assets/images/lvls/level_${currentLevel.number}.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Фолбек на дефолтное изображение
                      return Container(
                        color: AppColors.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.school,
                          color: AppColors.primary.withOpacity(0.3),
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // CTA кнопка
      SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () => _continueLevel(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: AppColors.primary.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow, size: 24),
              SizedBox(width: 8),
              Text(
                'Продолжить обучение',
                style: AppTextStyles.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)
```

### 4. QuickActionsSection
```dart
Container(
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  child: Row(
    children: [
      // Библиотека
      Expanded(
        child: _QuickActionCard(
          icon: Icons.library_books,
          title: 'Библиотека',
          subtitle: '${libraryCount} материалов',
          onTap: () => Navigator.pushNamed(context, '/library'),
        ),
      ),
      SizedBox(width: 12),
      
      // Артефакты
      Expanded(
        child: _QuickActionCard(
          icon: Icons.folder_special,
          title: 'Мои артефакты',
          subtitle: '${artifactsCount} инструментов',
          onTap: () => Navigator.pushNamed(context, '/artifacts'),
        ),
      ),
    ],
  ),
)

// Виджет карточки быстрого действия
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Анимации и микровзаимодействия

### 1. При загрузке страницы
```dart
// Используй staggered animations для элементов
AnimationController _controller;
Animation<double> _fadeAnimation;
Animation<Offset> _slideAnimation;

// Последовательное появление:
// 1. Header (0ms)
// 2. Goal card (100ms)  
// 3. Continue learning (200ms)
// 4. Quick actions (300ms)
```

### 2. Pull-to-refresh
```dart
RefreshIndicator(
  color: AppColors.primary,
  backgroundColor: AppColors.surface,
  onRefresh: () async {
    // Обновить данные пользователя, GP, прогресс
    await Future.wait([
      _refreshUserData(),
      _refreshGpBalance(),
      _refreshGoalProgress(),
    ]);
  },
)
```

### 3. GP изменение
```dart
// При изменении баланса GP:
// 1. Число пульсирует (scale 1.0 -> 1.1 -> 1.0)
// 2. Показать +/- изменение зеленым/красным
// 3. Fade out через 2 секунды
```

### 4. Взаимодействие с кнопками
```dart
// Все интерактивные элементы должны иметь:
// - InkWell с правильным borderRadius
// - Haptic feedback на тап (HapticFeedback.lightImpact())
// - Scale animation при нажатии (0.98)
```

## Адаптивность

### Планшеты
```dart
// На планшетах (width > 600):
// - Максимальная ширина контента: 600px
// - Центрирование через Center + ConstrainedBox
// - Увеличенные отступы: horizontal: 32px
```

### Темная тема
```dart
// Поддержка темной темы:
// - Все цвета должны браться из Theme.of(context)
// - Тени заменяются на subtle borders
// - Градиенты адаптируются под темную тему
```

## Состояния

### Loading
```dart
// Пока данные загружаются:
// - Shimmer эффект для всех блоков
// - Используй shimmer package или кастомный ShimmerWidget
```

### Error
```dart
// При ошибке загрузки:
// - Friendly error message
// - Кнопка "Попробовать снова"
// - Иллюстрация ошибки (опционально)
```

### Empty states
```dart
// Если нет цели:
// - Показать CTA для создания первой цели
// - Мотивирующий текст
// - Иллюстрация
```

## Дополнительные требования

1. **Производительность**: 
   - Используй const конструкторы где возможно
   - Кешируй изображения
   - Lazy loading для тяжелых элементов

2. **Доступность**:
   - Все интерактивные элементы с Semantics
   - Минимальный размер тап-зоны: 48x48
   - Контраст текста минимум 4.5:1

3. **Аналитика**:
   - Трекинг всех тапов на кнопки
   - Screen view event при открытии
   - Scroll depth tracking

## Важные детали

- **НЕ хардкодь строки** - используй локализацию
- **НЕ хардкодь размеры** - используй дизайн-систему
- **НЕ забудь про error boundaries** - оберни в error handlers
- **ОБЯЗАТЕЛЬНО протестируй** на разных размерах экранов
