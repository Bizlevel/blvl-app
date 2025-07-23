# План модификации Online Course App → BizLevel v2.0

## 🎯 Главные принципы
- Максимум существующего кода
- Минимум новых зависимостей
- Простота важнее идеального кода
- 14 дней на запуск MVP

## 📦 Обновление зависимостей

### Удаляем:
- `carousel_slider` - не нужна карусель для уровней

### Добавляем:
```yaml
flutter_riverpod: ^2.4.0      # Стейт-менеджмент (вместо Provider)
supabase_flutter: ^2.3.0      # Backend
dio: ^5.4.0                   # Вызовы Edge Functions и OpenAI
video_player: ^2.8.1          # Нативный видео-плеер
chewie: ^1.7.0                # Контролы поверх video_player
flutter_cache_manager: ^3.3.0 # Офлайн-кэш видео
flutter_animate: ^4.3.0       # Простые анимации
url_launcher: ^6.2.2          # Открытие ссылок на оплату
sentry_flutter: ^7.16.0       # Crash-репорты
freezed_annotation: ^2.4.1    # Генерация моделей
```

**dev_dependencies:**
```yaml
build_runner: ^2.4.8          # Генерация кода
freezed: ^2.4.1               # Модели immutable
json_serializable: ^6.7.1     # JSON (де)сериализация
```

## 🗂 Структура проекта

### Существующая структура:
```
lib/
├── screens/
│   ├── home.dart
│   ├── chat.dart
│   ├── account.dart
│   └── root_app.dart
├── widgets/
│   ├── feature_item.dart
│   ├── category_box.dart
│   ├── chat_item.dart
│   ├── custom_image.dart
│   ├── custom_textfield.dart
│   ├── notification_box.dart
│   ├── bottombar_item.dart
│   └── ...
├── theme/
│   └── color.dart
├── utils/
│   ├── data.dart
│   └── constant.dart
└── main.dart
```

### Новая структура:
```
lib/
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart         # НОВЫЙ
│   │   └── onboarding_screens.dart   # НОВЫЙ
│   ├── levels_map_screen.dart        # ПЕРЕИМЕНОВАН из home.dart
│   ├── level_detail_screen.dart      # НОВЫЙ
│   ├── leo_chat_screen.dart          # ПЕРЕИМЕНОВАН из chat.dart
│   ├── leo_dialog_screen.dart        # НОВЫЙ
│   ├── profile_screen.dart           # ПЕРЕИМЕНОВАН из account.dart
│   └── root_app.dart                 # ИЗМЕНЕН
├── widgets/
│   ├── level_card.dart               # АДАПТИРОВАН из feature_item.dart
│   ├── lesson_widget.dart            # НОВЫЙ
│   ├── quiz_widget.dart              # НОВЫЙ
│   ├── leo_message_bubble.dart       # НОВЫЙ
│   ├── artifact_card.dart            # АДАПТИРОВАН из recommend_item.dart
│   └── ... (остальные без изменений)
├── models/                            # НОВАЯ ПАПКА
│   ├── user_model.dart
│   ├── level_model.dart
│   ├── lesson_model.dart
│   └── leo_chat_model.dart
├── services/                          # НОВАЯ ПАПКА
│   ├── supabase_service.dart
│   ├── auth_service.dart
│   └── leo_service.dart
├── providers/                         # НОВАЯ ПАПКА
│   ├── auth_provider.dart
│   ├── levels_provider.dart
│   ├── leo_provider.dart
│   └── user_progress_provider.dart
├── theme/
│   └── color.dart                    # БЕЗ ИЗМЕНЕНИЙ
└── main.dart                         # ИЗМЕНЕН

assets/
├── icons/                            # БЕЗ ИЗМЕНЕНИЙ
└── images/                          # НОВАЯ ПАПКА
    └── onboarding/
```

## 🔄 Детальный план трансформации

### 1. main.dart
**Что меняем:**
- Инициализация Supabase
- Обертка в ProviderScope (Riverpod)
- Проверка авторизации при запуске

**Логика:**
```
1. Инициализировать Supabase с ключами
2. Проверить сохраненную сессию
3. Если есть → RootApp
4. Если нет → LoginScreen
```

### 2. screens/home.dart → levels_map_screen.dart
**Что оставляем:**
- CustomScrollView с SliverAppBar
- Общую структуру разметки
- Стилизацию

**Что убираем:**
- Горизонтальный список категорий (CategoryBox)
- CarouselSlider с featured курсами
- Секцию Recommended

**Что добавляем:**
- Riverpod ConsumerWidget вместо StatefulWidget
- Загрузка уровней из Supabase через levelsProvider
- Вертикальный список LevelCard
- Проверка доступа (бесплатные/платные)

**Компоненты:**
- `_buildHeader()` → показывает имя и прогресс пользователя
- `_buildLevelsList()` → использует существующий ListView с LevelCard
- `NotificationBox` → переделываем для показа остатка сообщений Leo

### 3. widgets/feature_item.dart → level_card.dart
**Что оставляем:**
- Всю структуру и дизайн карточки
- Анимации и тени
- Расположение элементов

**Что меняем:**
- Вместо цены → номер уровня в круге
- Вместо session/duration → количество уроков
- Добавляем оверлей с замком для заблокированных

**Логика отображения:**
```
if (уровень <= 3 || user.isPremium || уровень пройден) {
  показать нормально
} else {
  показать с серым оверлеем и иконкой замка
}
```

### 4. screens/chat.dart → leo_chat_screen.dart
**Что оставляем:**
- Структуру экрана с заголовком
- CustomTextBox для поиска → убираем
- ListView для отображения

**Что меняем:**
- Вместо списка чатов → список старых диалогов с Leo
- ChatItem показывает превью диалога (первое сообщение)
- При клике → открываем LeoDialogScreen

**Новые компоненты:**
- Кнопка "Новый диалог" вверху
- Счетчик оставшихся сообщений

### 5. screens/leo_dialog_screen.dart (НОВЫЙ)
**Компоненты:**
- AppBar с названием "Leo AI Ментор"
- ListView.builder для сообщений
- LeoMessageBubble для отображения сообщений
- CustomTextBox внизу для ввода
- Кнопка отправки

**Логика:**
```
1. Загрузить историю если есть conversationId
2. При отправке:
   - Проверить лимит сообщений
   - Отправить на Edge Function
   - Показать typing индикатор
   - Добавить ответ в список
   - Обновить счетчик
```

### 6. screens/account.dart → profile_screen.dart
**Что оставляем:**
- Всю структуру и компоненты
- SettingBox для статистики
- SettingItem для настроек

**Что меняем:**
- Вместо "12 courses" → "Уровень X/10"
- Вместо "55 hours" → "X сообщений Leo"
- Вместо "4.8" → "X артефактов"
- Добавляем кнопку "Получить Premium" если не Premium

**Новые секции:**
- Список скачанных артефактов (используем ArtifactCard)
- Кнопка "Инструкция по оплате"

### 7. screens/root_app.dart
**Что оставляем:**
- Всю логику навигации
- Анимации переходов
- BottomBar структуру

**Что меняем:**
- Только 3 таба: Уровни, Leo, Профиль
- Иконки: home → levels, chat → leo, profile остается
- Обертка в ConsumerWidget для Riverpod

### 8. screens/auth/login_screen.dart (НОВЫЙ)
**Компоненты:**
- CustomImage для логотипа
- 2x CustomTextBox (email, пароль)
- Кнопка "Войти" (стилизованный ElevatedButton)
- TextButton "Регистрация"

**Логика:**
- Supabase Auth signInWithPassword
- При успехе → проверка онбординга
- При ошибке → SnackBar

### 9. screens/auth/onboarding_screens.dart (НОВЫЙ)
**Экран 1 - Профиль:**
- CustomTextBox для имени
- CustomTextBox для "О себе" (multiline)
- CustomTextBox для "Цель обучения"
- Кнопка "Далее"

**Экран 2 - Видео инструкция:**
- video_player + chewie с Vimeo-роликом (кэширование через flutter_cache_manager)
- Полноэкранный режим
- Кнопка "Начать" внизу
- "Пропустить" появляется через 5 сек

### 10. screens/level_detail_screen.dart (НОВЫЙ)
**Структура:**
- AppBar с названием уровня
- SingleChildScrollView с уроками
- Последовательное прохождение

**Компоненты:**
- LessonWidget для каждого урока
- QuizWidget после видео
- Кнопка "Завершить уровень" в конце
- ArtifactCard для скачивания

### 11. widgets/lesson_widget.dart (НОВЫЙ)
**Компоненты:**
- Text для описания урока
- video_player + chewie для видео (9:16) с offline-кэшированием
- Кнопки "Назад" и "Далее"

**Логика:**
- Автовоспроизведение видео
- Блокировка "Далее" пока не посмотрено
- Сохранение прогресса

### 12. widgets/quiz_widget.dart (НОВЫЙ)
**Компоненты:**
- Text с вопросом
- RadioListTile для вариантов
- Кнопка "Проверить"
- Text с результатом

**Логика:**
- Локальная проверка ответа
- При ошибке → подсказка
- При успехе → разблокировка "Далее"

## 🔌 Сервисы

### supabase_service.dart
**Функции:**
- `initialize()` - инициализация при запуске
- `getCurrentUser()` - текущий пользователь
- `getLevels()` - список уровней
- `getLessons(levelId)` - уроки уровня
- `getUserProgress()` - прогресс пользователя
- `updateProgress()` - обновление прогресса
- `getLeoChats()` - история диалогов

### auth_service.dart
**Функции:**
- `signIn(email, password)`
- `signUp(email, password)`
- `signOut()`
- `updateProfile(name, about, goal)`
- `checkOnboarding()`

### leo_service.dart
**Функции:**
- `sendMessage(messages, userId)` - через Edge Function
- `checkMessageLimit(userId)`
- `decrementMessageCount(userId)`
- `saveConversation(messages, userId)`

## 📊 Providers (Riverpod)

### auth_provider.dart
```
- authStateProvider - слушает изменения авторизации
- currentUserProvider - данные текущего пользователя
```

### levels_provider.dart
```
- levelsProvider - список всех уровней
- currentLevelProvider - текущий открытый уровень
- lessonsProvider(levelId) - уроки конкретного уровня
```

### leo_provider.dart
```
- leoChatsProvider - история диалогов
- currentChatProvider - текущий диалог
- messageCountProvider - остаток сообщений
```

### user_progress_provider.dart
```
- userProgressProvider - прогресс по всем уровням
- levelProgressProvider(levelId) - прогресс конкретного уровня
```

## ⏱ План работ по дням

### Дни 1-2: Инфраструктура
- Настройка Supabase проекта
- Создание таблиц и RLS политик
- Добавление зависимостей
- Базовая структура папок
- Настройка Riverpod

### Дни 3-4: Авторизация
- LoginScreen с Supabase Auth
- Онбординг (2 экрана)
- Сохранение профиля
- AuthService и AuthProvider

### Дни 5-7: Основной функционал
- Трансформация home → levels_map_screen
- Адаптация feature_item → level_card
- LevelDetailScreen с уроками
- LessonWidget с video_player + chewie
- QuizWidget с локальной валидацией

### Дни 8-10: Leo AI
- Настройка Edge Function
- Трансформация chat → leo_chat_screen
- LeoDialogScreen
- LeoService с подсчетом лимитов
- Интеграция с OpenAI

### Дни 11-12: Профиль и платежи
- Адаптация account → profile_screen
- Отображение прогресса и артефактов
- Инструкция по оплате
- Интеграция Kaspi Pay (базовая)

### Дни 13-14: Финализация
- Тестирование всех флоу
- Исправление багов
- Оптимизация производительности
- Сборка APK для Android
- Подготовка к релизу

## ✅ Что получаем в MVP
- Полноценное обучение с видео
- AI ментор с лимитами
- Система прогресса
- Монетизация через подписку
- Офлайн просмотр видео

## ❌ Что НЕ включаем
- Push уведомления
- Сложная аналитика
- Социальные функции
- Офлайн режим для данных
- Сертификаты