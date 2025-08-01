# План реализации BizLevel v2.0 - Фаза 2 (Этапы 8-10)

## Этап 8: Видео-инфраструктура и базовая логика уровней

### Задача 8.1: Миграция видео-контента
Файлы: Supabase Dashboard, lib/services/supabase_service.dart
Зависимости: Существующий bucket `videos`
Компоненты: SupabaseService

Что делать:
1. Загрузить все видео уроков в bucket `videos` (формат .mp4, вертикальные 9:16)
2. Загрузить онбординг видео в тот же bucket
3. Обновить все записи в таблице `lessons` - поле `video_url` должно содержать путь в Storage
4. Создать метод `getVideoSignedUrl(path)` в SupabaseService (аналогично `getArtifactSignedUrl`)
5. Протестировать генерацию signed URLs

Почему это важно:
Видео - основной контент приложения. Без рабочих видео пользователи не могут проходить обучение.

Проверка результата:
Все видео загружены в Storage, signed URLs генерируются и работают.

### Задача 8.2: Обновление видео-плеера для Supabase
Файлы: lib/widgets/lesson_widget.dart, lib/screens/auth/onboarding_screens.dart
Зависимости: 8.1
Компоненты: LessonWidget, OnboardingVideoScreen

Что делать:
1. Удалить метод `_resolvePlayableUrl` и всю логику Vimeo из LessonWidget
2. Использовать `SupabaseService.getVideoSignedUrl()` для получения URL
3. Настроить VideoPlayerController с aspectRatio 9:16
4. Обернуть видео в AspectRatio widget для корректного отображения
5. Обновить OnboardingVideoScreen аналогичным образом

Почему это важно:
Текущая интеграция с Vimeo не работает. Переход на Supabase Storage решит проблему.

Проверка результата:
Видео воспроизводятся в вертикальном формате как в уроках, так и в онбординге.

### Задача 8.3: Реализация последовательного доступа к уровням
Файлы: lib/providers/levels_provider.dart, lib/services/supabase_service.dart
Зависимости: 8.2
Компоненты: levelsProvider, SupabaseService

Что делать:
1. Модифицировать `fetchLevelsWithProgress()` для загрузки данных с JOIN на user_progress
2. В levelsProvider добавить логику определения доступности:
   - Уровень 1 всегда доступен
   - Уровень N доступен если is_completed = true для уровня N-1
   - Для !is_premium максимум 3 уровня независимо от прогресса
3. Добавить поле `isAccessible` в модель Level
4. В LevelCard показывать причину блокировки

Почему это важно:
Последовательное прохождение - ключевая механика геймификации.

Проверка результата:
Новый пользователь видит только уровень 1 доступным, остальные заблокированы.

### Задача 8.4: Переработка структуры экрана уровня
Файлы: lib/screens/level_detail_screen.dart
Зависимости: 8.3
Компоненты: LevelDetailScreen

Что делать:
1. Изменить структуру на PageView для блочной навигации
2. Создать блоки:
   - IntroBlock (описание + изображение уровня)
   - LessonBlock (видео + кнопки навигации)
   - QuizBlock (тест с повтором при ошибке)
   - ArtifactBlock (описание + кнопка скачивания)
3. Добавить индикатор прогресса внизу экрана
4. Реализовать навигацию между блоками кнопками "Назад"/"Далее"

Почему это важно:
Блочная структура соответствует концепции и улучшает UX.

Проверка результата:
Уровень отображается как последовательность полноэкранных блоков с навигацией.

## Этап 9: Система прогресса и Leo чат-баббл

### Задача 9.1: Отслеживание прогресса внутри уровня
Файлы: lib/providers/lesson_progress_provider.dart, lib/screens/level_detail_screen.dart
Зависимости: 8.4
Компоненты: lessonProgressProvider, LevelDetailScreen

Что делать:
1. Создать lessonProgressProvider для хранения:
   - Текущий блок/урок
   - Просмотренные видео (через 10 сек после начала)
   - Пройденные тесты
2. В LessonBlock добавить таймер на 10 сек для разблокировки "Далее"
3. В QuizBlock сохранять результаты тестов
4. Persist прогресс в localStorage для восстановления при выходе

Почему это важно:
Пользователи должны продолжать с места остановки.

Проверка результата:
При выходе и возврате в уровень позиция сохраняется.

### Задача 9.2: Условия завершения уровня
Файлы: lib/screens/level_detail_screen.dart, lib/services/supabase_service.dart
Зависимости: 9.1
Компоненты: LevelDetailScreen, SupabaseService

Что делать:
1. В финальном блоке проверять:
   - Все видео отмечены как просмотренные
   - Все тесты пройдены успешно
2. Активировать кнопку "Завершить уровень" только при выполнении условий
3. Реализовать `completeLevel(levelId)`:
   - Upsert в user_progress с is_completed = true
   - Обновить users.current_level если нужно
4. После завершения показать поздравление и вернуть на карту уровней

Почему это важно:
Четкие условия завершения мотивируют пройти весь контент.

Проверка результата:
Уровень 2 разблокируется только после полного прохождения уровня 1.

### Задача 9.3: Создание Leo чат-баббла
Файлы: lib/widgets/floating_chat_bubble.dart
Зависимости: 9.2
Компоненты: FloatingChatBubble

Что делать:
1. Создать StatefulWidget FloatingChatBubble
2. Позиционировать через Stack + Positioned (bottom: 20, right: 20)
3. Добавить анимацию пульсации для привлечения внимания
4. Показывать счетчик непрочитанных если есть новые сообщения
5. При тапе открывать LeoDialogScreen как модальное окно

Почему это важно:
Быстрый доступ к AI-помощнику улучшает обучение.

Проверка результата:
Баббл отображается поверх контента и открывает чат.

### Задача 9.4: Интеграция чат-баббла в уровни
Файлы: lib/screens/level_detail_screen.dart, lib/providers/leo_provider.dart
Зависимости: 9.3
Компоненты: LevelDetailScreen, leoProvider

Что делать:
1. Добавить FloatingChatBubble в Stack LevelDetailScreen
2. Передавать контекст текущего урока в Leo через systemPrompt
3. При закрытии чата сохранять диалог в leo_chats
4. Показывать/скрывать баббл в зависимости от текущего блока
5. Добавить подсказки Leo на основе текущего контента

Почему это важно:
Контекстная помощь AI повышает понимание материала.

Проверка результата:
Leo отвечает с учетом текущего урока, история сохраняется.

## Этап 10: Платформы и финальная оптимизация

### Задача 10.1: Отладка Android версии
Файлы: android/app/build.gradle, android/app/src/main/AndroidManifest.xml
Зависимости: 9.4
Компоненты: Android конфигурация

Что делать:
1. Проверить и исправить permissions для internet и storage
2. Настроить ProGuard rules для release сборки
3. Оптимизировать размер APK (удалить неиспользуемые ресурсы)
4. Протестировать на Android 8+ устройствах
5. Исправить найденные проблемы

Почему это важно:
Android - основная платформа для целевой аудитории.

Проверка результата:
Release APK собирается, устанавливается и работает стабильно.

### Задача 10.2: Базовая Web версия
Файлы: lib/main.dart, web/index.html
Зависимости: 10.1
Компоненты: Web конфигурация

Что делать:
1. Обернуть MaterialApp в ResponsiveWrapper
2. Ограничить максимальную ширину контента 600px
3. Адаптировать видео-плеер для web (может потребоваться другой пакет)
4. Заменить свайпы на кнопки навигации где нужно
5. Настроить CORS для Supabase

Почему это важно:
Web версия расширит охват аудитории.

Проверка результата:
Приложение работает в Chrome/Safari/Firefox.

### Задача 10.3: Критические исправления
Файлы: lib/screens/leo_dialog_screen.dart, все сервисы
Зависимости: 10.2
Компоненты: Все экраны и сервисы

Что делать:
1. Добавить mounted проверки перед всеми setState
2. Реализовать retry логику для Supabase запросов
3. Добавить обработку отсутствия интернета
4. Показывать понятные сообщения об ошибках
5. Логировать критические ошибки в Sentry

Почему это важно:
Стабильность критична для удержания пользователей.

Проверка результата:
Приложение gracefully обрабатывает все ошибки.

### Задача 10.4: UX полировка
Файлы: все экраны и виджеты
Зависимости: 10.3
Компоненты: UI компоненты

Что делать:
1. Добавить shimmer эффекты при загрузке
2. Улучшить анимации переходов между блоками
3. Добавить haptic feedback на важных действиях
4. Оптимизировать скорость загрузки экранов
5. Проверить и исправить мелкие UI баги

Почему это важно:
Внимание к деталям создает премиум впечатление.

Проверка результата:
Приложение работает плавно и отзывчиво.

### Задача 10.5: Финальное тестирование
Файлы: test/integration/, документация
Зависимости: 10.4
Компоненты: Все приложение

Что делать:
1. Пройти полный user journey от регистрации до завершения уровня 3
2. Протестировать на 5+ разных устройствах
3. Проверить все edge cases
4. Составить список известных ограничений
5. Подготовить release notes

Почему это важно:
Качественное тестирование предотвратит негативные отзывы.

Проверка результата:
Все основные сценарии работают без критических багов.