# Этап 52-fix: Чаты — UX быстрых ответов и чтения
- 52.fix-1: `LeoDialogScreen` — скрытие клавиатуры по жесту скролла (`keyboardDismissBehavior:onDrag`), по тапу вне поля (`onTapOutside`) и иконка «Скрыть клавиатуру». Добавлен FAB «Вниз» при отскролле.
- 52.fix-2: Подсказки переведены в компактную горизонтальную ленту (1 строка, прокрутка) с кнопкой «Ещё…» (bottom‑sheet) и «Показать подсказки» при сворачивании.
- 52.fix-3: Метки времени у сообщений (hh:mm), `SelectableText` для баблов ассистента. Пагинация/автоскролл и контракты LeoService без изменений. Линты чистые.

## 2025-11-14 — Задача startup-bootstrap fix
- Добавлен `BootstrapGate` с FutureProvider: обязательный bootstrap переносится за первый кадр без блокировки runApp.
- dotenv, Supabase service и Hive (notifications) инициализируются последовательно, логируются тайминги и ошибки.
- Splash/ошибка показываются отдельным `MaterialApp`, после успеха запускаются `MyApp` и фоновые сервисы.

## 2025-11-14 — Задача ios-black-screen fix
- Firebase конфигурируется синхронно (Dart bootstrap + `AppDelegate`), `PushService` ждёт готовности через completer, iOS логи больше не ругаются на `No app configured`.
- Оставшиеся `Hive.openBox` вынесены в `HiveBoxHelper`, heavy I/O boxes открываются лениво без блокировки первого кадра.
- Sentry больше не собирает скриншоты/ViewHierarchy на старте; release формируется из `APP_VERSION/APP_BUILD`, PackageInfo не трогается до UI.

## 2025-11-16 — Задача ios-black-screen-stage2 fix
- `AppDelegate` явно читает `GoogleService-Info.plist` и конфигурирует Firebase до Flutter, логи без `No app configured`.
- Маршрут запуска хранится в `SharedPreferences`, Notifications/Push стартуют только после авторизации пользователя.
- Фоновые сервисы запускаются от Riverpod-listener с задержкой, PushService больше не трогает Firebase init повторно.

## 2025-11-16 — Задача ios-black-screen-stage3 fix
- Переехали на ленивый SWR-кеш: `Goals/Cases/Library/Levels/Lessons/GpService` больше не вызывают `Hive.openBox()` до запроса, запись и инвалидация выполняются отложенно через `HiveBoxHelper`.
- Firebase на iOS конфигурируется ещё в `willFinishLaunching`, поэтому SDK не успевает логировать `I-COR000003`, Dart часть не вызывает повторный init.
- Практика/GP кеши чистятся через helper без блокировок, `saveBalanceCache`/purchase id пишутся defer — стартап не делает синхронного диска.

## 2025-11-16 — Задача ios-black-screen-stage4 fix
- Bootstrap больше не трогает `FirebaseMessaging`: auto-init/permissions запускаются в `PushService` уже после первого кадра и входа пользователя.
- `FirebaseMessaging.onBackgroundMessage` регистрируется только на Android, iOS не создаёт `flutter_callback_cache.json` во время старта.
- `AppDelegate` конфигурирует Firebase уже в `init` + `willFinish`, предупреждение `I-COR000003` исчезает до инициализации плагинов.

## 2025-11-16 — Задача ios-black-screen-final fix
- Firebase конфигурируется в `main.swift` до `UIApplicationMain`, устраняя `I-COR000003`.
- PushService использует платформенные хуки: фоновые обработчики собираются только на Android, на iOS добавлена безопасная задержка.
- Auto-init FCM выключен в bootstrap и включается после отложенной инициализации сервиса.

## 2025-11-17 — Задача ios-prelaunch-rollback fix
- Локально откатил кодовую базу к `origin/prelaunch`, оставив в актуальном виде только `docs` и новые UI-файлы (`lib/theme`, `lib/widgets`, `lib/screens` + утилиты, от которых они зависят).
- Обновил `pubspec` (добавлен `dynamic_color`) и проверил сборку `flutter analyze`, чтобы убедиться, что дизайн компилируется на прежнем стеке.

## 2025-11-17 — Задача ios-black-screen-fcm fix
- Bootstrap не вызывает `FirebaseMessaging.setAutoInitEnabled` на iOS до регистрации native-плагина.
- `_ensureIosMessagingRegistered` через MethodChannel регистрирует плагин и отключает auto-init, чтобы Dart bootstrap не падал и не блокировал первый кадр.

## 2025-11-11 — Задача level-detail-refactor fix
- Разбил `level_detail_screen.dart` на независимые блоки (`Intro/Lesson/Quiz/Artifact/ProfileForm/GoalV1`) и общий интерфейс `LevelPageBlock`.
- Вынес UI‑элементы (`LevelNavBar`, `LevelProgressDots`, `ParallaxImage`, `ArtifactPreview`), добавил хелпер `level_page_index.dart`.
- Перенёс запрос артефакта в `SupabaseService.fetchLevelArtifactMeta`, подчистил легаси/неиспользуемые импорты.
- Поведение/навигация не изменены, линтеры по изменённым файлам — без ошибок.

# Этап 53: IAP покупки GP (StoreKit/Google Billing)
- Клиент:
  - Добавлен `in_app_purchase`, сервис `IapService` (запрос продуктов, покупка consumable), метод `GpService.verifyIapPurchase`.
  - `GpStoreScreen`: для iOS/Android покупки через IAP, цены подставляются из стора; для Web — прежний фолбэк.
  - Добавлены breadcrumbs Sentry: `gp_iap_products_loaded/gp_iap_purchase_*`, `gp_verify_*`, `gp_web_purchase_init`.
- Сервер:
  - Edge `gp-purchase-verify`: валидация iOS (verifyReceipt) и Android (Google Purchases), CORS/OPTIONS, коды ошибок, идемпотентное начисление через RPC `gp_purchase_verify`.
  - Маппинг продуктов: gp_300=300, gp_1400=1400 (1000+400 бонус), gp_3000=3000.
- Безопасность:
  - Ключи Apple/Google выносятся в Supabase Edge Secrets (не в репозиторий). Требуются: APPLE_ISSUER_ID/APPLE_KEY_ID/APPLE_PRIVATE_KEY, GOOGLE_SERVICE_ACCOUNT_JSON, ANDROID_PACKAGE_NAME.

## Fix: Стандартизация уровней и навигации (после Этапа 53)
- Добавлен `currentLevelNumberProvider` (нормализация номера уровня из `users.current_level`).
- UI переведён на нормализованный уровень (`GoalScreen`, `GoalCheckpointScreen`, `ProfileScreen`, `AppShell`).
- `ContextService`: `userContext/levelContext` теперь отдают `level_number` (+ `level_id`, если доступен).
- `nextLevelToContinueProvider`: обработка выхода за max (ведёт к последнему уровню), убран лейбл «Ресепшн».
- CTA «Перейти на Уровень 1» ведёт в `/tower?scrollTo=1` (надёжная навигация).
- Добавлен фича‑флаг `kNormalizeCurrentLevel` (по умолчанию true) для поэтапного включения.
- Наблюдаемость: breadcrumb `client_level_mismatch` при подозрительном `users.current_level`.
- Аудит Supabase: `v_users_level_mismatch` → 0 расхождений.

# Этап 54: Цель — консолидация спринта и Макса (финальные правки)
- Данные: `GoalsRepository.fetchAllGoals` расширен полями `sprint_status/sprint_start_date`; провайдеры получают актуальные значения без дублирования JSON‑ключей.
- UI:
  - `SprintSection`: заголовок недель выводит дату старта из `sprint_start_date`.
  - `GoalCompactCard`: «Дней осталось» считается от `sprint_start_date`; показ локализованного статуса спринта; `readiness_score` берётся из v4.
  - `CheckInForm`: добавлен индикатор «Прогресс к цели: N%» на основе v2 (current/target) и факта за неделю.
  - `GoalScreen`: источники дат/статусов приведены к серверным полям; корректно определяются старт/завершение 28 дней.
- Контроллер: `currentWeekNumber()` и `getWeekGoalFromV3()` переведены на `sprint_start_date` и ключи `week*_focus` (с fallback на старые ключи при наличии).
- Daily: после успешного `startSprint()` вызывается автозаполнение `daily_progress.task_text` из `v3 week*_focus` (без перезаписи существующих задач).
- Edge: в `supabase/functions/leo-chat/index.ts` заменено `sprint_number` → `week_number` для выборки `weekly_progress` и формирования спринт‑блока в контексте Макса.
- Документация: добавлен краткий отчёт (этот раздел) и сводка «2025‑10‑08 — Goal sprint sync & UX fixes».
- Линтер/сборка: проект собирается; предупреждения — только по сложности в `GoalsRepository` (неблокирующие).

# Этап 55: Память Лео/Макса — семантика, архив и стабильность
- Edge `leo-memory`:
  - Фильтр пользовательских сообщений (только role=user, длина ≥50, исключены однословные ответы).
  - Извлечение фактов, нормализация без PII, генерация эмбеддингов и upsert в `user_memories`.
  - Лимит «горячих» записей: 50 на пользователя; «хвост» переносится в `memory_archive` (горизонтальная чистка).
- Edge `leo-chat`:
  - Семантический отбор памяти (top‑k через RPC `match_user_memories`), фолбэк на последние записи при ошибке.
  - Обновление `access_count/last_accessed` через RPC `touch_user_memories` для используемых записей.
  - Гейтинг по прогрессу сохранён; RAG ограничен `RAG_MAX_TOKENS`; XAI‑клиент для ответов без изменений.
- Надёжность и безопасность:
  - Логи без PII; фича‑флаг `ENABLE_SEMANTIC_MEMORIES`; graceful‑fallback при отсутствии `OPENAI_API_KEY`.
  - Асинхронные запросы сведены в параллельные группы; ошибки — структурированные, не прерывают основной ответ.
- Риски и дальнейшие улучшения:
  - Добавить token‑кап на общий системный промпт (персонализация/память/сводки) и микро‑сжатие блоков, чтобы стабилизировать суммарный контекст.
  - Включить decay‑механизм по `relevance_score` и плановый weekly `persona_summary` (cron) для «тёплой» памяти.
  - Метрики: покрытие семантических попаданий, средняя длина контекста, доля фолбэков.
  
## 2025-10-08 — Goal sprint sync & UX fixes
- Данные: добавлены `sprint_status`, `sprint_start_date` в выборку `fetchAllGoals`; провайдеры теперь получают эти поля.
- UI: `SprintSection` и `GoalCompactCard` используют `sprint_start_date`; «Дней осталось» считается от серверной даты; вывод статуса спринта; показывается `readiness_score` из v4.
- Daily: после `startSprint()` автоматически вызывается автозаполнение `daily_progress.task_text` из `v3 week*_focus`.
- Weekly: в форме чек‑ина показан «Прогресс к цели: N%» на основе метрики v2.
- Edge: в `leo-chat` заменено `sprint_number` → `week_number` для `weekly_progress`.
- Контроллер: расчёт текущей недели и задач переведён на `sprint_start_date` и ключи `week*_focus`.

## 2025-10-13 — Видео: переход на Bunny Stream
- Клиент:
  - `LessonWidget` переведён на единый источник `video_url` (Bunny HLS или Supabase Storage). Ветки Vimeo и временные override удалены. Web воспроизводит HLS через локальный `web/hls_player.html` (hls.js); iOS/Android/Desktop — через `video_player`.
  - При пустом `video_url` урок помечается как просмотренный (временно до полной миграции данных).
- Данные:
  - Переход выполняется заменой `public.lessons.video_url` на HLS‑ссылки Bunny (`…/playlist.m3u8`). Схема БД не менялась.
- Требования к окружению:
  - В Bunny разрешён dev‑origin (localhost:port) в hotlink/Shield для HLS, иначе возможен 403.
- Проверка:
  - Web/iOS/Android: урок 1.1 проигрывается с Bunny; Sentry без PII; overflow отсутствуют.

## 2025-10-14 — Мониторинг Sentry (bizlevel-flutter)
- Проверена интеграция sentry-mcp: доступ к орг. `bizlevel`, проект `bizlevel-flutter` найден.
- DSN сконфигурирован через `envOrDefine('SENTRY_DSN')` в `lib/main.dart`, `SentryFlutter.init` задаёт `environment` и `release`.
- iOS: `Podfile` содержит `Sentry/HybridSDK` (8.52.1); Android — без плагина Sentry Gradle, но для Dart‑стека это не требуется.
- В Sentry видны релизы и события: последний релиз `bizlevel@1.0.7+7`, есть события до 2025‑10‑14 05:37Z. Ошибки при списке событий через API не мешают выводу по релизам.
- Рекомендации: при необходимости нативной символикации добавить загрузку dSYM (iOS) и маппингов ProGuard (Android); настроить `sentry-cli` токен в CI для `scripts/sentry_check.sh`.
Статус: интеграция работает, логи видны.

## 2025-10-16 — Упрощение «Цели»: единая цель и журнал применений
- Клиент:
  - Страница «Цель» переведена на единую модель: редактируемая цель (goal_text/metric*/readiness) + журнал применений (practice_log). Удалены версии v1–v4, недельные спринты и 28‑дневный режим.
  - Убраны фичефлаги weekly/daily/chips/hideBubble и зависимый UI.
  - Башня: чекпоинты цели больше не гейтят прогресс; по тапу открывается чат Макса.
  - LeoDialog: добавлен CTA «Открыть артефакт…» (эвристика) → маршрут /artifacts.
  - Уведомления: добавлены ежедневные напоминания практики (Пн/Ср/Пт 19:00) вместо расписания 28 дней.
- Репозитории/провайдеры:
  - Добавлены `userGoalProvider`/`practiceLogProvider`, CRUD и агрегаты (daysApplied/topTools).
  - Удалены/не используются провайдеры версий/weekly.
- Edge:
  - `leo-chat`: режимы `weekly_checkin` и `goal_comment` отключены (410 Gone). Контекст формируется из user_goal/practice_log.
- БД (Supabase):
  - Создана `public.user_goal` (RLS owner-only, updated_at, unique(user_id)).
  - `daily_progress` переименована в `practice_log` (+ applied_tools[], note, applied_at). Индексы по user_id, applied_at.
  - Миграция `core_goals` → `user_goal` и удаление `core_goals`.
  - Удалены `weekly_progress`, `goal_checkpoint_progress` и связанные RPC/триггеры.
  - Добавлен бонус `gp_bonus_rules('daily_application',5)` и RPC `gp_claim_daily_application()`.

### 2025-10-16 — Чекпоинты L1/L4/L7, агрегаторы и тесты (эта сессия)
- Реализованы экраны чекпоинтов: `CheckpointL1Screen` (мастер 4 шага), `CheckpointL4Screen` (финфокус), `CheckpointL7Screen` (проверка реальности Z/W).
- Навигация: добавлены маршруты `/checkpoint/l1`, `/checkpoint/l4`, `/checkpoint/l7`, башня ведёт на мастер вместо чата.
- Репозиторий: добавлены агрегаторы practice_log — `aggregatePracticeLog`, `computeRecentPace(Z)`, `computeRequiredPace(W)`; запросы на Web включают `apikey`.
- Тесты: добавлены `checkpoint_l7_screen_test` (smoke UI) и `practice_log_aggregate_test` (агрегации/математика Z/W).
- Наблюдаемость: breadcrumbs для действий чекпоинтов (`l4_add_fin_metric/l4_keep_as_is`, l7‑выборы) без PII.
- Линтер: предупреждения сведены к информационным; критичных ошибок нет.

## 2025-10-16 BizLevel Goal refactor (edge+client)

- GoalScreen: добавлен ввод/сохранение `target_date` (datepicker), прогресс‑бар и «Осталось N дней».
- GoalsRepository: для веб добавлен глобальный `apikey` (через `SupabaseService`), запросы `practice_log` работают без 404 (web PostgREST).
- Leo Edge (`supabase/functions/leo-chat`): контекст Макса переведён на `user_goal` + последние `practice_log` (вместо `core_goals`/`weekly_progress`). `goal_comment`/`weekly_checkin` → 410 Gone.
- Башня: возвращены узлы `goal_checkpoint` после уровней 1/4/7, по тапу открывается чат Макса; статусы completion вычисляются от `user_goal`/`practice_log`.
- Уровень 1 (конец): убрана форма «Набросок цели», добавлен CTA «Открыть страницу Цель».
- Убраны/заглушены остатки: `NextActionBanner`, `DailySprint28Widget` и 28‑дневные ссылки.

## 2025-10-17 — Связка Цель ⇆ Чекпоинты ⇆ Журнал
- БД: добавлены поля `financial_focus`, `action_plan_note` в `public.user_goal`; индекс `ix_practice_log_user_applied_at(user_id, applied_at desc)`.
- Репозиторий: `fetchUserGoal/upsertUserGoal` поддерживают новые поля; добавлен `computeGoalProgressPercent`; breadcrumb `practice_entry_saved`.
- Провайдеры: `goalStateProvider(l1Done/l4Done/l7Done)` для NextActionBanner.
- UI «Цель»: статус‑чипы L1/L4/L7, строка «Финфокус», баннер «Что дальше?» (L1→L4→L7→Журнал), хинт влияния записи на метрику.
- Чекпоинты: превью «Моя цель» в L1/L4/L7; L7 сохраняет решение в `action_plan_note` и пишет системную запись в `practice_log`.
- Башня: узлы `goal_checkpoint` ведут на `/checkpoint/l1|l4|l7`.
- LeoService: обычный чат списывает 1 GP, авто‑сообщения/кейс — без списания; стабильность сохранена.
- Безопасность БД: включены RLS+SELECT‑политики для `lesson_metadata/lesson_facts/package_items`; `v_users_level_mismatch` переведён на security_invoker; зафиксирован `search_path=public` у функций из Advisors.
- Уведомления: при login пересоздаём расписания (`weekly plan`, `daily practice`), при logout — отменяем; маршрутизация на `/goal`.
- Чат: пробрасываем `chatId` в `sendMessageWithRAG` для идемпотентности списаний GP.
- Башня: подписи чекпоинтов обновлены на L1/L4/L7.
- Цель: человекочитаемый остаток дней до дедлайна.

### Задача bl-journey-10 fix
- Починил навигацию CTA L1/L4/L7 на `GoRouter.push` вместо `Navigator.pushNamed`.
- Устранил падение `Flexible` внутри `Wrap` на экране `goal_screen.dart` (замена на `ConstrainedBox`).
- Статусы `L1/L4/L7` на «Цели»: L1 считается выполненной при наличии `goal_text` и `metric_type`; L4 после сохранения инвалидации `userGoalProvider` и возврат на `/goal`.
- Журнал: чипы навыков заменены на выпадающий список «Выбрать навык» (один выбор); в блоке «Вся история» отображаются только 3 записи, формат даты `dd-аббр-YYYY`, кнопка «Вся история →» ведёт на `/goal/history`.
- Топ‑навыки: добавлены быстрые кнопки «Топ‑3» над выпадающим списком; клики логируются в Sentry.
- Чекпоинт L4: добавлен диалог с Максом («Обсудить с Максом») и кнопка «Завершить чекпоинт → /goal».
- Чекпоинт L7: добавлены «Обсудить с Максом» и «Настроить напоминания».
- Настроены уведомления для Чекпоинта L7, на странице Цель (Журнал применений), Профиль-Настройки (Настройки уведомлений). Приведены в единый формат. 
### 2025-10-21 — Стандартизация UI чекпоинтов и Goal‑виджетов
- Goal/widgets: кнопки переведены на `BizLevelButton`, каркасы секций — на `BizLevelCard`, отступы — `AppSpacing`.
- Библиотека: `SnackBar` заменены на `NotificationCenter` (успех/ошибка/инфо), доступность ≥44px.
- Профиль/Уровни: инлайн цвета/типографика переведены на `AppColor`/`textTheme`.
- Чекпоинты L1/L4/L7: 
  - L1 — форма цели на `BizLevelTextField`, формат даты YYYY‑MM‑DD, CTA неактивна при пустой цели, нотификации через `NotificationCenter`.
  - L4/L7 — чат обёрнут в `BizLevelCard` и оформлен как в квизах: добавлен хедер с аватаром Макса и бейджем «Чекпоинт L4/L7»; кнопки приведены к `BizLevelButton`.
- Башня/виджеты: финальный токен‑проход без функциональных изменений.

## 2025-10-21 — Задача bl-db-cleanup fix
- Задача bl-db-cleanup fix: Удалены неиспользуемые legacy-таблицы и функции в Supabase: `core_goals`, `weekly_progress`, `goal_checkpoint_progress`, `daily_progress`, `reminder_checks`, `application_bank`, `payments`, `user_rhythm`, `internal_usage_stats`, `documents_backfill_map`, а также `upsert_goal_field(..)`. Использование по коду и edge перепроверено; актуальная модель — `user_goal` и `practice_log`. Advisors без критичных замечаний.

- Задача bonus-fix: динамическая цена разблокировки этажа берётся из `packages.price_gp` (клиент: `GpService.getFloorPrice`, `tower_tiles.dart`), убран риск рассинхрона с сервером. Применены миграции индексов через supabase‑mcp: добавлен `idx_gp_bonus_grants_rule_key`, удалены дубли `gp_ledger_user_created_idx`, `idx_practice_log_user_applied_at`, снят дублирующий unique‑constraint `user_goal_user_id_unique`. Advisors perf — чисто по GP.
 - Задача goals-repo-refactor fix: в `GoalsRepository` устранено дублирование (helpers `_ensureAnonApikey/_requireUserId/_getBox`), вынесены билдеры payload/запросов (`_buildUserGoalPayload`, `_fetchPracticeRows`), бонус за дневную практику вынесен в `_claimDailyBonusAndRefresh`. Публичные сигнатуры без изменений.

## 2025-10-22 — Тесты: чистка и актуализация
- Удалены legacy/пустые тесты под старую модель: `test/screens/goal_checkpoint_screen_test.dart`,
  `test/screens/goal_screen_readonly_test.dart`, `test/screens/levels_map_screen_test.dart`,
  `test/services/leo_service_unit_test.dart`.
- Добавлены актуальные тесты:
  - `test/screens/next_action_banner_test.dart` — L1/L4/L7/Журнал.
  - `test/screens/goal_practice_aggregates_test.dart` — агрегаты журнала Z/W.
  - Скелеты (skip): `test/screens/tower_checkpoint_navigation_test.dart`,
    `test/services/gp_unlock_floor_flow_test.dart`, `test/services/leo_service_gp_spend_test.dart`.
- Исправления для стабилизации:
  - `GoalsRepository.aggregatePracticeLog` считает уникальные дни (а не метки времени).
  - `gp_service_cache_test.dart`: инициализация Hive box перед чтением кеша.
  - `NotificationCenter` тесты: дополнительные `pump` и безопасный тап по action.
  - `LeoQuizWidget` тесты: переход на клики по ключам карточек (`leo_quiz_option_*`).
- Прогон тестов: часть падений остаётся (требуют отдельной адаптации под новый UI/моки Supabase):
  - mocktail: заменить `thenReturn(Future)` → `thenAnswer` в отдельных тестах сервисов/репозиториев.
  - UI-оверфлоу на `GoalCompactCard` в узкой ширине; тестам нужен иной layout/селекторы.
  - Навигационные тесты (`levels_system_test.dart`, `street_screen_test.dart`) — привести к актуальным маршрутам `/tower`.
  - Интеграции, зависящие от реального бэкенда, оставить `skip`/smoke с моками.

## 2025-10-23 — Design System: токены и консистентность (база)
- Добавлены токены в `AppColor`: backgroundSuccess/backgroundInfo/backgroundWarning/backgroundError, borderSubtle/borderStrong, textTertiary; централизована палитра `skillColors`.
- Повышен контраст вторичного текста: `labelColor=#64748B`.
- Кнопки: `BizLevelButton` — minSize повышены (sm=48, md=52) для доступности.
- Замены хардкод‑цветов на токены:
  - `NotificationCenter` → фон баннеров из `AppColor.background*`.
  - `GpStoreScreen` (нижний бар) → `AppColor.surface/borderStrong`.
  - `GpBalanceWidget` → `AppColor.surface/borderSubtle`.
  - `SkillsTreeView` → цвета навыков из `AppColor.skillColors`.
  - `LoginScreen` → фоновые градиенты через `AppColor.bgGradient`.
- Линты: критичных ошибок нет; предупреждения по сложности в `NotificationCenter` не блокируют.

## 2025-10-24 — Design System: анимации/тема/инпуты и библиотека
- Анимации: добавлены токены `AppAnimations` (quick/normal/slow/verySlow, кривые) и подключены в ключевых компонентах:
  - `BizLevelProgressBar` (slow), `SuccessIndicator` (normal, easeOutCubic→defaultCurve),
  - `AchievementBadge` (verySlow), `BottomBarItem` (normal+smoothCurve).
- Размеры/spacing:
  - Создан `AppDimensions` (иконки, радиусы, min touch target),
  - `AppSpacing` расширен специализированными токенами (card/screen/section/item, buttonPadding).
- Поля ввода: введён `AppInputDecoration.theme()` и подключён в теме приложения; единые бордеры/паддинги/цвета ошибок.
- Тема:
  - Создан `AppTheme.light()/dark()`; включён `AppTheme.light()` (dark подготовлен, по умолчанию не активирован).
- Кнопки: удалён `AnimatedButton`, все места переведены на `BizLevelButton` (градиент и scale через общие токены/стили).
- Библиотека:
  - `LibraryScreen`/`LibrarySectionScreen`: выведены расширенные поля, отступы переведены на `AppSpacing`, цвета — на `AppColor`, кнопки — на `BizLevelButton`; убраны жёсткие бордеры в фильтрах (используется `InputDecorationTheme`).
- Уведомления: `NotificationCenter` рефакторинг — введены `_BannerOptions/_BannerStyle`, сокращено число параметров вызова, без изменения UX.
- Прочее: сняты локальные хардкоды бордеров/цветов (включая `GpStoreScreen`/`GpBalanceWidget`); `SkillsTreeView` берёт палитру из токенов; `LoginScreen` использует градиент‑токен.
- Анализ кода (fix6): ошибок/варнингов нет; INFO сведены к безопасным рекомендациям (use_build_context_synchronously в UI местах с уже добавленными mounted-проверками).

### 2025-10-24 — Линт‑чистка (fix6.x)
- fix6.1: Применены автофиксы (`dart fix`) и повторный анализ.
- fix6.2: Массово удалены дефолтные аргументы (`avoid_redundant_argument_values`).
- fix6.3: Добавлены `context.mounted/mounted` и перенос `ScaffoldMessenger` до await.
- fix6.4: GoRouter: `.location` → `.uri.toString()`.
- fix6.5: Правки `throw/rethrow` в `gp_service.dart` (устранены ошибки; поведение без изменений).
- fix6.6: Переименованы локальные идентификаторы с подчёркиванием.
- fix6.7: Добавлены фигурные скобки у одинарных if/else.
- fix6.8: Константы к lowerCamelCase (`ANIMATED_BODY_MS` → `animatedBodyMs`).

## 2025-10-24 — Design Strategy: финальные правки UI/тема
- MainStreet: локальный фон‑градиент (#FAFAFA→#F7F3FF), цветовое кодирование карточек разделов (мягкие градиенты по типам).
- Goal: hero‑прогресс — круговой индикатор с градиентом + «Осталось N дн.» (безопасные фолбэки).
- Tower: вертикальный градиент путей в `_GridPathPainter` (без просадок FPS); узлы приведены к 60×60 (геометрия сохранена).
- Chat: микроанимация «плавания» аватара (low‑end guard), лёгкие «эмо‑реакции» у ассистента (ненавязчиво, без шума).
- Checkpoints L4/L7: единый хедер диалога Макса (аватар, бейдж, подложка).
- Profile: витрина достижений на `AchievementBadge` (shine‑эффект); мини‑баланс GP сохранён.
- Artifacts: tilt/hover, бейдж «NEW» до первого просмотра (Hive), полноэкранный viewer без регрессий.
- Library: fade‑in для описаний и динамических блоков, empty/error экраны унифицированы.
- Level Detail: тёплый CTA, тонкая верхняя полоса прогресса по урокам, лёгкий параллакс иллюстрации (отключается на low‑end).
- Тема: добавлен `AppColor.warmGradient`, подключён `AppTheme.dark()` + тумблер в Профиле; в тёмной теме уточнены бордеры/инпуты (светлые границы, приглушённые градиенты).

### 2025-10-24 — UX: LoginScreen
- Переставлена основная CTA «Войти» сразу под полем пароля (до соц‑логинов), чтобы уменьшить путаницу и улучшить завершение сценария входа.

## 2025-10-24 — DB hardening (fix6.x)
- Привёл search_path: функция `match_user_memories` теперь фиксирована на `public` (устранён `function_search_path_mutable`).
- Ужесточены права EXECUTE у RPC ядра GP (`gp_balance/gp_spend/gp_package_buy/gp_bonus_claim/gp_purchase_verify` и `gp_floor_unlock*`): только `authenticated` и `service_role`.
- Добавлены покрывающие индексы для FK: `ai_message(leo_message_id)`, `memory_archive(user_id)`, `user_packages(package_id)`.

## 2025-10-24 — RLS перепись (initplan/duplicates)
- Заменены выражения `auth.uid()` на `(select auth.uid())` в USING/WITH CHECK (исключён initplan‑overhead) для таблиц: `ai_message`, `leo_chats`, `leo_messages`, `user_memories`, `user_progress`.
- Удалены дубли permissive‑политик: `ai_message` (второй INSERT), `leo_chats` (`select_own`, `update_own`), `app_settings` (`app_settings_deny_all`). Поведение доступа не расширено.
- Service‑role политики не менялись. Функциональные права пользователей не изменялись (owner‑паттерн сохранён).

## 2025-10-24 — GP IAP/Web Verify (fix6.9–fix6.12)
- Добавлена RPC `gp_iap_credit(p_purchase_id text, p_amount_gp int)` (SECURITY DEFINER, search_path=public). Идемпотентное начисление по ключу `iap:<purchase_id>` в `gp_ledger`; обновление `gp_wallets`. GRANT EXECUTE → authenticated.
- Обновлена Edge Function `gp-purchase-verify`:
  - Ветка IAP (Android/iOS): верификация в сторе → вызов `gp_iap_credit` c `purchaseId = <platform>:<product_id>:<transactionId>`.
  - Ветка Web: поддержан `purchase_id` (вызов `gp_purchase_verify(purchase_id)` для завершения веб‑покупки).
- Клиент Android: добавлен fallback на `purchaseToken` из `localVerificationData` при неуспешной первой попытке verify; добавлены breadcrumbs.
- Проверки: линтеры чистые; деплой edge v49; таблицы `gp_wallets/gp_ledger` готовы к зачислениям (новые записи появятся после первой реальной покупки).

## 2025-11-05 — Задача nav-ux-2025-11-05 fix: навигация/главная/тренеры
- Нижняя навигация: 4 вкладки — Главная/Башня/Тренеры/Профиль (убраны «Цель/Артефакты» из табов).
- Главная: добавлен единый блок «Моя цель» (`GoalCompactCard`), крупный CTA «Продолжить», быстрые действия.
- Тренеры: заголовок «Тренеры», мгновенный старт чата по карточке, «Последние диалоги», аватары в списке, бейдж 1 GP.
- Очистка: удалены карточки «Коворкинг/Маркетплейс» и путь `assets/images/street/` из pubspec.

Задача 55.7 fix — Главная (MainStreet) финальные правки по draft‑3 и UX‑логам
- Верхний блок: убран логотип; аватар увеличен до 80×80 и вынесен влево, рядом крупно имя, ниже «Уровень N»; справа компактный GP‑бейдж (иконка + баланс) с переходом в `/gp-store`; снижены вертикальные отступы, устранены локальные overflow.
- CTA «ПРОДОЛЖИТЬ ОБУЧЕНИЕ»: одна иконка ▶ внутри плашки; заголовок «ПРОДОЛЖИТЬ ОБУЧЕНИЕ», подзаголовок формируется как «Уровень N: {title}» при наличии названия уровня (без дублирования «Уровень N: Уровень N»), иначе — «Уровень N: {label}».
- «Моя цель»: минимальная высота 160dp, убран лишний Spacer, кнопки 36 dp; добавлены Semantics‑лейблы, тени/цвета на токенах.
- «Полезное»: удалён заголовок, плитки уплощены (childAspectRatio≈3.2, меньшие вертикальные отступы); под «Библиотека» выводится суммарное число материалов через новый `libraryTotalCountProvider` — блок гарантированно умещается на одном экране.
- Декомпозиция и токены: вынесены `HomeCta`, `HomeGoalCard`, `TopGpBadge`; добавлен `AppDimensions` (общие высоты), внедрены Semantics для CTA/плиток/аватара; удалены жёсткие числа и лишние импорты; линтер — без предупреждений.
- `nextLevelToContinueProvider` дополнен полем `levelTitle` (из `levels.title`) для корректного подзаголовка CTA.

## 2025-11-06 — Задача nav-clean-2025-11-06 fix
- Нижняя навигация синхронизирована: вкладки — Главная/Башня/Тренеры/Профиль (`AppShell`).
- Таб‑маршруты: `/tower` → `BizTowerScreen`, `/chat` → `LeoChatScreen`; иконки обновлены.
- Главная: удалены устаревшие приватные виджеты (`_HomeGoalCard`, `_MainCtaButton`), очищены импорты; функционал без изменений.
- `pubspec.yaml`: подтверждена очистка — удалён `assets/images/street/` (ассеты «Street» более не подключаются).

### Задача ui-nav-final-2025-11-07 fix
- Вкладка «Уровни» (Башня): убрана кнопка «Назад» в AppBar (в экран заходим через таб).
- «База тренеров» переименована в «Менторы»; на экране Менторов увеличены аватары Лео/Макс в селекторе, единая страница истории чатов сохраняется для обоих ботов (iOS/Android/Web консистентны).
- Страница «Цель»: добавлена кнопка «Назад» в левом верхнем углу для возврата на Главную.

### Задача mentors-unify-2025-11-07 fix
- Менторы: карточки Лео/Макс стали CTA «Начать чат» (тапы запускают новый диалог без FAB).
- История: единый список для всех диалогов; у каждого элемента слева аватар бота, под ним жирным имя бота; заголовок — название чата, справа дата.
- Код: удалён state переключения бота; запрос чатов без фильтра по bot; открытие существующих чатов с корректной передачей `bot`.

## 2025-11-09 — Задача home-ui-main fix
- Главная: добавлены капсулы «Уровень N» и outlined‑бейдж GP с анимацией дельты; карточка «Моя цель» переразметена (правый блок процента), кнопки переведены на `BizLevelButton`.
- «Продолжить обучение»: введён `HomeContinueCard` (текст слева, превью уровня справа), замена `HomeCta`.
- Обновлены быстрые действия (карточность, ratio≈2.3); добавлен pull‑to‑refresh и breadcrumbs `home_opened/home_cta_continue_tap/home_quick_action_tap`.
- Тёмная тема/доступность соблюдены; добавлен smoke‑тест `home_continue_card_test`.

## 2025-11-10 — Задача home‑ui‑donut‑quote fix
- Цитата: вынесен общий `HomeQuoteCard` без аватара, подключён на Главной; `MotivationCard` на «Цели» лишён аватара.
- Прогресс цели: добавлен `DonutProgress` (анимированное кольцо), интегрирован в `HomeGoalCard`.
- Дедлайн: вместо «Дедлайн прошёл» показывается «Поставить новый дедлайн»; дата будущего дедлайна — «до DD.MM.YYYY».
- Кнопки цели: «Действие к цели» (secondary, иконка «+») и «Обсудить с Максом»; добавлены breadcrumbs.
- Quick Actions: hover/focus (Web) и лёгкая анимация scale; сохранены токены.
- Refresh: баннер «Обновлено» через `NotificationCenter`.
- Багфиксы: нормализованы даты для `showDatePicker` (крэш устранён).
- Тесты: smoke для `DonutProgress` и `HomeQuoteCard`.

### Задача goal‑suite fix
- Главная: скрываем кольцо прогресса при отсутствии метрики, показываем хинт «Добавьте метрику»; в контекст Макса добавлены `metric_*` и `target_date`.
- Цель: добавлен блок «Метрика цели» (тип/текущее/цель), bottom‑sheet «Обновить текущее», авто‑установка `metric_start` при первом вводе; пояснение формулы прогресса.
- Онбординг: баннер с CTA в L1 при пустой цели.
- Журнал: подсказка‑легенда для «Топ‑3» инструментов.
- Напоминания: при сохранении настроек дополнительно вызывается `cancelDailyPracticeReminder`; отображается «Следующее напоминание: …».
- Очистка: удалены легаси‑методы в `GoalsRepository`; убрана ветка `goalCheckpointVersion` из `MainStreetScreen`.
- Бэкенд: добавлена `user_goal_history`, связка `practice_log.goal_history_id`, указатель `user_goal.current_history_id`; edge `leo-chat` фильтрует практику по текущей истории; RLS‑политика для `leo_messages_processed`.

### 2025-11-10 — Задача goal‑journey UI/UX+
- L1: добавлен верхний интро‑блок (картинка + 3 строки текста); в форме — поля «Текущая» и «Цель» (числа), при сохранении `metric_start=metric_current`, `metric_target` пишется сразу.
- Главная: кнопки «+ Действие к цели» и «Обсудить с Максом» увеличены (size=lg); действие ведёт на `/goal?scroll=journal` и автопрокручивает к Журналу.
- «Цель/Моя цель»: убран выпадающий список «Метрика (тип)» и кнопка «Обновить текущее»; в шите «Новая цель» добавлены поля «Текущая/Цель».
- Журнал: добавлено поле «обновить текущее значение»; при сохранении запись пишется в `practice_log`, затем обновляется `metric_current` через репозиторий; в чат «Макс» передаём `metric_current_updated`.
- Локализация: включены `flutter_localizations`; `MaterialApp.router` поддерживает ru/en; `showDatePicker(locale: ru)` на экранах выбора даты.

### 2025-11-11 — Задача goal‑context+rpc cleanup
- Контекст Макса: удалён `metric_type`; добавлен общий helper `buildMaxUserContext(...)` и подключён в Home/Цели/Журнале.
- Дата: создан единый helper `showRuDatePicker(...)`, применён в L1 и «Моя цель».
- Журнал: debounce выбора «Топ‑3», сообщение «Метрика обновлена до N», фикс дублей в Dropdown.
- Бэкенд: миграция `log_practice_and_update_metric` (транзакция — вставка `practice_log` + обновление `metric_current` в `user_goal`/`user_goal_history`), индексы на `practice_log` и `user_goal_history`.
- Клиент: при сохранении записи используем RPC; на ошибке — фоллбек к прежней схеме (insert + update).

## 2025-11-11 — Задача DS-001 fix: Аудит дизайн‑системы
- Проведён аудит темы (`lib/theme/*`), найдены антипаттерны в экранах/виджетах; подготовлены рекомендации по Material 3, доступности и адаптиву.
- Добавлен тестовый экран `ThemeGalleryScreen` (lib/widgets/dev/theme_gallery.dart) для визуальной проверки токенов/компонентов (экран не подключён в навигацию).
‑ Включён Material 3, добавлены ThemeExtensions (Chat/Quiz/GP/GameProgress/Video), компонентные темы (Buttons/Chips/NavBar/TabBar/Cards/ListTile/Dialog/BottomSheet/Progress/Tooltip/SnackBar), Dynamic Color (Android 12+), OLED‑тёмная тема. Частичный token hygiene на ключевых экранах + `scripts/lint_tokens.sh` для контроля.

## 2025-11-12 — Задача mobile-iap-store-only fix
- Мобилки: отключён веб‑фолбэк оплат. В `GpStoreScreen` веб‑инициация/verify по `purchase_id` заблокированы на iOS/Android; покупки только через StoreKit/Google Billing.
- Клиент: `GpService` добавляет заголовок `x-client-platform` (`web|android|ios`) для Edge.
- Сервер: `gp-purchase-verify` принимает ветку `purchase_id` только при `x-client-platform=web`; на мобилках возвращает 403 `web_verify_not_allowed_on_mobile`. CORS обновлён.
- Деплой: edge `gp-purchase-verify` v67. Линтеры по изменённым файлам — без ошибок.

## 2025-11-13 — Задача iap-store-fix fix
- Стандартизированы productId: `gp_300/gp_1000/gp_2000` (клиент `GpStoreScreen` + сервер `gp-purchase-verify` v68).
- Мобилки: отключён веб‑фолбэк; добавлены `x-client-platform` и серверная проверка (web‑verify запрещён на iOS/Android).
- iOS: обновлён `Sentry/HybridSDK` до 8.56.2, переустановлены Pods; вход Google переведён на OAuth Supabase.
- Обновлены SDK/пакеты: Flutter 3.35.7 / Dart 3.9.2, `in_app_purchase` (+ StoreKit plugin).
- ТЗ по ASC: вывести IAP из Draft в Ready to Submit и прикрепить к версии.

## 2025-11-14 — Задача ios-bootstrap fix:
- Bootstrap: синхронным остался только dotenv + Supabase, Hive перенесён в фон.
- Deferred: Firebase, PushService, Hive‑боксы и таймзоны/уведомления запускаются fire-and-forget.
- Мониторинг: добавлены логи POSTBOOT и отложенная инициализация Sentry после первого кадра.
- Кеши: добавлен `HiveBoxHelper`, все сервисы/репозитории используют ленивое открытие боксов без блокировки главного потока.
