import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_course/models/user_model.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/providers/levels_provider.dart';
import 'package:online_course/screens/payment_screen.dart';
import 'package:online_course/screens/profile_screen.dart';
import 'package:online_course/screens/root_app.dart';
import 'package:online_course/widgets/artifact_card.dart';
import 'package:online_course/widgets/bottombar_item.dart';

void main() {
  group('Profile & Monetization', () {
    final freeUser = UserModel(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
      currentLevel: 3,
      isPremium: false,
      leoMessagesTotal: 25,
      leoMessagesToday: 25,
    );

    final premiumUser = freeUser.copyWith(isPremium: true);

    final mockLevels = [
      {
        'level': 1,
        'artifact_title': 'Чек-лист идеи',
        'artifact_description': 'Шаблон для проверки бизнес-идеи',
        'artifact_url': 'https://example.com/level1.pdf',
        'image': 'https://placehold.co/60',
      }
    ];

    testWidgets('Displays user stats and artifacts', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) async => freeUser),
            levelsProvider.overrideWith((ref) async => mockLevels),
          ],
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Уровень 3'), findsOneWidget);
      expect(find.textContaining('сообщений'), findsOneWidget);
      expect(find.byType(ArtifactCard), findsOneWidget);
    });

    testWidgets('Navigates to PaymentScreen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) async => freeUser),
            levelsProvider.overrideWith((ref) async => mockLevels),
          ],
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Оплата'));
      await tester.pumpAndSettle();

      expect(find.byType(PaymentScreen), findsOneWidget);
      expect(find.text('Инструкция по оплате'), findsOneWidget);
    });

    testWidgets('Premium user hides Premium button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) async => premiumUser),
            levelsProvider.overrideWith((ref) async => mockLevels),
          ],
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Получить Premium'), findsNothing);
    });

    testWidgets('Bottom navigation switches tabs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) async => freeUser),
            levelsProvider.overrideWith((ref) async => mockLevels),
          ],
          child: const MaterialApp(home: RootApp()),
        ),
      );
      await tester.pumpAndSettle();

      // Tap профиль (index 2)
      final profileIcon = find.byType(BottomBarItem).at(2);
      await tester.tap(profileIcon);
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });
}
