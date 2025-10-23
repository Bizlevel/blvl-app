import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/models/level_model.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:bizlevel/providers/auth_provider.dart';

void main() {
  AuthService authService = AuthService(Supabase.instance.client);

  setUpAll(() async {
    // Ensure Supabase is ready before running any tests.
    await SupabaseService.initialize();
    authService = AuthService(Supabase.instance.client);
  });

  group('Model serialization', () {
    test('UserModel toJson/fromJson symmetry (subset)', () {
      final json = {
        'id': 'test-id',
        'email': 'user@example.com',
        'name': 'Tester',
        'avatar_url': null,
        'avatar_id': null,
        'about': 'About',
        'goal': 'Goal',
        'business_area': null,
        'experience_level': null,
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
      final out = model.toJson();
      expect(out['id'], json['id']);
      expect(out['email'], json['email']);
      expect(out['name'], json['name']);
      expect(out['about'], json['about']);
      expect(out['goal'], json['goal']);
      expect(out['current_level'], json['current_level']);
      expect(out['onboarding_completed'], json['onboarding_completed']);
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
        'skill_id': null,
        'created_at': null,
      };
      final model = LevelModel.fromJson(json);
      final out = model.toJson();
      expect(out['id'], json['id']);
      expect(out['number'], json['number']);
      expect(out['title'], json['title']);
    });

    test('LessonModel toJson/fromJson symmetry', () {
      final json = {
        'id': 1,
        'level_id': 1,
        'order': 1,
        'title': 'Lesson 1',
        'description': 'Desc',
        'video_url': 'http://video',
        'vimeo_id': null,
        'duration_minutes': 5,
        'quiz_questions': [],
        'correct_answers': [],
        'created_at': null,
      };
      final model = LessonModel.fromJson(json);
      final out = model.toJson();
      expect(out['id'], json['id']);
      expect(out['level_id'], json['level_id']);
      expect(out['title'], json['title']);
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
