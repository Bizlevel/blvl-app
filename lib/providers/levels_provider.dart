import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/models/level_model.dart';
import 'package:online_course/services/supabase_service.dart';

/// Provides список уровней в формате, удобном для LevelCard.
final levelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // Получаем "сырые" записи из таблицы levels
  final rows = await SupabaseService.fetchLevelsRaw();

  return rows.map((json) {
    final level = LevelModel.fromJson(json);

    // Простая логика блокировки: первые 3 уровни бесплатны.
    final bool isLocked = !level.isFree && level.number > 3;

    return {
      'image': level.imageUrl,
      'level': level.number,
      'name': level.title,
      'lessons':
          json['lessons_count'] ?? 0, // TODO: заменить реальным количеством
      'isLocked': isLocked,
    };
  }).toList();
});
