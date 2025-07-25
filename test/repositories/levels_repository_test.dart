import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/repositories/levels_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late Directory tempDir;
  late Box box;
  late LevelsRepository repository;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(p.join(tempDir.path, 'hive'));
    box = await Hive.openBox('levels');
  });

  tearDownAll(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() {
    repository = LevelsRepository(_MockSupabaseClient());
    box.clear();
  });

  group('LevelsRepository.fetchLevels', () {
    test('returns cached data when offline', () async {
      final cachedData = [
        {'id': 1, 'number': 1, 'title': 'Level 1'},
      ];
      await box.put('public', cachedData);

      final result = await repository.fetchLevels();

      expect(result, cachedData);
    });

    test('throws when no cache and offline', () async {
      expect(() => repository.fetchLevels(), throwsException);
    });
  });
}
