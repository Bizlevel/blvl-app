import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/leo_service.dart';

// -------------------- Моки --------------------
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockSession extends Mock implements Session {}

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
  late MockSession session;

  setUp(() {
    client = MockSupabaseClient();
    auth = MockGoTrueClient();
    user = MockUser();
    session = MockSession();

    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(user);
    when(() => auth.currentSession).thenReturn(session);
    when(() => user.id).thenReturn('uid');
    when(() => session.accessToken).thenReturn('fake_jwt_token');

    service = LeoService(client);
  });

  // Только decrementMessageCount тестируем – не требует сложного builder.
  // Контракт ответа /leo-chat не менялся.
  // Добавлен режим bot, но дефолт 'leo' сохраняет обратную совместимость.

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

  // Тест на sendMessage/saveConversation намеренно не добавляем —
  // требует сложных моков PostgREST и покрыт интеграционными/UI‑тестами.
}
