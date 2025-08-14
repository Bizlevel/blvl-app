import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mocks.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Настройка тестового окружения
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
