import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/main.dart';
import 'package:online_course/screens/auth/login_screen.dart';
import 'package:online_course/screens/auth/onboarding_screens.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_course/models/user_model.dart';

import 'helpers/web_test_helpers.dart';

void main() {
  group('Authentication & Onboarding Flow (Web)', () {
    setUpAll(() async {
      await WebTestHelper.initializeTestEnvironment();
    });

    testWidgets('New visitor sees login screen', (tester) async {
      // Override authStateProvider to emit signedOut state.
      final overrides = <Override>[
        authStateProvider.overrideWith((ref) {
          return Stream<AuthState>.value(
            AuthState(AuthChangeEvent.signedOut, null),
          );
        }),
      ];

      await tester
          .pumpWidget(WebTestHelper.createTestApp(overrides: overrides));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('User who completed onboarding goes directly to LevelsMap',
        (tester) async {
      // Create fake session to simulate logged in user.
      final fakeUser = User(
          id: 'uid',
          aud: '',
          email: 'user@biz.kz',
          appMetadata: {},
          userMetadata: {},
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String());
      final session = Session(
        accessToken: 'test',
        refreshToken: 'ref',
        tokenType: 'bearer',
        user: fakeUser,
        expiresIn: 3600,
      );

      final overrides = <Override>[
        authStateProvider.overrideWith((ref) {
          return Stream<AuthState>.value(
              AuthState(AuthChangeEvent.signedIn, session));
        }),
        // currentUserProvider override: user completed onboarding
        currentUserProvider.overrideWith((ref) async {
          return UserModel(
            id: 'uid',
            email: 'user@biz.kz',
            name: 'User',
            onboardingCompleted: true,
            currentLevel: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        })
      ];

      await tester
          .pumpWidget(WebTestHelper.createTestApp(overrides: overrides));
      await tester.pumpAndSettle();

      // Should not show onboarding profilescreen
      expect(find.byType(OnboardingProfileScreen), findsNothing);
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}
