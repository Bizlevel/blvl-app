// Helper to get env value safely
import 'package:flutter_dotenv/flutter_dotenv.dart';

String envOrDefine(String key, {String defaultValue = ''}) {
  if (dotenv.isInitialized) {
    final v = dotenv.env[key];
    if (v != null && v.isNotEmpty) return v;

    // Fallback: поддерживаем переменные в нижнем регистре (например, sentry_dsn)
    final lowerCaseValue = dotenv.env[key.toLowerCase()];
    if (lowerCaseValue != null && lowerCaseValue.isNotEmpty) {
      return lowerCaseValue;
    }
  }

  switch (key) {
    case 'SUPABASE_URL':
      return const String.fromEnvironment('SUPABASE_URL');
    case 'SUPABASE_ANON_KEY':
      return const String.fromEnvironment('SUPABASE_ANON_KEY');
    case 'GOOGLE_WEB_CLIENT_ID':
      return const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
    case 'IOS_GOOGLE_CLIENT_ID':
      return const String.fromEnvironment('IOS_GOOGLE_CLIENT_ID');
    case 'WEB_REDIRECT_ORIGIN':
      return const String.fromEnvironment('WEB_REDIRECT_ORIGIN');
    case 'SENTRY_DSN':
      return const String.fromEnvironment('SENTRY_DSN');
    case 'SENTRY_ENV':
      return const String.fromEnvironment('SENTRY_ENV');
    case 'SENTRY_ENVIRONMENT':
      return const String.fromEnvironment('SENTRY_ENVIRONMENT');
    case 'SENTRY_ENABLE_SESSIONS':
      return const String.fromEnvironment('SENTRY_ENABLE_SESSIONS');
    case 'SENTRY_RELEASE':
      return const String.fromEnvironment('SENTRY_RELEASE');
    case 'OPENAI_API_KEY':
      return const String.fromEnvironment('OPENAI_API_KEY');
    case 'ONESIGNAL_APP_ID':
      return const String.fromEnvironment('ONESIGNAL_APP_ID');
    default:
      return defaultValue;
  }
}
