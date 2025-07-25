import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/models/level_model.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:bizlevel/providers/auth_provider.dart';

@Skip('integration test – requires network')
void main() {
  AuthService authService = AuthService(Supabase.instance.client);

  setUpAll(() async {
    // Ensure Supabase is ready before running any tests.
    await SupabaseService.initialize();
    authService = AuthService(Supabase.instance.client);
  });

  group('Model serialization', () {
    test('UserModel toJson/fromJson symmetry', () {
      final json = {
        'id': 'test-id',
        'email': 'user@example.com',
        'name': 'Tester',
        'avatar_url': null,
        'about': 'About',
        'goal': 'Goal',
        'is_premium': false,
        'current_level': 1,
        'leo_messages_total': 30,
        'leo_messages_today': 30,
        'leo_reset_at': null,
        'onboarding_completed': false,
        'created_at': null,
        'updated_at': null,
      };
      final model = UserModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('LevelModel toJson/fromJson symmetry', () {
      final json = {
        'id': 1,
        'number': 1,
        'title': 'Level 1',
        'description': 'Desc',
        'image_url': 'http://example.com/img.png',
        'is_free': true,
        'artifact_title': null,
        'artifact_description': null,
        'artifact_url': null,
        'created_at': null,
      };
      final model = LevelModel.fromJson(json);
      expect(model.toJson(), json);
    });

    test('LessonModel toJson/fromJson symmetry', () {
      final json = {
        'id': 1,
        'level_id': 1,
        'order': 1,
        'title': 'Lesson 1',
        'description': 'Desc',
        'video_url': 'http://video',
        'duration_minutes': 5,
        'quiz_questions': [],
        'correct_answers': [],
        'created_at': null,
      };
      final model = LessonModel.fromJson(json);
      expect(model.toJson(), json);
    });
  });

  group('AuthService error handling', () {
    test('signIn with invalid creds throws AuthFailure', () async {
      expect(
        () => authService.signIn(
            email: 'wrong@example.com', password: 'incorrect'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('Riverpod providers', () {
    test('authStateProvider emits an AuthState', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final first = await container.read(authStateProvider.future);
      expect(first, isA<AuthState>());
    });

    test('currentUserProvider returns null when signed out', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final user = await container.read(currentUserProvider.future);
      expect(user, isNull);
    });
  });
}
