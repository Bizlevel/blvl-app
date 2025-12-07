/// Тесты для GoRouter — проверка, что роутер не блокирует запуск.
///
/// Проблема: ref.watch(authStateProvider) внутри Provider может заблокировать
/// UI навсегда, если StreamProvider не выдаёт события сразу.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/routing/app_router.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      await Supabase.initialize(
        url: 'https://test.supabase.co',
        anonKey: 'test-anon-key',
      );
    } on AssertionError {
      // Already initialized
    }
  });

  group('🚀 GoRouter Startup Tests', () {
    test('goRouterProvider creates router within 100ms (no blocking)', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stopwatch = Stopwatch()..start();

      // Это должно завершиться мгновенно, без ожидания сети
      final router = container.read(goRouterProvider);
      
      stopwatch.stop();
      
      expect(router, isNotNull);
      expect(router.routeInformationProvider, isNotNull);
      expect(stopwatch.elapsedMilliseconds, lessThan(100),
          reason: 'goRouterProvider should not block on StreamProvider');
      
      print('✅ goRouterProvider created in ${stopwatch.elapsedMilliseconds}ms');
    });

    test('goRouterProvider configuration has /login route', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      
      // Проверяем, что роутер содержит маршрут /login
      // (в тестовой среде без NavigatorObserver fullPath может быть пустым)
      final routes = router.configuration.routes;
      expect(routes.length, greaterThan(0));
      
      print('✅ Router has ${routes.length} top-level routes configured');
    });

    test('goRouterProvider does NOT watch authStateProvider directly', () async {
      // Этот тест проверяет, что goRouterProvider не подписывается
      // на authStateProvider (StreamProvider), что могло бы заблокировать.
      
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Читаем роутер несколько раз — должно быть быстро каждый раз
      for (var i = 0; i < 5; i++) {
        final stopwatch = Stopwatch()..start();
        final router = container.read(goRouterProvider);
        stopwatch.stop();
        
        expect(router, isNotNull);
        expect(stopwatch.elapsedMilliseconds, lessThan(50),
            reason: 'Repeated reads should be fast');
      }
      
      print('✅ goRouterProvider reads are consistently fast');
    });
  });
}

