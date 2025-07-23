# План реализации BizLevel v2.1 - Фаза 14-16: Рефакторинг и стабилизация архитектуры

Настоящий план основан на результатах технического аудита и направлен на устранение ключевых архитектурных недостатков, повышение тестируемости и стабильности приложения. Задачи разбиты на атомарные операции для последовательного и безопасного выполнения.

## Этап 14: Фундаментальный рефакторинг и DI

### Задача 14.1: Исправление бага в логике онбординга
- **Файлы:** `lib/services/auth_service.dart`
- **Компоненты:** `AuthService`
- **Что делать:**
  1. В методе `updateProfile` изменить жестко заданное значение `onboarding_completed: false`. Логика должна позволять устанавливать это поле в `true` или обновлять профиль, не затрагивая его.
  2. Рекомендуемое решение: добавить необязательный параметр `bool? onboardingCompleted`.
- **Почему это важно:**
  Критический баг, который ломает ключевую логику онбординга.
- **Проверка результата:**
  Вызов `updateProfile` с `onboardingCompleted: true` корректно обновляет поле в БД. Вызов без этого параметра не изменяет существующее значение.

### Задача 14.2: Преобразование AuthService в инстанцируемый класс
- **Файлы:** `lib/services/auth_service.dart`, `lib/services/supabase_service.dart`
- **Компоненты:** `AuthService`, `SupabaseService`, `Riverpod Providers`
- **Что делать:**
  1. Создать провайдер `supabaseClientProvider`, который будет возвращать `SupabaseService.client`.
  2. В `AuthService` убрать `static` у всех методов. Класс больше не должен быть синглтоном.
  3. Создать конструктор для `AuthService`, который принимает `SupabaseClient`.
  4. Создать `authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.watch(supabaseClientProvider)))`.
- **Почему это важно:**
  Это **фундаментальный шаг** для внедрения Dependency Injection. Он подготавливает сервис к использованию в тестах и в других частях приложения через DI.
- **Проверка результата:**
  `AuthService` является обычным классом. Провайдер `authServiceProvider` успешно его создает. Приложение пока не будет компилироваться, это нормально.

### Задача 14.3: Миграция потребителей AuthService на использование провайдера
- **Файлы:** `lib/screens/auth/login_screen.dart`, `lib/providers/auth_provider.dart` и другие места, где вызывается `AuthService`.
- **Зависимости:** 14.2
- **Компоненты:** `LoginScreen`, `currentUserProvider`
- **Что делать:**
  1. Найти все вызовы `AuthService.staticMethod()` в проекте.
  2. Заменить их на `ref.read(authServiceProvider).instanceMethod()` (в методах) или `ref.watch(authServiceProvider)` (в `build` методах).
  3. Для классовых виджетов передавать `WidgetRef` в методы.
- **Почему это важно:**
  Завершает переход на DI, полностью отвязывая UI и другие провайдеры от статической реализации сервиса.
- **Проверка результата:**
  Проект компилируется. Статические вызовы `AuthService` полностью отсутствуют. Функционал логина работает как прежде.

### Задача 14.4: Устранение дублирования кода в `AuthService`
- **Файлы:** `lib/services/auth_service.dart`
- **Зависимости:** 14.3
- **Компоненты:** `AuthService`
- **Что делать:**
  1. Создать приватный метод-обертку, например `_handleAuthCall`, который содержит общий блок `try-catch`.
  2. Рефакторить публичные методы (`signIn`, `signUp`, `signOut`, `updateProfile`) для использования этой обертки.
- **Почему это важно:**
  Соответствие принципу DRY. Упрощает поддержку логики обработки ошибок.
- **Проверка результата:**
  Дублирующиеся блоки `try-catch` удалены. Логика обработки ошибок централизована и работает корректно.

## Этап 15: Внедрение GoRouter и рефакторинг навигации

### Задача 15.1: Установка и базовая настройка `GoRouter`
- **Файлы:** `pubspec.yaml`, `lib/main.dart`, новый `lib/routing/app_router.dart`
- **Компоненты:** `GoRouter`, `MaterialApp`
- **Что делать:**
  1. Добавить `go_router` в `pubspec.yaml`.
  2. Создать файл `app_router.dart` и определить в нем `GoRouter` через `Riverpod` провайдер.
  3. Определить основные маршруты: `/login`, `/register`, `/home`.
  4. В `main.dart` заменить `MaterialApp` на `MaterialApp.router` и подключить конфигурацию роутера.
- **Почему это важно:**
  Создает основу для централизованной системы навигации.
- **Проверка результата:**
  Приложение запускается с `GoRouter`. Открытие стартовой страницы (`/login`) работает.

### Задача 15.2: Реализация `AuthGate` через `redirect` в `GoRouter`
- **Файлы:** `lib/routing/app_router.dart`, `lib/main.dart`
- **Зависимости:** 15.1
- **Компоненты:** `GoRouter redirect`, `authStateProvider`
- **Что делать:**
  1. В конфигурации `GoRouter` добавить секцию `redirect`.
  2. В `redirect` добавить логику, которая будет слушать `authStateProvider` и проверять текущий маршрут.
  3. Если пользователь не аутентифицирован и пытается зайти не на `/login` или `/register`, перенаправлять его на `/login`.
  4. Если пользователь аутентифицирован и находится на `/login`, перенаправлять его на `/home`.
  5. Удалить старую логику роутинга из виджета `MyApp` в `main.dart`.
- **Почему это важно:**
  Централизует всю логику авторизационных переходов в одном месте, делая ее предсказуемой и легко поддерживаемой.
- **Проверка результата:**
  Пользователь без сессии автоматически попадает на `/login`. После успешного входа его перебрасывает на `/home`.

### Задача 15.3: Рефакторинг `LoginScreen` для управления UI-состоянием через Riverpod
- **Файлы:** `lib/screens/auth/login_screen.dart`
- **Зависимости:** 14.3
- **Компоненты:** `LoginScreen`, `StateNotifier`
- **Что делать:**
  1. Создать `LoginController` (`StateNotifier<bool>`) для управления состоянием загрузки кнопки.
  2. В `LoginScreen` заменить `ConsumerStatefulWidget` на `ConsumerWidget`.
  3. Удалить локальное состояние `_isLoading` и `setState`.
  4. Кнопка "Войти" должна менять свое состояние (текст/индикатор) на основе `ref.watch(loginControllerProvider)`.
  5. `onPressed` должен вызывать `ref.read(loginControllerProvider.notifier).signIn(...)`.
- **Почему это важно:**
  Переход на идиоматичное для Riverpod управление состоянием. Делает виджет проще и готовит его к тестированию.
- **Проверка результата:**
  Экран входа работает как раньше, но без использования `StatefulWidget` и `setState`.

## Этап 16: Слой данных и Тестирование

### Задача 16.1: Создание `UserRepository` и рефакторинг `currentUserProvider`
- **Файлы:** новый `lib/repositories/user_repository.dart`, `lib/providers/auth_provider.dart`
- **Зависимости:** 14.3
- **Компоненты:** `UserRepository`, `currentUserProvider`
- **Что делать:**
  1. Создать класс `UserRepository`, принимающий `SupabaseClient`.
  2. Перенести логику запроса к таблице `users` из `currentUserProvider` в метод `fetchProfile(userId)` в `UserRepository`.
  3. Создать `userRepositoryProvider`.
  4. `currentUserProvider` должен зависеть от `userRepositoryProvider` для получения данных.
- **Почему это важно:**
  Абстрагирует доступ к данным, улучшает структуру и позволяет переиспользовать логику запросов.
- **Проверка результата:**
  Данные пользователя загружаются через `UserRepository`, `currentUserProvider` не содержит прямых вызовов к Supabase.

### Задача 16.2: Написание Unit-тестов для `AuthService`
- **Файлы:** `test/services/auth_service_test.dart`
- **Зависимости:** 14.2, `mocktail`
- **Компоненты:** `flutter_test`
- **Что делать:**
  1. Добавить `mocktail` в `dev_dependencies`.
  2. Написать тесты для `AuthService`, используя "мок" `SupabaseClient`. Проверить, что сервис вызывает правильные методы клиента и корректно обрабатывает исключения.
- **Почему это важно:**
  Гарантирует, что ключевая логика аутентификации работает корректно и защищена от регрессий.
- **Проверка результата:**
  Выполнение `flutter test test/services/auth_service_test.dart` проходит успешно.

### Задача 16.3: Написание Widget-теста для `LoginScreen`
- **Файлы:** `test/screens/auth/login_screen_test.dart`
- **Зависимости:** 15.3, 16.2
- **Компоненты:** `flutter_test`, `mocktail`
- **Что делать:**
  1. Написать widget-тест для `LoginScreen`.
  2. Использовать `ProviderScope(overrides: ...)` для подмены `authServiceProvider` и `loginControllerProvider` на мок-версии.
  3. Проверить, что при ошибке от `signIn` показывается `SnackBar`.
  4. Проверить, что во время загрузки на кнопке отображается `CircularProgressIndicator`.
- **Почему это важно:**
  Проверяет корректность взаимодействия UI с бизнес-логикой без реальных сетевых запросов.
- **Проверка результата:**
  Выполнение `flutter test test/screens/auth/login_screen_test.dart` проходит успешно.

## Этап 17: Завершение DI и миграция навигации

### Задача 17.1: Инстанцируемый SupabaseService + провайдер
- **Файлы:** `lib/services/supabase_service.dart`, `lib/providers/*`, `lib/main.dart`
- **Что делать:**
  1. Убрать `static`-паттерн из `SupabaseService`, перевести в обычный класс.
  2. Создать `supabaseServiceProvider = Provider<SupabaseService>((_) => SupabaseService())`.
  3. Экспортировать `SupabaseClient` через геттер внутри сервиса.
  4. Заменить прямые обращения `SupabaseService.client` на `ref.read(supabaseServiceProvider).client`.
- **Почему это важно:** Завершает переход на DI и унифицирует доступ к Supabase.
- **Проверка результата:** Приложение собирается и выполняет запросы к БД без ошибок.

### Задача 17.2: Инстанцируемый LeoService + провайдер
- **Файлы:** `lib/services/leo_service.dart`, `lib/providers/*`
- **Зависимости:** 17.1
- **Что делать:**
  1. Аналогично 17.1, убрать `static` из `LeoService`.
  2. Создать `leoServiceProvider` (Provider).
  3. Обновить все вызовы `LeoService.*` на DI-вариант `ref.read(leoServiceProvider)`.
- **Проверка результата:** Отправка сообщения Leo и загрузка истории работают.

### Задача 17.3: LevelsRepository и LessonsRepository
- **Файлы:** `lib/repositories/levels_repository.dart`, `lib/repositories/lessons_repository.dart`, `lib/providers/levels_provider.dart`, `lib/providers/lessons_provider.dart`
- **Что делать:**
  1. Создать два репозитория с методами `fetchLevels()` и `fetchLessons(levelId)`.
  2. Переместить логику из текущих провайдеров в репозитории.
  3. Провайдеры должны вызывать методы репозиториев, а не Supabase напрямую.
  4. **Рефакторинг:** Перенести специфичные методы (`getVideoSignedUrl`, `getArtifactSignedUrl`) из `SupabaseService` в профильные репозитории для улучшения инкапсуляции.
- **Проверка результата:** UI карт уровней и деталек загружается корректно, тесты проходят.

### Задача 17.4: Миграция Onboarding и Profile на GoRouter
- **Файлы:** `lib/routing/app_router.dart`, `lib/screens/auth/onboarding_*`, `lib/screens/profile_screen.dart`
- **Зависимости:** 15.x
- **Что делать:**
  1. Добавить маршруты `/onboarding/profile`, `/onboarding/video`, `/profile`.
  2. Заменить оставшиеся `Navigator.push` на `context.go()` / `context.push()`.
  3. Удалить устаревшие импорты `Navigator` где они больше не нужны.
- **Проверка результата:** Навигация через GoRouter работает во всех флоу без дублирования кода.

### Задача 17.5: Базовый deep-linking `/levels/:id`
- **Файлы:** `lib/routing/app_router.dart`, `lib/screens/level_detail_screen.dart`, `pubspec.yaml`
- **Что делать:**
  1. Подключить пакет `uni_links`.
  2. Обработать URI с шаблоном `bizlevel://levels/<id>` и перенаправлять в GoRouter.
  3. Добавить базовый тест на парсинг ссылки.
- **Проверка результата:** Открытие deep-ссылки из браузера/терминала ведёт к нужному уровню.

### Задача 17.6: Unit-тесты для репозиториев и сервисов
- **Файлы:** `test/repositories/`, `test/services/`
- **Зависимости:** 17.1, 17.2, 17.3
- **Что делать:**
  1. Написать Unit-тесты для `UserRepository`, `LevelsRepository`, `LessonsRepository`, используя мок `SupabaseClient`.
  2. Написать Unit-тесты для инстанцируемого `LeoService`.
  3. Проверить корректность обработки данных и исключений.
- **Почему это важно:** Гарантирует стабильность слоя данных и бизнес-логики, защищает от регрессий.
- **Проверка результата:** Тесты в директориях `test/repositories` и `test/services` успешно выполняются.

### Задача 17.7: Widget-тесты для экранов уровней
- **Файлы:** `test/screens/levels_map_screen_test.dart`, `test/screens/level_detail_screen_test.dart`
- **Зависимости:** 17.6
- **Что делать:**
  1. Написать widget-тесты для `LevelsMapScreen` и `LevelDetailScreen`.
  2. Использовать `ProviderScope(overrides: ...)` для подмены репозиториев на мок-версии.
  3. Проверить корректное отображение состояний загрузки, данных и ошибок.
- **Почему это важно:** Проверяет корректность интеграции UI со слоем данных.
- **Проверка результата:** Тесты в директории `test/screens` успешно выполняются.

## Этап 18: Безопасность, офлайн-кеш и платежи

### Задача 18.1: RLS-аудит и автоматическая проверка
- **Файлы:** `supabase/migrations/*`, `.github/workflows/ci.yaml`
- **Что делать:**
  1. В CI вызвать `mcp_supabase_get_advisors` (security) и упасть, если есть критические нарушения.
  2. Добавить недостающие RLS-политики для `lessons`, `levels`, `leo_messages`, `user_progress`.
- **Проверка результата:** Адвайзоры возвращают «0 критических», CI проходит.

### Задача 18.2: Локальный кеш уровней и уроков через Hive
- **Файлы:** `pubspec.yaml`, `lib/repositories/*`, `lib/providers/*`
- **Зависимости:** 17.3
- **Что делать:**
  1. Добавить зависимость `hive` + генераторы.
  2. В `LevelsRepository` и `LessonsRepository` реализовать стратегию `stale-while-revalidate`.
  3. При отсутствии интернета отдавать кеш; при наличии — обновлять и сохранять.
- **Проверка результата:** Уровни/уроки отображаются офлайн, а онлайн-режим обновляет данные.

### Задача 18.3: Базовая схема подписок в Supabase
- **Файлы:** `supabase/migrations/add_subscriptions.sql`
- **Что делать:**
  1. Создать таблицы `subscriptions` и `payments` с FK на `users`.
  2. Добавить индексы и RLS (доступ только владельцу и сервисным ролям).
- **Проверка результата:** Миграция выполняется без ошибок, таблицы видны в Studio.

### Задача 18.4: Edge Function `create_checkout_session`
- **Файлы:** `supabase/functions/create-checkout-session/index.ts`, `lib/services/payment_service.dart`
- **Зависимости:** 18.3
- **Что делать:**
  1. Написать функцию, вызывающую Kaspi/Freedom Pay API и возвращающую URL платежа.
  2. Создать `PaymentService` с методом `startCheckout()` (Dio + Edge Function).
- **Проверка результата:** Вызов метода возвращает URL, который открывается в WebView и ведёт на кассу.

### Задача 18.5: Экран Premium и состояние подписки
- **Файлы:** `lib/screens/premium_screen.dart`, `lib/providers/subscription_provider.dart`, `lib/screens/profile_screen.dart`
- **Зависимости:** 18.4
- **Что делать:**
  1. Создать экран c тарифами и кнопкой «Оформить» (вызывает `startCheckout`).
  2. `subscriptionProvider` слушает статус из таблицы `subscriptions` (реaltime).
  3. В `ProfileScreen` отображать бейдж Premium при активной подписке.
- **Проверка результата:** После тестовой записи в `subscriptions.status = active` UI показывает Premium.

### Задача 18.6: Ускорение CI/CD за счет кэширования
- **Файлы:** `.github/workflows/ci.yaml`
- **Что делать:**
  1. В CI-workflow добавить шаги для кэширования зависимостей:
     - `flutter pub get`
     - `CocoaPods`
     - `Gradle`
- **Почему это важно:**
  Значительно сокращает время выполнения CI/CD, экономит ресурсы и ускоряет получение обратной связи.
- **Проверка результата:**
  Последующие запуски CI-пайплайна выполняются быстрее на шагах установки зависимостей.

### Задача 18.7: Улучшенное логирование в CI при падении тестов
- **Файлы:** `.github/workflows/ci.yaml`
- **Что делать:**
  1. Добавить в workflow условный шаг, который выполняется только при падении шага `flutter test`.
  2. Этот шаг должен вызывать `mcp_supabase_get_logs`, чтобы получить последние логи из сервисов Supabase.
- **Почему это важно:**
  Ускоряет диагностику проблем, связанных с бэкендом, позволяя увидеть ошибки Supabase прямо в логах CI, без необходимости идти в дашборд.
- **Проверка результата:**
  При падении интеграционного теста в логах CI появляется вывод логов Supabase.
