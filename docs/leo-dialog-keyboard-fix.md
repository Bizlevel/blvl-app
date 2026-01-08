# Исправление проблемы с клавиатурой в диалоге Лео/Макса

**Дата:** Январь 2026  
**Проблема:** Приложение крашилось на Android при открытии клавиатуры в модальном диалоге чата с Лео/Максом  
**Статус:** ✅ Решено

## Проблема

При открытии клавиатуры в модальном диалоге (`showModalBottomSheet`) приложение на Android крашилось и возвращало пользователя на экран "башни уровней". Проблема проявлялась в двух местах:
- `FloatingChatBubble` — плавающая кнопка чата
- `LevelDetailScreen` — кнопка "Обсудить с Лео" на странице уровня

### Симптомы
1. Диалог неожиданно закрывался при появлении клавиатуры
2. Виджет `LeoDialogScreen` терял доступ к провайдерам Riverpod
3. Приложение возвращалось на предыдущий экран без явного вызова `Navigator.pop()`

## Причина

Проблема была вызвана комбинацией факторов:

1. **Конфликт обработки клавиатуры**: `adjustResize` в AndroidManifest вызывал пересчет layout, который конфликтовал с внутренней логикой `showModalBottomSheet`

2. **Потеря контекста провайдеров**: При открытии клавиатуры родительские виджеты перестраивались, что приводило к потере контекста Riverpod провайдеров, от которых зависел `LeoDialogScreen`

3. **Неправильный навигатор**: Диалог открывался в локальном навигаторе, который мог быть уничтожен при изменении layout

## Решение

### 1. Замена `showModalBottomSheet` на кастомный роут

Создан `CustomModalBottomSheetRoute` для полного контроля над поведением модального окна:

**Файл:** `lib/utils/custom_modal_route.dart`

```dart
class CustomModalBottomSheetRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  CustomModalBottomSheetRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          opaque: false,
          barrierDismissible: true,
          barrierColor: Colors.black54,
          fullscreenDialog: false,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeOut)),
              ),
              child: child,
            );
          },
        );
}
```

**Преимущества:**
- Полный контроль над жизненным циклом роута
- Избежание внутренних триггеров `showModalBottomSheet`
- Гибкая настройка анимации и поведения

### 2. Использование корневого навигатора

Все вызовы `Navigator.push` и `Navigator.pop` для диалога используют `rootNavigator: true`:

**Изменения в:**
- `lib/widgets/floating_chat_bubble.dart`
- `lib/screens/level_detail_screen.dart`

```dart
Navigator.of(context, rootNavigator: true).push(
  CustomModalBottomSheetRoute(
    child: Scaffold(...),
  ),
);
```

**Почему это важно:**
- Диалог открывается в корневом навигаторе, который не зависит от жизненного цикла родительских виджетов
- Гарантирует стабильность навигационного стека

### 3. Сохранение контекста провайдеров

`LeoDialogScreen` обернут в `UncontrolledProviderScope` для сохранения доступа к провайдерам:

```dart
UncontrolledProviderScope(
  container: ProviderScope.containerOf(context),
  child: LeoDialogScreen(
    chatId: widget.chatId,
    embedded: true,
  ),
)
```

**Изменения в:**
- `lib/widgets/floating_chat_bubble.dart`
- `lib/screens/level_detail_screen.dart`

**Почему это важно:**
- `UncontrolledProviderScope` создает независимый scope, который не зависит от жизненного цикла родителя
- Явная передача `ProviderContainer` гарантирует доступ к тем же провайдерам, что и у родителя

### 4. Настройка обработки клавиатуры в Android

**Файл:** `android/app/src/main/AndroidManifest.xml`

```xml
<activity
    android:name=".MainActivity"
    android:windowSoftInputMode="adjustResize"
    ...>
</activity>
```

**Эволюция решения:**
1. **Изначально:** `adjustResize` → вызывал краш из-за конфликта с `showModalBottomSheet`
2. **Промежуточное:** `adjustPan` → предотвратил краш, но клавиатура перекрывала поле ввода
3. **Финальное:** `adjustResize` + кастомный роут → стабильная работа с правильной обработкой клавиатуры

### 5. Настройка Flutter для работы с клавиатурой

**Изменения в:**
- `lib/widgets/floating_chat_bubble.dart`
- `lib/screens/level_detail_screen.dart`

```dart
Scaffold(
  backgroundColor: Colors.transparent,
  resizeToAvoidBottomInset: true, // Flutter поднимает контент при появлении клавиатуры
  body: Stack(
    children: [
      // Прозрачный слой для закрытия
      Positioned.fill(
        child: GestureDetector(
          onTap: () => Navigator.of(context, rootNavigator: true).pop(),
          child: Container(color: Colors.transparent),
        ),
      ),
      // Контент диалога
      Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Container(...),
        ),
      ),
    ],
  ),
)
```

**Ключевые изменения:**
- `resizeToAvoidBottomInset: true` — позволяет Flutter автоматически поднимать контент
- `ConstrainedBox` вместо фиксированной высоты — диалог может сжиматься при появлении клавиатуры
- `Expanded` внутри `LeoDialogScreen` автоматически уменьшает список сообщений

### 6. Исправление кнопки закрытия

Кнопка закрытия в AppBar не работала при открытой клавиатуре из-за проблем с контекстом:

```dart
leading: Builder(
  builder: (context) => IconButton(
    tooltip: 'Закрыть',
    icon: const Icon(Icons.close),
    onPressed: () {
      // Скрываем клавиатуру перед закрытием
      FocusManager.instance.primaryFocus?.unfocus();
      // Закрываем диалог с небольшой задержкой
      Future.microtask(() {
        final navigator = Navigator.of(context, rootNavigator: true);
        if (navigator.canPop()) {
          navigator.pop();
        }
      });
    },
  ),
),
```

**Почему это важно:**
- `Builder` гарантирует получение актуального контекста при нажатии
- `FocusManager.instance.primaryFocus?.unfocus()` надежно скрывает клавиатуру
- `Future.microtask` дает время клавиатуре закрыться перед закрытием диалога

## Структура изменений

### Новые файлы
- `lib/utils/custom_modal_route.dart` — кастомный роут для модальных окон

### Измененные файлы
1. **android/app/src/main/AndroidManifest.xml**
   - `android:windowSoftInputMode="adjustResize"`

2. **lib/widgets/floating_chat_bubble.dart**
   - Замена `showModalBottomSheet` на `Navigator.push` с `CustomModalBottomSheetRoute`
   - Использование `rootNavigator: true`
   - Обертка `LeoDialogScreen` в `UncontrolledProviderScope`
   - `resizeToAvoidBottomInset: true`
   - `ConstrainedBox` вместо фиксированной высоты
   - Исправление кнопки закрытия

3. **lib/screens/level_detail_screen.dart**
   - Те же изменения, что и в `floating_chat_bubble.dart`

4. **lib/screens/leo_dialog_screen.dart**
   - Обновлены комментарии для `adjustResize`
   - `SafeArea(bottom: false)` — Flutter сам обработает отступы

## Тестирование

### Проверенные сценарии
1. ✅ Открытие диалога из `FloatingChatBubble` — работает
2. ✅ Открытие диалога из `LevelDetailScreen` — работает
3. ✅ Открытие клавиатуры — диалог не закрывается, поле ввода не перекрывается
4. ✅ Закрытие по кнопке — работает даже при открытой клавиатуре
5. ✅ Закрытие по тапу мимо окна — работает
6. ✅ Провайдеры остаются доступными — данные не теряются

### Удаленные отладочные инструменты
После успешного решения проблемы были удалены:
- `lib/utils/dialog_logger.dart` — класс для логирования
- `scripts/capture_dialog_logs.sh` — скрипт для захвата логов
- Все вызовы `DialogLogger.log()` из кода
- `dialog_close_log.txt` — файл с логами

## Итоговый результат

✅ **Проблема решена полностью:**
- Приложение не крашится при открытии клавиатуры
- Диалог стабильно работает в любых условиях
- Клавиатура не перекрывает поле ввода и кнопки
- Провайдеры сохраняют доступность
- UX соответствует ожиданиям пользователя

## Технические детали

### Зависимости
- `flutter_riverpod: ^2.5.1` — для `UncontrolledProviderScope` и `ProviderScope.containerOf`

### Совместимость
- Android: протестировано на Android 6.0+
- iOS: изменения не требуются (iOS обрабатывает клавиатуру по-другому)

### Производительность
- Кастомный роут не добавляет накладных расходов
- `UncontrolledProviderScope` использует существующий контейнер, не создавая новый

## Рекомендации для будущих изменений

1. **При работе с модальными диалогами:**
   - Используйте `CustomModalBottomSheetRoute` вместо `showModalBottomSheet` для критичных диалогов
   - Всегда используйте `rootNavigator: true` для диалогов, которые должны быть независимы от родителя

2. **При работе с провайдерами в диалогах:**
   - Используйте `UncontrolledProviderScope` если диалог должен пережить перестройку родителя
   - Явно передавайте `ProviderContainer` через `ProviderScope.containerOf(context)`

3. **При настройке клавиатуры:**
   - Используйте `adjustResize` для сложных layout с автоматической адаптацией
   - Устанавливайте `resizeToAvoidBottomInset: true` в `Scaffold`
   - Используйте `ConstrainedBox` вместо фиксированных размеров для гибкости

## Связанные задачи

- Исправление краша при открытии клавиатуры в модальном диалоге
- Улучшение UX работы с клавиатурой в диалогах
- Стабилизация работы провайдеров в модальных окнах
