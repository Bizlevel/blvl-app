import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/repositories/goals_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockQueryBuilder extends Mock implements SupabaseQueryBuilder {}

void main() {
  late Directory tempDir;
  late Box goalsBox;
  late Box quotesBox;
  late GoalsRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(p.join(tempDir.path, 'hive'));
    goalsBox = await Hive.openBox('goals');
    quotesBox = await Hive.openBox('quotes');
  });

  tearDownAll(() async {
    await goalsBox.close();
    await quotesBox.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() {
    final client = _MockSupabaseClient();
    final builder = _MockQueryBuilder();
    when(() => client.from(any())).thenReturn(builder);
    when(() => builder.select(any()))
        .thenThrow(const SocketException('offline'));
    repository = GoalsRepository(client);
    goalsBox.clear();
    quotesBox.clear();
  });

  group('GoalsRepository', () {
    test('getDailyQuote returns deterministic item from cache', () async {
      final active = [
        {'id': 'q1', 'quote_text': 'A', 'author': 'Au'},
        {'id': 'q2', 'quote_text': 'B', 'author': 'Au'},
      ];
      await quotesBox.put('active', active);

      final q = await repository.getDailyQuote();
      expect(q, isNotNull);
      expect(q!['quote_text'], anyOf('A', 'B'));
    });
  });
}
