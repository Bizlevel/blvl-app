### BizLevel — аудит тестов (2025-12-15)

#### Цель проверки
Инвентаризировать тесты в репозитории и зафиксировать фактический статус: **что проходит**, **что падает**, **что легаси/неактуально**, **что “тестируется неправильно”**, а также выявить типовые проблемы тестового окружения.

#### Что сделано (фактами)
- **Прочитаны документы**: `docs/status.md`, `docs/project-structure-dec.md`, `docs/bizlevel-concept.md`.
- **Инвентаризация**: найдено **60** файлов `*_test.dart` по репозиторию.
- **Проверка CI**: `.github/workflows/ci.yaml` запускает:
  - **Unit job**: `flutter test --coverage` (весь `test/**`)
  - **Integration jobs**: `flutter test integration_test -d ...`, но папка `integration_test/` **пустая** → эти джобы сейчас **не дают реального сигнала**.
- **Запуски тестов**: сделан полный прогон `test/` (reporter `failures-only`) + точечные запуски отдельных файлов для подтверждения статуса.

#### Важные детали тестового harness
- `test/flutter_test_config.dart`:
  - делает `TestWidgetsFlutterBinding.ensureInitialized()`
  - мокает `SharedPreferences`
  - инициализирует Supabase через `Supabase.initialize(... httpClient: TestHttpClient())`
  - **не инициализирует Hive**
- `test/mocks.dart`:
  - `TestHttpClient` всегда возвращает **HTTP 400** (с валидным JSON), без реальной сети

---

#### Сводка статусов (по текущему состоянию репозитория)
- **Всего файлов `*_test.dart`**: 60
- **В `test/` (входят в `flutter test`)**: 59
- **В `integration_test/`**: 0
- **PASS**: 33 файла
- **FAIL**: 21 файл
- **SKIP**: 5 файлов
  - 2 файла полностью пропущены через `@Skip(...)`
  - 3 файла “зелёные” только формально: **all tests skipped** (`skip: true`)
- **LEGACY / вне suite**: 1 файл — `ios/test/widget_test.dart` (не компилируется)

---

#### Матрица по файлам

##### PASS (33) — дают полезный сигнал
- `test/deep_link_test.dart`
- `test/deep_links_test.dart`
- `test/infrastructure_integration_test.dart`
- `test/integration/practice_log_max_comment_test.dart`
- `test/providers/goals_providers_test.dart`
- `test/providers/provider_smoke_test.dart`
- `test/providers/startup_performance_test.dart`
- `test/rag/rag_quality_test.dart`
- `test/repositories/goals_repository_progress_test.dart`
- `test/repositories/goals_repository_test.dart`
- `test/repositories/practice_log_aggregate_test.dart`
- `test/routing/app_router_test.dart`
- `test/screens/auth/register_screen_test.dart`
- `test/screens/checkpoint_l7_integration_test.dart`
- `test/screens/goal_practice_aggregates_test.dart`
- `test/screens/goal_screen_zw_and_sticky_test.dart`
- `test/screens/gp_store_screen_test.dart`
- `test/screens/leo_dialog_screen_test.dart`
- `test/screens/library_screen_test.dart`
- `test/screens/next_action_banner_test.dart`
- `test/screens/tower_map_screen_test.dart`
- `test/services/auth_service_test.dart` *(есть 1 skipped test внутри файла)*
- `test/services/gp_bonus_flow_test.dart`
- `test/services/gp_service_cache_test.dart`
- `test/services/payment_service_test.dart`
- `test/ui_text_scaling_test.dart`
- `test/user_skills_increment_test.dart`
- `test/web_smoke_test.dart`
- `test/widgets/donut_progress_test.dart`
- `test/widgets/goal_checkpoint_progress_test.dart`
- `test/widgets/leo_quiz_widget_test.dart`
- `test/widgets/notification_center_test.dart`
- `test/widgets/skills_tree_view_test.dart`

##### SKIP (5) — сейчас не проверяют ничего
- `test/auth_flow_test.dart` — `@Skip('requires real Supabase env')`
- `test/leo_integration_test.dart` — `@Skip('requires real Supabase env')`
- `test/screens/tower_checkpoint_navigation_test.dart` — **All tests skipped** (`skip: true`)
- `test/services/gp_unlock_floor_flow_test.dart` — **All tests skipped** (`skip: true`)
- `test/services/leo_service_gp_spend_test.dart` — **All tests skipped** (`skip: true`)

##### LEGACY / вне suite (1)
- `ios/test/widget_test.dart` — **не компилируется** (`package:ios/main.dart` не существует). Похоже на остаток scaffold’а, не связанный с реальным приложением.

##### FAIL (21) — текущий suite не зелёный
Ниже — **первопричина/тип проблемы**, чтобы понимать, где “баг теста”, где “баг окружения”, где “продуктовый баг/изменение UI”.

| Файл | Симптом | Вероятная причина | Класс |
|---|---|---|---|
| `test/repositories/levels_repository_test.dart` | “returns cached when offline” падает (`Нет соединения с интернетом`) | В самом тесте `box.clear()` вызывается **без `await`** → гонка/очистка кэша после `put` | **Баг теста (async/race)** |
| `test/repositories/lessons_repository_test.dart` | аналогично падает “returns cached when offline” | Та же гонка: `box.clear()` без `await` | **Баг теста (async/race)** |
| `test/repositories/library_repository_test.dart` | `SocketException: offline` пробрасывается наружу, кэш не подхватывается | Та же гонка: `box.clear()` без `await` → кэш может исчезать | **Баг теста (async/race)** |
| `test/infrastructure_test.dart` | NPE внутри `PostgrestBuilder._parseResponse` при `.select()` | Конфиг тестов принудительно использует `TestHttpClient` (HTTP 400), а тест ожидает `PostgrestException`. По сути это **интеграционный тест**, но запускается в unit-suite | **Неправильный слой теста / harness mismatch** |
| `test/widgets/home_quote_card_test.dart` | `Bad state: No ProviderScope found` | `HomeQuoteCard` — `ConsumerWidget`, а тест не оборачивает в `ProviderScope` | **Баг теста (harness)** |
| `test/screens/street_screen_test.dart` | `HiveError: You need to initialize Hive...` + падения finders/таймауты | Экран/провайдеры дергают `LibraryRepository`, который делает `Hive.openBox(...)` напрямую; Hive в `flutter_test_config.dart` не инициализируется | **Баг окружения (Hive init) + хрупкие ожидания** |
| `test/screens/home_continue_card_test.dart` | `find.textContaining('Уровень')` находит 2 виджета | Слишком широкий finder, UI содержит несколько строк с “Уровень …” | **Хрупкий тест (finders)** |
| `test/screens/level_detail_screen_test.dart` | аналогично (дубликаты текста “Уровень …”) | Широкий finder/изменения UI | **Хрупкий тест (finders)** |
| `test/screens/auth/login_screen_test.dart` | `pumpAndSettle timed out` / индикатор не найден | Бесконечные анимации/stream + устаревшие ожидания по loading UI | **Хрупкий тест (async/UI)** |
| `test/screens/checkpoint_l7_cta_navigation_test.dart` | `RenderFlex overflowed...` + не найден CTA текст | Тестовый viewport мал / контент не помещается; плюс возможное изменение текста/структуры | **UI layout в тестах + хрупкие finders** |
| `test/screens/checkpoint_l4_l7_buttons_test.dart` | overflow + не найден “Добавить метрику”/“Усилить применение” | То же: viewport/layout и ожидания по текстам | **UI layout + хрупкие finders** |
| `test/screens/checkpoint_l7_screen_test.dart` | overflow + не найден “Чекпоинт: …” | То же | **UI layout + хрупкие finders** |
| `test/screens/checkpoints_l4_l7_dialog_flow_test.dart` | overflow + не найден “Обсудить с Максом” | То же | **UI layout + хрупкие finders** |
| `test/screens/goal_screen_top_tools_test.dart` | `Bad state: No element` при `tap()` | Ожидаемые кнопки не найдены: либо провайдер возвращает пусто, либо UI изменился, либо нужно ждать/override | **Хрупкий тест (state/UI)** |
| `test/screens/profile_screen_integration_test.dart` | Не найден “Test User” | Моки auth/user не совпадают с тем, что реально рендерится (или имя не отображается) | **Хрупкий тест (state/UI)** |
| `test/screens/level_detail_screen_quiz_flow_test.dart` | video init error + `RangeError` при выборе ответа | Недостаточно стабилен мок/инициализация видео/контента; finder по индексу ломается при изменениях UI | **Хрупкий тест (async/content)** |
| `test/lesson_progress_persistence_test.dart` | Ожидает сохранение прогресса, но получает `null` | Либо изменились ключи/логика сохранения, либо тест смотрит не туда (SharedPreferences мокается) | **Возможный баг в коде или устаревший тест** |
| `test/level_flow_test.dart` | `Bad state: No element` (не находится ожидаемый виджет на шаге) | Флоу UI изменился / finder слишком конкретный / недостаточный `pump` | **Хрупкий e2e-widget тест** |
| `test/levels_system_test.dart` | Ожидание навигации на `LevelDetailScreen` не выполняется | Маршрутизация/условия навигации изменились, тест не обновлён | **Хрупкий e2e-widget тест** |
| `test/profile_monetization_test.dart` | Не найден текст вроде “3 Уровень” | UI/тексты изменились (или формат теперь другой) | **Хрупкий тест (UI тексты)** |
| `test/level_zero_flow_test.dart` | Не найден “Далее” в онбординге | UI/контент/условия показа изменились | **Хрупкий e2e-widget тест** |

---

#### Ключевые классы проблем (что системно мешает тестам)
- **Hive init в тестовом окружении**:
  - Часть кода открывает box напрямую (`Hive.openBox`), а `flutter_test_config.dart` Hive не инициализирует.
  - Это ломает экранные тесты, которые транзитивно трогают библиотеку/кэш.
- **Хрупкие finders по тексту**:
  - `textContaining('Уровень')` / ожидания на точные строки часто ломаются при небольших UI-изменениях.
  - Для BizLevel лучше переходить на `Key`/структурные проверки (но это уже этап исправлений).
- **`pumpAndSettle` в местах с анимациями/стримами**:
  - Возможны вечные “settle” таймауты, если на экране есть индикаторы/анимации/таймеры.
- **RenderFlex overflow в checkpoint-экранах**:
  - Либо реальный UX-баг на малых/планшетных размерах,
  - либо тестам нужно выставлять корректный viewport/скролл (определится при исправлениях).
- **Интеграционные проверки в unit-suite**:
  - `test/infrastructure_test.dart` по смыслу проверяет Supabase соединение/RLS, но запускается в окружении с синтетическим `TestHttpClient`.
- **Ошибки в самих тестах (async)**:
  - В repo-тестах `box.clear()` вызывается без `await`, что делает их **флейковыми/невалидными**.

---

#### Рекомендованный порядок приведения suite в зелёный (без реализации)
**P0 (инфраструктура тестов):**
- Унифицировать инициализацию Hive в тестах (чтобы screen/provider тесты не падали на `HiveError`).
- Решить стратегию Supabase для тестов: “всё мокается” vs “часть integration с реальным env”.

**P1 (исправление явных багов тестов):**
- `await box.clear()` в repo-тестах, добавить `ProviderScope` в `home_quote_card_test.dart`.

**P2 (стабилизация UI-тестов):**
- Убрать finders по “содержит текст” там, где возможно (заменить на Key/точные ожидания).
- Заменить `pumpAndSettle` на управляемые `pump(Duration...)` там, где есть бесконечные анимации.

**P3 (checkpoint-экраны):**
- Разобрать overflow: это продуктовая проблема верстки или “тестовый viewport” (и выбрать корректный фикс).

**P4 (интеграционные сценарии):**
- Перенести `@Skip(requires real Supabase env)` сценарии в реальный `integration_test/` либо включить их под отдельным флагом/джобой в CI.

