import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

import '../services/supabase_service.dart';
import 'package:bizlevel/utils/hive_box_helper.dart';

class LessonsRepository {
  // ignore: unused_field
  final SupabaseClient _client;
  LessonsRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchLessons(int levelId) async {
    final String cacheKey = 'level_$levelId';
    Future<List<Map<String, dynamic>>?> readCached() async {
      final cached = await HiveBoxHelper.readValue('lessons', cacheKey);
      if (cached == null) return null;
      try {
        return List<Map<String, dynamic>>.from(
          (cached as List).map((e) => Map<String, dynamic>.from(e as Map)),
        );
      } catch (_) {
        return null;
      }
    }

    try {
      final data = await SupabaseService.fetchLessonsRaw(levelId);
      HiveBoxHelper.putDeferred('lessons', cacheKey, data);
      return data;
    } on SocketException {
      final cached = await readCached();
      if (cached != null) return cached;
      rethrow;
    } catch (_) {
      final cached = await readCached();
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<String?> getVideoSignedUrl(String relativePath) async {
    return SupabaseService.getVideoSignedUrl(relativePath);
  }
}
