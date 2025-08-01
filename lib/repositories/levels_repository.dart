import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

import '../services/supabase_service.dart';

class LevelsRepository {
  // ignore: unused_field
  final SupabaseClient _client;
  LevelsRepository(this._client);

  /// Загружает уровни. Если [userId] передан, включает прогресс.
  Future<List<Map<String, dynamic>>> fetchLevels({String? userId}) async {
    final Box cache = Hive.box('levels');
    final String cacheKey = userId == null ? 'public' : 'user_$userId';

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

      await cache.put(cacheKey, resolved);
      return resolved;
    } on SocketException {
      // Нет интернета → читаем из кеша
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      rethrow;
    } catch (_) {
      // При любой другой ошибке пробуем вернуть кеш
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      rethrow;
    }
  }

  /// Возвращает подписанный URL артефакта.
  Future<String?> getArtifactSignedUrl(String relativePath) async {
    return SupabaseService.getArtifactSignedUrl(relativePath);
  }
}
