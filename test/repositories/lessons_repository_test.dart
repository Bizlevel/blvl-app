import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/repositories/lessons_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late Directory tempDir;
  late Box box;
  late LessonsRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(p.join(tempDir.path, 'hive_lessons'));
    box = await Hive.openBox('lessons');
  });

  tearDownAll(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() {
    repository = LessonsRepository(_MockSupabaseClient());
    box.clear();
  });

  group('LessonsRepository.fetchLessons', () {
    test('returns cached when offline', () async {
      const levelId = 1;
      final cachedData = [
        {'id': 10, 'level_id': levelId, 'title': 'Lesson 1'},
      ];
      await box.put('level_$levelId', cachedData);

      final result = await repository.fetchLessons(levelId);
      expect(result, cachedData);
    });

    test('throws when no cache and offline', () async {
      expect(() => repository.fetchLessons(999), throwsException);
    });
  });
}
