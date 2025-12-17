import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../services/supabase_service.dart';
import '../utils/hive_box_helper.dart';

class LevelsRepository {
  // ignore: unused_field
  final SupabaseClient _client;
  LevelsRepository(this._client);

  /// Загружает уровни. Если [userId] передан, включает прогресс.
  /// Для Web: без Hive кеша (только сеть).
  /// Для Mobile: с Hive кешем и offline fallback.
  Future<List<Map<String, dynamic>>> fetchLevels({String? userId}) async {
    // Web: работаем только через сеть, без кеша
    if (kIsWeb) {
      return _fetchFromNetwork(userId);
    }

    // Mobile: используем Hive кеш
    return _fetchWithCache(userId);
  }

  /// Загрузка с сервера без кеширования (для Web)
  Future<List<Map<String, dynamic>>> _fetchFromNetwork(String? userId) async {
    final data = userId == null
        ? await SupabaseService.fetchLevelsRaw()
        : await SupabaseService.fetchLevelsWithProgress(userId);

    return _resolveImages(data);
  }

  /// Загрузка с Hive кешем и offline fallback (для Mobile)
  Future<List<Map<String, dynamic>>> _fetchWithCache(String? userId) async {
    final Box cache = await HiveBoxHelper.openBox('levels');
    final String cacheKey = userId == null ? 'public' : 'user_$userId';

    try {
      final data = userId == null
          ? await SupabaseService.fetchLevelsRaw()
          : await SupabaseService.fetchLevelsWithProgress(userId);

      final resolved = await _resolveImages(data);
      await cache.put(cacheKey, resolved);
      return resolved;
    } catch (_) {
      // При ошибке пробуем вернуть кеш
      final cached = cache.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached);
      }
      rethrow;
    }
  }

  /// Резолвит URL изображений для уровней
  Future<List<Map<String, dynamic>>> _resolveImages(
      List<Map<String, dynamic>> data) async {
    return Future.wait(data.map((level) async {
      final String? coverPath = level['cover_path'] as String?;
      String? imageUrl;
      if (coverPath != null && coverPath.isNotEmpty) {
        imageUrl = await SupabaseService.getCoverSignedUrl(coverPath);
      }
      level['image'] = imageUrl ?? level['image_url'] ?? level['image'];
      return level;
    }));
  }

  /// Возвращает подписанный URL артефакта.
  Future<String?> getArtifactSignedUrl(String relativePath) async {
    return SupabaseService.getArtifactSignedUrl(relativePath);
  }
}
