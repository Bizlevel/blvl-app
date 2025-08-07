import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/models/user_skill_model.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/providers/subscription_provider.dart';
import 'package:bizlevel/repositories/user_repository.dart';
import 'package:bizlevel/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  final mockUser = MockUser();
  when(() => mockUser.id).thenReturn('test_user_id');

  final authState = AuthState(
    AuthChangeEvent.signedIn,
    Session(
      accessToken: 'token',
      tokenType: 'bearer',
      user: mockUser,
    ),
  );

  final userModel = UserModel(
    id: 'test_user_id',
    name: 'Test User',
    email: 'test@example.com',
    onboardingCompleted: true,
    currentLevel: 1,
  );

  final skills = [
    const UserSkillModel(
      userId: 'test_user_id',
      skillId: 1,
      points: 5,
      skillName: 'Test Skill 1',
    ),
  ];

  testWidgets('ProfileScreen displays skills after loading user and auth state',
      (WidgetTester tester) async {
    when(() => mockUserRepository.fetchProfile(any()))
        .thenAnswer((_) async => userModel);
    when(() => mockUserRepository.fetchUserSkills(any()))
        .thenAnswer((_) async => skills);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(authState)),
          userRepositoryProvider.overrideWithValue(mockUserRepository),
          levelsProvider.overrideWith((ref) => Future.value([])),
          subscriptionProvider.overrideWith((ref) => Stream.value('free')),
        ],
        child: const MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    // Initial loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    // After loading, check for user info and skills
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Test Skill 1'), findsOneWidget);
    expect(find.text('5/10'), findsOneWidget);
  });
}
