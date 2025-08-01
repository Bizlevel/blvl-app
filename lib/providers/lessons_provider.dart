import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/providers/lessons_repository_provider.dart';

/// Provides list of lessons for a given levelId.
final lessonsProvider =
    FutureProvider.family<List<LessonModel>, int>((ref, levelId) async {
  final repo = ref.watch(lessonsRepositoryProvider);
  final rows = await repo.fetchLessons(levelId);
  return rows.map((json) => LessonModel.fromJson(json)).toList();
});
