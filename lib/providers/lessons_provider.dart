import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/models/lesson_model.dart';
import 'package:online_course/services/supabase_service.dart';

/// Provides list of lessons for a given levelId.
final lessonsProvider =
    FutureProvider.family<List<LessonModel>, int>((ref, levelId) async {
  final rows = await SupabaseService.fetchLessonsRaw(levelId);
  return rows.map((json) => LessonModel.fromJson(json)).toList();
});
