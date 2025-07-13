import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/models/level_model.dart';
import 'package:online_course/services/supabase_service.dart';

/// Provides список уровней в формате, удобном для LevelCard.
final levelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // Запрашиваем количество уроков агрегатом lessons(count)
  final rows = await SupabaseService.client
      .from('levels')
      .select(
          'id, number, title, description, image_url, is_free, lessons(count)')
      .order('number', ascending: true);

  return rows.map((json) {
    final level = LevelModel.fromJson(json);

    // Простая логика блокировки: первые 3 уровни бесплатны.
    final bool isLocked = !level.isFree && level.number > 3;

    return {
      'id': level.id,
      'image': level.imageUrl,
      'level': level.number,
      'name': level.title,
      'lessons': () {
        final lessonsAgg = json['lessons'];
        if (lessonsAgg is List && lessonsAgg.isNotEmpty) {
          return (lessonsAgg.first['count'] as int? ?? 0);
        }
        return 0;
      }(),
      'isLocked': isLocked,
    };
  }).toList();
});
