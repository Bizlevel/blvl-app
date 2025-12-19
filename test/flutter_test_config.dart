import 'dart:async';
import 'dart:io' show Platform;

import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mocks.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final bool isIntegration =
      Platform.environment['BIZLEVEL_INTEGRATION_TEST'] == '1';

  // Для integration_test (iOS/Android): используем IntegrationTest binding и НЕ мокируем
  // ни SharedPreferences, ни Supabase. Интеграционные тесты должны работать с реальными
  // плагинами/сетью/бэкендом, а инициализацию Supabase делать явно в самих тестах.
  if (isIntegration) {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await testMain();
    return;
  }

  // Настройка unit/widget тестового окружения
  TestWidgetsFlutterBinding.ensureInitialized();

  // Мокаем SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // Инициализируем Supabase с мок-клиентом
  await Supabase.initialize(
    url: 'http://localhost:54321', // Dummy URL
    anonKey: 'dummy_key', // Dummy key
    httpClient: TestHttpClient(),
  );

  // Запускаем основной тестовый файл
  await testMain();
}
