# Отчёт: Улучшения и предостережения после startup-blocking fix

**Дата:** 2025-12-08  
**Контекст:** Приложение работает стабильно. Этот документ содержит рекомендации по улучшению и критические предостережения.

---

# 🔧 УЛУЧШЕНИЯ (не ломая работу)

## 1. ВЫСОКИЙ ПРИОРИТЕТ: MainThreadIOMonitor предупреждения от Firebase

### Что не работает оптимально

Логи показывают множественные предупреждения:
```
fault: Performing I/O on the main thread can cause slow launches.
       antipattern trigger: -[NSData initWithContentsOfFile:options:error:]
fault: Performing I/O on the main thread can cause hangs.
       antipattern trigger: -[NSBundle bundlePath]
fault: antipattern trigger: dlopen
```

**Причина:** Firebase SDK читает `GoogleService-Info.plist` и загружает динамические библиотеки синхронно на main thread во время `[FIRApp configure]`.

**Файл:** `ios/Runner/AppDelegate.swift` (функция `configureFirebaseBeforeMain()`)

### Текущая реализация

```swift
// ios/Runner/AppDelegate.swift:80-130
static func configureFirebaseBeforeMain() {
    guard !didConfigureFirebase else { return }
    didConfigureFirebase = true
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    FirebaseApp.configure()  // ← I/O на main thread!
    // ...
}
```

### Предлагаемое решение

**ВНИМАНИЕ:** Это решение РИСКОВАННОЕ. Flutter плагины требуют Firebase ДО регистрации. Тестируйте тщательно!

```swift
static func configureFirebaseBeforeMain() {
    guard !didConfigureFirebase else { return }
    didConfigureFirebase = true
    
    // Вариант 1: Минимизация логов (уже сделано)
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    
    // Вариант 2: Асинхронная инициализация тяжёлых частей
    // ТОЛЬКО для App Check и Analytics, НЕ для core!
    FirebaseApp.configure()  // Core должен быть синхронным
    
    DispatchQueue.global(qos: .userInitiated).async {
        // Тяжёлые операции в фоне
        Analytics.setAnalyticsCollectionEnabled(true)
    }
    
    // App Check уже в async (сделано в текущей версии)
    DispatchQueue.main.async {
        self.configureAppCheck()
    }
}
```

### Альтернативное решение (безопаснее)

Оставить как есть, но добавить в `Info.plist`:
```xml
<key>FirebaseDataCollectionDefaultEnabled</key>
<false/>
```

Это отключит автоматический сбор данных при старте, уменьшив I/O.

### Риски

- Если сделать `FirebaseApp.configure()` асинхронным, плагины могут упасть с `[I-COR000005] No app has been configured`
- iOS 13+ Scene Lifecycle требует Firebase ДО SceneDelegate

### Рекомендация

**НЕ МЕНЯТЬ** без крайней необходимости. Предупреждения не блокируют запуск, приложение работает.

---

## 2. СРЕДНИЙ ПРИОРИТЕТ: sign_in_with_apple switch warning

### Что не работает

Компилятор выдаёт предупреждение:
```
sign_in_with_apple: Switch covers known cases, but 'ASAuthorizationError.Code' may have additional unknown values
```

**Причина:** iOS 18 добавил новые case в `ASAuthorizationError.Code`:
- `.credentialImport`
- `.credentialExport`  
- `.preferSignInWithApple`
- `.deviceNotConfiguredForPasskeyCreation`

**Файл:** Плагин `sign_in_with_apple` (внешняя зависимость)

### Предлагаемое решение

Создать патч в `ios/Podfile`:

```ruby
def patch_sign_in_with_apple(installer)
  installer.pods_project.targets.each do |target|
    next unless target.name == 'sign_in_with_apple'
    target.source_build_phase.files.each do |file|
      next unless file.file_ref.path.end_with?('.swift')
      # Добавить @unknown default в switch
    end
  end
end
```

**ИЛИ** обновить плагин до версии с исправлением (если доступна).

### Риски

- Патчи плагинов хрупкие — обновление плагина может сломать патч
- Warning не критичен, приложение работает

### Рекомендация

Проверить наличие обновления `sign_in_with_apple` в pub.dev. Если нет — игнорировать warning.

---

## 3. СРЕДНИЙ ПРИОРИТЕТ: Отменённые запросы (Error -999 cancelled)

### Что происходит

Логи показывают:
```
Task finished with error [-999] Error Domain=NSURLErrorDomain Code=-999 "cancelled"
```

**Причина:** При навигации между экранами активные HTTP запросы отменяются, но не graceful.

**Файлы:** Все провайдеры и сервисы, делающие сетевые запросы.

### Текущая реализация

```dart
// Типичный провайдер
final someDataProvider = FutureProvider<Data>((ref) async {
  final response = await supabase.from('table').select();
  return Data.fromJson(response);
});
```

### Предлагаемое решение

Использовать `CancelToken` и обрабатывать отмену:

```dart
final someDataProvider = FutureProvider<Data>((ref) async {
  final cancelToken = CancelToken();
  
  // Отменить запрос при dispose провайдера
  ref.onDispose(() => cancelToken.cancel());
  
  try {
    final response = await supabase
        .from('table')
        .select()
        .withConverter((data) => Data.fromJson(data));
    return response;
  } on PostgrestException catch (e) {
    if (e.code == 'PGRST116') {
      // Request was cancelled - это OK
      throw StateError('Request cancelled');
    }
    rethrow;
  }
});
```

### Риски

- Supabase SDK не поддерживает `CancelToken` напрямую
- Требует рефакторинга всех провайдеров

### Рекомендация

Низкий приоритет. Error -999 — нормальное поведение iOS при навигации.

---

## 4. СРЕДНИЙ ПРИОРИТЕТ: Optimistic UI для логина

### Что не оптимально

Текущий flow:
1. Пользователь нажимает "Войти"
2. Ждём ответ от Supabase (1-3 сек)
3. Инвалидируем провайдеры
4. GoRouter редиректит на `/home`

**Пользователь видит loading 1-3 секунды.**

**Файл:** `lib/providers/login_controller.dart`

### Текущая реализация

```dart
Future<void> signIn({required String email, required String password}) async {
  state = const AsyncLoading();
  try {
    await ref.read(authServiceProvider).signIn(email: email, password: password);
    state = const AsyncData(null);
    _invalidateAuthDependentProviders();  // ← Только после успеха
  } catch (e, st) {
    state = AsyncError(e, st);
  }
}
```

### Предлагаемое решение

```dart
Future<void> signIn({required String email, required String password}) async {
  state = const AsyncLoading();
  
  // Optimistic: показываем home сразу
  // GoRouter.of(context).go('/home');  // Требует BuildContext
  
  try {
    await ref.read(authServiceProvider).signIn(email: email, password: password);
    state = const AsyncData(null);
    _invalidateAuthDependentProviders();
  } catch (e, st) {
    state = AsyncError(e, st);
    // Rollback: вернуть на login
    // GoRouter.of(context).go('/login');
  }
}
```

**Проблема:** `LoginController` не имеет доступа к `BuildContext` для навигации.

### Альтернативное решение

Использовать `rootNavigatorKey` (уже добавлен):

```dart
import '../routing/app_router.dart';

Future<void> signIn({...}) async {
  state = const AsyncLoading();
  
  // Optimistic navigation
  final navigator = rootNavigatorKey.currentState;
  if (navigator != null) {
    // Показываем home с loading overlay
  }
  
  try {
    await ref.read(authServiceProvider).signIn(...);
    _invalidateAuthDependentProviders();
  } catch (e, st) {
    // Rollback
  }
}
```

### Риски

- При ошибке сети пользователь увидит home, потом вернётся на login — плохой UX
- Нужно добавить loading overlay на home

### Рекомендация

Средний приоритет. Улучшит UX, но требует дополнительной работы.

---

## 5. НИЗКИЙ ПРИОРИТЕТ: Кэширование профиля пользователя

### Что не оптимально

`currentUserProvider` каждый раз делает запрос к Supabase:

```dart
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  // ...
  final profile = await repository.fetchProfile(supabaseUser.id);  // ← Сеть!
  return profile;
});
```

**Файл:** `lib/providers/auth_provider.dart`

### Предлагаемое решение

Добавить локальный кэш с TTL:

```dart
class UserProfileCache {
  UserModel? _cached;
  DateTime? _cachedAt;
  static const _ttl = Duration(minutes: 5);
  
  bool get isValid => 
    _cached != null && 
    _cachedAt != null && 
    DateTime.now().difference(_cachedAt!) < _ttl;
  
  UserModel? get() => isValid ? _cached : null;
  
  void set(UserModel profile) {
    _cached = profile;
    _cachedAt = DateTime.now();
  }
  
  void invalidate() {
    _cached = null;
    _cachedAt = null;
  }
}

final _profileCache = UserProfileCache();

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final session = Supabase.instance.client.auth.currentSession;
  if (session == null) return null;
  
  // Проверяем кэш
  final cached = _profileCache.get();
  if (cached != null && cached.id == session.user.id) {
    return cached;
  }
  
  // Загружаем из сети
  final profile = await repository.fetchProfile(session.user.id);
  if (profile != null) {
    _profileCache.set(profile);
  }
  return profile;
});
```

### Риски

- Кэш может устареть (профиль изменён на другом устройстве)
- Нужно инвалидировать кэш при обновлении профиля

### Рекомендация

Низкий приоритет. Текущая реализация работает, сетевые запросы не критичны.

---

## 6. НИЗКИЙ ПРИОРИТЕТ: Предзагрузка данных в splash

### Что можно улучшить

Пока показывается splash screen, можно параллельно загружать данные:
- Профиль пользователя
- GP баланс
- Список уровней
- Последний прогресс

**Файл:** `lib/main.dart` (функция `_schedulePostFrameBootstraps()`)

### Предлагаемое решение

```dart
void _schedulePostFrameBootstraps() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Существующая инициализация...
    await _ensureFirebaseInitialized('post_frame_bootstrap');
    await _initializeDeferredLocalServices();
    
    // Предзагрузка данных (параллельно!)
    await Future.wait([
      _preloadUserProfile(),
      _preloadGpBalance(),
      _preloadLevels(),
    ]);
  });
}

Future<void> _preloadUserProfile() async {
  try {
    final container = ProviderContainer();
    await container.read(currentUserProvider.future);
  } catch (_) {}
}
```

### Риски

- Если пользователь не залогинен, загрузка бессмысленна
- Дополнительный расход трафика при старте

### Рекомендация

Низкий приоритет. Реализовать только если splash показывается долго.

---

# ⛔ КРИТИЧЕСКИЕ ПРЕДОСТЕРЕЖЕНИЯ

## Что НЕЛЬЗЯ делать (чтобы не сломать приложение)

### 1. НЕ использовать `await ref.watch(authStateProvider.future)`

**Почему запрещено:**
```dart
// ❌ ОПАСНО! Блокирует навсегда!
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final auth = await ref.watch(authStateProvider.future);  // ← БЛОКИРОВКА!
});
```

`authStateProvider` — это `StreamProvider`. Вызов `.future` ждёт **первого события** от `onAuthStateChange`. Если:
- Сеть недоступна
- Supabase не отвечает
- Нет кэшированной сессии

...то `.future` будет ждать **бесконечно**, блокируя весь UI.

**Правильный способ:**
```dart
// ✅ ПРАВИЛЬНО! Синхронное чтение из кэша
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final session = Supabase.instance.client.auth.currentSession;
  // ...
});
```

---

### 2. НЕ использовать `ref.watch(authStateProvider)` в Provider/FutureProvider

**Почему запрещено:**
```dart
// ❌ ОПАСНО! Может блокировать!
final goRouterProvider = Provider<GoRouter>((ref) {
  ref.watch(authStateProvider);  // ← Блокирует если Stream не эмитит
});
```

`ref.watch()` на `StreamProvider` внутри `Provider` или `FutureProvider` создаёт зависимость, которая может блокировать пока Stream не выдаст значение.

**Правильный способ:**
```dart
// ✅ ПРАВИЛЬНО! Синхронное чтение
final goRouterProvider = Provider<GoRouter>((ref) {
  final session = Supabase.instance.client.auth.currentSession;
  // ...
});
```

---

### 3. НЕ инициализировать Sentry ДО `runApp()`

**Почему запрещено:**
```dart
// ❌ ОПАСНО! Блокирует UI на 60+ секунд!
Future<void> main() async {
  await _initializeSentry(dsn);  // ← Сетевые запросы с таймаутом!
  runApp(rootApp);
}
```

Sentry SDK при инициализации:
1. Делает сетевые запросы
2. Имеет таймаут 60 секунд
3. Блокирует main thread

**Правильный способ:**
```dart
// ✅ ПРАВИЛЬНО! Sentry после первого кадра
Future<void> main() async {
  runApp(rootApp);  // ← UI сразу!
  _schedulePostFrameBootstraps();  // ← Sentry здесь
}

void _schedulePostFrameBootstraps() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await _initializeSentry(dsn);  // ← После UI
  });
}
```

---

### 4. НЕ инициализировать Firebase в `+load` или `constructor`

**Почему запрещено:**
```objc
// ❌ ОПАСНО! Блокирует ДО UIApplicationMain!
// ios/Runner/FirebaseEarlyInit.m
+ (void)load {
    [FIRApp configure];  // ← Блокирует main thread!
}
```

Методы `+load` и `__attribute__((constructor))` выполняются **до** `UIApplicationMain`. Любой I/O здесь блокирует запуск приложения.

**Правильный способ:**
Firebase инициализируется в `willFinishLaunchingWithOptions`:
```swift
// ✅ ПРАВИЛЬНО!
// ios/Runner/AppDelegate.swift
override func application(
    _ application: UIApplication,
    willFinishLaunchingWithOptions: ...
) -> Bool {
    Self.configureFirebaseBeforeMain()  // ← Здесь безопасно
    return super.application(...)
}
```

---

### 5. НЕ использовать `FutureBuilder` в `build()` для критичных операций

**Почему запрещено:**
```dart
// ❌ ОПАСНО! Race condition с инициализацией!
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: NotificationsService.instance.consumeAnyLaunchRoute(),
      builder: (context, snap) => ...,  // ← Hive может быть не готов!
    );
  }
}
```

`FutureBuilder` в `build()` может вызывать операции **до** завершения инициализации в `main()`.

**Правильный способ:**
```dart
// ✅ ПРАВИЛЬНО! Обработка в post-frame
void _schedulePostFrameBootstraps() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await _handleNotificationLaunchRoute();  // ← После инициализации
  });
}
```

---

### 6. НЕ забывать инвалидировать провайдеры после логина

**Почему важно:**
После исправления блокировок, провайдеры больше не подписаны на `authStateProvider`. Это значит, что они **не узнают** об изменении auth state автоматически.

```dart
// ✅ ОБЯЗАТЕЛЬНО после успешного логина!
void _invalidateAuthDependentProviders() {
  ref.invalidate(currentUserProvider);
  ref.invalidate(goRouterProvider);
  debugPrint('LoginController: invalidated auth-dependent providers');
}
```

---

# 📂 ФАЙЛЫ, КОТОРЫЕ БЫЛИ ИЗМЕНЕНЫ

| Файл | Что изменено | Зачем |
|------|--------------|-------|
| `ios/Podfile` | Закомментирован `patch_sentry_installation` | Патч генерировал некорректный код |
| `ios/Runner/FirebaseEarlyInit.m` | Закомментированы вызовы в `+load` и `constructor` | Блокировали main thread |
| `ios/Runner/main.m` | Закомментирован вызов `configureFirebaseBeforeMain` | Дублировал инициализацию |
| `ios/Runner/AppDelegate.swift` | Firebase в `willFinishLaunching` + оптимизации | Правильный порядок для iOS 13+ |
| `lib/providers/auth_provider.dart` | Убран `await authStateProvider.future` | Блокировал навсегда |
| `lib/providers/gp_providers.dart` | Убран `ref.watch(authStateProvider)` | Блокировал UI |
| `lib/routing/app_router.dart` | Убран `ref.watch(authStateProvider)`, добавлен `rootNavigatorKey` | Блокировал GoRouter |
| `lib/main.dart` | Sentry в post-frame, убран FutureBuilder | Блокировал `runApp()` |
| `lib/services/notifications_service.dart` | `_ensureLaunchBox()` возвращает null при ошибке | Защита от HiveError |
| `lib/providers/login_controller.dart` | Добавлена инвалидация провайдеров | Провайдеры не подписаны на auth changes |

---

# 🧪 ТЕСТЫ

Созданы тесты для предотвращения регрессий:

1. **`test/providers/provider_smoke_test.dart`** — smoke-тесты провайдеров
2. **`test/providers/startup_performance_test.dart`** — тесты производительности
3. **`test/routing/app_router_test.dart`** — тесты GoRouter

**Все 16 тестов должны проходить!**

```bash
flutter test test/providers/ test/routing/
```

---

# 📋 ЧЕКЛИСТ ПЕРЕД ИЗМЕНЕНИЯМИ

Перед любыми изменениями в auth/startup коде:

- [ ] Провайдер НЕ использует `await ref.watch(streamProvider.future)`
- [ ] Провайдер НЕ использует `ref.watch(streamProvider)` без необходимости
- [ ] Sentry init НЕ блокирует `runApp()`
- [ ] Firebase init в `willFinishLaunchingWithOptions` (не раньше!)
- [ ] Нет `FutureBuilder` в `build()` для критичных операций
- [ ] После логина вызывается `_invalidateAuthDependentProviders()`
- [ ] Все 16 тестов проходят

