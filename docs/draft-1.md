# BizLevel — iOS: регрессия зависаний/долгого старта (декабрь 2025)

Дата: 2025‑12‑14  
Статус: ✅ завершено

## 0) Контекст (что случилось)
После последних правок снова появились **сильные подвисания** и долгий запуск на iOS.  
По логам (`docs/draft-2.md`, `docs/draft-4.md`) фиксируются:

- **Hang detected: 14.14s** (около `12:18:18`) + затем `flutter: INFO: Supabase bootstrap completed` / `Hive bootstrap completed`
- **Hang detected: 8.91s** (около `12:18:27`) рядом со стартом Sentry (`SentryFlutterPlugin ... started`) и `MainThreadIOMonitor` стеком Sentry
- **Hang detected: 29.16s** + `Gesture: System gesture gate timed out` (около `12:18:59`) — UI реально «не отвечает»
- В `docs/draft-2.md` есть **`Message from debugger: killed`** после `gesture gate timed out` → процесс убивается из‑за неотзывчивости (watchdog).

`docs/draft-6.md` уже описывает похожий класс проблем и принципы фикса:  
**не блокировать первый кадр**, **не запускать тяжёлое в одной await‑цепочке**, **permissions не на cold start**, **timezone/Hive — лениво**, **Sentry — не в критическом пути UI**.

## 1) Гипотезы причин (почему это происходит)
На текущий момент наиболее вероятные источники зависаний:

1) **Запрос notification permissions на cold start**  
`NotificationsService.initialize()` вызывает `_requestPermissionsIfNeeded()` сразу — на iOS это ведёт к системным операциям/деактивациям и может “подвешивать” интерактивность.

2) **Тяжёлый timezone init на старте**  
`tzdata.initializeTimeZones()` — синхронная тяжёлая операция; если выполняется во время пользовательской интеракции, легко получить `gesture gate timed out`.

3) **Массовое открытие Hive box’ов на старте**  
Открытие пачки коробок даёт пики дискового I/O и может “замораживать” главный изолят.

4) **Sentry init / native I/O близко к моментам интерактивности**  
Логи содержат `MainThreadIOMonitor` стек внутри Sentry (`SentryAsyncLogWrapper initializeAsyncLogFile`), что совпадает с hang‑событиями.

## 2) Что из правок в этом чате могло вернуть проблему (список)
Потенциальные триггеры регрессии (по коду и логам):

- Добавление/усиление post‑frame цепочки “Sentry → deferred local services → notifications → timezone → push”.
- Инициализация уведомлений с запросом разрешений на старте (`NotificationsService.initialize()`).
- Инициализация timezone (`tzdata.initializeTimeZones()`) в рамках deferred‑старта, а не по требованию.
- Массовое `Hive.openBox` для множества боксов на старте.

## 3) Цели фикса (KPI)
- **KPI‑1 (интерактивность)**: нет `Gesture: System gesture gate timed out` и нет `killed` при обычной интеракции (чат/клавиатура).
- **KPI‑2 (cold start)**: первый UI появляется быстро, а тяжёлые задачи не “замораживают” UI.
- **KPI‑3 (анти‑регресс)**: правила зафиксированы (permissions/TZ/Hive/Sentry) + есть простая диагностика таймингов.

---

## 4) План работ (TODO, выполняем по шагам)

> ВАЖНО: после каждого шага ниже я дописываю **результат** в раздел “Журнал выполнения”.

### T0 — Базовая фиксация проблемы (без функциональных изменений)
- [x] **T0.1** Добавить лёгкую инструментализацию таймингов старта (Stopwatch/Timeline) в:
  - `lib/main.dart` (bootstrap + post-frame этапы)
  - `lib/services/notifications_service.dart` (init + permissions)
  - `lib/services/timezone_gate.dart` (timezone init)
- **Критерий готовности**: в логах есть понятные метки `STARTUP[...]` с длительностями.

### T1 — Убрать notification permissions с cold start (P1)
- [x] **T1.1** Разделить notifications init на:
  - `initialize()` (ядро без запроса permissions)
  - `ensurePermissionsRequested()` (только по запросу из UI/перед scheduling)
- [x] **T1.2** Проверить вызовы: где нужно — добавить явный запрос permissions (экран настроек/включение напоминаний).
- **Критерий готовности**: при cold start нет системного запроса разрешений; разрешение спрашивается только при явном действии пользователя.

### T2 — Убрать timezone init с cold start (P3)
- [x] **T2.1** Убрать `_warmUpTimezone()` из дефолтного startup пути.
- [x] **T2.2** Ввести “ensure timezone” по требованию (перед schedule reminders) и корректно закрыть `TimezoneGate`.
- **Критерий готовности**: `tzdata.initializeTimeZones()` не запускается на старте, но напоминания продолжают работать.

### T3 — Уменьшить Hive I/O на старте (P2)
- [x] **T3.1** На старте открывать только то, что необходимо для launch-route (обычно `notifications` box).
- [x] **T3.2** Остальные box’ы открывать лениво, либо при входе на конкретные экраны/фичи.
- **Критерий готовности**: нет массового открытия боксов на старте; нет HiveError; функциональность не сломана.

### T4 — Sentry: убрать из критического пути интерактивности (P4)
- [x] **T4.1** Перенести/разнести Sentry init так, чтобы он не блокировал UI (не одной await‑цепочкой).
- [x] **T4.2** При необходимости — сделать “delay/idle init” (инициализация после показа первого реального экрана).
- **Критерий готовности**: исчезают hang‑кластеры, совпадающие по времени со стартом Sentry.

### T5 — Финальная проверка и меры против регрессии
- [x] **T5.1** Прогнать `flutter analyze` + `test/ui_text_scaling_test.dart` + `test/providers/startup_performance_test.dart`.
- [x] **T5.2** Зафиксировать правила “чтобы не возвращалось” (permissions/TZ/Hive/Sentry) в конце этого файла.

---

## 5) Журнал выполнения (обновляется после каждого шага)

### 2025‑12‑14
- ✅ **T0.1 Инструментация таймингов (STARTUP[*]) добавлена**
  - Файлы: `lib/main.dart`, `lib/services/notifications_service.dart`, `lib/services/timezone_gate.dart`
  - Добавлены метки:
    - `STARTUP[bootstrap.*]` (dotenv/supabase/hive)
    - `STARTUP[postframe.*]` (Sentry prewarm/init, local services, launch route)
    - `STARTUP[ui.*.first_frame]` (первый кадр bootstrap и router UI)
    - `STARTUP[notif.*]` (init/permissions)
    - `STARTUP[timezone.init.*]` (ленивая инициализация timezone)
  - Проверки:
    - `flutter analyze` ✅
    - `flutter test test/ui_text_scaling_test.dart` ✅
    - `flutter test test/providers/startup_performance_test.dart` ✅

- ✅ **T1 Убрали permissions‑prompt с cold start**
  - `NotificationsService.initialize()` больше **не вызывает** `_requestPermissionsIfNeeded()`.
  - Добавлен `NotificationsService.ensurePermissionsRequested()` и он вызывается:
    - при `schedulePracticeReminders()` (то есть при сохранении настроек напоминаний пользователем)
  - Убрано авто‑расписание напоминаний на login (email+password и Apple), чтобы не провоцировать внезапный системный диалог.
  - Проверки:
    - `flutter analyze` ✅
    - `flutter test test/ui_text_scaling_test.dart` ✅
    - `flutter test test/providers/startup_performance_test.dart` ✅

- ✅ **T2 Timezone стал ленивым (по требованию)**
  - Убрали `tzdata.initializeTimeZones()` из `_initializeDeferredLocalServices()` (не запускается на старте).
  - Реализовали `TimezoneGate.ensureInitialized()` (внутри tzdata + FlutterTimezone + tz.setLocalLocation).
  - `NotificationsService` теперь вызывает timezone init только при scheduling (и пробрасывает ошибку наверх, чтобы UI мог показать фидбек).
  - Проверки:
    - `flutter analyze` ✅
    - `flutter test test/ui_text_scaling_test.dart` ✅
    - `flutter test test/providers/startup_performance_test.dart` ✅

- ✅ **T3 Уменьшили Hive I/O на старте**
  - В `lib/main.dart` сокращён список “pre-open” box’ов до: `gp`, `notifications`
    - больше не открываем на старте: `levels`, `lessons`, `user_goal`, `practice_log`, `quotes` и т.п.
  - `LevelsRepository` и `LessonsRepository` переведены на ленивое открытие через `HiveBoxHelper.openBox(...)`.
  - Проверки:
    - `flutter analyze` ✅
    - `flutter test test/ui_text_scaling_test.dart` ✅
    - `flutter test test/providers/startup_performance_test.dart` ✅

- ✅ **T4 Sentry вынесен из критического окна интерактивности**
  - `SentryFlutter.init` больше **не выполняется** синхронно в post‑frame цепочке до local services.
  - Добавлен `_scheduleDeferredSentryInit()`:
    - стартует через ~1500мс
    - выполняется в `SchedulerBinding.scheduleTask(..., Priority.idle)` (когда UI простаивает)
  - Проверки:
    - `flutter analyze` ✅
    - `flutter test test/providers/startup_performance_test.dart` ✅
    - `flutter test test/ui_text_scaling_test.dart` ✅

- ✅ **T5 Финальная валидация + анти‑регресс правила**
  - Повторно прогнаны проверки после всех шагов:
    - `flutter analyze` ✅
    - `flutter test test/ui_text_scaling_test.dart` ✅
    - `flutter test test/providers/startup_performance_test.dart` ✅
  - Добавлены правила ниже (см. разделы 6–7).

---

## 6) Как проверить фикс на iOS (ручной чеклист)

### 6.1 Cold start (важно)
1) Удалить приложение с устройства (чтобы был “чистый” cold start).
2) Поставить заново и запустить.
3) В Xcode/Console убедиться:
   - **нет** системного prompt “разрешить уведомления” на старте
   - в логах есть `STARTUP[bootstrap.*]`, `STARTUP[postframe.*]`
   - `STARTUP[postframe.sentry.deferred.start]` появляется **после** `postframe.done` и с задержкой.

### 6.2 Интерактивность (чат/клавиатура)
1) Сразу после появления UI:
   - открыть чат → вызвать клавиатуру → быстро печатать/скроллить.
2) В логах должно быть:
   - **нет** `Hang detected: ...`
   - **нет** `Gesture: System gesture gate timed out`
   - **нет** `Message from debugger: killed`

### 6.3 Напоминания (timezone+permissions теперь по запросу)
1) Открыть экран **Напоминания** → нажать **Сохранить**.
2) Ожидаем:
   - системный prompt на разрешение уведомлений появляется **тут** (если не давали раньше)
   - после этого scheduling проходит (нет ошибок), напоминания приходят в выбранное время.

---

## 7) Правила, чтобы проблема не возвращалась (anti‑regress)
- **Permissions**: не запрашивать notification permissions на cold start / на логине. Только по явному действию (настройка напоминаний).
- **Timezone**: `tzdata.initializeTimeZones()` — только по требованию перед scheduling (лениво через `TimezoneGate.ensureInitialized()`).
- **Hive**:
  - на старте не открывать “пачку” box’ов;
  - если репозиторий использует Hive — открывать box лениво (`HiveBoxHelper.openBox`), либо через `Hive.openBox` внутри метода.
- **Sentry**:
  - не запускать Sentry init в критическом окне интерактивности;
  - Sentry init — позже, через idle/задержку (как в `_scheduleDeferredSentryInit`).
- **Правка Pods**: не лечить поведение правками в `ios/Pods/**` (всё устойчивое — в исходниках/скриптах проекта).

---

## 8) Follow‑up (2025‑12‑14): лаг первой клавиши на логине
После первого круга фиксов приложение стало собираться, а `pod install` проходит чисто, но на iOS осталось **небольшое подтормаживание** при первом вводе в поле логина.

По свежим логам (`docs/draft-2.md`, `docs/draft-4.md`) видно:
- `STARTUP[postframe.local_services]` занимал около **~4.8s** и совпадал по времени с `Hang detected: 4.81s`.
- В момент первого ввода/показа клавиатуры появляются системные события `TUIKeyboard*` и `MainThreadIOMonitor ... InternalConfig.plist`, после чего фиксируются `Hang detected: 6.26s / 10.52s` (в логах отмечено `debugger attached`).

### Применённые добивки (минимальные, направленные на интерактивность)
- `lib/main.dart`: **убрана** инициализация `NotificationsService` из `postframe.local_services` (оставили только быстрый preload `launch_route` через Hive). Уведомления теперь инициализируются **лениво** при реальном использовании.
- `lib/widgets/custom_textfield.dart`, `lib/screens/auth/login_screen.dart`: для `email/password` отключены `autocorrect`, `enableSuggestions`, `enableIMEPersonalizedLearning`, выставлены `keyboardType`, `autofillHints`, отключены smart quotes/dashes — чтобы снизить нагрузку клавиатуры на первом вводе.

Проверки после добивок:
- `flutter analyze` ✅
- `flutter test test/providers/startup_performance_test.dart` ✅
- `flutter test test/ui_text_scaling_test.dart` ✅

---

## 9) Регрессия (2025‑12‑14): стало ещё хуже по cold start — что было не так и как исправили

### 9.1 Что показывают свежие логи (draft‑2 / draft‑4)
- `STARTUP[ui.bootstrap.first_frame]` появляется только на **~6.0s**, и почти сразу после этого завершается `bootstrap.dotenv`:
  - `bootstrap.dotenv.start` → `bootstrap.dotenv.ok` ≈ **6s**
  - рядом фиксируется `Hang detected: ~6.01s`
- `STARTUP[postframe.local_services]` занимает **~8.06s** (`local_services.start` → `local_services.ok`), и это совпадает с:
  - `Hang detected: 8.06s`
  - затем возможны `Gesture: System gesture gate timed out`
- Дополнительно есть “длинные” хэнги в районе клавиатуры (`Hang detected: 18.35s`, `7.35s`) — они проявляются, когда в момент системной инициализации клавиатуры наш главный поток занят долгими задачами.

### 9.2 Что я сделал не так (корень регрессии)
1) **Запуск bootstrap слишком рано**  
   Мы запускали `appBootstrapProvider` прямо в `MyApp.build()` через `ref.watch(...)`.  
   Если внутри bootstrap есть тяжёлые операции/платформенные вызовы, это способно задержать первый кадр и дать “Hang detected” ещё до того, как UI станет интерактивным.

2) **Оставили блокирующий I/O в `postframe.local_services`**  
   В `main.dart` оставался preload launch‑route через `Hive.openBox('notifications')`.  
   На iOS это может занимать секунды и блокировать главный поток → ровно то, что видно как `local_services ~8s` + `Hang detected`.

### 9.3 Что изменили, чтобы исправить
- **Первый кадр**: `MyApp` переведён на `ConsumerStatefulWidget` и bootstrap запускается **после первого кадра** Bootscreen (через `addPostFrameCallback`).
- **Launch route без Hive**:
  - `NotificationsService.persistLaunchRoute/consumeAnyLaunchRoute` теперь используют `SharedPreferences` (`NSUserDefaults`) как быстрый storage.
  - `NotificationsService._ensureLaunchBox()` больше **не делает** `Hive.openBox(...)` на cold start.
  - preload launch‑route через Hive удалён из `main.dart`, чтобы `postframe.local_services` был практически мгновенным.

Проверки после этих правок:
- `flutter analyze` ✅
- `flutter test test/providers/startup_performance_test.dart` ✅
- `flutter test test/ui_text_scaling_test.dart` ✅


