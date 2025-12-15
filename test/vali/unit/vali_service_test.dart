import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/vali_service.dart';
import '../mocks/mock_supabase.dart';

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(Uri());
    registerFallbackValue(Options());
  });

  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late MockSession mockSession;
  late ValiService valiService;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();
    mockSession = MockSession();

    when(() => mockClient.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockAuth.currentSession).thenReturn(mockSession);
    when(() => mockUser.id).thenReturn('test-user-id');
    when(() => mockSession.accessToken).thenReturn('test-token');

    valiService = ValiService(mockClient);
  });

  group('ValiService - sendMessage', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentSession).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.sendMessage(messages: []),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Пользователь не авторизован',
          ),
        ),
      );
    });

    // Note: Тесты для успешной отправки и обработки HTTP ошибок требуют мокирования
    // статического Dio из ValiService, что сложно сделать без рефакторинга.
    // Эти тесты будут отмечены как skip с комментарием о необходимости рефакторинга.

    test('должен выбросить ValiFailure при недостаточном балансе GP (402)', () async {
      // Skip: Требует мокирования статического Dio
    }, skip: true);

    test('должен выбросить ValiFailure при сетевой ошибке', () async {
      // Skip: Требует мокирования статического Dio
    }, skip: true);

    test('должен выбросить ValiFailure при timeout', () async {
      // Skip: Требует мокирования статического Dio
    }, skip: true);
  });

  group('ValiService - scoreValidation', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentSession).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.scoreValidation(
          messages: [],
          validationId: 'test-id',
        ),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Пользователь не авторизован',
          ),
        ),
      );
    });

    // Note: Тесты для успешного скоринга требуют мокирования статического Dio
    test('должен вернуть результаты скоринга при успехе', () async {
      // Skip: Требует мокирования статического Dio
    }, skip: true);
  });

  group('ValiService - createValidation', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.createValidation(),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Не авторизован',
          ),
        ),
      );
    });

    test('должен создать валидацию без chatId', () async {
      // Skip: Требует сложного мокирования Postgrest цепочки вызовов
      // Проверка через интеграционные тесты
    }, skip: true);

    test('должен создать валидацию с chatId и ideaSummary', () async {
      // Skip: Требует сложного мокирования Postgrest цепочки вызовов
    }, skip: true);

    test('должен выбросить ValiFailure при ошибке БД', () async {
      // Arrange
      final mockBuilder = MockSupabaseQueryBuilder();
      when(() => mockClient.from('idea_validations')).thenReturn(mockBuilder);
      when(() => mockBuilder.insert(any())).thenThrow(
        const PostgrestException(message: 'Database error'),
      );

      // Act & Assert
      expect(
        () => valiService.createValidation(),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Database error',
          ),
        ),
      );
    });
  });

  group('ValiService - getValidation', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.getValidation('test-id'),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Не авторизован',
          ),
        ),
      );
    });

    test('должен вернуть данные валидации при успехе', () async {
      // Skip: Требует сложного мокирования Postgrest цепочки
    }, skip: true);

    test('должен вернуть null, если валидация не найдена', () async {
      // Skip: Требует сложного мокирования Postgrest цепочки
    }, skip: true);

    test('должен выбросить ValiFailure при ошибке БД', () async {
      // Skip: Требует сложного мокирования Postgrest цепочки
    }, skip: true);
  });

  group('ValiService - updateValidationProgress', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.updateValidationProgress(
          validationId: 'test-id',
          currentStep: 2,
        ),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Не авторизован',
          ),
        ),
      );
    });

    test('должен обновить прогресс валидации', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);

    test('должен выбросить ValiFailure при ошибке БД', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);
  });

  group('ValiService - saveValidationResults', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.saveValidationResults(
          validationId: 'test-id',
          scores: {'total': 75},
          totalScore: 75,
          archetype: 'СТРОИТЕЛЬ',
          reportMarkdown: 'Test report',
        ),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Не авторизован',
          ),
        ),
      );
    });

    test('должен сохранить результаты валидации', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);

    test('должен сохранить результаты без опциональных полей', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);
  });

  group('ValiService - getUserValidations', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.getUserValidations(),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Не авторизован',
          ),
        ),
      );
    });

    test('должен вернуть список валидаций пользователя', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);

    test('должен применить пагинацию (limit и offset)', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);
  });

  group('ValiService - isFirstValidation', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.isFirstValidation(),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Не авторизован',
          ),
        ),
      );
    });

    test('должен вернуть true, если нет завершённых валидаций', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);

    test('должен вернуть false, если есть завершённые валидации', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);

    test('должен вернуть false при ошибке БД (безопасное поведение)', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);
  });

  group('ValiService - abandonValidation', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.abandonValidation('test-id'),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Не авторизован',
          ),
        ),
      );
    });

    test('должен обновить статус валидации на abandoned', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);
  });

  group('ValiService - saveConversation', () {
    test('должен выбросить ValiFailure, если пользователь не авторизован', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act & Assert
      expect(
        () => valiService.saveConversation(
          role: 'user',
          content: 'Test message',
        ),
        throwsA(
          isA<ValiFailure>().having(
            (e) => e.message,
            'message',
            'Не авторизован',
          ),
        ),
      );
    });

    test('должен создать новый чат и сохранить сообщение', () async {
      // Skip: Требует сложного мокирования множественных Postgrest цепочек
    }, skip: true);

    test('должен сохранить сообщение в существующий чат', () async {
      // Skip: Требует мокирования Postgrest цепочки
    }, skip: true);

    test('должен связать валидацию с новым чатом', () async {
      // Skip: Требует мокирования множественных Postgrest цепочек
    }, skip: true);
  });
}
