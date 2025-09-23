# Настройка уведомлений (iOS/Android/Firebase/Xcode)

## Android
- Разрешение для Android 13+: в `android/app/src/main/AndroidManifest.xml` добавить:
```
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```
- Иконка уведомлений: монохромная small‑icon `ic_stat_tower` (res/drawable*), указана в коде канала.
- Ресивер после перезагрузки (опционально): `RECEIVE_BOOT_COMPLETED` и `BootReceiver`.
- Тест: первый запуск → запрос разрешений; проверка прихода еженедельных уведомлений.

## iOS
- Capabilities: Push Notifications, Background Modes (Remote notifications для FCM).
- Разрешения запрашиваются через `DarwinInitializationSettings` (alert/badge/sound=true).
- APNs: при включении FCM добавить APNs Auth Key в Firebase Console, привязать к Bundle ID.

## Firebase (для этапа 47.8)
- Создать проект, приложения iOS/Android.
- Скачать `google-services.json` (Android) и `GoogleService-Info.plist` (iOS), поместить в платформенные каталоги.
- Проверить получение пушей в фоне/убитом состоянии.
- Файлы ключей НЕ коммитить. Убедиться, что в `.gitignore` присутствуют:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
  - `**/google-services.json`, `**/GoogleService-Info.plist`

### Android (Firebase + Gradle)
- В `android/build.gradle` (root) добавить classpath Google Services:
```
buildscript { dependencies { classpath 'com.google.gms:google-services:4.4.2' } }
```
- В `android/app/build.gradle` (app) подключить плагин:
```
apply plugin: 'com.google.gms.google-services'
```
- Скопировать `google-services.json` в `android/app/`.

### iOS (Firebase + APNs)
- Скопировать `GoogleService-Info.plist` в `ios/Runner/`.
- В Xcode включить Capabilities: Push Notifications, Background Modes (Remote notifications).
- В Firebase Console → iOS app: загрузить APNs Auth Key (p8) для Bundle ID и связать со средами (sandbox/prod).

### Flutter зависимости и инициализация
- Добавить пакеты:
```
firebase_core: ^3.5.0
firebase_messaging: ^15.1.4
```
- Инициализация в `main.dart` до runApp:
```
await Firebase.initializeApp();
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
```
- iOS запрос разрешений:
```
await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
```

### Обработчики и deeplink
- Foreground: `FirebaseMessaging.onMessage.listen(...)` — показать баннер/локальное уведомление.
- Background/killed tap: `FirebaseMessaging.onMessageOpenedApp.listen(...)` — парсить `data['route']` → переход через глобальный роутер.
- Cold start: `getInitialMessage()` и отложенная навигация после инициализации роутера.

### Хранение и ротация токена
- Получение токена: `await FirebaseMessaging.instance.getToken()`.
- Подписка на обновление: `FirebaseMessaging.instance.onTokenRefresh.listen(...)`.
- На логине — регистрировать токен в Supabase; на логауте — удалять.

### Supabase: таблица токенов и RLS (через supabase-mcp)
- Создать таблицу `push_tokens(user_id uuid, token text, platform text, created_at timestamptz, updated_at timestamptz)`.
- Уникальный индекс `(user_id, token)` и RLS: owner‑only (политики на select/insert/delete/update).

### Edge Function `push-dispatch`
- Принимает список `user_ids`/сегмент и `payload`.
- Тянет токены из `push_tokens` и отправляет FCM (HTTP v1). Секреты (service account JSON) хранить в Supabase secrets.
- Для Android указывать `android.notification.channel_id` из заранее созданных каналов.

## GoRouter / Deeplink
- Обработчик тапа `onDidReceiveNotificationResponse` декодирует `payload` JSON `{ route: "/goal" }` и выполняет переход через глобальный роутер.
- Для cold start — читать `getNotificationAppLaunchDetails()` и выполнить отложенную навигацию после инициализации роутера.

## Топ‑левел обработчики (Android)
- Для FCM фоновые обработчики должны быть top‑level (вне классов). Пример:
```
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // handle background message
}
```

## Пошагово (чек‑лист запуска FCM)
1) Поместить ключи локально: `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist` (не коммитить).
2) Включить Google Services в Gradle (root/app) и собрать Android.
3) В Xcode включить Push Notifications и Background Modes, связать APNs Key с Firebase.
4) Добавить `firebase_core`, `firebase_messaging`; инициализировать в `main.dart` и подключить background handler.
5) Реализовать обработчики onMessage/onMessageOpenedApp/getInitialMessage: переход по `data.route`.
6) Создать таблицу `push_tokens` и RLS в Supabase; реализовать регистрацию/удаление токена на клиенте.
7) Развернуть Edge Function `push-dispatch`, добавить секреты FCM (service account) в Supabase.
8) Отправить тестовый пуш на свой токен, проверить foreground/background/terminated + deeplink.

## Внешние сервисы: что сделать пошагово

### Firebase Console
- Создать проект и приложения iOS/Android (если ещё не созданы).
- Скачать `google-services.json` (Android) и `GoogleService-Info.plist` (iOS).
- В разделе Project Settings → Cloud Messaging:
  - Для HTTP v1 нажать Manage service accounts → создать ключ сервисного аккаунта (JSON). Этот файл НЕ хранить в репозитории.
  - Включить APNs для iOS: загрузить APNs Auth Key (p8), привязать к Bundle ID `kz.bizlevel.bizlevelapp`, проверить sandbox/prod.

### Apple Developer
- Certificates, Identifiers & Profiles:
  - Убедиться, что для Bundle ID `kz.bizlevel.bizlevelapp` включены Push Notifications.
  - Сгенерировать APNs Auth Key (p8), сохранить безопасно.
  - Обновить Provisioning Profiles при необходимости и скачать их в Xcode.

### Supabase
- Применить миграцию `push_tokens` (уже выполнено в этом проекте).
- Задеплоить Edge Function `push-dispatch`:
  - В Supabase Secrets добавить:
    - `FCM_SERVICE_ACCOUNT_JSON` — содержимое JSON сервисного аккаунта Firebase (HTTP v1).
    - `SUPABASE_SERVICE_ROLE_KEY` — Service Role ключ проекта.
  - Перезапустить функцию после добавления секретов.
- Проверить RLS других таблиц по советам Advisor при необходимости.

### Проверка end‑to‑end
- Запустить приложение на устройстве, принять разрешения.
- Проверить наличие токена в таблице `public.push_tokens` (для текущего `user_id`).
- Вызвать Edge Function `push-dispatch` с `user_ids: ["<user_uuid>"]` и `data: { route: "/tower" }`.
- Убедиться, что пуш приходит в фоне/убитом состоянии, и тап ведёт по маршруту.

## Чек‑лист отладки
- Разрешения: POST_NOTIFICATIONS (Android 13+), iOS alert/badge/sound.
- Каналы Android: `goal_reminder`, `education`, `gp_economy`, `chat_messages`, `goal_critical` видны в настройках.
- Таймзоны: IANA (`flutter_native_timezone`), без смещений во времени.
- Deeplink: тап по уведомлению ведёт на нужный экран (в т.ч. из закрытого состояния).
- Payload: не содержит PII/JWT; только безопасные маршруты/метаданные.

