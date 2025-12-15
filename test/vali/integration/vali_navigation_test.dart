import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bizlevel/screens/leo_chat_screen.dart';
import 'package:bizlevel/screens/vali_dialog_screen.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';

class MockLeoService extends Mock implements LeoService {}

void main() {
  late MockLeoService mockLeoService;

  setUp(() {
    mockLeoService = MockLeoService();
    when(() => mockLeoService.checkMessageLimit()).thenAnswer((_) async => 10);
  });

  Widget createTestApp() {
    return ProviderScope(
      overrides: [
        leoServiceProvider.overrideWithValue(mockLeoService),
      ],
      child: const MaterialApp(
        home: LeoChatScreen(),
      ),
    );
  }

  group('Vali Navigation', () {
    testWidgets('Base Trainers → ValiDialogScreen при нажатии на карточку', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Vali AI'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Валли'), findsOneWidget); // AppBar title
      expect(find.text('1/7'), findsOneWidget); // Progress indicator
    });

    testWidgets('должен создать новую валидацию при открытии', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Vali AI'));
      await tester.pumpAndSettle();

      // Assert
      // Проверяем, что отображается приветственное сообщение (новая валидация)
      expect(find.textContaining('Привет! Я Валли'), findsOneWidget);
    });

    testWidgets('кнопка "Назад" должна вернуть в Base Trainers', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Открываем ValiDialogScreen
      await tester.tap(find.text('Vali AI'));
      await tester.pumpAndSettle();

      // Act - нажимаем кнопку "Назад" в AppBar
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Менторы'), findsOneWidget); // Заголовок Base Trainers
      expect(find.text('Vali AI'), findsOneWidget); // Карточка снова видна
    });
  });

  group('Vali Navigation - История чатов', () {
    testWidgets('История чатов → ValiDialogScreen при клике на чат с Валли', (tester) async {
      // Skip: Требует мокирования Supabase запросов для загрузки истории чатов
    }, skip: true);

    testWidgets('должен загрузить существующий чат с историей сообщений', (tester) async {
      // Skip: Требует мокирования getValidation() и загрузки leo_messages
    }, skip: true);

    testWidgets('должен показать правильный прогресс для незавершённого чата', (tester) async {
      // Skip: Требует мокирования валидации с current_step != 7
    }, skip: true);
  });

  group('Vali Navigation - CTA кнопки в отчёте', () {
    testWidgets('ValiDialogScreen → Max (CTA "Поставить цель с Максом")', (tester) async {
      // Skip: Требует:
      // 1. Мокирования завершённой валидации
      // 2. Проверки навигации на /chat/max через go_router
    }, skip: true);

    testWidgets('ValiDialogScreen → Рекомендованный уровень (CTA "Пройти урок")', (tester) async {
      // Skip: Требует:
      // 1. Мокирования валидации с recommended_levels
      // 2. Проверки навигации на /levels/:levelNumber через go_router
    }, skip: true);

    testWidgets('CTA "Пройти урок" должен показать SnackBar при недостаточном уровне пользователя', (tester) async {
      // Skip: Требует:
      // 1. Мокирования валидации с recommended_levels
      // 2. Мокирования currentLevelNumberProvider с уровнем ниже рекомендованного
      // 3. Проверки отсутствия навигации и наличия SnackBar
    }, skip: true);

    testWidgets('CTA "Пройти урок" должен навигировать при достаточном уровне пользователя', (tester) async {
      // Skip: Требует:
      // 1. Мокирования валидации с recommended_levels
      // 2. Мокирования currentLevelNumberProvider с уровнем >= рекомендованного
      // 3. Проверки успешной навигации на /levels/:levelNumber
    }, skip: true);

    testWidgets('ValiDialogScreen → Новая валидация (CTA "Проверить другую идею")', (tester) async {
      // Skip: Требует:
      // 1. Мокирования завершённой валидации
      // 2. Проверки создания нового ValiDialogScreen через pushReplacement
    }, skip: true);

    testWidgets('кнопка "Вернуться в Башню" должна закрыть экран', (tester) async {
      // Skip: Требует мокирования завершённой валидации и проверки Navigator.pop()
    }, skip: true);
  });

  group('Vali Navigation - GP пополнение', () {
    testWidgets('Диалог "Недостаточно GP" → /gp-purchase', (tester) async {
      // Skip: Требует:
      // 1. Эмуляции ошибки 402 при отправке сообщения
      // 2. Проверки навигации через go_router
    }, skip: true);

    testWidgets('должен вернуться в ValiDialogScreen после пополнения GP', (tester) async {
      // Skip: Требует сложного моделирования навигационного стека
    }, skip: true);
  });

  group('Vali Navigation - Deep Links', () {
    testWidgets('должен открыть ValiDialogScreen по validationId из deep link', (tester) async {
      // Skip: Требует тестирования go_router с параметрами маршрута
    }, skip: true);

    testWidgets('должен загрузить валидацию по ID из deep link', (tester) async {
      // Skip: Требует мокирования getValidation() с конкретным ID
    }, skip: true);

    testWidgets('должен показать ошибку, если валидация не найдена', (tester) async {
      // Skip: Требует мокирования getValidation() → null
    }, skip: true);
  });

  group('Vali Navigation - Edge Cases', () {
    testWidgets('должен корректно обработать быстрое двойное нажатие на карточку', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Act - двойное нажатие
      await tester.tap(find.text('Vali AI'));
      await tester.tap(find.text('Vali AI'));
      await tester.pumpAndSettle();

      // Assert
      // Должен открыться только один экран (не дублирование)
      expect(find.text('Валли'), findsOneWidget);
    });

    testWidgets('должен сохранить состояние при навигации назад и вперёд', (tester) async {
      // Skip: Требует сложного тестирования состояния навигации
    }, skip: true);

    testWidgets('должен очистить state при полном закрытии экрана', (tester) async {
      // Skip: Требует проверки dispose() и очистки контроллеров
    }, skip: true);
  });
}
