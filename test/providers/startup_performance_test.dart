// Тесты производительности запуска приложения.
//
// Эти тесты проверяют, что критические провайдеры и инициализации
// завершаются в разумное время и не блокируют UI.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Импорты провайдеров
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/gp_providers.dart';

void main() {
  // Инициализируем Supabase один раз для всех тестов
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      await Supabase.initialize(
        url: 'https://test.supabase.co',
        anonKey: 'test-anon-key',
      );
    } on AssertionError {
      // Already initialized — OK
    }
  });

  group('🚀 Startup Performance Tests', () {
    test('currentUserProvider completes within 500ms (no blocking)', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stopwatch = Stopwatch()..start();

      final result = await container.read(currentUserProvider.future).timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {
          fail('❌ currentUserProvider BLOCKED for > 500ms! '
              'This will cause white/black screen on launch.');
        },
      );

      stopwatch.stop();

      expect(result, isNull, reason: 'No session = null user');
      expect(stopwatch.elapsedMilliseconds, lessThan(500),
          reason: 'Provider should complete quickly');

      // ignore: avoid_print
      print(
          '✅ currentUserProvider completed in ${stopwatch.elapsedMilliseconds}ms');
    });

    test('gpBalanceProvider completes within 500ms (no blocking)', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stopwatch = Stopwatch()..start();

      final result = await container.read(gpBalanceProvider.future).timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {
          fail('❌ gpBalanceProvider BLOCKED for > 500ms! '
              'This will cause UI freeze.');
        },
      );

      stopwatch.stop();

      expect(result['balance'], equals(0), reason: 'No session = zero balance');
      expect(stopwatch.elapsedMilliseconds, lessThan(500));

      // ignore: avoid_print
      print(
          '✅ gpBalanceProvider completed in ${stopwatch.elapsedMilliseconds}ms');
    });

    test('authStateProvider can be watched without timeout', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stopwatch = Stopwatch()..start();

      // Просто читаем — не должно блокировать
      final asyncValue = container.read(authStateProvider);

      stopwatch.stop();

      // StreamProvider в начале в состоянии loading
      expect(asyncValue.isLoading || asyncValue.hasValue, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(100),
          reason: 'Watching StreamProvider should be instant');

      // ignore: avoid_print
      print(
          '✅ authStateProvider watched in ${stopwatch.elapsedMilliseconds}ms');
    });

    test('supabaseClientProvider is synchronous', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stopwatch = Stopwatch()..start();
      final client = container.read(supabaseClientProvider);
      stopwatch.stop();

      expect(client, isNotNull);
      expect(stopwatch.elapsedMilliseconds, lessThan(10),
          reason: 'Reading client should be instant');

      // ignore: avoid_print
      print(
          '✅ supabaseClientProvider read in ${stopwatch.elapsedMilliseconds}ms');
    });
  });

  group('🔒 Auth Provider Chain Tests', () {
    test('currentUserProvider does NOT await authStateProvider.future',
        () async {
      // Этот тест проверяет паттерн кода — если бы провайдер использовал
      // `await authStateProvider.future`, он бы зависал навсегда
      // при пустом потоке (что и происходило раньше)

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Если этот тест проходит за 500ms — значит нет блокировки
      await container.read(currentUserProvider.future).timeout(
            const Duration(milliseconds: 500),
            onTimeout: () =>
                throw TimeoutException('currentUserProvider is blocking! '
                    'Check if it uses authStateProvider.future'),
          );

      // ignore: avoid_print
      print('✅ currentUserProvider chain is non-blocking');
    });

    test('Multiple providers can be read concurrently', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stopwatch = Stopwatch()..start();

      // Читаем несколько провайдеров параллельно
      final futures = await Future.wait([
        container.read(currentUserProvider.future),
        container.read(gpBalanceProvider.future),
      ]).timeout(
        const Duration(milliseconds: 1000),
        onTimeout: () {
          fail('❌ Concurrent provider reads BLOCKED!');
        },
      );

      stopwatch.stop();

      expect(futures.length, equals(2));
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));

      // ignore: avoid_print
      print(
          '✅ Concurrent reads completed in ${stopwatch.elapsedMilliseconds}ms');
    });
  });
}

/// Custom TimeoutException for better error messages
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
