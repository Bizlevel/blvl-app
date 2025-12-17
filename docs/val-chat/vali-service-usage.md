# ValiService — Руководство по использованию

## Обзор

`ValiService` — Dart-сервис для взаимодействия с Edge Function `val-chat` (Валли — AI-валидатор идей).

**Расположение:** `lib/services/vali_service.dart`

## Инициализация

```dart
import 'package:bizlevel/services/vali_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final valiService = ValiService(supabase);
```

## Основные сценарии использования

### 1. Создание новой валидации

```dart
try {
  // Создаём запись в idea_validations
  final validationId = await valiService.createValidation(
    ideaSummary: 'Мобильное приложение для доставки продуктов',
  );
  
  print('Создана валидация: $validationId');
} on ValiFailure catch (e) {
  print('Ошибка: ${e.message}');
}
```

### 2. Отправка сообщения в диалоге

```dart
try {
  // Формируем историю диалога
  final messages = [
    {'role': 'user', 'content': 'Хочу создать приложение для доставки еды'},
  ];
  
  // Отправляем в режиме dialog
  final response = await valiService.sendMessage(
    messages: messages,
    validationId: validationId, // опционально
  );
  
  // Получаем ответ Валли
  final assistantMessage = response['message']['content'];
  print('Валли: $assistantMessage');
  
  // Сохраняем сообщения в БД
  await valiService.saveConversation(
    role: 'user',
    content: 'Хочу создать приложение для доставки еды',
    chatId: chatId, // если есть
    validationId: validationId,
  );
  
  await valiService.saveConversation(
    role: 'assistant',
    content: assistantMessage,
    chatId: chatId,
    validationId: validationId,
  );
  
} on ValiFailure catch (e) {
  if (e.statusCode == 402) {
    // Недостаточно GP
    print('Нужно пополнить баланс: ${e.data?['required']} GP');
  } else {
    print('Ошибка: ${e.message}');
  }
}
```

### 3. Обновление прогресса диалога

```dart
try {
  // После каждого ответа пользователя обновляем current_step
  await valiService.updateValidationProgress(
    validationId: validationId,
    currentStep: 3, // текущий вопрос (1-7)
  );
} on ValiFailure catch (e) {
  print('Ошибка: ${e.message}');
}
```

### 4. Скоринг валидации (завершение диалога)

```dart
try {
  // После 7 вопросов запрашиваем скоринг
  final messages = [
    {'role': 'user', 'content': 'Хочу создать...'},
    {'role': 'assistant', 'content': 'Расскажи подробнее...'},
    // ... полная история диалога
  ];
  
  final result = await valiService.scoreValidation(
    messages: messages,
    validationId: validationId,
  );
  
  // Получаем результаты
  final scores = result['scores'];
  final report = result['report']; // markdown отчёт
  
  print('Итоговый балл: ${scores['total']}/100');
  print('Архетип: ${scores['archetype']}');
  print('\nОтчёт:\n$report');
  
} on ValiFailure catch (e) {
  print('Ошибка скоринга: ${e.message}');
}
```

### 5. Получение валидации по ID

```dart
try {
  final validation = await valiService.getValidation(validationId);
  
  if (validation != null) {
    print('Статус: ${validation['status']}');
    print('Шаг: ${validation['current_step']}');
    print('Балл: ${validation['total_score']}');
  }
} on ValiFailure catch (e) {
  print('Ошибка: ${e.message}');
}
```

### 6. Получение списка всех валидаций

```dart
try {
  final validations = await valiService.getUserValidations(
    limit: 20,
    offset: 0,
  );
  
  for (final v in validations) {
    print('${v['id']}: ${v['idea_summary']} (${v['status']})');
  }
} on ValiFailure catch (e) {
  print('Ошибка: ${e.message}');
}
```

### 7. Проверка первой валидации (для GP-экономики)

```dart
try {
  final isFirst = await valiService.isFirstValidation();
  
  if (isFirst) {
    print('Первая валидация — бесплатно! 🎉');
  } else {
    print('Повторная валидация — 20 GP');
  }
} on ValiFailure catch (e) {
  print('Ошибка: ${e.message}');
}
```

### 8. Пометка валидации как заброшенной

```dart
try {
  await valiService.abandonValidation(validationId);
  print('Валидация помечена как заброшенная');
} on ValiFailure catch (e) {
  print('Ошибка: ${e.message}');
}
```

## Обработка ошибок

### ValiFailure — типизированное исключение

```dart
try {
  await valiService.sendMessage(...);
} on ValiFailure catch (e) {
  // Все методы выбрасывают ValiFailure при ошибках
  
  print('Сообщение: ${e.message}');
  print('HTTP код: ${e.statusCode}');
  print('Данные: ${e.data}');
  
  // Специальная обработка по коду
  switch (e.statusCode) {
    case 401:
      // Пользователь не авторизован
      break;
    case 402:
      // Недостаточно GP
      final required = e.data?['required'] ?? 100;
      showGpTopUpDialog(required);
      break;
    case 500:
      // Серверная ошибка
      break;
    default:
      // Общая ошибка
      break;
  }
}
```

### Типичные ошибки и решения

| Ошибка | Код | Причина | Решение |
|--------|-----|---------|---------|
| `Пользователь не авторизован` | 401 | Нет активной сессии | Перелогиниться |
| `Недостаточно GP` | 402 | Баланс < 20 GP | Пополнить баланс |
| `Нет соединения с интернетом` | - | Сетевая ошибка | Проверить подключение |
| `Сервер временно недоступен` | 500+ | Проблема на бэкенде | Повторить позже |

## GP-экономика

- **Первая валидация:** бесплатно
- **Повторные валидации:** 20 GP

Списание GP происходит автоматически при вызове `sendMessage()` в режиме `dialog` (если это не первая валидация).

Edge Function `val-chat` проверяет баланс на стороне сервера и возвращает 402, если GP недостаточно.

## Интеграция с другими сервисами

### GpService — проверка баланса

```dart
import 'package:bizlevel/services/gp_service.dart';

final gpService = GpService(supabase);

try {
  final balance = await gpService.getBalance();
  final currentBalance = balance['balance'] ?? 0;
  
  if (currentBalance < 100) {
    print('Недостаточно GP для валидации');
  }
} on GpFailure catch (e) {
  print('Ошибка GP: ${e.message}');
}
```

### Sentry breadcrumbs — отладка

`ValiService` автоматически добавляет breadcrumbs в Sentry для отладки:

- `vali.send_message_start` — начало отправки
- `vali.send_message_success` — успех
- `vali.insufficient_gp` — недостаточно GP
- `vali.score_validation_start` — начало скоринга
- `vali.score_validation_success` — успех скоринга
- `vali.create_validation_start` — создание валидации
- `vali.create_validation_success` — успех создания
- `vali.validation_abandoned` — валидация заброшена

## Примеры полных сценариев

### Сценарий 1: Полный цикл валидации

```dart
Future<void> runFullValidation() async {
  final valiService = ValiService(Supabase.instance.client);
  
  try {
    // 1. Проверяем, первая ли это валидация
    final isFirst = await valiService.isFirstValidation();
    print(isFirst ? 'Первая валидация — бесплатно!' : 'Стоимость: 20 GP');
    
    // 2. Создаём валидацию
    final validationId = await valiService.createValidation();
    
    // 3. Ведём диалог (7 вопросов)
    final messages = <Map<String, dynamic>>[];
    String? chatId;
    
    for (int step = 1; step <= 7; step++) {
      // Получаем ввод пользователя
      final userInput = await getUserInput();
      messages.add({'role': 'user', 'content': userInput});
      
      // Отправляем в Валли
      final response = await valiService.sendMessage(
        messages: messages,
        validationId: validationId,
      );
      
      final assistantMessage = response['message']['content'];
      messages.add({'role': 'assistant', 'content': assistantMessage});
      
      // Сохраняем в БД
      chatId = await valiService.saveConversation(
        role: 'user',
        content: userInput,
        chatId: chatId,
        validationId: validationId,
      );
      
      await valiService.saveConversation(
        role: 'assistant',
        content: assistantMessage,
        chatId: chatId,
        validationId: validationId,
      );
      
      // Обновляем прогресс
      await valiService.updateValidationProgress(
        validationId: validationId,
        currentStep: step,
      );
      
      print('Валли (вопрос $step): $assistantMessage');
    }
    
    // 4. Запрашиваем скоринг
    final scoringResult = await valiService.scoreValidation(
      messages: messages,
      validationId: validationId,
    );
    
    // 5. Показываем результаты
    final report = scoringResult['report'];
    print('\n$report');
    
  } on ValiFailure catch (e) {
    if (e.statusCode == 402) {
      print('Недостаточно GP. Нужно пополнить баланс.');
    } else {
      print('Ошибка: ${e.message}');
    }
  }
}
```

### Сценарий 2: Продолжение незавершённой валидации

```dart
Future<void> resumeValidation(String validationId) async {
  final valiService = ValiService(Supabase.instance.client);
  
  try {
    // 1. Загружаем валидацию
    final validation = await valiService.getValidation(validationId);
    
    if (validation == null) {
      print('Валидация не найдена');
      return;
    }
    
    if (validation['status'] == 'completed') {
      print('Валидация уже завершена');
      return;
    }
    
    // 2. Загружаем историю сообщений из leo_messages
    final chatId = validation['chat_id'];
    final messages = await loadMessagesFromDb(chatId);
    
    // 3. Продолжаем с текущего шага
    final currentStep = validation['current_step'] ?? 1;
    print('Продолжаем с вопроса $currentStep');
    
    // ... продолжаем диалог
    
  } on ValiFailure catch (e) {
    print('Ошибка: ${e.message}');
  }
}
```

## Архитектурные решения

### 1. Переиспользование LeoService паттернов

- Dio для HTTP-запросов (как в `LeoService`)
- Retry механизм с экспоненциальным backoff
- Sentry breadcrumbs для отладки
- Единообразная обработка ошибок

### 2. Интеграция с существующей инфраструктурой

- Использует `leo_chats` и `leo_messages` с `bot='vali'`
- Отдельная таблица `idea_validations` для метаданных
- GP-экономика через `GpService`

### 3. Типобезопасность

- Typed exception `ValiFailure` с кодом и данными
- Явные типы параметров и возвращаемых значений
- Null safety по всему коду

### 4. Отладка

- Sentry breadcrumbs на всех ключевых этапах
- `debugPrint` для локальной разработки
- Структурированные данные в breadcrumbs

## Миграция с прототипа

Если у вас уже есть код валидации на прототипе, используйте следующую схему миграции:

```dart
// ❌ Старый код (прототип)
final response = await dio.post('https://.../val-chat', ...);

// ✅ Новый код (ValiService)
final response = await valiService.sendMessage(messages: messages);
```

## Тестирование

### Unit-тесты

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('ValiService.sendMessage should handle 402 error', () async {
    // Arrange
    final mockClient = MockSupabaseClient();
    final valiService = ValiService(mockClient);
    
    // Act & Assert
    expect(
      () => valiService.sendMessage(messages: []),
      throwsA(isA<ValiFailure>().having(
        (e) => e.statusCode, 
        'statusCode', 
        equals(402)
      )),
    );
  });
}
```

## Дополнительные ресурсы

- **Edge Function:** `supabase/functions/val-chat/index.ts`
- **База данных:** `supabase/migrations/20251215_create_idea_validations.sql`
- **План реализации:** `docs/val-chat/val-plan.md`
- **Концепт Валли:** `docs/val-chat/concept_valli.md`

---

**Версия:** 1.0  
**Дата:** 15.12.2024  
**Автор:** BizLevel Development Team
