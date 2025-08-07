# Этап 23: Мелкие UI-фиксы и полировка (Web + Mobile)

### Задача 23.1: Экран логина и регистрации
- **Файлы:** `lib/screens/auth/login_screen.dart`, `lib/screens/auth/register_screen.dart`, `assets/images/logo_light.png`
- **Что делать:**
  1. Увеличить логотип до 96 px и поместить его в белый `Container` с радиусом 24 px.
  2. Сделать поле пароля скрытым (`obscureText`) и добавить кнопку-глаз для показа/скрытия.
  3. Обновить `RegisterScreen`, приведя макет к стилю `LoginScreen` (общий `AuthForm`).
  4. Обновить тест `login_screen_test.dart` и добавить аналогичный для регистрации.
- **Проверка:** визуальное совпадение макетов, тесты входа/регистрации зелёные.

### Задача 23.2: Карточка уровня (`LevelCard`)
- **Файл:** `lib/widgets/level_card.dart`
- **Что делать:**
  1. Убрать внутренний голубой фон, оставить только полупрозрачную серую окантовку.
  2. Замковый оверлей заблокированного уровня должен заполнять всю карточку.
  3. Отображать текст «Уровень N» вместо просто номера.
  4. Обновить golden-тесты карточки.
- **Проверка:** карточка отображается корректно во всех состояниях, golden-тесты зелёные.

### Задача 23.3: Экран уровня (`LevelDetailScreen`)
- **Файлы:** `lib/screens/level_detail_screen.dart`, `lib/providers/lesson_progress_provider.dart`
- **Что делать:**
  1. Гарантировать старт с блока 0 (текстовое описание): убедиться, что `initialPage` = 0 и `unlockedPage` по умолчанию 0.
  2. Сдвинуть `FloatingChatBubble` вверх на высоту `BottomNavigationBar` + 16 px, чтобы не перекрывать кнопку «Далее».
  3. Обновить интеграционный тест `level_detail_screen_test.dart`.
- **Проверка:** уровень всегда открывается с описания, кнопки не перекрываются, тесты проходят.

### Задача 23.4: Чат Leo
- **Файлы:** `lib/screens/leo_chat_screen.dart`, `lib/widgets/chat_item.dart`
- **Что делать:**
  1. Переместить кнопку «Новый диалог» в нижнюю часть экрана посередине (FloatingActionButton).
  2. Добавить аватар Leo (`assets/images/avatars/avatar_leo.png`) в заголовок списка диалогов.
  3. Разместить счётчик «X сообщений Leo» справа от аватара.
  4. Обновить тест `leo_integration_test.dart`.
- **Проверка:** UI совпадает с макетом Chat_Leo.png, тесты зелёные.

### Задача 23.5: Desktop NavigationRail
- **Файл:** `lib/widgets/desktop_nav_bar.dart`
- **Что делать:**
  1. Отображать подписи («Карта уровней», «Чат», «Профиль») справа от иконок.
  2. Использовать Material-иконки `map`, `chat_bubble`, `person`.
  3. Убедиться, что mobile-версия (`BottomNavigationBar`) остаётся без изменений.
- **Проверка:** на ширине >1024 px подписи сбоку, на mobile всё работает как прежде.

### Задача 23.6: Тесты и CI
- Обновить/добавить widget- и golden-тесты для всех изменённых компонентов.
- Запустить `flutter analyze` и убедиться, что нет новых warning.
- Поддержать успешное прохождение CI-workflow.

---

### Задача 23.7: Профиль — визуальное выравнивание
- **Файлы:** `lib/screens/profile_screen.dart`, `lib/widgets/stat_card.dart`
- **Что делать:**
  1. Переместить аватар и имя пользователя в одну строку с бейджем «Premium/Free».  
  2. Выровнять статистику (уровни, сообщения, артефакты) в 3-колоночный `Wrap` с равными отступами.  
  3. Добавить кнопку «Изменить фото» (иконка камеры) поверх аватара.
- **Проверка:** layout совпадает с макетом Profile.png, аватар обновляется без перезагрузки.

### Задача 23.8: Hover-эффект LevelCard только на Web
- **Файл:** `lib/widgets/level_card.dart`
- **Что делать:** отключить `MouseRegion` и `AnimatedScale`, если ширина экрана <600 px (тач-устройства), чтобы избежать ненужных rebuild.
- **Проверка:** на mobile анимация отсутствует, на Web остаётся.

### Задача 23.9: Адаптивность форм входа/регистрации
- **Файлы:** `lib/screens/auth/login_screen.dart`, `lib/screens/auth/register_screen.dart`
- **Что делать:** при ширине 600–1024 px (tablet) ограничить ширину карточки формы 480 px и центрировать по горизонтали.  
- **Проверка:** форма не растягивается на планшете, mobile/web не изменились.

### Задача 23.10: Чистка warning `flutter analyze`
- Удалить/поправить `unused_import`, `unused_*`, `dead_*`, `override_on_non_overriding_member` и `invalid_annotation_target`.  
- Добавить недостающие пакеты в `dev_dependencies` для тестов (`path`, `video_player_platform_interface`).
- **Проверка:** `flutter analyze` ≤ 20 info-level сообщений, 0 warning.

## Реорганизация flow регистрации с обязательным подтверждением email

### Задача 23.11: Обновление RegisterScreen для email-подтверждения
- **Файлы:** `lib/screens/auth/register_screen.dart`
- **Что делать:**
  1. После успешной регистрации НЕ переходить на онбординг автоматически
  2. Показывать сообщение "Регистрация успешна! Проверьте почту для подтверждения аккаунта"
  3. Добавить кнопку "Уже подтвердили? Войти" → переход на `/login?registered=true`
  4. Убрать логику автоматического перенаправления после `signUp`
- **Проверка:** после регистрации пользователь остается на экране с инструкциями, переход происходит только по кнопке

### Задача 23.12: Обновление LoginScreen для обработки подтвержденной регистрации
- **Файлы:** `lib/screens/auth/login_screen.dart`, `lib/routing/app_router.dart`
- **Что делать:**
  1. Добавить чтение URL-параметра `registered` из GoRouter state
  2. При `registered=true` показывать баннер "Вы успешно зарегистрировались!" в верхней части экрана
  3. После успешного входа с `registered=true` → принудительный переход на `/onboarding/profile`
  4. Обновить маршрут в `app_router.dart` для поддержки query-параметров
- **Проверка:** баннер отображается только при переходе после подтверждения email, вход ведет на онбординг

### Задача 23.13: Обновление GoRouter для email-подтверждения и онбординг-gate
- **Файлы:** `lib/routing/app_router.dart`, `lib/utils/deep_link.dart`
- **Что делать:**
  1. Добавить обработку deep-link `bizlevel://auth/confirm` → `/login?registered=true`
  2. В `redirect` логике добавить проверку `user.onboardingCompleted`:
     - Если пользователь авторизован и `onboardingCompleted = false` → `/onboarding/profile`
     - Если `onboardingCompleted = true` → обычная логика
  3. Обновить `mapBizLevelDeepLink` в `deep_link.dart` для auth-ссылок
  4. Добавить обработку состояния загрузки currentUserProvider в redirect
- **Проверка:** email-подтверждение ведет на логин, неонбордившие пользователи попадают на онбординг

### Задача 23.14: Расширение OnboardingProfileScreen с выбором аватара
- **Файлы:** `lib/screens/auth/onboarding_screens.dart`, `lib/services/auth_service.dart`
- **Что делать:**
  1. Заменить placeholder-аватар на кликабельный виджет с выбором
  2. Переиспользовать логику `_showAvatarPicker()` из `ProfileScreen`
  3. Добавить состояние `selectedAvatarId` в OnboardingProfileScreen
  4. Передавать `avatarId` в `AuthService.updateProfile`
  5. Расширить `AuthService.updateProfile` параметром `int? avatarId`
  6. Гарантировать создание записи с `onboarding_completed: false`
- **Проверка:** пользователь может выбрать аватар, данные сохраняются в БД с правильным avatar_id

### Задача 23.15: Унификация OnboardingVideoScreen через AuthService
- **Файлы:** `lib/screens/auth/onboarding_video_screen.dart`, `lib/services/auth_service.dart`
- **Что делать:**
  1. Заменить прямой SQL `UPDATE users SET onboarding_completed = true` на вызов AuthService
  2. В `_goToApp()` использовать `ref.read(authServiceProvider).updateProfile(onboardingCompleted: true)`
  3. Убрать импорт Supabase и прямые обращения к БД
  4. Добавить обработку ошибок через AuthFailure
  5. Сохранить существующую логику SharedPreferences и навигации
- **Проверка:** флаг онбординга обновляется через сервис, ошибки обрабатываются корректно

### Задача 23.16: Обновление AuthService для поддержки аватаров и частичных обновлений
- **Файлы:** `lib/services/auth_service.dart`
- **Что делать:**
  1. Добавить параметр `int? avatarId` в метод `updateProfile`
  2. Сделать параметры `name`, `about`, `goal` опциональными (для частичных обновлений)
  3. В payload добавлять только переданные поля (не null)
  4. Объединить логику `updateAvatar` в общий `updateProfile`
  5. Обеспечить backward compatibility существующих вызовов
- **Проверка:** метод поддерживает частичные обновления, все тесты проходят

### Задача 23.17: Настройка Supabase Auth для правильных редиректов
- **Файлы:** Supabase Dashboard, документация по настройке
- **Что делать:**
  1. В Supabase Auth Settings настроить Site URL и Redirect URLs
  2. Добавить `bizlevel://auth/confirm` в список разрешенных redirect URLs
  3. Настроить Email Templates для включения правильного redirect URL
  4. Протестировать получение email-подтверждения с правильной ссылкой
- **Проверка:** email содержит ссылку, которая открывает приложение с нужными параметрами

### Задача 23.18: Обновление тестов для нового registration flow
- **Файлы:** `test/auth_flow_test.dart`, `test/screens/auth/register_screen_test.dart`, `test/email_confirmation_flow_test.dart` (новый)
- **Что делать:**
  1. Обновить `auth_flow_test.dart` под новую логику регистрации без автоперехода
  2. Добавить моки для email-подтверждения в тестах
  3. Создать `email_confirmation_flow_test.dart` для полного цикла регистрация→подтверждение→вход→онбординг
  4. Обновить widget-тесты для LoginScreen и RegisterScreen
  5. Добавить тесты для GoRouter redirect с проверкой onboarding_completed
- **Проверка:** все тесты проходят, покрытие нового flow не менее 80%

# Этап 24: Добавление древа навыков

## Часть 1: Бэкенд и миграции

### Задача 24.1: Создание миграции для навыков
- **Файлы:** `supabase/migrations/YYYYMMDD_add_skills_system.sql` (новый)
- **Что делать:**
  1. Создать таблицу `skills` (id, name) для хранения названий навыков.
  2. Наполнить `skills` шестью базовыми навыками.
  3. Добавить колонку `skill_id` (INT, FK -> skills.id) в таблицу `levels`.
  4. Создать таблицу `user_skills` (user_id, skill_id, points) для хранения прогресса.
  5. Включить RLS для новых таблиц, разрешив чтение всем авторизованным пользователям и запись только через security definer функции.
- **Проверка:** миграция применяется успешно, таблицы созданы, RLS активен.

### Задача 24.2: Обновление RPC-функции для начисления очков
- **Файлы:** `supabase/migrations/YYYYMMDD_add_skills_system.sql` (дополнить)
- **Что делать:**
  1. Модифицировать существующую RPC-функцию `update_current_level(level_id, user_id)`.
  2. Добавить в неё шаг для определения `skill_id` завершённого уровня.
  3. Реализовать `UPSERT` в `user_skills`, который увеличивает `points` на 1 для соответствующего `user_id` и `skill_id`.
- **Проверка:** вызов функции `update_current_level` корректно обновляет `user_progress`, `users.current_level` и `user_skills.points`.

## Часть 2: Слой данных (Flutter)

### Задача 24.3: Обновление моделей данных
- **Файлы:** `lib/models/level_model.dart`, `lib/models/skill_model.dart` (новый), `lib/models/user_skill_model.dart` (новый)
- **Что делать:**
  1. Добавить `int? skillId` в `LevelModel`.
  2. Создать модели `SkillModel` (id, name) и `UserSkillModel` (skillId, userId, points, skillName).
  3. Запустить `build_runner` для генерации `.freezed.dart` и `.g.dart` файлов.
- **Проверка:** код компилируется, модели корректно сериализуют/десериализуют JSON.

### Задача 24.4: Расширение репозиториев
- **Файлы:** `lib/repositories/user_repository.dart`, `lib/repositories/levels_repository.dart`
- **Что делать:**
  1. В `UserRepository` добавить метод `Future<List<UserSkillModel>> fetchUserSkills(String userId)`. Он должен делать JOIN таблиц `user_skills` и `skills`.
  2. Убедиться, что `LevelsRepository.completeLevel()` вызывает обновленную RPC-функцию.
- **Проверка:** `fetchUserSkills` возвращает корректный список навыков с очками, `completeLevel` работает как ожидается.

### Задача 24.5: Создание провайдера для навыков
- **Файлы:** `lib/providers/skills_provider.dart` (новый), `lib/screens/level_detail_screen.dart`
- **Что делать:**
  1. Создать `userSkillsProvider` (FutureProvider), который вызывает `UserRepository.fetchUserSkills()`.
  2. В `LevelDetailScreen`, после успешного вызова `completeLevel`, добавить `ref.invalidate(userSkillsProvider)`.
- **Проверка:** провайдер предоставляет данные в UI; после завершения уровня данные в профиле обновляются.

## Часть 3: Пользовательский интерфейс (Flutter)

### Задача 24.6: Создание виджета древа навыков
- **Файл:** `lib/widgets/skills_tree_view.dart` (новый)
- **Что делать:**
  1. Создать `StatelessWidget`, который принимает `List<UserSkillModel>`.
  2. Отобразить 6 шкал прогресса (`LinearProgressIndicator`) с названиями навыков.
  3. Показать количество очков рядом с каждой шкалой (например, "5/10").
- **Проверка:** виджет корректно отображает переданные ему данные о навыках.

### Задача 24.7: Интеграция древа навыков в профиль
- **Файл:** `lib/screens/profile_screen.dart`
- **Что делать:**
  1. Добавить в `ProfileScreen` блок "Древо навыков".
  2. Использовать `ref.watch(userSkillsProvider)` для получения данных.
  3. Отображать `CircularProgressIndicator` во время загрузки.
  4. В случае успеха, отображать `SkillsTreeView` с полученными данными.
- **Проверка:** на экране профиля отображается прогресс по навыкам, выше настроек, состояние загрузки/ошибки обрабатывается корректно.

### Задача 24.8: Тестирование
- **Файлы:** `test/repositories/user_repository_test.dart`, `test/screens/profile_screen_test.dart`
- **Что делать:**
  1. Добавить unit-тест для `UserRepository.fetchUserSkills` с использованием моков.
  2. Добавить widget-тест для `ProfileScreen`, проверяющий отображение `SkillsTreeView` с мок-данными через `ProviderScope`.
- **Проверка:** все новые и существующие тесты проходят успешно.
