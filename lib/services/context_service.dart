import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/services/supabase_service.dart';

/// Centralized builder for Leo chat personalization contexts.
/// Keeps userContext/levelContext consistent across screens.
class ContextService {
  const ContextService._();

  /// Builds rich userContext string or returns null if nothing to add.
  static Future<String?> buildUserContext(UserModel? user) async {
    if (user == null) return null;
    final parts = <String>[];
    if (user.goal?.isNotEmpty == true) parts.add('Цель: ${user.goal}');
    if (user.about?.isNotEmpty == true) parts.add('О себе: ${user.about}');
    if (user.businessArea?.isNotEmpty == true) {
      parts.add('Сфера: ${user.businessArea}');
    }
    if (user.experienceLevel?.isNotEmpty == true) {
      parts.add('Опыт: ${user.experienceLevel}');
    }
    if (user.businessSize?.isNotEmpty == true) {
      parts.add('Размер бизнеса: ${user.businessSize}');
    }
    if ((user.keyChallenges ?? const []).isNotEmpty) {
      parts.add('Вызовы: ${(user.keyChallenges!).join(', ')}');
    }
    if (user.learningStyle?.isNotEmpty == true) {
      parts.add('Стиль: ${user.learningStyle}');
    }
    if (user.businessRegion?.isNotEmpty == true) {
      parts.add('Регион: ${user.businessRegion}');
    }
    // Важно: текущий уровень включаем для персонализации в двух видах
    final levelNum = await SupabaseService.levelNumberFromId(user.currentLevel);
    parts.add('Текущий уровень: $levelNum (level_id: ${user.currentLevel})');
    return parts.isNotEmpty ? parts.join('. ') : null;
  }

  /// Builds levelContext string. Server can parse `level_id: <id>`.
  static Future<String?> buildLevelContext(UserModel? user) async {
    if (user == null) return null;
    final int levelId = user.currentLevel;
    final int levelNum = await SupabaseService.levelNumberFromId(levelId);
    // Используем чёткий формат, который сервер умеет парсить через regex
    // и дополняем человекочитаемым номером
    return 'level_id: $levelId, current_level_number: $levelNum';
  }
}


