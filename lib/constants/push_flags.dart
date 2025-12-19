// Включает пуши на iOS (используем OneSignal). Отключайте через --dart-define ENABLE_IOS_PUSH=false.
const bool kEnableIosPush =
    bool.fromEnvironment('ENABLE_IOS_PUSH', defaultValue: true);

/// Enables cloud push notifications via OneSignal (Stage 2).
///
/// IMPORTANT:
/// - Default is `false`, because BizLevel currently relies on local reminders (Stage 1).
/// - When `false`, the app must not initialize OneSignal nor write to `public.push_tokens`.
const bool kEnableCloudPush =
    bool.fromEnvironment('ENABLE_CLOUD_PUSH');

// Исторический флаг для iOS FCM; по умолчанию выключен, оставлен для совместимости.
const bool kEnableIosFcm =
    bool.fromEnvironment('ENABLE_IOS_FCM');
