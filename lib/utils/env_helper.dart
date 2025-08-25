/// Helper to get env value safely
import 'package:flutter_dotenv/flutter_dotenv.dart';

String envOrDefine(String key, {String defaultValue = ''}) {
  if (dotenv.isInitialized) {
    final v = dotenv.env[key];
    if (v != null && v.isNotEmpty) return v;

    // Fallback: поддерживаем переменные в нижнем регистре (например, sentry_dsn)
    final lowerCaseValue = dotenv.env[key.toLowerCase()];
    if (lowerCaseValue != null && lowerCaseValue.isNotEmpty)
      return lowerCaseValue;
  }

  switch (key) {
    case 'SUPABASE_URL':
      return const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    case 'SUPABASE_ANON_KEY':
      return const String.fromEnvironment('SUPABASE_ANON_KEY',
          defaultValue: '');
    case 'SENTRY_DSN':
      return const String.fromEnvironment('SENTRY_DSN', defaultValue: '');
    case 'OPENAI_API_KEY':
      return const String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
    default:
      return defaultValue;
  }
}
