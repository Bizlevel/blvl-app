import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class LessonsRepository {
  final SupabaseClient _client;
  LessonsRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchLessons(int levelId) async {
    return SupabaseService.fetchLessonsRaw(levelId);
  }

  Future<String?> getVideoSignedUrl(String relativePath) async {
    return SupabaseService.getVideoSignedUrl(relativePath);
  }
}
