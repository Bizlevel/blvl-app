// Smoke-тесты провайдеров: проверяют, что они не падают при создании.
// Не требуют моков — используют реальный Supabase SDK (без сети).

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Импортируем провайдеры
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/gp_providers.dart';

void main() {
  // Инициализируем Supabase с фейковыми credentials для тестов
  setUpAll(() async {
    try {
      await Supabase.initialize(
        url: 'https://test.supabase.co',
        anonKey: 'test-anon-key',
      );
    } on AssertionError {
      // Already initialized
    }
  });

  group('Provider Smoke Tests', () {
    test('authStateProvider can be watched without throwing', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Не должен бросать исключение
      expect(
        () => container.read(authStateProvider),
        returnsNormally,
      );
    });

    test('currentUserProvider.future completes within timeout', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Должен завершиться за 2 секунды (без блокировки)
      final result = await container
          .read(currentUserProvider.future)
          .timeout(const Duration(seconds: 2));

      // Без реальной авторизации — должен вернуть null
      expect(result, isNull);
    });

    test('gpBalanceProvider.future completes within timeout', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Должен завершиться за 2 секунды
      final result = await container
          .read(gpBalanceProvider.future)
          .timeout(const Duration(seconds: 2));

      // Без сессии — должен вернуть нулевой баланс
      expect(result['balance'], equals(0));
    });

    test('supabaseClientProvider returns client instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final client = container.read(supabaseClientProvider);
      expect(client, isNotNull);
      expect(client, isA<SupabaseClient>());
    });
  });

  group('Auth State Tests', () {
    test('currentSession is null when not logged in', () {
      final session = Supabase.instance.client.auth.currentSession;
      expect(session, isNull);
    });

    test('currentUser is null when not logged in', () {
      final user = Supabase.instance.client.auth.currentUser;
      expect(user, isNull);
    });
  });
}

