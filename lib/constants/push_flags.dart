// Включает пуши на iOS (используем OneSignal). Отключайте через --dart-define ENABLE_IOS_PUSH=false.
const bool kEnableIosPush =
    bool.fromEnvironment('ENABLE_IOS_PUSH', defaultValue: true);

// Исторический флаг для iOS FCM; по умолчанию выключен, оставлен для совместимости.
const bool kEnableIosFcm =
    bool.fromEnvironment('ENABLE_IOS_FCM', defaultValue: false);
