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

# Этап 25: Смена онбординга
 
### Задача 25.1: Упрощение маршрутизации — вход сразу на Карту уровней
- **Файлы:** `lib/routing/app_router.dart`, `lib/utils/deep_link.dart`
- **Что делать:**
  1. Удалить редиректы на маршруты онбординга `/onboarding/profile` и `/onboarding/video` в `GoRouter.redirect`.
  2. После успешной аутентификации всегда направлять пользователя на карту уровней (`/home` или корневой маршрут, если он указывает на LevelsMapScreen).
  3. В `mapBizLevelDeepLink` оставить обработку `bizlevel://auth/confirm` → `/login?registered=true` (без перехода на онбординг).
  4. Сохранить баннер "Вы успешно зарегистрировались!" при `registered=true` на `LoginScreen` (без дополнительного редиректа на онбординг).
- **Проверка:** авторизованный пользователь оказывается на карте уровней без промежуточных онбординг-экранов; deeplink подтверждения email ведёт на `/login?registered=true`.

### Задача 25.2: Supabase — добавить стартовый уровень 0 «Первый шаг»
- **Миграция:** `supabase/migrations/YYYYMMDD_add_level_zero_first_step.sql`
- **Таблицы Supabase:** `levels`, `lessons`, `users`
- **Что делать:**
  1. Вставить в `levels` запись уровня 0:
     - `level_number = 0`, `title = 'Первый шаг'`, `description` — текст приветствия (см. Задача 25.4, Intro-блок), `is_free = true`, `is_premium = false`, валидные `created_at/updated_at`.
  2. Вставить в `lessons` 1 урок для уровня 0 с видео:
     - `level_id` = id созданного уровня 0, `title = 'Онбординг'`, `description` краткое, заполнить `vimeo_id` (по аналогии с существующими уроками), `video_url` можно оставить NULL (используется Vimeo).
  3. Установить дефолт `users.current_level = 0` для новых пользователей (ALTER TABLE DEFAULT).
  4. Корректирующее обновление для существующих пользователей: не менять `current_level`, если `current_level >= 1`; при `NULL` или `<1` — установить `0`.
  5. Не менять RLS — использовать текущие политики для `levels/lessons`.
- **Проверка:** миграция применяется через supabase-mcp; новый уровень и урок доступны по SELECT авторизованному пользователю; `users.current_level` по умолчанию 0 для новых записей.

### Задача 25.3: Карта уровней — показать «Первый шаг» первым
- **Файлы:** `lib/providers/levels_provider.dart`, `lib/screens/levels_map_screen.dart`, `lib/widgets/level_card.dart`, тесты `test/screens/levels_map_screen_test.dart`
- **Что делать:**
  1. Убедиться, что сортировка уровней отображает `level_number = 0` первым в списке.
  2. В `LevelCard` при `level.number == 0` выводить бейдж/заголовок «Первый шаг» вместо «Уровень 0».
  3. Обновить логику `isCurrent/isLocked`: если `current_level == 0` и уровень 0 не завершён — он current, уровни >=1 заблокированы.
  4. Обновить/добавить тесты отображения карточки и порядка уровней.
- **Проверка:** на карте уровней «Первый шаг» рендерится первым, правильно помечается текущим/заблокированным; тесты зелёные.

### Задача 25.4: Уровень 0 — структура блоков (Intro → Видео → Профиль → Финал)
- **Файл:** `lib/screens/level_detail_screen.dart`
- **Что делать:**
  1. Добавить локальный блок `_ProfileFormBlock` по аналогии с `_ArtifactBlock`:
     - Поля: выбор аватара, `Имя`, `О себе`, `Цель`.
     - Сохранение профиля через `ref.read(authServiceProvider).updateProfile(...)` с обработкой `AuthFailure` (SnackBar).
     - После успешного сохранения — разблокировать следующий блок через `LessonProgressProvider`.
  2. Добавить локальный блок `_OutroBlock` с текстом поздравления и кнопкой «Перейти к Уровню 1»:
     - Кнопка активна при выполнении: просмотрен видео-блок уровня 0 и профиль сохранён.
     - По нажатию: `await completeLevel(levelId)` и переход `context.go('/levels/1')` (учесть `mounted` и ошибки).
  3. Intro-блок (блок 0) содержит текст:
     "Привет! 👋\nЯ Leo, ваш персональный AI-ментор по бизнесу.\nЗа следующие пару минут Вы:\n- Узнаете, как получить максимум от BizLevel\n- Настроите свой профиль, чтобы я мог давать Вам персонализированные советы и рекомендации.\nГотовы начать свой путь в бизнесе?"
  4. Видео-блок использует существующий `LessonWidget` и `vimeo_id` из `lessons` уровня 0.
- **Проверка:** переходы по блокам последовательные, профиль сохраняется и разблокирует финал, кнопка завершения переводит на Уровень 1.

### Задача 25.5: Провайдеры/репозитории — статус уровня 0 и завершение
- **Файлы:** `lib/repositories/levels_repository.dart`, `lib/providers/lesson_progress_provider.dart`, `lib/providers/levels_provider.dart`
- **Что делать:**
  1. Убедиться, что `completeLevel(levelId)` корректно вызывает RPC и обновляет `users.current_level` (поведение уже реализовано; при необходимости добавить инвалидацию провайдера уровней после завершения 0).
  2. Для уровня 0 дополнительно учитывать флаг «профиль сохранён» при активации кнопки финального блока (локальная проверка в экране уровня, без изменения общей логики `_isLevelCompleted`).
  3. После `completeLevel(0)` инвалидацировать `levelsProvider` (и при наличии — `userSkillsProvider`).
- **Проверка:** после завершения уровня 0 обновляется статус карты уровней, «Уровень 1» становится доступным.

### Задача 25.6: Деприкация старых экранов онбординга (без удаления)
- **Файлы:** `lib/screens/auth/onboarding_screens.dart`, `lib/screens/auth/onboarding_video_screen.dart`, `lib/routing/app_router.dart`
- **Что делать:**
  1. Удалить маршруты на экраны онбординга из `app_router.dart`.
  2. Сами файлы экранов оставить в репозитории (возможный reuse), но убрать все прямые переходы на них.
  3. Комментариями пометить экраны как устаревшие для прямой навигации (deprecated routes), чтобы исключить случайное использование.
- **Проверка:** приложение не содержит навигации на старые онбординг-экраны; сборка и тесты проходят.

### Задача 25.7: Тесты нового flow
- **Файлы:**
  - Новый: `test/level_zero_flow_test.dart`
  - Обновить: `test/deep_link_test.dart`, `test/screens/levels_map_screen_test.dart`, `test/routing/app_router_redirect_test.dart`
- **Что делать:**
  1. `level_zero_flow_test.dart`: эмулировать прохождение уровня 0 — Intro → Видео (onWatched) → Профиль (сохранение) → Финал (кнопка активна) → вызов `completeLevel(0)` → редирект на уровень 1.
  2. Обновить `deep_link_test.dart`: deeplink `/login?registered=true` без онбординг-редиректа.
  3. Обновить тесты карты уровней: наличие «Первого шага» первым в списке, корректные бейджи/лочинг.
  4. Тест редиректов GoRouter: после логина — на карту уровней, без перехода на `/onboarding/*`.
  5. Проверить через `supabase-mcp` advisors, что нет регрессий RLS/индексов.
- **Проверка:** все новые и обновлённые тесты зелёные, покрытие flow уровня 0 ≥ 80% для экрана.

# Этап 26: Улучшение Лео

### Задача 26.1: База данных — персонализация и долговременная память
- Файлы: `supabase/migrations/YYYYMMDD_add_personalization_and_memories.sql`
- Таблицы/колонки:
  - `users.persona_summary text NULL` — краткая персональная сводка (персона) пользователя, используется в системном промпте.
  - `leo_chats.summary text NULL`, `leo_chats.last_topics jsonb NOT NULL DEFAULT '[]'` — свёртка чата и последние темы.
  - Новая таблица `user_memories`:
    - `user_id uuid NOT NULL` (FK → `users.id`),
    - `content text NOT NULL`,
    - `embedding vector(1536) NULL`,
    - `weight integer NOT NULL DEFAULT 1`,
    - `created_at timestamptz NOT NULL DEFAULT now()`,
    - `updated_at timestamptz NOT NULL DEFAULT now()`,
    - PK `(user_id, content)` или surrogate `id uuid` — выбрать один вариант; рекомендуется `id uuid DEFAULT gen_random_uuid()`.
  - Индексы:
    - HNSW для векторного поиска: `CREATE INDEX IF NOT EXISTS user_memories_embedding_hnsw ON public.user_memories USING hnsw (embedding vector_cosine_ops) WITH (m=16, ef_construction=64);`
    - По пользователю/времени: `CREATE INDEX IF NOT EXISTS user_memories_user_time_idx ON public.user_memories(user_id, updated_at DESC);`
  - Политики RLS: enable RLS; SELECT/INSERT/UPDATE/DELETE только для `auth.uid() = user_id`.
- Проверка: через `supabase-mcp` применить миграцию, убедиться, что таблицы/колонки появились, индексы созданы, RLS активен.

### Задача 26.2: Оптимизация RAG и объединение запросов (уменьшение RTT)
- Файлы: `supabase/functions/leo-chat/index.ts`
- Что делать:
  1) Перенести логику RAG из `leo-rag` внутрь `leo-chat`: при наличии запроса строить embedding (модель `text-embedding-3-small`), вызывать `rpc('match_documents', { query_embedding, match_threshold: 0.3..0.4, match_count: 5..8 })`, собрать контекст (сжатый).
  2) Добавить фильтрацию по метаданным (если передан текущий уровень/скилл): использовать `documents.metadata->>'level_id'`/`skill_id` в RPC/фильтрах.
  3) Скомбинировать: `persona_summary` → `user_memories` (top-K по сходству) → `RAG контекст` → системный промпт. Не менять текущий формат ответа `{ message, usage }`.
- Backward compatibility: оставить поддержку текущего запроса от клиента (поле `knowledgeContext` опционально игнорировать). `leo-rag` не удалять на этом этапе.
- Проверка: локальный вызов функции с тем же payload, что сейчас отправляет `LeoService`, должен возвращать ответ без деградации.

### Задача 26.3: Быстрый доступ к «персоне» и кэширование контекстов в функции
- Файлы: `supabase/functions/leo-chat/index.ts`
- Что делать:
  1) Загружать `users.persona_summary`; если пусто — формировать on-the-fly из `users.{name, about, goal, business_area, experience_level}` (fallback).
  2) Ввести in-memory кэш (глобальные переменные модуля Deno) на 2–5 минут для `persona_summary` и результатов `match_documents` по `(user_id, last_query_hash)`.
  3) Ограничить итоговый объём контекста (truncate по токенам), использовать сжатие чанков (краткие тезисы) перед добавлением в системный промпт.
- Проверка: несколько последовательных запросов возвращают ответы быстрее (нет лишнего повторного поиска), при смене пользователя кэш не конфликтует.

### Задача 26.4: Долговременная память — извлечение фактов из диалогов
- Файлы: `supabase/functions/leo-memory/index.ts` (новая Edge Function)
- Что делать:
  1) Реализовать эндпоинт, принимающий список свежих сообщений чата и возвращающий JSON c массивом «памяток» (atomic facts/preferences/goals).
  2) Для каждой «памятки» считать embedding (тот же модельный размер), upsert в `user_memories` (по `(user_id, content)` или `id`).
  3) Добавить лёгкую нормализацию текста (обрезка, нижний регистр для ключей, удаление PII, если нужно).
- Проверка: ручной вызов функции создаёт записи в `user_memories`; повторный вызов не плодит дубликаты (upsert).

### Задача 26.5: Фоновый запуск извлечения памяти
- Инструменты: Supabase Scheduled Functions (Cron)
- Что делать:
  1) Создать расписание (каждые 1–5 минут) на вызов `leo-memory` с секретным заголовком.
  2) Внутри `leo-memory` выбирать «необработанные» сообщения за последний интервал (по `leo_messages.created_at`) и помечать обработанные (сервисный маркер в Redis/таблице `leo_messages_processed` — создать простую таблицу id/timestamp).
- Таблицы: при необходимости добавить `leo_messages_processed(id uuid PK, processed_at timestamptz)` с RLS=OFF (только service-role).
- Проверка: память пополняется после диалогов, повторная обработка не происходит.

### Задача 26.6: Улучшение `documents` (metadata и индексы) для точного/быстрого RAG
- Файлы: `supabase/migrations/YYYYMMDD_optimize_documents_for_rag.sql`
- Исходное состояние (подтверждено): в `metadata` только `file_id`, `file_name`, `chunk_index`, `total_chunks`; ключей `level_id/skill_id/title/section/tags` нет; индекс по embedding — `ivfflat`, GIN по metadata отсутствует.
- Что делать:
  1) Индексы по embedding:
     - Зафиксировать стандарт: перейти на HNSW (если доступна pgvector ≥ 0.7) —
       `CREATE INDEX IF NOT EXISTS documents_embedding_hnsw ON public.documents USING hnsw (embedding vector_cosine_ops) WITH (m=16, ef_construction=64);`
     - Если HNSW недоступен — оставить существующий `ivfflat` как фолбэк, задокументировать выбор.
  2) Индексы по metadata:
     - `CREATE INDEX IF NOT EXISTS documents_metadata_gin ON public.documents USING gin (metadata);`
  3) Обогащение metadata (без изменения схемы столбцов):
     - Добавить ключи: `level_id` (int), `skill_id` (int), `title` (string), `section` (string), `tags` (string[]), где они отсутствуют.
     - В миграции предусмотреть бэкфилл существующих строк: `UPDATE documents SET metadata = metadata || jsonb_build_object(...)` на основе временного маппинга (см. задачу 26.12) и/или эвристик по `file_name`.
  4) Параметризовать пороги поиска: оставить `match_threshold`/`match_count` как настраиваемые через ENV/RPC параметры.
- Проверка: `rpc('match_documents', ...)` с `metadata`-фильтрами по `level_id/skill_id` работает, время ответа сокращается (за счёт HNSW/GIN и фильтров), содержимое metadata содержит новые ключи.

### Задача 26.7: Клиент — минимальная адаптация без поломок
- Файлы: `lib/services/leo_service.dart`, `lib/screens/leo_dialog_screen.dart`
- Что делать:
  1) Обновить `sendMessage`/`sendMessageWithRAG` на единый вызов `/leo-chat` (с флагом `enableRag: true`), без отдельного запроса в `/leo-rag`. Сохранить текущий контракт ответа.
  2) Поля `userContext`/`levelContext` оставить как опциональные (передавать можно, но функция теперь сама формирует персонализацию из БД). Backward compatible.
  3) Логика сохранения сообщений/лимитов не меняется.
- Проверка: текущие UI-потоки работают как прежде, количество сетевых запросов на одно сообщение стало меньше.

### Задача 26.8: Свёртки чатов
- Файлы: `supabase/functions/leo-memory/index.ts`, `supabase/migrations/YYYYMMDD_add_chat_summaries.sql`
- Что делать:
  1) В `leo-memory` после обработки батча сообщений формировать обновлённую `leo_chats.summary` (короткая выжимка) и `last_topics` (массив строк, max 5), `updated_at = now()`.
  2) При старте нового чата в `leo-chat` подтягивать 2–3 последних релевантных `summary` пользователя (по темам — через быстрый string-similarity/вектор `user_memories`).
- Проверка: новая сессия получает контекст прошлых бесед (без длинного history), LLM отвечает «помня» прошлый опыт.

### Задача 26.9: Качество поиска — гибрид и реранк
- Файлы: `supabase/functions/leo-chat/index.ts`, `supabase/migrations/YYYYMMDD_update_match_documents.sql`
- Что делать:
  1) В `match_documents` добавить параметр `metadata_filter jsonb DEFAULT '{}'` и/или отдельные параметры (уровень, скилл), применять WHERE-фильтры до ANN.
  2) В `leo-chat` после top-K ANN запустить лёгкий re-rank (OpenAI rerank или эвристика по tf-idf/BM25 через полнотекстовый индекс). В проде — фича-флаг.
- Проверка: ответы чаще ссылаются на корректные разделы учебника, уместность выше.

### Задача 26.10: Пайплайн загрузки/чанкования документов и бэкфилл metadata
- Файлы: `scripts/upload_from_drive.py`, `supabase/migrations/YYYYMMDD_documents_metadata_backfill.sql`
- Что делать:
  1) Обновить пайплайн чанкования в `scripts/upload_from_drive.py`:
     - использовать токенизацию (напр. `tiktoken`) и целевой размер 300–500 токенов с перекрытием;
     - извлекать и сохранять заголовки/подзаголовки в metadata: `title`, `section`, `tags`;
     - при наличии маппинга — добавлять `level_id`/`skill_id` в metadata при загрузке.
  2) Бэкфилл для существующих строк:
     - подготовить временную таблицу маппинга `documents_backfill_map(file_id text PRIMARY KEY, level_id int, skill_id int, title text, section text, tags text[])` (заполняется вручную/скриптом);
     - миграцией выполнить `UPDATE documents d SET metadata = d.metadata || jsonb_build_object('level_id', m.level_id, 'skill_id', m.skill_id, 'title', m.title, 'section', m.section, 'tags', to_jsonb(m.tags)) FROM documents_backfill_map m WHERE m.file_id = (d.metadata->>'file_id');`
     - по завершении — удалить/очистить временную таблицу.
- Проверка: новые документы загружаются с полной metadata; существующие получают заполненные `level_id/skill_id/title/section/tags`; выборки с фильтрами работают.

### Задача 26.11: Тесты
- Файлы:
  - Новые: `test/edge/leo_memory_function_test.md` (док-тест сценариев), `test/rag/rag_quality_test.dart` (offline-проверка hit@k по эталонным запросам),
  - Обновить: `test/leo_integration_test.dart` (путь один к `/leo-chat`), `test/services/leo_service_unit_test.dart` (контракт ответа без `leo-rag`).
- Что делать:
  1) Добавить фикстуры эталонных вопросов/ответов по ключевым темам уровней.
  2) Проверить, что количество сетевых вызовов за отправку сообщения уменьшилось (без регрессий UI).
- Проверка: тесты зелёные, rag-тесты демонстрируют стабильный hit@k и скорость.

### Задача 26.12: Контроль рисков и обратная совместимость
- Не удалять `supabase/functions/leo-rag` до завершения 26.7 и прохождения интеграционных тестов.
- `leo-chat` должен принимать старый payload (со старыми полями) и корректно работать без них.
- Миграции БД — только additive (новые колонки/таблицы/индексы). Изменять существующие поля/политики RLS — запрещено на этом этапе.

### Задача 26.13: Надёжный запуск памяти и свёрток без cron (триггер + защита)
- Файлы: `supabase/functions/leo-memory/index.ts`, SQL (триггеры/функции), `supabase/functions/leo-chat/index.ts` (опционально)
- Что сделать:
  1) Триггер AFTER INSERT на `leo_messages` для `role='assistant'` (уже есть). Уточнить условие: `WHEN NEW.role='assistant' AND COALESCE(NEW.is_final, true)` во избежание зацикливания и полу-сообщений.
  2) Вызов `leo-memory` делать через `pg_net` с малым таймаутом (2–3 сек) и без ожидания длинной работы. Рекомендуемый ответ функции — 202.
  3) В `http_post` передавать payload (минимум `message_id`, `chat_id`, `user_id`, `content`, опц. `level_id`) — чтобы избежать гонки чтения незакоммиченной строки и повысить детерминизм.
  4) Идемпотентность: в `leo-memory` перед upsert в `user_memories` отмечать сообщение в `leo_messages_processed` (UPSERT по `message_id`) и пропускать повторную обработку.
  5) Исключить петлю: `leo-memory` не должно писать новые сообщения в `leo_messages`. Если потребуется служебная запись — добавлять флаг источника в метаданные и фильтровать в триггере.
  6) Безопасность секрета: хранить `CRON_SECRET` не в общедоступной таблице; как минимум — включить RLS на `public.app_settings` (deny для пользователей), либо перенести секрет в ENV Edge Function и не хранить в БД.
  7) Структура контекста уровня: клиент или сервер должны формировать `levelContext` в структурном виде (`{"level_id":6}` или строка `level_id: 6`) — это включает `metadata_filter` и повышает точность RAG.

### Задача 26.14: Ручная настройка в Supabase (пошагово)
- Цель: обеспечить запуск памяти и свёрток без cron, защитить секреты, включить точный RAG.
- Шаги:
  1) Открыть Supabase → Edge Functions → `leo-memory` → Environment → добавить/установить `CRON_SECRET=<секрет>` → redeploy.
  2) SQL Editor → выполнить: `update public.app_settings set value='<тот_же_секрет>' where key='leo_memory_cron_secret';` (если используется посредник через таблицу).
  3) Защитить секреты: включить RLS на `public.app_settings`. Создать политики deny‑all для анонимных/авторизованных ролей. (Edge Functions с service-role продолжают работать.)
  4) Проверить/включить расширение `pg_net` (Extensions → pg_net → enable), если ещё не активно.
  5) Убедиться, что триггер `trg_call_leo_memory` существует на `public.leo_messages` и вызывает `public.call_leo_memory()` при `role='assistant'`.
  6) В клиенте обеспечить структурный `levelContext` при вызове `/leo-chat` (например `{"level_id":6}`), либо передавать строку `level_id: 6`.
  7) Прогнать проверку: отправить сообщение → ответ ассистента → через ~сек проверить `user_memories` (новые записи), `leo_chats.summary/last_topics` (заполнены). Новый чат должен получить блок «Итоги прошлых обсуждений» в системном промпте и корректно отвечать на вопрос про прошлый диалог.
