import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

import '../services/supabase_service.dart';
import 'package:bizlevel/utils/hive_box_helper.dart';

class LevelsRepository {
  // ignore: unused_field
  final SupabaseClient _client;
  LevelsRepository(this._client);

  /// Загружает уровни. Если [userId] передан, включает прогресс.
  Future<List<Map<String, dynamic>>> fetchLevels({String? userId}) async {
    final String cacheKey = userId == null ? 'public' : 'user_$userId';
    Future<List<Map<String, dynamic>>?> readCached() async {
      final cached = await HiveBoxHelper.readValue('levels', cacheKey);
      if (cached == null) return null;
      try {
        return List<Map<String, dynamic>>.from(
          (cached as List).map((e) => Map<String, dynamic>.from(e as Map)),
        );
      } catch (_) {
        return null;
      }
    }

    // Сначала пытаемся запросить сервер.
    try {
      final data = userId == null
          ? await SupabaseService.fetchLevelsRaw()
          : await SupabaseService.fetchLevelsWithProgress(userId);

      // Сохраняем в кеш (Hive поддерживает Map/List примитивов)
      final resolved = await Future.wait(data.map((level) async {
        final String? coverPath = level['cover_path'] as String?;
        String? imageUrl;
        if (coverPath != null && coverPath.isNotEmpty) {
          imageUrl = await SupabaseService.getCoverSignedUrl(coverPath);
        }

        level['image'] = imageUrl ?? level['image_url'] ?? level['image'];
        return level;
      }));

      HiveBoxHelper.putDeferred('levels', cacheKey, resolved);
      return resolved;
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

  /// Возвращает подписанный URL артефакта.
  Future<String?> getArtifactSignedUrl(String relativePath) async {
    return SupabaseService.getArtifactSignedUrl(relativePath);
  }
}
