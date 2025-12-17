# Интеграция Валли в Base Trainers

## Обзор

Валли интегрирован в экран Base Trainers (`leo_chat_screen.dart`) как третья карточка выбора AI-ассистента, наряду с Лео и Максом.

## Файлы

- **Экран:** `lib/screens/leo_chat_screen.dart`
- **Дата интеграции:** 15.12.2024

## Изменения

### 1. Импорт ValiDialogScreen

```dart
import 'package:bizlevel/screens/vali_dialog_screen.dart';
```

### 2. Layout карточек

**Было (2 карточки горизонтально):**
```dart
return Row(
  children: [
    buildCard(bot: 'leo', ...),
    buildCard(bot: 'max', ...),
  ],
);
```

**Стало (3 карточки вертикально):**
```dart
return Column(
  children: [
    buildCard(bot: 'leo', ...),
    buildCard(bot: 'max', ...),
    buildCard(bot: 'vali', ...),
  ],
);
```

**Причина изменения:** 3 карточки не помещаются горизонтально на мобильных экранах.

### 3. Карточка Валли

```dart
buildCard(
  bot: 'vali',
  name: 'Vali AI',
  subtitle: 'Проверь идею на прочность',
  avatar: 'assets/images/avatars/avatar_vali.png',
),
```

**Метаданные:**
- **bot:** `'vali'` — идентификатор бота
- **name:** `'Vali AI'` — отображаемое имя
- **subtitle:** `'Проверь идею на прочность'` — описание функционала
- **avatar:** путь к аватару (временно используется копия Лео)

### 4. Навигация к ValiDialogScreen

**Метод `_onNewChat()` обновлён:**

```dart
void _onNewChat(String bot) {
  if (bot == 'vali') {
    // Валли → ValiDialogScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ValiDialogScreen(),
      ),
    );
  } else {
    // Лео/Макс → LeoDialogScreen (существующая логика)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FutureBuilder<List<String?>>(
          future: Future.wait([_getUserContext(), _getLevelContext()]),
          builder: (context, snap) {
            final userCtx = (snap.data != null) ? snap.data![0] : null;
            final lvlCtx = (snap.data != null) ? snap.data![1] : null;
            return LeoDialogScreen(
              userContext: userCtx,
              levelContext: lvlCtx,
              bot: bot,
            );
          },
        ),
      ),
    );
  }
}
```

**Особенности:**
- Для Валли НЕ требуется `userContext` и `levelContext` (используется внутри ValiService)
- Создаётся новая валидация автоматически при открытии ValiDialogScreen

### 5. История чатов

**Обработка `bot='vali'` в `_buildChats()`:**

```dart
// Парсинг бота из чата
final String botRaw = (chat['bot'] as String?)?.toLowerCase() ?? 'leo';
final String bot = ['leo', 'max', 'vali'].contains(botRaw) ? botRaw : 'leo';

// Метаданные для отображения
final String botLabel = bot == 'max' 
    ? 'Max AI' 
    : bot == 'vali' 
        ? 'Vali AI' 
        : 'Leo AI';

final String avatarPath = bot == 'max'
    ? 'assets/images/avatars/avatar_max.png'
    : bot == 'vali'
        ? 'assets/images/avatars/avatar_vali.png'
        : 'assets/images/avatars/avatar_leo.png';
```

**Навигация при клике на чат:**

```dart
return ChatItem(
  chatData,
  onTap: () {
    if (bot == 'vali') {
      // Для Валли используем ValiDialogScreen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ValiDialogScreen(
            chatId: chat['id'],
          ),
        ),
      );
    } else {
      // Для Лео и Макса — существующая логика
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FutureBuilder<List<String?>>(
            future: Future.wait([_getUserContext(), _getLevelContext()]),
            builder: (context, snap) {
              final userCtx = (snap.data != null) ? snap.data![0] : null;
              final lvlCtx = (snap.data != null) ? snap.data![1] : null;
              return LeoDialogScreen(
                chatId: chat['id'],
                userContext: userCtx,
                levelContext: lvlCtx,
                bot: bot,
              );
            },
          ),
        ),
      );
    }
  },
);
```

## UX Flow

### Новая валидация

```
Пользователь → Base Trainers
             ↓
    Нажимает на карточку "Vali AI"
             ↓
    ValiDialogScreen открывается
             ↓
    ValiService.createValidation()
             ↓
    Приветственное сообщение от Валли
             ↓
    Диалог (7 вопросов)
```

### Продолжение существующего чата

```
Пользователь → Base Trainers
             ↓
    Видит историю чатов
             ↓
    Нажимает на чат с Валли
             ↓
    ValiDialogScreen(chatId: '...')
             ↓
    Загружается история сообщений
             ↓
    Продолжение диалога
```

## Визуальная структура

```
┌─────────────────────────────────────┐
│     Base Trainers (Менторы)        │
├─────────────────────────────────────┤
│                                     │
│  ┌────────────────────────────┐    │
│  │  [🤖] Leo AI               │    │
│  │  Твой бизнес-ментор        │    │
│  │  → Начать чат              │    │
│  └────────────────────────────┘    │
│                                     │
│  ┌────────────────────────────┐    │
│  │  [🎯] Max AI               │    │
│  │  Помощник в достижении цели│    │
│  │  → Начать чат              │    │
│  └────────────────────────────┘    │
│                                     │
│  ┌────────────────────────────┐    │
│  │  [💡] Vali AI              │    │
│  │  Проверь идею на прочность │    │
│  │  → Начать чат              │    │
│  └────────────────────────────┘    │
│                                     │
│  ════════════════════════════      │
│                                     │
│  История диалогов:                 │
│  • Диалог с Leo (5 сообщений)     │
│  • Диалог с Max (12 сообщений)    │
│  • Валидация идеи (7 сообщений)   │ ← Vali
│                                     │
└─────────────────────────────────────┘
```

## Тестирование

### Ручное тестирование

1. **Открыть Base Trainers:**
   ```
   Главный экран → Менторы (таб)
   ```

2. **Проверить карточку Валли:**
   - ✅ Карточка отображается третьей
   - ✅ Аватар загружается
   - ✅ Текст "Vali AI" и "Проверь идею на прочность"
   - ✅ Кнопка "Начать чат"

3. **Нажать на карточку Валли:**
   - ✅ Открывается ValiDialogScreen
   - ✅ Приветственное сообщение от Валли
   - ✅ Прогресс-бар показывает "1/7"

4. **Проверить историю чатов:**
   - Создать чат с Валли
   - Вернуться в Base Trainers
   - ✅ Чат отображается в истории
   - ✅ Аватар Валли
   - ✅ Метка "Vali AI"
   - Нажать на чат
   - ✅ Открывается ValiDialogScreen с историей

### Unit-тесты

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('должен отобразить 3 карточки ботов', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LeoChatScreen()),
    );
    
    expect(find.text('Leo AI'), findsOneWidget);
    expect(find.text('Max AI'), findsOneWidget);
    expect(find.text('Vali AI'), findsOneWidget);
  });
  
  testWidgets('должен открыть ValiDialogScreen при нажатии', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LeoChatScreen()),
    );
    
    await tester.tap(find.text('Vali AI'));
    await tester.pumpAndSettle();
    
    expect(find.byType(ValiDialogScreen), findsOneWidget);
  });
}
```

## Известные ограничения

1. **Аватар Валли** — используется отдельный аватар совы‑Валли

2. **Вертикальный layout** — занимает больше места на экране
   - Альтернатива: горизонтальный скролл (не реализовано)

3. **Нет фильтра** — все 3 бота всегда видны
   - Альтернатива: показывать только доступных ботов (не требуется для MVP)

## Следующие шаги

1. ✅ Интеграция завершена
2. ✅ Создать уникальный аватар Валли
3. ⏳ Добавить анимацию при открытии карточки
4. ⏳ Добавить бейдж "NEW" на карточку Валли (опционально)

---

**Версия:** 1.0  
**Дата:** 15.12.2024  
**Статус:** Готово к тестированию
