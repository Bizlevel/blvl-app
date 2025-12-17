import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/repositories/goals_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockQueryBuilder extends Mock implements SupabaseQueryBuilder {}

void main() {
  late GoalsRepository repository;

  setUp(() {
    final client = _MockSupabaseClient();
    final builder = _MockQueryBuilder();
    when(() => client.from(any())).thenAnswer((_) => builder);
    when(() => builder.select(any()))
        .thenThrow(const SocketException('offline'));
    repository = GoalsRepository(client);
  });

  group('GoalsRepository', () {
    test('getDailyQuote returns null when offline', () async {
      final q = await repository.getDailyQuote();
      expect(q, isNull);
    });
  });
}
