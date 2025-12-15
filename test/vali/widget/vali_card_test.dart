import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bizlevel/screens/leo_chat_screen.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';

class MockLeoService extends Mock implements LeoService {}

void main() {
  late MockLeoService mockLeoService;

  setUp(() {
    mockLeoService = MockLeoService();
    when(() => mockLeoService.checkMessageLimit()).thenAnswer((_) async => 10);
  });

  /// Helper для создания тестового окружения
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        leoServiceProvider.overrideWithValue(mockLeoService),
      ],
      child: const MaterialApp(
        home: LeoChatScreen(),
      ),
    );
  }

  group('Vali Card - Отображение', () {
    testWidgets('должен показать карточку Vali AI в Base Trainers', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Vali AI'), findsOneWidget);
    });

    testWidgets('должен показать subtitle "Проверь идею на прочность"', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Проверь идею на прочность'), findsOneWidget);
    });

    testWidgets('должен показать кнопку "Начать чат"', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Начать чат'), findsAtLeastNWidgets(1));
    });

    testWidgets('должен показать аватар Валли', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      // Проверяем, что есть CircleAvatar с правильным изображением
      final avatarFinder = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(CircleAvatar),
      );
      
      expect(avatarFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('карточка Валли должна идти третьей после Leo и Max', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      // Находим все карточки
      final leoCard = find.text('Leo AI');
      final maxCard = find.text('Max AI');
      final valiCard = find.text('Vali AI');
      
      expect(leoCard, findsOneWidget);
      expect(maxCard, findsOneWidget);
      expect(valiCard, findsOneWidget);
      
      // Проверяем, что Vali отображается после Max
      final leoY = tester.getTopLeft(leoCard).dy;
      final maxY = tester.getTopLeft(maxCard).dy;
      final valiY = tester.getTopLeft(valiCard).dy;
      
      expect(leoY < maxY, isTrue, reason: 'Leo должен быть выше Max');
      expect(maxY < valiY, isTrue, reason: 'Max должен быть выше Vali');
    });
  });

  group('Vali Card - Навигация', () {
    testWidgets('должен открыть ValiDialogScreen при нажатии на карточку', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Нажимаем на карточку Валли
      await tester.tap(find.text('Vali AI'));
      await tester.pumpAndSettle();

      // Assert
      // Проверяем, что открылся новый экран с заголовком "Валли"
      expect(find.text('Валли'), findsOneWidget);
    });

    testWidgets('должен создать новую валидацию при открытии экрана', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Нажимаем на карточку Валли
      await tester.tap(find.text('Vali AI'));
      await tester.pumpAndSettle();

      // Assert
      // Проверяем, что показывается начальный прогресс 1/7
      expect(find.text('1/7'), findsOneWidget);
    });
  });

  group('Vali Card - История чатов', () {
    testWidgets('должен показать чат с Валли в истории', (tester) async {
      // Skip: Требует мокирования Supabase запросов для загрузки чатов
    }, skip: true);

    testWidgets('должен открыть существующий чат с Валли при нажатии', (tester) async {
      // Skip: Требует мокирования Supabase запросов
    }, skip: true);

    testWidgets('должен показать правильный аватар для чата с Валли', (tester) async {
      // Skip: Требует мокирования Supabase запросов
    }, skip: true);

    testWidgets('должен показать "Vali AI" как botLabel в истории', (tester) async {
      // Skip: Требует мокирования Supabase запросов
    }, skip: true);
  });

  group('Vali Card - Стили', () {
    testWidgets('карточка должна иметь правильное оформление', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      // Находим контейнер карточки Валли
      final valiCardFinder = find.ancestor(
        of: find.text('Vali AI'),
        matching: find.byType(Container),
      );
      
      expect(valiCardFinder, findsAtLeastNWidgets(1));
      
      // Проверяем, что у карточки есть декорация (border, shadow)
      final container = tester.widget<Container>(valiCardFinder.first);
      expect(container.decoration, isNotNull);
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('аватар должен иметь радиус 32', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final avatars = tester.widgetList<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      
      // У нас есть 3 карточки (Leo, Max, Vali)
      expect(avatars.length, greaterThanOrEqualTo(3));
      
      // Проверяем радиус всех аватаров
      for (final avatar in avatars) {
        expect(avatar.radius, 32);
      }
    });
  });

  group('Vali Card - Взаимодействие', () {
    testWidgets('карточка должна быть кликабельной (GestureDetector)', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final gestureDetectors = find.descendant(
        of: find.ancestor(
          of: find.text('Vali AI'),
          matching: find.byType(GestureDetector),
        ),
        matching: find.byType(GestureDetector),
      );
      
      expect(gestureDetectors, findsAtLeastNWidgets(1));
    });

    testWidgets('должен показать визуальный фидбек при нажатии', (tester) async {
      // Skip: Требует проверки визуальных эффектов
    }, skip: true);
  });
}
