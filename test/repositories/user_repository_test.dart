import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_course/repositories/user_repository.dart';
import 'package:online_course/models/user_model.dart';

// -------------------- Моки --------------------
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  late MockSupabaseClient client;
  late UserRepository repository;
  late dynamic builder;

  setUp(() {
    client = MockSupabaseClient();
    repository = UserRepository(client);

    builder = MockSupabaseQueryBuilder();
    when(() => client.from('users')).thenAnswer((_) => builder as dynamic);
    when(() => (builder as dynamic).select())
        .thenAnswer((_) => builder as dynamic);
    when(() => (builder as dynamic).eq(any(), any()))
        .thenAnswer((_) => builder as dynamic);
  });

  test('возвращает UserModel, если запись найдена', () async {
    const userId = 'uid';
    final json = {
      'id': userId,
      'name': 'Test',
      'avatar_url': null,
      'current_level': 1,
      'onboarding_completed': true,
      'is_premium': false,
      'leo_messages_total': 0,
      'leo_messages_today': 0,
      'leo_reset_at': null,
    };

    when(() => (builder as dynamic).maybeSingle())
        .thenAnswer((_) async => json);

    final user = await repository.fetchProfile(userId);

    expect(user, isA<UserModel>());
    expect(user?.id, userId);
  });

  test('возвращает null, если запись отсутствует', () async {
    when(() => (builder as dynamic).maybeSingle())
        .thenAnswer((_) async => null);

    final user = await repository.fetchProfile('uid');
    expect(user, isNull);
  });

  test('возвращает null при PostgrestException', () async {
    when(() => (builder as dynamic).maybeSingle())
        .thenThrow(PostgrestException(message: 'Err', code: 'PGRST116'));

    final user = await repository.fetchProfile('uid');
    expect(user, isNull);
  });
}
