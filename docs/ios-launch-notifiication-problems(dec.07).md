# План исправления iOS-сборки и уведомлений

**Дата:** 2025-12-07  
**Контекст:** После отката к ветке main билд собирается, но приложение зависает с чёрным экраном.

---

## Этап 1: Исправление критической ошибки билда

### Шаг 1.1: Удалить сломанный патч SentryInstallation из Podfile
**Статус:** ✅ Выполнено

**Проблема:**  
Патч `patch_sentry_installation` в `ios/Podfile` удаляет объявление переменной `fileManager`, но не заменяет её использование, что приводит к ошибке компиляции:
```
SentryInstallation.m:85:19: error: unknown receiver 'fileManager'
```

**Отчёт (2025-12-07):**  
- Закомментировал вызов `patch_sentry_installation` в `post_install` секции Podfile (строка 491)
- Функция `patch_sentry_installation` осталась в файле, но не вызывается
- Причина проблемы: паттерн поиска в патче использовал фиксированные отступы, которые не совпадали с реальным файлом

---

### Шаг 1.2: Полная пересборка Pods
**Статус:** ✅ Выполнено пользователем

**Отчёт (2025-12-07):**  
- Выполнены команды `flutter clean`, `rm -rf ios/Pods ios/Podfile.lock`, `flutter pub get`, `pod install`
- Pods пересобраны успешно

---

### Шаг 1.3: Проверка сборки в Xcode
**Статус:** ✅ Билд успешен, но проблема запуска!

**Отчёт (2025-12-07):**  
- Билд собрался успешно (см. `docs/draft-3.md`)
- Warning'и: `sign_in_with_apple` switch exhaustive (не критично)
- **КРИТИЧЕСКАЯ ПРОБЛЕМА:** Приложение запускается, но зависает с чёрным экраном

---

## Этап 1.5: КРИТИЧНО — Исправление чёрного экрана при запуске

### Анализ логов (draft-2.md, draft-4.md)

**Корневая причина:**  
Файл `ios/Runner/FirebaseEarlyInit.m` использует `+load` и `__attribute__((constructor))` для инициализации Firebase **до запуска Flutter**:

```
12:21:02.450628 Runner FirebaseEarlyInit: +load invoked before constructors
12:21:02.535815 Runner FirebaseEarlyInit(load): FIRApp configure() executed on Objective-C layer
```

Это приводит к множественным I/O операциям на main thread:
```
fault: Performing I/O on the main thread can cause hangs.
       antipattern trigger: -[NSData initWithContentsOfFile:options:error:]
fault: Performing I/O on the main thread can cause slow launches.
       antipattern trigger: -[NSBundle bundlePath]
fault: antipattern trigger: dlopen
```

**Хронология проблемного запуска:**
1. dyld загружает Runner → вызывается `+load` в `FirebaseEarlyInit.m`
2. `[FIRApp configure]` выполняется (I/O: GoogleService-Info.plist, NSBundle)
3. `constructor(0)` и `constructor` — Firebase уже настроен
4. `willFinishLaunchingWithOptions` — Firebase уже настроен
5. Main thread заблокирован I/O, Flutter не может отрисовать первый кадр
6. **Чёрный экран**

---

### Шаг 1.5.1: Отключить ранний bootstrap Firebase
**Статус:** ✅ Выполнено (итерация 4 — ФИНАЛЬНАЯ)

**Решение:**  
Убрать ВСЕ синхронные вызовы Firebase на нативной стороне. Firebase будет инициализирован **асинхронно** из Flutter после первого кадра.

**Хронология итераций:**

| Итерация | Найдено | Файл | Статус |
|----------|---------|------|--------|
| 1 | `+load`, `constructor` | `FirebaseEarlyInit.m` | ✅ ОТКЛЮЧЕНО |
| 2 | `[AppDelegate configureFirebaseBeforeMain]` | `main.m:6` | ✅ ОТКЛЮЧЕНО |
| 3 | `configureFirebaseBeforeMain()` | `AppDelegate.willFinishLaunchingWithOptions` | ✅ ОТКЛЮЧЕНО |
| 4 | **`configureFirebaseBeforeMain()`** | **`AppDelegate.didFinishLaunchingWithOptions:124`** | ✅ ОТКЛЮЧЕНО |

**Ключевое открытие (итерация 4):**
Stack trace из логов показал:
```
13  Runner.debug.dylib  $s6Runner11AppDelegateC27configureFirebaseBeforeMainyyFZ + 244
14  Runner.debug.dylib  $s6Runner11AppDelegateC11application_29didFinishLaunchingWithOptionsSbSo13UIApplicationC_SDySo0j6LaunchI3KeyaypGSgtF + 80
```
`configureFirebaseBeforeMain()` всё ещё вызывался из `didFinishLaunchingWithOptions` (строка 124)!

Таймлайн из draft-4.md показал **51+ секунд** между `didFinishLaunching` и `SceneDelegate`:
- 12:45:42 — Firebase I/O (didFinishLaunching)
- 12:46:33 — SceneDelegate scene creation  
- 12:47:15 — Flutter plugins

**Что теперь полностью отключено:**
- ❌ `main.m` → ОТКЛЮЧЕНО
- ❌ `FirebaseEarlyInit.m` → ОТКЛЮЧЕНО  
- ❌ `willFinishLaunchingWithOptions` → ОТКЛЮЧЕНО
- ❌ **`didFinishLaunchingWithOptions`** → ОТКЛЮЧЕНО (финальное исправление!)

**Новый порядок инициализации:**
1. `main()` → `UIApplicationMain` (без Firebase)
2. `willFinishLaunchingWithOptions` → return super (без Firebase)
3. `didFinishLaunchingWithOptions` → только `UNUserNotificationCenter.delegate` (без Firebase)
4. `SceneDelegate.scene(_:willConnectTo:)` → создаёт FlutterViewController
5. Flutter engine starts
6. **Первый кадр отрисовывается!**
7. `_schedulePostFrameBootstraps()` → `Firebase.initializeApp()` **асинхронно**

**Почему это безопасно:**
Flutter код в `lib/main.dart:260-270` уже обрабатывает отложенную инициализацию:
```dart
Future<void> _ensureFirebaseInitialized(String caller) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}
```

**Следующий шаг:** Пересборка и тест на устройстве

---

### Шаг 1.5.2: Пересборка и тест
**Статус:** ⏳ Требуется ваше действие

**Действие:**  
1. В Xcode: Product → Clean Build Folder (Cmd+Shift+K)
2. Собрать проект (Cmd+B)
3. Запустить на устройстве (Cmd+R)
4. Проверить:
   - Приложение запускается без чёрного экрана?
   - Время запуска нормальное?
   - В логах консоли НЕТ `FirebaseEarlyInit(load): FIRApp configure()`?

**Ожидаемый результат в логах:**
- Нет строки `FirebaseEarlyInit(load): FIRApp configure() executed on Objective-C layer`
- Нет или меньше `fault: Performing I/O on the main thread can cause hangs`

**Отчёт:** _ожидаем выполнения пользователем_

---

## Этап 2: Исправление warning'ов компиляции

### Шаг 2.1: Исправить sign_in_with_apple switch exhaustive warning
**Статус:** ⏸️ Ожидает (низкий приоритет)

**Проблема:**  
На iOS 18 добавлены новые case в `ASAuthorizationError.Code`:
- `.credentialImport`
- `.credentialExport`
- `.preferSignInWithApple`
- `.deviceNotConfiguredForPasskeyCreation`

**Действие:**  
Добавить патч для `sign_in_with_apple` с `@unknown default` case в switch.

**Отчёт:** _будет заполнен после выполнения_

---

## Этап 3: Стабилизация уведомлений

### Шаг 3.1: Проверить конфигурацию Firebase/FCM в Info.plist
**Статус:** ⏸️ Ожидает

**Проблема:**  
Конфликтующие флаги: `EnableIosFcm=true`, но `FirebaseMessagingAutoInitEnabled=false` и `GULAppDelegateSwizzlerEnabled=false`.

**Действие:**  
Привести флаги в согласованное состояние после решения проблемы чёрного экрана.

**Отчёт:** _будет заполнен после выполнения_

---

### Шаг 3.2: Упростить цепочку Firebase bootstrap
**Статус:** ⏸️ Ожидает

**Проблема:**  
Множественные точки инициализации Firebase (`+load`, `constructor(0)`, `willFinishLaunching`, `didFinishLaunching`) создают сложность и риски.

**Действие:**  
Оставить одну надёжную точку инициализации — `didFinishLaunching` в AppDelegate.

**Отчёт:** _будет заполнен после выполнения_

---

## Этап 4: Тестирование

### Шаг 4.1: Smoke-тест на устройстве
**Статус:** ⏸️ Ожидает

**Действие:**  
- Запуск приложения (холодный старт) — проверка времени загрузки
- Проверка экрана уведомлений — нет зависания
- Проверка push-уведомлений (если FCM работает)

**Отчёт:** _будет заполнен после выполнения_

---

## Риски и заметки

- После каждого изменения в Podfile требуется полная пересборка Pods
- Патчи плагинов хрупкие — изменения в upstream могут их сломать
- Не трогаем Web-версию в этом плане
- **Главная проблема сейчас — `FirebaseEarlyInit.m` блокирует main thread**

---

## Логи и история изменений

### 2025-12-07 12:30
- Шаг 1.1: Закомментирован вызов `patch_sentry_installation` в Podfile
- Шаг 1.2: Пользователь выполнил пересборку Pods
- Шаг 1.3: Билд успешен, но чёрный экран при запуске
- **Анализ:** Проблема в `FirebaseEarlyInit.m` — ранний bootstrap блокирует main thread

### 2025-12-07 13:00
- Шаг 1.5.1 (итерация 1): Отключен код в `FirebaseEarlyInit.m`
- НО проблема осталась — логи показали вызов из `main.m`

### 2025-12-07 13:15
- Шаг 1.5.1 (итерация 2): Найден и отключен вызов в `ios/Runner/main.m`
- НО проблема осталась — логи показали вызов из `willFinishLaunchingWithOptions`

### 2025-12-07 13:30
- Шаг 1.5.1 (итерация 3): Отключен вызов в `AppDelegate.willFinishLaunchingWithOptions`
- Проблема осталась!

### 2025-12-07 14:00
- **Глубокий анализ draft-4.md** — обнаружена 51+ секунд задержка между App launch и Flutter UI
- **Ключевое открытие:** Stack trace указывал на `didFinishLaunchingWithOptions` (строка 124), а не `willFinishLaunchingWithOptions`!
- Символы: `$s6Runner11AppDelegateC11application_29didFinishLaunchingWithOptionsSbSo...`
- Шаг 1.5.1 (итерация 4): **Отключен вызов в `AppDelegate.didFinishLaunchingWithOptions:124`**
- Теперь Firebase инициализируется ТОЛЬКО из Flutter (`Firebase.initializeApp()`) после первого кадра
- **ПРОБЛЕМА:** Это сломало регистрацию плагинов! (см. следующую запись)

### 2025-12-07 15:00 — КРИТИЧЕСКОЕ ОТКРЫТИЕ
**Глубокий анализ нового draft-4.md выявил 5 проблем:**

1. **Firebase не инициализирован, но плагины его требуют:**
   - `GeneratedPluginRegistrant` регистрирует `FLTFirebaseCorePlugin` и `FLTFirebaseMessagingPlugin`
   - Эти плагины читают `GoogleService-Info.plist` и вызывают `[FIRApp defaultApp]`
   - Без `[FIRApp configure]` получаем ошибку `[I-COR000005] No app has been configured yet`

2. **86+ секунд задержки до Flutter VM:**
   - 12:55:07 — App launch
   - 12:56:33 — Flutter VM ready (+86 сек!)
   - Причина: ошибки Firebase вызывают retry/timeout в плагинах

3. **Сравнение draft-2.md vs draft-4.md:**
   - draft-2.md (успех): "Firebase configured before UIApplicationMain" → всё работает
   - draft-4.md (провал): "[I-COR000005] No app has been configured" → зависание

4. **Порядок инициализации нарушен:**
   - Плагины регистрируются ДО Firebase → ошибка
   - Нужно: Firebase → Engine → Плагины

**РЕШЕНИЕ (Шаг 1.5.2):**
- Вернули `configureFirebaseBeforeMain()` в `didFinishLaunchingWithOptions`
- Оптимизировали функцию:
  - `didConfigureFirebase = true` устанавливается сразу (защита от повторного входа)
  - `FirebaseConfiguration.shared.setLoggerLevel(.min)` в начале (меньше логов)
  - `configureAppCheck()` вызывается через `DispatchQueue.main.async` (не блокирует)
- Теперь порядок: Firebase → Engine → Плагины (правильно!)

**Почему это работает:**
- Проблема была в `willFinishLaunching` и `main.m` — там инициализация блокировала UI **до** `UIApplicationMain`
- В `didFinishLaunching` — `UIApplicationMain` **уже запущен**, UI loop работает
- Firebase init здесь безопасен, т.к. он не блокирует первый кадр

**Результат:** Проблема не решена — белый экран!

### 2025-12-07 15:30 — iOS 13+ Scene Lifecycle!

**Новый анализ логов draft-4.md:**

| Время | Событие |
|-------|---------|
| 13:04:22 | App launch |
| **13:04:32** | ❌ `[I-COR000003] Firebase not configured` — плагины требуют Firebase |
| **13:04:57** | ✅ `Firebase configured` — но уже ПОЗДНО! (25 сек после ошибки) |

**Ключевое открытие: iOS 13+ Scene Lifecycle!**

В iOS 13+ порядок вызовов:
```
1. willFinishLaunchingWithOptions  ← Firebase был ОТКЛЮЧЁН здесь
2. SceneDelegate.scene(_:willConnectTo:) ← Создаёт FlutterController → плагины → ОШИБКА!
3. didFinishLaunchingWithOptions ← Firebase конфигурировался ЗДЕСЬ, но это ПОСЛЕ SceneDelegate!
```

**Проблема:** SceneDelegate вызывается **ДО** `didFinishLaunchingWithOptions`!

**Решение (Шаг 1.5.3):**
- Вернули `configureFirebaseBeforeMain()` в `willFinishLaunchingWithOptions`
- Это единственное место, которое гарантированно вызывается ДО SceneDelegate
- Оптимизации делают это быстрым: min logging, async App Check

**Почему раньше это блокировало:**
- В старой версии `configureFirebaseBeforeMain()` делал много синхронных операций
- Теперь функция оптимизирована:
  - `didConfigureFirebase = true` сразу (защита от повторного входа)
  - `FirebaseConfiguration.shared.setLoggerLevel(.min)` (меньше логов)
  - `configureAppCheck()` через `DispatchQueue.main.async` (не блокирует)

**Результат:** Проблема не решена — зависание на белом/чёрном экране 5+ минут!

### 2025-12-07 16:30 — КРИТИЧЕСКАЯ ПРОБЛЕМА В FLUTTER!

**Глубокий анализ логов draft-4.md и draft-2.md:**

| Время | Событие |
|-------|---------|
| 13:20:02 | App launch |
| 13:20:58 | FlutterView создан |
| 13:21:27 | `flutter: Firebase bootstrap deferred` |
| **13:22:00** | **`Supabase init completed`** — **ПОСЛЕДНЕЕ Flutter-сообщение!** |
| 13:23:58+ | Background tasks... **Flutter молчит 5+ минут!** |

**Что работает:**
- Native iOS bootstrap ✅
- Firebase configured ✅
- FlutterView создан ✅
- Supabase initialized ✅

**Что НЕ работает:**
- После `Supabase init completed` Flutter **перестаёт выводить сообщения**
- UI **не рендерится** (белый/чёрный экран)
- GoRouter **не инициализируется**

---

## 🎯 КОРНЕВАЯ ПРИЧИНА НАЙДЕНА!

**Файл: `lib/providers/auth_provider.dart:43`**

```dart
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final auth = await ref.watch(authStateProvider.future);  // ← БЕСКОНЕЧНОЕ ОЖИДАНИЕ!
  ...
});
```

**Проблема:**
- `authStateProvider` — это `StreamProvider<AuthState>`
- Вызов `.future` ждёт **первого события** от потока `onAuthStateChange`
- Если Supabase **не выдаёт событие** (сеть недоступна, сессия не кэширована), 
  `currentUserProvider` **навсегда в loading**!

**Цепочка зависаний:**
```
currentUserProvider.future → ждёт authStateProvider.future → ждёт onAuthStateChange
    ↓
goRouterProvider → ref.watch(currentUserProvider) → LOADING...
    ↓
UI не рендерится → белый/чёрный экран навсегда!
```

**Решение (Шаг 1.6):**

Изменён `lib/providers/auth_provider.dart`:

```dart
// БЫЛО (БЛОКИРУЮЩЕЕ):
final auth = await ref.watch(authStateProvider.future);  // Ждёт первого события!
final supabaseUser = auth.session?.user;

// СТАЛО (НЕ БЛОКИРУЮЩЕЕ):
ref.watch(authStateProvider);  // Подписка на обновления, но без ожидания
final client = ref.read(supabaseClientProvider);
final session = client.auth.currentSession;  // Синхронно из кэша Supabase
final supabaseUser = session?.user;
```

**Почему это работает:**
- `currentSession` читается **синхронно** из локального кэша Supabase SDK
- Не нужно ждать сетевого ответа
- `ref.watch(authStateProvider)` — подписка на **будущие** изменения,
  но не блокирует текущее выполнение

**Результат:** `currentUserProvider` теперь работает!

Логи показывают:
```
flutter: currentUserProvider: session = false, user = null
```

**НО:** После этого Flutter молчит 73+ секунд. Проблема продолжается...

---

### 2025-12-07 17:00 — ВТОРАЯ БЛОКИРОВКА: Sentry init!

**Анализ таймлайна:**
| Время | Событие | Задержка |
|-------|---------|----------|
| 13:33:04 | Supabase init completed | 0 |
| **13:34:17** | currentUserProvider | **+73 сек!** |

**Между ними только одна операция:** `_initializeSentry(dsn)`

Sentry SDK блокирует main thread на сетевых операциях (timeout 60 секунд).

**Решение (Шаг 1.8):**

Перенёс Sentry init в `_schedulePostFrameBootstraps()` — **после** первого кадра UI:

```dart
// БЫЛО (БЛОКИРУЮЩЕЕ):
final dsn = envOrDefine('SENTRY_DSN');
if (dsn.isNotEmpty) {
  await _prewarmSentryCache(dsn);
  await _initializeSentry(dsn);  // ← Блокирует на 73+ сек!
}
runApp(rootApp);

// СТАЛО (НЕ БЛОКИРУЮЩЕЕ):
runApp(rootApp);  // ← UI сразу!
_schedulePostFrameBootstraps();  // ← Sentry после первого кадра
```

**Ожидаем:** финальный тест на устройстве (Шаг 1.9)

---

### 2025-12-07 18:00 — ФИНАЛЬНЫЕ ИСПРАВЛЕНИЯ

**Найдено и исправлено ещё 2 проблемы:**

1. **`currentUserProvider`** — `ref.watch(authStateProvider)` тоже блокирует FutureProvider!
   - Исправлено: полностью убрали зависимость от StreamProvider

2. **`gpBalanceProvider`** — та же проблема с `ref.watch(authStateProvider)`
   - Исправлено: убрали блокирующую подписку

**Созданы тесты производительности (`test/providers/startup_performance_test.dart`):**

```
✅ currentUserProvider completed in 13ms
✅ gpBalanceProvider completed in 0ms  
✅ authStateProvider watched in 3ms
✅ supabaseClientProvider read in 0ms
✅ currentUserProvider chain is non-blocking
✅ Concurrent reads completed in 0ms
```

**ВСЕ 13 ТЕСТОВ ПРОХОДЯТ!**

---

### ВАЖНОЕ ОТКРЫТИЕ: Debug vs Release

**Анализ логов устройства показал:**

| Событие | Время | Разница |
|---------|-------|---------|
| Firebase native config | `13:48:37` | 0 сек |
| Dart VM loaded | `13:48:50` | **+13 сек** |
| Flutter main() | `13:51:03` | **+2 мин 26 сек** |

**Причина медленного запуска — DEBUG BUILD!**

- Debug: JIT компиляция, отладочные символы, медленный старт
- Release: AOT компиляция, оптимизированный код, быстрый старт

**Ошибка `[FirebaseCore][I-COR000003]` — нормальная в Debug:**
- Firebase конфигурируется в native (мгновенно)
- Dart VM загружается 13+ секунд (Debug overhead)
- Плагины пытаются использовать Firebase до Dart init — ошибка

**В Release сборке этой проблемы не будет!**

---

### Рекомендация: Проверить Release сборку

В Xcode:
1. **Product → Scheme → Edit Scheme**
2. **Run → Build Configuration → Release**
3. **Run** (`Cmd+R`)

Или через Flutter:
```bash
flutter run --release
```

---

### 2025-12-07 19:30 — КРИТИЧЕСКИЕ ИСПРАВЛЕНИЯ (Release всё ещё зависает)

**Анализ логов Release сборки показал:**

| Время | Событие | Задержка |
|-------|---------|----------|
| `13:59:30.646` | iOS старт | 0 сек |
| `13:59:52.320` | I/O warnings | **+22 сек!** |
| `14:00:06.412` | BizPluginRegistrant | **+36 сек!** |

**Найдены ещё 2 критические блокировки:**

#### 1. Блокирующие операции в `main()` ДО `runApp()`

**БЫЛО:**
```dart
await SupabaseService.initialize();  // ← OK (быстрый)
await _ensureHiveInitialized();      // ← Disk I/O — БЛОКИРУЕТ!
await _preloadNotificationsLaunchData(); // ← Disk I/O — БЛОКИРУЕТ!
runApp(rootApp);  // ← UI заблокирован на 36+ секунд!
```

**СТАЛО:**
```dart
await SupabaseService.initialize();  // ← Только это ждём
// Hive и notifications — в post-frame
runApp(rootApp);  // ← UI сразу!
_schedulePostFrameBootstraps();  // ← Тяжёлые операции здесь
```

#### 2. `ref.watch(authStateProvider)` в `goRouterProvider`

**БЫЛО:**
```dart
final goRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);  // ← StreamProvider БЛОКИРУЕТ!
  ...
});
```

**СТАЛО:**
```dart
final goRouterProvider = Provider<GoRouter>((ref) {
  final currentUserAsync = ref.watch(currentUserProvider);  // ← OK
  final session = Supabase.instance.client.auth.currentSession;  // ← Синхронно!
  ...
});
```

**Созданы новые тесты (`test/routing/app_router_test.dart`):**

```
✅ goRouterProvider created in 27ms
✅ Router has 3 top-level routes configured
✅ goRouterProvider reads are consistently fast
```

**ВСЕ 16 ТЕСТОВ ПРОХОДЯТ!**

---

### Итоговый список исправлений (2025-12-07):

| # | Файл | Проблема | Статус |
|---|------|----------|--------|
| 1 | `auth_provider.dart` | `await authStateProvider.future` | ✅ |
| 2 | `auth_provider.dart` | `ref.watch(authStateProvider)` | ✅ |
| 3 | `gp_providers.dart` | `await authStateProvider.future` | ✅ |
| 4 | `gp_providers.dart` | `ref.watch(authStateProvider)` | ✅ |
| 5 | `main.dart` | Sentry init блокирует runApp() | ✅ |
| 6 | `main.dart` | Hive init блокирует runApp() | ✅ |
| 7 | `main.dart` | preloadNotifications блокирует | ✅ |
| 8 | `app_router.dart` | `ref.watch(authStateProvider)` | ✅ |

---

### 2025-12-07 20:30 — КРИТИЧЕСКАЯ ОШИБКА: HiveError

**Анализ логов выявил:**

```
HiveError: You need to initialize Hive or provide a path to store the box.
```

**Причина:**
`MyApp.build()` вызывает `NotificationsService.consumeAnyLaunchRoute()`, 
который требует инициализированный Hive. Но мы убрали `await _ensureHiveInitialized()` 
из `main()` — **race condition!**

**Исправление:**
Вернул `await _ensureHiveInitialized()` в `main()` — это **быстрая операция** 
(только `Hive.initFlutter()` — установка пути). Медленное открытие боксов 
осталось в `post-frame`.

| # | Файл | Проблема | Статус |
|---|------|----------|--------|
| 9 | `main.dart` | HiveError — race condition | ✅ |

---

### 2025-12-07 21:00 — КРИТИЧЕСКАЯ ОШИБКА: HiveError сохраняется

**Анализ логов выявил:**
- `HiveError: You need to initialize Hive` — ошибка повторяется многократно
- Hive.initFlutter() вызывается, но MyApp.build() вызывает NotificationsService **ДО** завершения init

**Найденные проблемы и исправления:**

| # | Проблема | Решение | Файл |
|---|----------|---------|------|
| 10 | `_ensureHiveInitialized()` не логировал результат | Добавлено логирование + fallback с явным путём | `main.dart` |
| 11 | `NotificationsService._ensureLaunchBox()` падает без Hive | Обёрнуто в try-catch, возвращает null | `notifications_service.dart` |
| 12 | `FutureBuilder` в `MyApp.build()` — анти-паттерн | Убран, launch route обрабатывается в post-frame | `main.dart` |
| 13 | Нет способа навигации из post-frame callback | Добавлен `rootNavigatorKey` в GoRouter | `app_router.dart` |
| 14 | `_handleNotificationLaunchRoute()` не было | Создана функция, вызывается после Hive init | `main.dart` |

**Изменения:**

1. **`main.dart`:**
   - `_ensureHiveInitialized()` — добавлено логирование и fallback с явным путём
   - Убран `FutureBuilder` из `MyApp.build()` — теперь просто рендерит виджет
   - Добавлена `_handleNotificationLaunchRoute()` — вызывается после Hive init

2. **`notifications_service.dart`:**
   - `_ensureLaunchBox()` возвращает `Box?` вместо `Box`
   - Добавлен try-catch, при ошибке возвращает `null`

3. **`app_router.dart`:**
   - Добавлен `rootNavigatorKey` для доступа из post-frame callback

---

## ✅ 2025-12-08 — ПРИЛОЖЕНИЕ РАБОТАЕТ!

**Статус:** Приложение запускается, экран уведомлений работает, логин успешен.

**Логи подтверждают:**
```
flutter: INFO: Firebase bootstrap deferred to post-frame stage
flutter: INFO: Supabase init completed
flutter: INFO: Hive.initFlutter() starting...
flutter: INFO: Hive.initFlutter() completed successfully
[SentryFlutterPlugin] Async native init scheduled in 0.00 s
AppDelegate: Firebase configured (debugProvider=OFF, fcm=YES)
```

---

# 📋 ПОЛНЫЙ ОТЧЁТ: ИСТИННЫЕ ПРИЧИНЫ И РЕШЕНИЯ

## 1. Сломанный патч Sentry в Podfile (БИЛД НЕ СОБИРАЛСЯ)

**Симптомы:** Ошибки компиляции `unknown receiver 'fileManager'` в `SentryInstallation.m`

**Истинная причина:** Ruby-функция `patch_sentry_installation` в `Podfile` генерировала некорректный Objective-C код — использовала `fileManager` без объявления переменной.

**Решение:** Закомментирован вызов `patch_sentry_installation` в `ios/Podfile`.

---

## 2. Firebase init в +load и constructor (ЧЁРНЫЙ ЭКРАН)

**Симптомы:** Приложение зависает на чёрном экране, Xcode показывает `MainThreadIOMonitor` предупреждения.

**Истинная причина:** `ios/Runner/FirebaseEarlyInit.m` инициализировал Firebase в `+load` и `__attribute__((constructor))` — это блокирует main thread **ДО** вызова `UIApplicationMain`.

**Решение:** Закомментированы вызовы `ConfigureFirebaseOnObjCIfNeeded` в `FirebaseEarlyInit.m` и `main.m`.

---

## 3. Firebase init в неправильном месте AppDelegate (БЕЛЫЙ ЭКРАН)

**Симптомы:** После отключения раннего init — белый экран, логи показывают `[FirebaseCore] Firebase not configured`.

**Истинная причина:** iOS 13+ Scene Lifecycle вызывает `SceneDelegate` (который регистрирует Flutter плагины) **ДО** `didFinishLaunchingWithOptions`. Плагины требуют Firebase.

**Решение:** Firebase init перенесён в `willFinishLaunchingWithOptions` (вызывается ДО SceneDelegate). Добавлена оптимизация: `setLoggerLevel(.min)` и `configureAppCheck()` в `DispatchQueue.main.async`.

---

## 4. await authStateProvider.future блокирует навсегда (ЗАВИСАНИЕ 73+ СЕК)

**Симптомы:** После `Supabase init completed` — пауза 73+ секунд, затем `currentUserProvider: session = false`.

**Истинная причина:** `currentUserProvider` использовал `await ref.watch(authStateProvider.future)`. `authStateProvider` — это `StreamProvider`, и `.future` ждёт первое событие от `onAuthStateChange`. Если сеть недоступна или Supabase не отвечает — бесконечное ожидание.

**Решение:** Убран `await ref.watch(authStateProvider.future)`. Вместо этого читаем `client.auth.currentSession` синхронно (кэш SDK).

---

## 5. ref.watch(authStateProvider) в FutureProvider (БЛОКИРОВКА)

**Симптомы:** Тесты зависают, приложение медленно запускается.

**Истинная причина:** `ref.watch(streamProvider)` внутри `FutureProvider` создаёт зависимость, которая может блокировать пока Stream не выдаст первое значение.

**Решение:** В `currentUserProvider`, `gpBalanceProvider` и `goRouterProvider` — убран `ref.watch(authStateProvider)`. Вместо этого читаем `Supabase.instance.client.auth.currentSession` синхронно.

---

## 6. Sentry init блокирует runApp() (ДО 73 СЕК ЗАДЕРЖКА)

**Симптомы:** Долгая пауза между Supabase init и появлением UI.

**Истинная причина:** `_prewarmSentryCache()` и `_initializeSentry()` выполнялись синхронно в `main()` ПЕРЕД `runApp()`. Sentry init включает сетевые запросы с таймаутами.

**Решение:** Sentry init перенесён в `_schedulePostFrameBootstraps()` — выполняется ПОСЛЕ первого кадра UI.

---

## 7. HiveError в MyApp.build() (RACE CONDITION)

**Симптомы:** `HiveError: You need to initialize Hive or provide a path to store the box.`

**Истинная причина:** `MyApp.build()` использовал `FutureBuilder` с `NotificationsService.consumeAnyLaunchRoute()`, который требует инициализированный Hive. Когда `_ensureHiveInitialized()` был перенесён в post-frame — race condition.

**Решение:**
1. `await _ensureHiveInitialized()` возвращён в `main()` ДО `runApp()` (быстрая операция — только `Hive.initFlutter()`)
2. `FutureBuilder` убран из `MyApp.build()` — анти-паттерн
3. Launch route обрабатывается в `_handleNotificationLaunchRoute()` после полной инициализации Hive
4. `NotificationsService._ensureLaunchBox()` теперь возвращает `null` при ошибке

---

## 8. Нет инвалидации currentUserProvider после логина (НЕ ПЕРЕХОДИТ НА HOME)

**Симптомы:** Успешный логин, но приложение остаётся на экране логина.

**Истинная причина:** После удаления `ref.watch(authStateProvider)` провайдер не узнаёт об изменении auth state.

**Решение:** В `LoginController` добавлена явная инвалидация `currentUserProvider` и `goRouterProvider` после успешного логина.

---

# 📊 ИТОГОВАЯ ТАБЛИЦА ИЗМЕНЕНИЙ

| # | Файл | Проблема | Решение |
|---|------|----------|---------|
| 1 | `ios/Podfile` | Сломанный патч Sentry | Закомментирован `patch_sentry_installation` |
| 2 | `ios/Runner/FirebaseEarlyInit.m` | Init в +load/constructor | Закомментированы вызовы |
| 3 | `ios/Runner/main.m` | Init до UIApplicationMain | Закомментирован вызов |
| 4 | `ios/Runner/AppDelegate.swift` | Init в неправильном месте | Перенесён в willFinishLaunching + оптимизация |
| 5 | `lib/providers/auth_provider.dart` | await authStateProvider.future | Синхронное чтение currentSession |
| 6 | `lib/providers/gp_providers.dart` | ref.watch(authStateProvider) | Синхронное чтение currentSession |
| 7 | `lib/routing/app_router.dart` | ref.watch(authStateProvider) | Синхронное чтение currentSession + rootNavigatorKey |
| 8 | `lib/main.dart` | Sentry блокирует runApp | Перенесён в post-frame |
| 9 | `lib/main.dart` | FutureBuilder + HiveError | Убран FutureBuilder, добавлен handler |
| 10 | `lib/services/notifications_service.dart` | Падает без Hive | Возвращает null при ошибке |
| 11 | `lib/providers/login_controller.dart` | Нет инвалидации после логина | Добавлена инвалидация провайдеров |

---

# 🔧 СПИСОК УЛУЧШЕНИЙ (НЕ ЛОМАЯ РАБОТУ)

## Приоритет: ВЫСОКИЙ

1. **MainThreadIOMonitor предупреждения:**
   - Firebase init всё ещё выполняет I/O на main thread
   - Решение: Обернуть `FIRApp.configure()` в `DispatchQueue.global(qos: .userInitiated).async`
   - Риск: Низкий, но требует тестирования порядка плагинов

2. **AggregateDictionary deprecated warning:**
   - Системное предупреждение от Apple SDK
   - Решение: Ждать обновления Flutter/Firebase

## Приоритет: СРЕДНИЙ

3. **sign_in_with_apple switch exhaustive warning:**
   - Lint warning в коде Apple Sign In
   - Решение: Добавить default case в switch

4. **Отменённые сетевые запросы (Error -999 cancelled):**
   - Нормальное поведение при навигации
   - Можно улучшить отмену запросов при unmount виджетов

5. **Optimistic UI для логина:**
   - Сейчас ждём ответ сервера перед переходом
   - Можно показывать home сразу, загружая данные в фоне

## Приоритет: НИЗКИЙ

6. **Кэширование профиля пользователя:**
   - `currentUserProvider` каждый раз делает запрос к БД
   - Можно добавить локальный кэш с TTL

7. **Предзагрузка данных в splash:**
   - Пока показывается splash, можно предзагрузить критичные данные

8. **Sentry performance spans:**
   - Добавить более детальные spans для отслеживания производительности

