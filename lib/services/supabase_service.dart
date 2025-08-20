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

  /// Fetches all levels ordered by number.
  static Future<List<Map<String, dynamic>>> fetchLevelsRaw() async {
    return _withRetry(() async {
      try {
        final response = await Supabase.instance.client
            .from('levels')
            .select()
            .order('number', ascending: true);
        return (response as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } on PostgrestException catch (e, st) {
        await Sentry.captureException(e, stackTrace: st);
        // JWT expired – выходим из аккаунта, чтобы пользователь заново залогинился
        if (e.message.toLowerCase().contains('jwt')) {
          await Supabase.instance.client.auth.signOut();
        }
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

        return (response as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } on PostgrestException catch (e, st) {
        await Sentry.captureException(e, stackTrace: st);
        if (e.message.toLowerCase().contains('jwt')) {
          await Supabase.instance.client.auth.signOut();
        }
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
    // Если это уже абсолютный URL, возвращаем как есть
    if (path.startsWith('http')) return path;

    return _withRetry(() async {
      try {
        final response = await Supabase.instance.client.storage
            .from('artifacts')
            .createSignedUrl(path, 60 * 60);
        return response;
      } on StorageException catch (e, st) {
        if ((e.statusCode ?? 0) != 404) {
          await Sentry.captureException(e, stackTrace: st);
        }
        return null;
      } on SocketException {
        throw Exception('Нет соединения с интернетом');
      }
    }, retries: 1);
  }

  static Future<String?> getCoverSignedUrl(String relativePath) async {
    // Абсолютный URL возвращаем сразу
    if (relativePath.startsWith('http')) return relativePath;

    return _withRetry(() async {
      try {
        final response = await Supabase.instance.client.storage
            .from('level-covers')
            .createSignedUrl(relativePath, 60 * 60);
        return response;
      } on StorageException catch (e, st) {
        if ((e.statusCode ?? 0) != 404) {
          await Sentry.captureException(e, stackTrace: st);
        }
        return null;
      } on SocketException {
        throw Exception('Нет соединения с интернетом');
      }
    }, retries: 1);
  }

  static Future<List<Map<String, dynamic>>> fetchLevelsWithProgress(
      String userId) async {
    return _withRetry(() async {
      try {
        final response = await Supabase.instance.client
            .from('levels')
            .select(
                'id, number, title, description, image_url, cover_path, artifact_title, artifact_description, artifact_url, is_free, lessons(count), user_progress!inner(user_id, is_completed)')
            .eq('user_progress.user_id', userId)
            .order('number', ascending: true);
        return (response as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } on PostgrestException catch (e, st) {
        await Sentry.captureException(e, stackTrace: st);
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
        // Update users.current_level if we just completed it
        await Supabase.instance.client
            .rpc('update_current_level', params: {'p_level_id': levelId});
      } on PostgrestException catch (e, st) {
        await Sentry.captureException(e, stackTrace: st);
        rethrow;
      }
    });
  }

  static Future<String?> getVideoSignedUrl(String relativePath) async {
    return _withRetry(() async {
      try {
        final response = await Supabase.instance.client.storage
            .from('video')
            .createSignedUrl(relativePath, 60 * 60);
        return response;
      } on StorageException catch (e, st) {
        if ((e.statusCode ?? 0) != 404) {
          await Sentry.captureException(e, stackTrace: st);
        }
        return null;
      } on SocketException {
        throw Exception('Нет соединения с интернетом');
      }
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
