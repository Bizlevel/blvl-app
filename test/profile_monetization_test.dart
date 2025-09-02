import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/levels_provider.dart';
// import 'package:bizlevel/screens/payment_screen.dart';
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
      // поля премиума/лимитов удалены в 39.1
    );

    // премиум удалён — оставляем одного пользователя

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

    testWidgets('Профиль отображается без экрана платежей', (tester) async {
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

      // Перехода на PaymentScreen больше нет
      expect(find.textContaining('Оплат'), findsNothing);
    });

    // Тест премиума удалён (подписки сняты в 39.1)

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
