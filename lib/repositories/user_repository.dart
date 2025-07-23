import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

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

      final response =
          await _client.from('users').select().eq('id', userId).maybeSingle();

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
}
