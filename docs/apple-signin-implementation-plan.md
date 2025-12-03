# План добавления "Sign in with Apple" в приложение BizLevel

## Обзор
Добавление возможности входа через Apple ID в Flutter приложение с бэкендом на Supabase. Реализация должна быть аналогична существующему входу через Google.

## Этапы реализации

### 1. Подготовка зависимостей и конфигурации

#### 1.1. Добавление пакета в pubspec.yaml
- Добавить зависимость `sign_in_with_apple: ^6.1.0` (или актуальную версию)
- Выполнить `flutter pub get`

#### 1.2. Настройка iOS (Xcode)

**1.2.1. Добавление Capability в Xcode:**
- Открыть `ios/Runner.xcworkspace` в Xcode
- Выбрать target `Runner`
- Перейти в `Signing & Capabilities`
- Добавить capability `Sign In with Apple`

**1.2.2. Обновление Runner.entitlements:**
- Добавить в `ios/Runner/Runner.entitlements`:
```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

**1.2.3. Проверка Bundle ID:**
- Убедиться, что Bundle ID соответствует настройкам в Apple Developer Portal
- Bundle ID должен быть зарегистрирован для Sign in with Apple

#### 1.3. Настройка Android (опционально, для будущей поддержки)
- Sign in with Apple на Android требует дополнительной настройки через Apple
- Пока можно оставить только iOS реализацию

#### 1.4. Настройка Supabase

**1.4.1. В панели Supabase:**
- Перейти в `Authentication` → `Providers`
- Включить `Apple` provider
- Настроить:
  - `Services ID` (из Apple Developer Portal)
  - `Secret Key` (скачать .p8 файл из Apple Developer Portal)
  - `Team ID` (из Apple Developer Portal)

**1.4.2. Получение ключей из Apple Developer Portal:**
- Зайти на https://developer.apple.com/account
- Перейти в `Certificates, Identifiers & Profiles`
- Создать новый `Services ID` (если еще нет)
- Создать новый `Key` для Sign in with Apple
- Скачать `.p8` файл (доступен только один раз)
- Записать `Key ID`

### 2. Реализация в коде

#### 2.1. Добавление константы для флага
**Файл:** `lib/utils/constant.dart`
- Добавить `const bool kEnableAppleAuth = true;` (по аналогии с `kEnableGoogleAuth`)

#### 2.2. Реализация метода в AuthService
**Файл:** `lib/services/auth_service.dart`

Добавить метод `signInWithApple()`:
```dart
/// Sign in with Apple for iOS.
/// Note: Apple Sign In is only available on iOS 13+.
Future<AuthResponse> signInWithApple() async {
  return _handleAuthCall(() async {
    if (Platform.isIOS) {
      // Проверка доступности (iOS 13+)
      if (!await SignInWithApple.isAvailable()) {
        throw AuthFailure('Sign in with Apple недоступен на этом устройстве');
      }

      // Запрос авторизации
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Получение identity token
      final identityToken = credential.identityToken;
      if (identityToken == null) {
        throw AuthFailure('Не удалось получить токен от Apple');
      }

      // Вход через Supabase
      return await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: identityToken,
        accessToken: credential.authorizationCode,
      );
    } else if (kIsWeb) {
      // Для web используем OAuth редирект
      final redirectTo = envOrDefine('WEB_REDIRECT_ORIGIN');
      await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: redirectTo.isNotEmpty ? redirectTo : null,
      );
      return AuthResponse();
    }
    throw AuthFailure('Sign in with Apple доступен только на iOS и Web');
  }, unknownErrorMessage: 'Неизвестная ошибка входа через Apple');
}
```

**Импорты:**
```dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
```

#### 2.3. Добавление метода в LoginController
**Файл:** `lib/providers/login_controller.dart`

Добавить метод:
```dart
Future<void> signInWithApple() async {
  state = const AsyncLoading();
  try {
    await ref.read(authServiceProvider).signInWithApple();
    state = const AsyncData(null);
  } catch (e, st) {
    state = AsyncError(e, st);
  }
}
```

#### 2.4. Добавление кнопки в UI

**2.4.1. Экран входа (login_screen.dart):**
- Добавить кнопку "Войти через Apple" после кнопки Google
- Использовать иконку Apple (можно использовать `Icons.apple` или SVG)
- Добавить проверку `kEnableAppleAuth` и `Platform.isIOS` (или `kIsWeb`)

**2.4.2. Экран регистрации (register_screen.dart):**
- Добавить аналогичную кнопку "Регистрация через Apple"

**Пример кнопки:**
```dart
if (kEnableAppleAuth && (Platform.isIOS || kIsWeb))
  SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      icon: const Icon(Icons.apple), // или кастомная иконка
      label: const Text('Войти через Apple'),
      onPressed: () {
        ref.read(loginControllerProvider.notifier).signInWithApple();
      },
      style: OutlinedButton.styleFrom(
        padding: AppSpacing.insetsSymmetric(v: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        side: BorderSide(
          color: AppColor.textColor.withValues(alpha: 0.2),
        ),
      ),
    ),
  ),
```

### 3. Обработка данных пользователя

#### 3.1. Обработка имени пользователя
- Apple может не предоставить имя при повторных входах
- Сохранять `fullName` при первом входе
- Обновлять профиль пользователя в таблице `users` при первом входе через Apple

**Дополнение в AuthService.signInWithApple():**
```dart
// После успешного входа
final user = response.user;
if (user != null) {
  // Установка Sentry контекста
  Sentry.configureScope((scope) {
    scope.setUser(SentryUser(id: user.id, email: user.email));
  });
  
  // Обновление профиля, если имя не заполнено
  if (credential.givenName != null || credential.familyName != null) {
    try {
      final fullName = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
      if (fullName.isNotEmpty) {
        await updateProfile(name: fullName);
      }
    } catch (_) {
      // Игнорируем ошибки обновления профиля
    }
  }
  
  // Бонус за первый вход (аналогично signIn)
  // ... код из signIn метода
}
```

### 4. Тестирование

#### 4.1. Тестирование на iOS устройстве
- Протестировать на реальном устройстве (симулятор может не поддерживать)
- Проверить первый вход (с именем)
- Проверить повторный вход (без имени)
- Проверить обработку ошибок (отмена, сеть)

#### 4.2. Тестирование на Web (если реализовано)
- Проверить OAuth редирект
- Проверить возврат в приложение

#### 4.3. Интеграционное тестирование
- Проверить создание пользователя в Supabase
- Проверить связывание аккаунтов (если пользователь уже есть)
- Проверить обновление профиля

### 5. Документация и настройки

#### 5.1. Обновление README
- Добавить инструкции по настройке Apple Sign In
- Указать требования (iOS 13+, настройка в Apple Developer Portal)

#### 5.2. Переменные окружения
- Проверить, нужны ли дополнительные переменные в `.env`
- Возможно, добавить `APPLE_SERVICES_ID` (если используется)

### 6. Дополнительные улучшения (опционально)

#### 6.1. Единый виджет для социальных кнопок
- Создать переиспользуемый виджет `SocialAuthButton`
- Упростить поддержку нескольких провайдеров

#### 6.2. Обработка связывания аккаунтов
- Если пользователь входит через Apple, но уже есть аккаунт с тем же email
- Supabase должен автоматически связать аккаунты (если настроено)

#### 6.3. Поддержка Android
- Apple Sign In на Android требует дополнительной настройки
- Можно отложить на будущее

## Порядок выполнения

1. ✅ Настройка Apple Developer Portal (Services ID, Key)
2. ✅ Настройка Supabase (добавление Apple provider)
3. ✅ Добавление зависимости в pubspec.yaml
4. ✅ Настройка iOS (entitlements, capability в Xcode)
5. ✅ Реализация метода в AuthService
6. ✅ Добавление метода в LoginController
7. ✅ Добавление кнопок в UI (login и register)
8. ✅ Добавление флага kEnableAppleAuth
9. ✅ Тестирование на реальном устройстве
10. ✅ Обработка edge cases (отмена, ошибки)

## Важные замечания

- **iOS 13+**: Sign in with Apple доступен только на iOS 13 и выше
- **Реальное устройство**: Тестирование на симуляторе может не работать
- **Первый вход**: Apple предоставляет имя только при первом входе
- **Privacy**: Apple требует, чтобы приложения, использующие другие социальные входы, также предлагали Sign in with Apple
- **Web**: Для web может потребоваться дополнительная настройка redirect URL в Supabase

## Ссылки на документацию

- [Supabase Apple OAuth](https://supabase.com/docs/guides/auth/social-login/auth-apple)
- [sign_in_with_apple package](https://pub.dev/packages/sign_in_with_apple)
- [Apple Sign In Documentation](https://developer.apple.com/sign-in-with-apple/)

