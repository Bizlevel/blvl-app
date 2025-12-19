### BizLevel — аудит и фиксы тестов (2025-12-15 → обновлено 2025-12-17)

#### Цель
Привести тестовую систему в состояние, где:
- unit/widget тесты **детерминированы**, не зависят от реальной сети/бэкенда и дают быстрый сигнал;
- integration тесты **реально проверяют** ключевые интеграции (Supabase) на мобильных устройствах;
- легаси/устаревшие тесты не ломают suite и не создают «ложный шум».

#### Итог (на 2025-12-17)
- **Всего файлов `*_test.dart`**: **53**
  - **`test/`**: **52** (входят в `flutter test`)
  - **`integration_test/`**: **1** (интеграционные тесты для мобилок)
  - **`ios/test/`**: **0**
- **Unit suite (`flutter test`)**: **зелёный**
  - **PASS**: **47** файлов
  - **SKIP**: **5** файлов (2 × `@Skip`, 3 × `skip: true`; ещё 1 skipped‑тест внутри `auth_service_test.dart`)
  - **FAIL**: **0**
- **Integration suite (`flutter test integration_test -d ...`)**: перестал быть «пустым» — добавлен smoke‑тест по Supabase.

---

#### Что сделано (фактами)
- Исправлены флейки/ошибки в тестах:
  - `await box.clear()` в repo‑тестах (гонки на Hive).
  - Убраны хрупкие `find.textContaining('Уровень')` там, где это давало дубликаты.
  - Заменён `pumpAndSettle()` в экранах с фоновыми анимациями на управляемые `pump(Duration...)`.
  - Исправлены тесты под актуальный UI (Login/Register, Goal top tools, Profile, Home/Street).
  - `lesson_progress_persistence_test.dart`: учтён debounce сохранения (200мс).
- Устранены системные причины падений:
  - `dailyQuoteProvider`: `_todayIndexProvider` переписан на **отменяемый** `Timer.periodic`, чтобы в widget tests не оставались pending timers.
  - `LibraryRepository`: открытие Hive box унифицировано через `HiveBoxHelper.openBox('library')` → больше нет `HiveError` в тестах/раннем UI.
  - Checkpoint L4/L7: чат переведён на `Expanded`, чтобы убрать `RenderFlex overflow` на малых размерах.
- Разграничены unit vs integration:
  - `test/flutter_test_config.dart` получил **2 режима** (см. ниже).
  - Добавлен `integration_test/supabase_infrastructure_test.dart`.
  - CI: для `integration_android`/`integration_ios` теперь создаётся **реальный `.env` из secrets** и выставляется `BIZLEVEL_INTEGRATION_TEST=1`.
- Удалено легаси/устаревшее:
  - `ios/test/widget_test.dart` (не компилировался).
  - Несколько e2e-widget тестов, завязанных на legacy UI/экраны и видео‑блоки (давали флейки и краши `flutter test`).

---

#### Важные детали test harness
`test/flutter_test_config.dart` теперь поддерживает **2 режима**:

- **Unit/widget (по умолчанию)**:
  - `TestWidgetsFlutterBinding.ensureInitialized()`
  - `SharedPreferences.setMockInitialValues({})`
  - `Supabase.initialize(... httpClient: TestHttpClient())` (без реальной сети)

- **Integration mode** (когда в окружении выставлен `BIZLEVEL_INTEGRATION_TEST=1`):
  - `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
  - **НЕ мокает** `SharedPreferences`
  - **НЕ инициализирует** Supabase (инициализация должна быть явной внутри integration тестов/приложения)

`test/mocks.dart`:
- `TestHttpClient` возвращает HTTP 400 (детерминированный «неуспех сети» для unit-suite).

---

#### SKIP (5) — сейчас не дают сигнала
- `test/auth_flow_test.dart` — `@Skip('requires real Supabase env')`
- `test/leo_integration_test.dart` — `@Skip('requires real Supabase env')`
- `test/screens/tower_checkpoint_navigation_test.dart` — **all tests skipped** (`skip: true`)
- `test/services/gp_unlock_floor_flow_test.dart` — **all tests skipped** (`skip: true`)
- `test/services/leo_service_gp_spend_test.dart` — **all tests skipped** (`skip: true`)

---

#### Integration tests (mobile) — текущий минимум
- `integration_test/supabase_infrastructure_test.dart`:
  - smoke‑проверка: `levels` читается как публичный контент;
  - smoke‑проверка: таблица `users` не читается без auth (RLS).

Запуск локально (пример):
- выставить `BIZLEVEL_INTEGRATION_TEST=1`
- `flutter test integration_test -d <device>`

---

#### Что осталось / next steps
- Определиться, что делать с `@Skip(requires real Supabase env)`:
  - либо перенести в `integration_test/` и сделать управляемым флагом/джобой,
  - либо оставить как manual/e2e проверки.
- По мере развития BizLevel добавлять интеграционные сценарии (минимальный happy‑path auth, GP‑баланс, базовый чат Leo/Max) **отдельно от unit suite**.


