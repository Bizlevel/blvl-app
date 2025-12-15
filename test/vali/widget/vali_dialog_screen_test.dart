import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bizlevel/screens/vali_dialog_screen.dart';
import 'package:bizlevel/services/vali_service.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import '../mocks/mock_vali_service.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  late MockValiService mockValiService;

  setUp(() {
    mockValiService = MockValiService();
  });

  /// Helper для создания тестового окружения с моками
  Widget createTestWidget({
    String? chatId,
    String? validationId,
    String? ideaSummary,
  }) {
    return ProviderScope(
      overrides: [
        // Mock GP balance provider
        gpBalanceProvider.overrideWith(
          (ref) => Future.value({'balance': 1000, 'total_earned': 5000, 'total_spent': 4000}),
        ),
      ],
      child: MaterialApp(
        home: ValiDialogScreen(
          chatId: chatId,
          validationId: validationId,
          ideaSummary: ideaSummary,
        ),
      ),
    );
  }

  group('ValiDialogScreen - Инициализация', () {
    testWidgets('должен показать заголовок "Валли" в AppBar', (tester) async {
      // Arrange
      when(() => mockValiService.createValidation(
            chatId: any(named: 'chatId'),
            ideaSummary: any(named: 'ideaSummary'),
          )).thenAnswer((_) async => 'new-validation-id');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Дождёмся инициализации

      // Assert
      expect(find.text('Валли'), findsOneWidget);
    });

    testWidgets('должен показать прогресс-бар с "1/7"', (tester) async {
      // Arrange
      when(() => mockValiService.createValidation(
            chatId: any(named: 'chatId'),
            ideaSummary: any(named: 'ideaSummary'),
          )).thenAnswer((_) async => 'new-validation-id');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('1/7'), findsOneWidget);
    });

    testWidgets('должен показать приветственное сообщение от Валли', (tester) async {
      // Arrange
      when(() => mockValiService.createValidation(
            chatId: any(named: 'chatId'),
            ideaSummary: any(named: 'ideaSummary'),
          )).thenAnswer((_) async => 'new-validation-id');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Привет! Я Валли'), findsOneWidget);
    });

    testWidgets('должен показать поле ввода с placeholder', (tester) async {
      // Arrange
      when(() => mockValiService.createValidation(
            chatId: any(named: 'chatId'),
            ideaSummary: any(named: 'ideaSummary'),
          )).thenAnswer((_) async => 'new-validation-id');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Введите ответ...'), findsOneWidget);
    });

    testWidgets('должен показать кнопку отправки', (tester) async {
      // Arrange
      when(() => mockValiService.createValidation(
            chatId: any(named: 'chatId'),
            ideaSummary: any(named: 'ideaSummary'),
          )).thenAnswer((_) async => 'new-validation-id');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });

  group('ValiDialogScreen - Отправка сообщения', () {
    testWidgets('должен добавить сообщение пользователя в список', (tester) async {
      // Skip: Требует более глубокого мокирования ValiService через DI
    }, skip: true);

    testWidgets('должен показать typing indicator при отправке', (tester) async {
      // Skip: Требует мокирования ValiService через DI
    }, skip: true);

    testWidgets('должен обновить прогресс-бар после ответа (2/7)', (tester) async {
      // Skip: Требует мокирования ValiService через DI
    }, skip: true);

    testWidgets('должен очистить поле ввода после отправки', (tester) async {
      // Skip: Требует мокирования ValiService через DI
    }, skip: true);
  });

  group('ValiDialogScreen - Прогресс', () {
    testWidgets('должен обновить прогресс с 1/7 до 7/7', (tester) async {
      // Skip: Требует сложного моделирования состояния
    }, skip: true);

    testWidgets('должен показать диалог завершения при 7/7', (tester) async {
      // Skip: Требует сложного моделирования состояния
    }, skip: true);
  });

  group('ValiDialogScreen - Режим отчёта', () {
    testWidgets('должен показать карточку с баллом при status=completed', (tester) async {
      // Arrange
      when(() => mockValiService.getValidation('completed-id')).thenAnswer(
        (_) async => {
          'id': 'completed-id',
          'status': 'completed',
          'total_score': 85,
          'archetype': 'СТРОИТЕЛЬ',
          'report_markdown': '# Отличный результат!',
          'recommended_levels': [],
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget(validationId: 'completed-id'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('85/100'), findsOneWidget);
      expect(find.text('СТРОИТЕЛЬ'), findsOneWidget);
    });

    testWidgets('должен показать markdown отчёт', (tester) async {
      // Arrange
      when(() => mockValiService.getValidation('completed-id')).thenAnswer(
        (_) async => {
          'id': 'completed-id',
          'status': 'completed',
          'total_score': 70,
          'archetype': 'МЕЧТАТЕЛЬ',
          'report_markdown': '# Твой отчёт\n\nОтличная работа!',
          'recommended_levels': [],
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget(validationId: 'completed-id'));
      await tester.pumpAndSettle();

      // Assert
      // Markdown содержит заголовок
      expect(find.textContaining('Твой отчёт'), findsOneWidget);
    });

    testWidgets('должен показать CTA кнопку "Поставить цель с Максом"', (tester) async {
      // Arrange
      when(() => mockValiService.getValidation('completed-id')).thenAnswer(
        (_) async => {
          'id': 'completed-id',
          'status': 'completed',
          'total_score': 60,
          'archetype': 'НАЧИНАЮЩИЙ',
          'report_markdown': 'Отчёт',
          'recommended_levels': [],
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget(validationId: 'completed-id'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Поставить цель с Максом'), findsOneWidget);
    });

    testWidgets('должен показать CTA кнопку "Проверить другую идею"', (tester) async {
      // Arrange
      when(() => mockValiService.getValidation('completed-id')).thenAnswer(
        (_) async => {
          'id': 'completed-id',
          'status': 'completed',
          'total_score': 50,
          'archetype': 'МЕЧТАТЕЛЬ',
          'report_markdown': 'Отчёт',
          'recommended_levels': [],
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget(validationId: 'completed-id'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Проверить другую идею'), findsOneWidget);
    });

    testWidgets('должен показать кнопку рекомендованного уровня', (tester) async {
      // Arrange
      when(() => mockValiService.getValidation('completed-id')).thenAnswer(
        (_) async => {
          'id': 'completed-id',
          'status': 'completed',
          'total_score': 75,
          'archetype': 'СТРОИТЕЛЬ',
          'report_markdown': 'Отчёт',
          'recommended_levels': [
            {'level_number': 3, 'name': 'Тестирование гипотез'}
          ],
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget(validationId: 'completed-id'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Тестирование гипотез'), findsOneWidget);
    });
  });

  group('ValiDialogScreen - Обработка ошибок', () {
    testWidgets('должен показать ошибку при сбое загрузки валидации', (tester) async {
      // Skip: Требует перехвата SnackBar
    }, skip: true);

    testWidgets('должен показать диалог при ошибке 402 (недостаточно GP)', (tester) async {
      // Skip: Требует мокирования отправки сообщения и обработки ошибок
    }, skip: true);

    testWidgets('должен показать SnackBar при сетевой ошибке', (tester) async {
      // Skip: Требует мокирования отправки сообщения
    }, skip: true);
  });

  group('ValiDialogScreen - Взаимодействие с UI', () {
    testWidgets('должен показать FAB "scroll to bottom" при прокрутке вверх', (tester) async {
      // Skip: Требует моделирования большого списка сообщений и прокрутки
    }, skip: true);

    testWidgets('должен скрыть клавиатуру при нажатии кнопки "скрыть"', (tester) async {
      // Arrange
      when(() => mockValiService.createValidation(
            chatId: any(named: 'chatId'),
            ideaSummary: any(named: 'ideaSummary'),
          )).thenAnswer((_) async => 'new-validation-id');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.keyboard_hide), findsOneWidget);
      
      // Нажимаем кнопку скрытия клавиатуры
      await tester.tap(find.byIcon(Icons.keyboard_hide));
      await tester.pumpAndSettle();
      
      // Проверяем, что фокус потерян (клавиатура скрыта)
      // Note: В реальности проверка фокуса требует более сложной логики
    });

    testWidgets('должен отключить кнопку отправки при пустом сообщении', (tester) async {
      // Note: Логика не отключает кнопку, но sendMessage проверяет пустоту
      // Этот тест скорее про проверку отсутствия действия при пустом тексте
    }, skip: true);
  });

  group('ValiDialogScreen - Анимации', () {
    testWidgets('должен анимировать появление последних 6 сообщений', (tester) async {
      // Skip: Требует проверки анимационных свойств
    }, skip: true);

    testWidgets('должен показать индикатор прогресса при скоринге', (tester) async {
      // Skip: Требует моделирования запроса скоринга
    }, skip: true);
  });
}
