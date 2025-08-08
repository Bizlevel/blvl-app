import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../models/user_skill_model.dart';

/// Репозиторий, отвечающий за загрузку и сохранение данных пользователя.
///
/// Вынесение доступа к таблице `users` в отдельный класс упрощает
/// переиспользование логики и делает код более тестируемым.
class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  /// Загружает профиль пользователя по его [userId].
  /// Возвращает [UserModel] либо `null`, если запись ещё не создана.
  Future<UserModel?> fetchProfile(String userId) async {
    try {
      if (kDebugMode) {
        debugPrint(
            'UserRepository.fetchProfile: querying users table for $userId');
      }

      final response = await _client
          .from('users')
          .select(
              'id, name, email, about, goal, onboarding_completed, current_level, leo_messages_today, leo_messages_total, is_premium, avatar_id')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        if (kDebugMode) {
          debugPrint('UserRepository.fetchProfile: no record for $userId');
        }
        return null;
      }

      final user = UserModel.fromJson(response);
      if (kDebugMode) {
        debugPrint('UserRepository.fetchProfile: loaded user ${user.id}');
      }
      return user;
    } on PostgrestException catch (e) {
      if (kDebugMode) {
        debugPrint(
            'UserRepository.fetchProfile: PostgrestException ${e.code} ${e.message}');
      }
      // таблица существует, но записи нет или другая ошибка – вернём null
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('UserRepository.fetchProfile: unexpected error = $e');
      }
      return null;
    }
  }

  /// Загружает полный список навыков (5) с очками пользователя.
  /// Если пользователь ещё не заработал очки по навыку, points = 0.
  Future<List<UserSkillModel>> fetchUserSkills(String userId) async {
    try {
      // 1. Загружаем все навыки каталога.
      final catalog = await _client.from('skills').select('id, name');
      final Map<int, String> skillCatalog = {
        for (final row in (catalog as List))
          row['id'] as int: row['name'] as String,
      };

      // 2. Загружаем очки пользователя.
      final raw = await _client
          .from('user_skills')
          .select('skill_id, points')
          .eq('user_id', userId);

      final Map<int, int> pointsBySkill = {
        for (final row in (raw as List))
          row['skill_id'] as int: row['points'] as int,
      };

      // 3. Составляем результирующий список из каталога, заполняя 0, если нет очков.
      final result = skillCatalog.entries.map((e) {
        return UserSkillModel(
          userId: userId,
          skillId: e.key,
          skillName: e.value,
          points: pointsBySkill[e.key] ?? 0,
        );
      }).toList()
        ..sort((a, b) => a.skillId.compareTo(b.skillId));

      return result;
    } catch (e) {
      debugPrint('Error fetching user skills: $e');
      return [];
    }
  }
}
