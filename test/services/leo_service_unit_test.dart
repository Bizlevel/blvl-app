import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_course/services/leo_service.dart';

// -------------------- Моки --------------------
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class FakePostgrestFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  @override
  noSuchMethod(Invocation invocation) => Future.value(8);
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  late MockSupabaseClient client;
  late MockGoTrueClient auth;
  late LeoService service;
  late MockUser user;

  setUp(() {
    client = MockSupabaseClient();
    auth = MockGoTrueClient();
    user = MockUser();

    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(user);
    when(() => user.id).thenReturn('uid');

    service = LeoService(client);
  });

  // Только decrementMessageCount тестируем – не требует сложного builder.

  group('decrementMessageCount', () {
    test('возвращает новое значение счётчика', () async {
      final fakeBuilder = FakePostgrestFilterBuilder();
      when(() => client.rpc('decrement_leo_message'))
          .thenAnswer((_) => fakeBuilder);

      final left = await service.decrementMessageCount();
      expect(left, 8);
      verify(() => client.rpc('decrement_leo_message')).called(1);
    });

    test('бросает LeoFailure, если не авторизован', () async {
      when(() => auth.currentUser).thenReturn(null);
      expect(service.decrementMessageCount(), throwsA(isA<LeoFailure>()));
    });
  });
}
