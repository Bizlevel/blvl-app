import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/services/supabase_service.dart';

/// Centralized builder for Leo chat personalization contexts.
/// Keeps userContext/levelContext consistent across screens.
class ContextService {
  const ContextService._();

  static String? _sanitizeText(String? value, {int maxLen = 180}) {
    if (value == null) return null;
    final cleaned = value
        .replaceAll(RegExp(r'[\u0000-\u001F\u007F]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return null;
    if (cleaned.length <= maxLen) return cleaned;
    return '${cleaned.substring(0, maxLen)}...';
  }

  static List<String> _sanitizeList(List<String>? values,
      {int maxItems = 10, int maxLen = 60}) {
    if (values == null || values.isEmpty) return const [];
    final cleaned = <String>[];
    for (final v in values) {
      final item = _sanitizeText(v, maxLen: maxLen);
      if (item != null) cleaned.add(item);
      if (cleaned.length >= maxItems) break;
    }
    return cleaned;
  }

  /// Builds rich userContext string or returns null if nothing to add.
  static Future<String?> buildUserContext(UserModel? user) async {
    if (user == null) return null;
    final parts = <String>[];
    final goal = _sanitizeText(user.goal);
    if (goal != null) parts.add('Цель: $goal');
    final about = _sanitizeText(user.about);
    if (about != null) parts.add('О себе: $about');
    final businessArea = _sanitizeText(user.businessArea);
    if (businessArea != null) parts.add('Сфера: $businessArea');
    final experienceLevel = _sanitizeText(user.experienceLevel);
    if (experienceLevel != null) parts.add('Опыт: $experienceLevel');
    final businessSize = _sanitizeText(user.businessSize);
    if (businessSize != null) parts.add('Размер бизнеса: $businessSize');
    final challenges = _sanitizeList(user.keyChallenges);
    if (challenges.isNotEmpty) {
      parts.add('Вызовы: ${challenges.join(', ')}');
    }
    final learningStyle = _sanitizeText(user.learningStyle);
    if (learningStyle != null) parts.add('Стиль: $learningStyle');
    final businessRegion = _sanitizeText(user.businessRegion);
    if (businessRegion != null) parts.add('Регион: $businessRegion');
    // Текущий уровень: используем нормализованный номер и, если возможно, id
    final levelNum =
        await SupabaseService.resolveCurrentLevelNumber(user.currentLevel);
    final levelId = await SupabaseService.levelIdFromNumber(levelNum);
    if (levelId != null) {
      parts.add('Текущий уровень: $levelNum (level_id: $levelId)');
    } else {
      parts.add('Текущий уровень: $levelNum');
    }
    return parts.isNotEmpty ? parts.join('. ') : null;
  }

  /// Builds levelContext string. Server can parse `level_id: <id>`.
  static Future<String?> buildLevelContext(UserModel? user) async {
    if (user == null) return null;
    final int levelNum =
        await SupabaseService.resolveCurrentLevelNumber(user.currentLevel);
    final int? levelId = await SupabaseService.levelIdFromNumber(levelNum);
    if (levelId != null) {
      return 'level_number: $levelNum, level_id: $levelId';
    }
    return 'level_number: $levelNum';
  }
}
