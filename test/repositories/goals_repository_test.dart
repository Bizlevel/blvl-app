import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/repositories/goals_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockPostgrest extends Mock implements PostgrestClient {}

class _MockQueryBuilder extends Mock implements SupabaseQueryBuilder {}

void main() {
  late Directory tempDir;
  late Box goalsBox;
  late Box weeklyBox;
  late Box quotesBox;
  late GoalsRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(p.join(tempDir.path, 'hive'));
    goalsBox = await Hive.openBox('goals');
    weeklyBox = await Hive.openBox('weekly_progress');
    quotesBox = await Hive.openBox('quotes');
  });

  tearDownAll(() async {
    await goalsBox.close();
    await weeklyBox.close();
    await quotesBox.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() {
    final client = _MockSupabaseClient();
    final builder = _MockQueryBuilder();
    // По умолчанию все сетевые вызовы бросают SocketException (эмулируем офлайн)
    when(() => client.from(any())).thenReturn(builder);
    when(() => builder.select(any()))
        .thenThrow(const SocketException('offline'));
    repository = GoalsRepository(client);
    goalsBox.clear();
    weeklyBox.clear();
    quotesBox.clear();
  });

  group('GoalsRepository SWR', () {
    test('fetchLatestGoal returns cache when offline', () async {
      final userId = 'u1';
      final key = 'latest_$userId';
      final cached = {
        'id': 'g1',
        'user_id': userId,
        'version': 1,
        'goal_text': 'Моя цель',
        'version_data': {
          'goal_initial': 'Протестировать',
          'goal_why': 'Важно',
          'main_obstacle': 'Нет времени'
        }
      };
      await goalsBox.put(key, cached);

      final result = await repository.fetchLatestGoal(userId);

      expect(result, isNotNull);
      expect(result!['id'], 'g1');
    });

    test('fetchSprint returns cache when offline', () async {
      final key = 'sprint_2';
      final cached = {
        'sprint_number': 2,
        'achievement': 'Сделано X',
      };
      await weeklyBox.put(key, cached);

      final result = await repository.fetchSprint(2);
      expect(result, isNotNull);
      expect(result!['achievement'], 'Сделано X');
    });

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
