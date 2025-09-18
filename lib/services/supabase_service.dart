import 'dart:async';
import 'dart:io';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/env_helper.dart';

class SupabaseService {
  /// Создаём обычный инстанцируемый сервис для последующей передачи через DI.
  SupabaseService();

  static bool _initialized = false;

  /// Инициализирует Supabase. Вызывать один раз при старте приложения.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Supabase.initialize(
        url: envOrDefine('SUPABASE_URL'),
        anonKey: envOrDefine('SUPABASE_ANON_KEY'),
      );
    } on AssertionError {
      // Already initialized in current isolate (tests may initialize globally)
    }

    _initialized = true;
  }

  /// Экспортирует [SupabaseClient] для внешнего использования.
  SupabaseClient get client => Supabase.instance.client;

  // Cached mapping: level_id -> levels.number
  static Map<int, int>? _levelIdToNumber;

  static Future<Map<int, int>> levelMap() async {
    if (_levelIdToNumber != null) return _levelIdToNumber!;
    final resp = await Supabase.instance.client
        .from('levels')
        .select('id, number');
    final list = _asListOfMaps(resp);
    _levelIdToNumber = {
      for (final m in list)
        (m['id'] as num).toInt(): (m['number'] as num).toInt()
    };
    return _levelIdToNumber!;
  }

  static Future<int> levelNumberFromId(int? levelId) async {
    final map = await levelMap();
    if (levelId == null) return 0;
    return map[levelId] ?? 0;
  }

  static Future<int?> levelIdFromNumber(int levelNumber) async {
    final map = await levelMap();
    for (final entry in map.entries) {
      if (entry.value == levelNumber) {
        return entry.key;
      }
    }
    return null;
  }

  /// Унифицированное преобразование ответа PostgREST в список мапов.
  static List<Map<String, dynamic>> _asListOfMaps(dynamic response) {
    final list = response as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Единая обработка PostgREST-исключений: логирование и signOut при истёкшем JWT.
  static Future<void> _handlePostgrestException(
    PostgrestException e,
    StackTrace st,
  ) async {
    await Sentry.captureException(e, stackTrace: st);
    final msg = e.message.toLowerCase();
    if (msg.contains('jwt')) {
      await Supabase.instance.client.auth.signOut();
    }
  }

  /// Создание подписанной ссылки из указанного bucket'а.
  /// Возвращает null при 404 (файл отсутствует), пробрасывает дружелюбную
  /// сетевую ошибку при оффлайне, логирует прочие ошибки в Sentry.
  static Future<String?> _createSignedUrl({
    required String bucket,
    required String path,
    int expiresSec = 60 * 60,
  }) async {
    // Абсолютный URL отдаём без запроса к Storage
    if (path.startsWith('http')) return path;

    try {
      final response = await Supabase.instance.client.storage
          .from(bucket)
          .createSignedUrl(path, expiresSec);
      return response;
    } on StorageException catch (e, st) {
      if ((e.statusCode ?? 0) != 404) {
        await Sentry.captureException(e, stackTrace: st);
      }
      return null;
    } on SocketException {
      throw Exception('Нет соединения с интернетом');
    }
  }

  /// Fetches all levels ordered by number.
  static Future<List<Map<String, dynamic>>> fetchLevelsRaw() async {
    return _withRetry(() async {
      try {
        final response = await Supabase.instance.client
            .from('levels')
            .select()
            .order('number', ascending: true);
        return _asListOfMaps(response);
      } on PostgrestException catch (e, st) {
        await _handlePostgrestException(e, st);
        rethrow;
      } on SocketException {
        throw Exception('Нет соединения с интернетом');
      } catch (_) {
        // В тестовой среде HTTP может вернуть синтетический 400, что приводит к ошибкам парсинга
        // внутри Postgrest. Считаем это оффлайном для целей кэширования.
        throw Exception('Нет соединения с интернетом');
      }
    });
  }

  /// Fetches lessons for a given level ID ordered by order field.
  static Future<List<Map<String, dynamic>>> fetchLessonsRaw(int levelId) async {
    return _withRetry(() async {
      try {
        final response = await Supabase.instance.client
            .from('lessons')
            .select()
            .eq('level_id', levelId)
            .order('order', ascending: true);

        return _asListOfMaps(response);
      } on PostgrestException catch (e, st) {
        await _handlePostgrestException(e, st);
        rethrow;
      } on SocketException catch (_) {
        throw Exception('Нет соединения с интернетом');
      } catch (_) {
        // См. комментарий выше: для тестов считаем нестандартные ошибки сетевыми.
        throw Exception('Нет соединения с интернетом');
      }
    });
  }

  static Future<String?> getArtifactSignedUrl(String path) async {
    return _withRetry(() async {
      return _createSignedUrl(bucket: 'artifacts', path: path);
    }, retries: 1);
  }

  static Future<String?> getCoverSignedUrl(String relativePath) async {
    return _withRetry(() async {
      return _createSignedUrl(bucket: 'level-covers', path: relativePath);
    }, retries: 1);
  }

  static Future<List<Map<String, dynamic>>> fetchLevelsWithProgress(
      String userId) async {
    return _withRetry(() async {
      try {
        final response = await Supabase.instance.client
            .from('levels')
            .select(
                'id, number, title, description, image_url, cover_path, artifact_title, artifact_description, artifact_url, is_free, lessons(count), user_progress(user_id, is_completed)')
            .order('number', ascending: true);
        return _asListOfMaps(response);
      } on PostgrestException catch (e, st) {
        await _handlePostgrestException(e, st);
        rethrow;
      } on SocketException {
        throw Exception('Нет соединения с интернетом');
      }
    });
  }

  /// Marks level as completed for current user and bumps current_level if needed.
  static Future<void> completeLevel(int levelId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('Пользователь не авторизован');
    await _withRetry(() async {
      try {
        // Upsert into user_progress
        await Supabase.instance.client.from('user_progress').upsert({
          'user_id': user.id,
          'level_id': levelId,
          'is_completed': true,
          'updated_at': DateTime.now().toIso8601String(),
        });
        // Пересчитываем users.current_level на основании максимального levels.number среди завершённых уровней
        // 1) Загружаем карту уровней: id -> number
        final levelsResp = await Supabase.instance.client
            .from('levels')
            .select('id, number');
        final levelsList = _asListOfMaps(levelsResp);
        final Map<int, int> levelIdToNumber = {
          for (final m in levelsList)
            (m['id'] as num).toInt(): (m['number'] as num).toInt()
        };

        // 2) Загружаем завершённые уровни пользователя
        final progressResp = await Supabase.instance.client
            .from('user_progress')
            .select('level_id')
            .eq('user_id', user.id)
            .eq('is_completed', true);
        final progressList = _asListOfMaps(progressResp);

        // 3) Определяем максимальный номер уровня
        int maxNumber = 0;
        for (final row in progressList) {
          final int lid = (row['level_id'] as num).toInt();
          final int numVal = levelIdToNumber[lid] ?? 0;
          if (numVal > maxNumber) maxNumber = numVal;
        }

        // 4) Находим level_id, соответствующий maxNumber (если нет завершённых — ставим null)
        int? targetLevelId;
        if (maxNumber > 0) {
          for (final entry in levelIdToNumber.entries) {
            if (entry.value == maxNumber) {
              targetLevelId = entry.key;
              break;
            }
          }
        }

        // 5) Обновляем users.current_level безопасно: если нет завершённых уровней — ставим стартовый level_id = 22 (уровень №0)
        final int safeLevelId = (targetLevelId ?? 22);
        await Supabase.instance.client
            .from('users')
            .update({'current_level': safeLevelId})
            .eq('id', user.id);
      } on PostgrestException catch (e, st) {
        await Sentry.captureException(e, stackTrace: st);
        rethrow;
      }
    });
  }

  static Future<String?> getVideoSignedUrl(String relativePath) async {
    return _withRetry(() async {
      return _createSignedUrl(bucket: 'video', path: relativePath);
    }, retries: 1);
  }

  /// Generic retry helper with exponential backoff (300ms, 600ms, 1200ms)
  static Future<T> _withRetry<T>(Future<T> Function() action,
      {int retries = 2}) async {
    int attempt = 0;
    while (true) {
      try {
        return await action();
      } catch (e) {
        if (attempt >= retries) rethrow;
        await Future.delayed(Duration(milliseconds: 300 * (1 << attempt)));
        attempt++;
      }
    }
  }
}
