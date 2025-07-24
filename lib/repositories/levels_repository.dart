import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class LevelsRepository {
  final SupabaseClient _client;
  LevelsRepository(this._client);

  /// Загружает уровни. Если [userId] передан, включает прогресс.
  Future<List<Map<String, dynamic>>> fetchLevels({String? userId}) async {
    if (userId == null) {
      return SupabaseService.fetchLevelsRaw();
    }
    return SupabaseService.fetchLevelsWithProgress(userId);
  }

  /// Возвращает подписанный URL артефакта.
  Future<String?> getArtifactSignedUrl(String relativePath) async {
    return SupabaseService.getArtifactSignedUrl(relativePath);
  }
}
