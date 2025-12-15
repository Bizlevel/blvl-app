import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/vali_service_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/services/vali_service.dart';
import '../mocks/mock_supabase.dart';

void main() {
  group('ValiServiceProvider', () {
    test('должен вернуть экземпляр ValiService', () {
      // Arrange
      final mockClient = MockSupabaseClient();
      final container = ProviderContainer(
        overrides: [
          supabaseClientProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final service = container.read(valiServiceProvider);

      // Assert
      expect(service, isA<ValiService>());
    });

    test('должен использовать SupabaseClient из supabaseClientProvider', () {
      // Arrange
      final mockClient = MockSupabaseClient();
      final container = ProviderContainer(
        overrides: [
          supabaseClientProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final service = container.read(valiServiceProvider);

      // Assert
      expect(service, isNotNull);
      expect(service, isA<ValiService>());
    });

    test('должен быть singleton (возвращать один и тот же экземпляр)', () {
      // Arrange
      final mockClient = MockSupabaseClient();
      final container = ProviderContainer(
        overrides: [
          supabaseClientProvider.overrideWithValue(mockClient),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final service1 = container.read(valiServiceProvider);
      final service2 = container.read(valiServiceProvider);

      // Assert
      expect(identical(service1, service2), isTrue);
    });

    test('должен пересоздать сервис при изменении SupabaseClient', () {
      // Arrange
      final mockClient1 = MockSupabaseClient();
      final mockClient2 = MockSupabaseClient();
      
      final container = ProviderContainer(
        overrides: [
          supabaseClientProvider.overrideWithValue(mockClient1),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final service1 = container.read(valiServiceProvider);
      
      // Обновляем override
      container.updateOverrides([
        supabaseClientProvider.overrideWithValue(mockClient2),
      ]);
      
      final service2 = container.read(valiServiceProvider);

      // Assert
      // Сервисы должны быть разными, так как зависимость изменилась
      expect(identical(service1, service2), isFalse);
    });
  });
}
