import 'dart:io';
import 'package:bizlevel/repositories/library_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late Directory tempDir;
  late Box box;
  late LibraryRepository repository;
  late _MockSupabaseClient client;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(p.join(tempDir.path, 'hive'));
    box = await Hive.openBox('library');
  });

  tearDownAll(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() async {
    client = _MockSupabaseClient();
    repository = LibraryRepository(client);
    // Важно: clear() async. Без await возможна гонка и флейки (кеш очищается после put()).
    await box.clear();
  });

  test('fetchCourses returns cached on offline', () async {
    final cached = [
      {'id': 'c1', 'title': 'Course 1'},
    ];
    await box.put('courses.v3:_all', cached);

    // Эмулируем офлайн: любой доступ к таблице бросает SocketException
    when(() => client.from(any())).thenThrow(const SocketException('offline'));

    final result = await repository.fetchCourses();
    expect(result, cached);
  });
}
