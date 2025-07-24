import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

import '../services/supabase_service.dart';

class LessonsRepository {
  // ignore: unused_field
  final SupabaseClient _client;
  LessonsRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchLessons(int levelId) async {
    final Box cache = Hive.box('lessons');
    final String cacheKey = 'level_$levelId';

    try {
      final data = await SupabaseService.fetchLessonsRaw(levelId);
      await cache.put(cacheKey, data);
      return data;
    } on SocketException {
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      rethrow;
    } catch (_) {
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      rethrow;
    }
  }

  Future<String?> getVideoSignedUrl(String relativePath) async {
    return SupabaseService.getVideoSignedUrl(relativePath);
  }
}
