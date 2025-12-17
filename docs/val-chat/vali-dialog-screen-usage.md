# ValiDialogScreen — Руководство по использованию

## Обзор

`ValiDialogScreen` — экран диалога с Валли (AI-валидатор идей), реализованный на основе `LeoDialogScreen` с модификациями для валидации бизнес-идей.

**Расположение:** `lib/screens/vali_dialog_screen.dart`

## Основные возможности

### 1. Диалоговый режим
- Чат с Валли (7 вопросов)
- Прогресс-бар в AppBar (1/7, 2/7, ..., 7/7)
- Typing indicator при ожидании ответа
- Автоматический скроллинг к последнему сообщению

### 2. Режим отчёта
- Отображение результатов валидации
- Markdown рендеринг отчёта
- Карточка с баллом и архетипом
- CTA кнопки для следующих действий

### 3. Интеграция
- ValiService для API вызовов
- Riverpod для DI
- Sentry для отладки
- GP Service для баланса

## Навигация

### 1. Новая валидация

```dart
import 'package:go_router/go_router.dart';

// Через GoRouter
context.push('/chat/vali');

// Или через Navigator
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ValiDialogScreen(),
  ),
);
```

### 2. Продолжение существующей валидации

```dart
// С validationId
context.push('/chat/vali?validationId=$validationId');

// Или через Navigator
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ValiDialogScreen(
      validationId: validationId,
    ),
  ),
);
```

### 3. С предзаполненной идеей

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ValiDialogScreen(
      ideaSummary: 'Мобильное приложение для доставки еды',
    ),
  ),
);
```

## Параметры конструктора

| Параметр | Тип | Описание |
|----------|-----|----------|
| `chatId` | `String?` | ID существующего чата (leo_chats) |
| `validationId` | `String?` | ID существующей валидации (idea_validations) |
| `ideaSummary` | `String?` | Краткое описание идеи для новой валидации |

## Жизненный цикл валидации

```
┌─────────────────────────────────────────────────┐
│ 1. Пользователь открывает ValiDialogScreen     │
└──────────────────┬──────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────┐
│ 2. initState() → _initializeValidation()       │
│    - Если validationId → загрузить             │
│    - Иначе → создать новую                     │
└──────────────────┬──────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────┐
│ 3. Диалог (7 вопросов)                         │
│    - Пользователь отвечает                     │
│    - Валли задаёт следующий вопрос             │
│    - currentStep++ после каждого ответа        │
└──────────────────┬──────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────┐
│ 4. После 7-го вопроса → _showCompletionDialog() │
│    "Готов узнать результат?"                   │
└──────────────────┬──────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────┐
│ 5. _requestScoring()                           │
│    - ValiService.scoreValidation()             │
│    - Показать SnackBar "Анализирую..."         │
│    - Сохранить результаты в БД                 │
└──────────────────┬──────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────┐
│ 6. _buildReportView()                          │
│    - Отобразить отчёт                          │
│    - Показать CTA кнопки                       │
└─────────────────────────────────────────────────┘
```

## Основные методы

### `_initializeValidation()`
Инициализирует валидацию при старте экрана:
- Если передан `validationId` → загружает данные
- Иначе → создаёт новую валидацию через `ValiService.createValidation()`
- Добавляет приветственное сообщение от Валли

### `_sendMessage()`
Отправляет сообщение пользователя:
- Debounce 500ms (предотвращает дубли)
- Сохраняет в БД через `ValiService.saveConversation()`
- Вызывает Edge Function через `ValiService.sendMessage()`
- Обновляет `current_step`
- После 7-го вопроса → показывает диалог завершения

### `_requestScoring()`
Запрашивает скоринг валидации:
- Вызывает `ValiService.scoreValidation()`
- Показывает SnackBar с прогрессом
- Обновляет данные валидации
- Переключает UI в режим отчёта

### `_buildReportView()`
Отображает отчёт с результатами:
- Карточка с баллом (0-100) и архетипом
- Markdown рендеринг полного отчёта
- CTA кнопки для следующих действий

## Обработка ошибок

### 402 — Недостаточно GP

```dart
void _showInsufficientGpDialog(int required) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Недостаточно GP'),
      content: Text('Для валидации нужно $required GP'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            context.push('/gp-purchase');
          },
          child: const Text('Пополнить GP'),
        ),
      ],
    ),
  );
}
```

**Когда возникает:**
- Первая валидация — бесплатно
- Повторные валидации — 100 GP
- Если баланс < 100 GP → показывается этот диалог

### Сетевые ошибки

```dart
try {
  await _vali.sendMessage(...);
} on ValiFailure catch (e) {
  _showError(e.message);
} catch (e) {
  _showError('Не удалось отправить сообщение: $e');
}
```

## UI компоненты

### 1. Прогресс-бар

```dart
Widget _buildProgressBar() {
  final progress = _currentStep / maxSteps;
  return Container(
    height: 4,
    child: FractionallySizedBox(
      widthFactor: progress,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.primary,
        ),
      ),
    ),
  );
}
```

Отображается в верхней части экрана под AppBar.

### 2. Список сообщений

Переиспользует виджеты из LeoDialogScreen:
- `LeoMessageBubble` — баблы сообщений
- `TypingIndicator.small()` — индикатор набора
- Анимация появления для последних 6 сообщений

### 3. Поле ввода

```dart
TextField(
  controller: _inputController,
  minLines: 1,
  maxLines: 4,
  textInputAction: TextInputAction.send,
  decoration: const InputDecoration(
    hintText: 'Введите ответ...',
    border: OutlineInputBorder(),
  ),
  onSubmitted: (text) {
    if (text.trim().isNotEmpty && !_isSending) {
      _sendMessage();
    }
  },
)
```

### 4. CTA кнопки (режим отчёта)

```dart
// Пройти рекомендованный урок
ElevatedButton.icon(
  onPressed: () {
    final levelNumber = recommendedLevels.first['level_number'];
    context.push('/levels/$levelNumber');
  },
  icon: const Icon(Icons.school),
  label: Text('Пройти урок'),
)

// Поставить цель с Максом
OutlinedButton.icon(
  onPressed: () => context.push('/chat/max'),
  icon: const Icon(Icons.flag),
  label: const Text('Поставить цель с Максом'),
)

// Проверить другую идею
OutlinedButton.icon(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ValiDialogScreen(),
      ),
    );
  },
  icon: const Icon(Icons.refresh),
  label: const Text('Проверить другую идею'),
)
```

## Интеграция с роутингом

### GoRouter

```dart
// В конфигурации роутера
GoRoute(
  path: '/chat/vali',
  builder: (context, state) {
    final validationId = state.uri.queryParameters['validationId'];
    final chatId = state.uri.queryParameters['chatId'];
    return ValiDialogScreen(
      validationId: validationId,
      chatId: chatId,
    );
  },
),
```

### Примеры URL:

- `/chat/vali` — новая валидация
- `/chat/vali?validationId=123-456` — продолжение валидации
- `/chat/vali?chatId=789` — продолжение чата

## Sentry breadcrumbs

ValiDialogScreen автоматически добавляет breadcrumbs:

```dart
// При запросе скоринга
Sentry.addBreadcrumb(Breadcrumb(
  category: 'vali',
  message: 'validation_scoring_start',
  data: {'validationId': _validationId},
));

// После завершения скоринга
Sentry.addBreadcrumb(Breadcrumb(
  category: 'vali',
  message: 'validation_scoring_complete',
  data: {
    'validationId': _validationId,
    'totalScore': result['scores']?['total'],
  },
));
```

## Переиспользуемые компоненты

ValiDialogScreen использует следующие виджеты из LeoDialogScreen:

| Виджет | Назначение |
|--------|-----------|
| `LeoMessageBubble` | Баблы сообщений (пользователь/ассистент) |
| `TypingIndicator.small()` | Индикатор "Валли печатает..." |
| `AppColor.*` | Цветовая палитра |
| `AppSpacing.*` | Отступы |
| `AppTypography.*` | Типографика |

## Markdown рендеринг

Отчёт рендерится через `flutter_markdown`:

```dart
MarkdownBody(
  data: report,
  styleSheet: MarkdownStyleSheet(
    p: Theme.of(context).textTheme.bodyMedium,
    h1: Theme.of(context).textTheme.titleLarge,
    h2: Theme.of(context).textTheme.titleMedium,
    strong: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

## Тестирование

### Unit-тесты

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ValiDialogScreen', () {
    testWidgets('должен показать приветственное сообщение', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ValiDialogScreen(),
        ),
      );
      
      expect(find.text('Привет! Я Валли'), findsOneWidget);
    });
    
    testWidgets('должен показать прогресс-бар', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ValiDialogScreen(),
        ),
      );
      
      expect(find.text('1/7'), findsOneWidget);
    });
  });
}
```

### Widget-тесты

```dart
testWidgets('должен отправить сообщение при нажатии Enter', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: ValiDialogScreen(),
      ),
    ),
  );
  
  // Вводим текст
  await tester.enterText(
    find.byType(TextField),
    'Моя идея',
  );
  
  // Нажимаем Enter
  await tester.testTextInput.receiveAction(TextInputAction.send);
  await tester.pump();
  
  // Проверяем, что сообщение добавлено
  expect(find.text('Моя идея'), findsOneWidget);
});
```

## Известные ограничения

1. **Аватар Валли** — используется уникальный аватар совы‑Валли в фирменном стиле BizLevel

2. **Подсказки (chips)** — пока не реализованы
   - TODO: добавить рекомендованные вопросы

3. **История валидаций** — нет экрана списка валидаций
   - TODO: создать ValiHistoryScreen

4. **Редактирование ответов** — нельзя изменить ответ на предыдущий вопрос
   - TODO: добавить возможность вернуться на шаг назад

## Следующие шаги

1. ✅ ValiDialogScreen создан
2. ✅ Карточка Валли в Base Trainers
3. ⏳ Интеграция с роутингом (GoRouter)
4. ⏳ История валидаций (ValiHistoryScreen)
5. ✅ Уникальный аватар Валли

---

**Версия:** 1.0  
**Дата:** 15.12.2024  
**Автор:** BizLevel Development Team
