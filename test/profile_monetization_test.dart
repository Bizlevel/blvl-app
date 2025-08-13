import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/screens/payment_screen.dart';
import 'package:bizlevel/screens/profile_screen.dart';
import 'package:bizlevel/screens/root_app.dart';
import 'package:bizlevel/widgets/artifact_card.dart';
import 'package:bizlevel/widgets/bottombar_item.dart';

void main() {
  group('Profile & Monetization', () {
    const freeUser = UserModel(
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

      // На экране выводится "3 Уровень" (число перед словом)
      expect(find.text('3 Уровень'), findsOneWidget);
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

      // В актуальном UI кнопка подписки может называться иначе.
      // Пытаемся найти по ключевым словам.
      final payButton = find.textContaining('Оплат').evaluate().isNotEmpty
          ? find.textContaining('Оплат')
          : find.textContaining('Преми');
      if (payButton.evaluate().isNotEmpty) {
        await tester.tap(payButton.first);
        await tester.pumpAndSettle();
      }
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

      // Текст кнопки премиума отсутствует для премиум-пользователя
      expect(find.textContaining('Преми'), findsNothing);
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
