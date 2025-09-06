import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Репозиторий Библиотеки (курсы/гранты/акселераторы/избранное) с SWR‑кешем на Hive.
class LibraryRepository {
  final SupabaseClient _client;
  LibraryRepository(this._client);

  Future<Box> _openBox() => Hive.openBox('library');

  Future<List<Map<String, dynamic>>> _fetchListSWR({
    required String cacheKey,
    required Future<List<dynamic>> Function() fetch,
  }) async {
    final box = await _openBox();
    try {
      final rows = await fetch();
      final data =
          rows.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      await box.put(cacheKey, data);
      return data;
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached as List);
      }
      rethrow;
    } on SocketException {
      final cached = box.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached as List);
      }
      rethrow;
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached as List);
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCourses({String? category}) async {
    final cacheKey = 'courses.v2:${category ?? '_all'}';
    const cols =
        'id,title,platform,url,description,category,sort_order,is_active';
    return _fetchListSWR(
      cacheKey: cacheKey,
      fetch: () async {
        var q =
            _client.from('library_courses').select(cols).eq('is_active', true);
        if (category != null && category.isNotEmpty) {
          q = q.eq('category', category);
        }
        return await q.order('sort_order') as List<dynamic>;
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchGrants({String? category}) async {
    final cacheKey = 'grants.v2:${category ?? '_all'}';
    const cols =
        'id,title,organizer,url,description,category,sort_order,is_active';
    return _fetchListSWR(
      cacheKey: cacheKey,
      fetch: () async {
        var q =
            _client.from('library_grants').select(cols).eq('is_active', true);
        if (category != null && category.isNotEmpty) {
          q = q.eq('category', category);
        }
        return await q.order('sort_order') as List<dynamic>;
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchAccelerators(
      {String? category}) async {
    final cacheKey = 'accelerators.v2:${category ?? '_all'}';
    const cols =
        'id,title,organizer,url,description,category,sort_order,is_active';
    return _fetchListSWR(
      cacheKey: cacheKey,
      fetch: () async {
        var q = _client
            .from('library_accelerators')
            .select(cols)
            .eq('is_active', true);
        if (category != null && category.isNotEmpty) {
          q = q.eq('category', category);
        }
        return await q.order('sort_order') as List<dynamic>;
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchFavorites() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Пользователь не авторизован');
    }
    final box = await _openBox();
    final cacheKey = 'favorites:user_$userId';
    try {
      final rows = await _client
          .from('library_favorites')
          .select('*')
          .order('created_at', ascending: false) as List<dynamic>;
      final data =
          rows.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      await box.put(cacheKey, data);
      return data;
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached as List);
      }
      rethrow;
    } on SocketException {
      final cached = box.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached as List);
      }
      rethrow;
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return List<Map<String, dynamic>>.from(cached as List);
      }
      rethrow;
    }
  }

  /// Переключает избранное. Возвращает true если добавлено, false если удалено.
  Future<bool> toggleFavorite({
    required String resourceType,
    required String resourceId,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Пользователь не авторизован');
    }

    try {
      final existing = await _client
          .from('library_favorites')
          .select('id')
          .eq('resource_type', resourceType)
          .eq('resource_id', resourceId)
          .limit(1) as List<dynamic>;

      if (existing.isNotEmpty) {
        final id = (existing.first as Map)['id'];
        await _client.from('library_favorites').delete().eq('id', id);
        return false;
      } else {
        await _client.from('library_favorites').insert({
          'user_id': userId,
          'resource_type': resourceType,
          'resource_id': resourceId,
        });
        return true;
      }
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      rethrow;
    } on SocketException {
      // Оффлайн — считаем ошибкой (сервер обязателен для мутации)
      rethrow;
    }
  }

  /// Загружает избранное с деталями карточек, сгруппированное по типам.
  /// Ключи: 'courses' | 'grants' | 'accelerators'.
  Future<Map<String, List<Map<String, dynamic>>>>
      fetchFavoritesDetailed() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Пользователь не авторизован');
    }

    try {
      final favRows = await _client
          .from('library_favorites')
          .select('id, resource_type, resource_id, created_at')
          .order('created_at', ascending: false) as List<dynamic>;

      final favorites =
          favRows.map((e) => Map<String, dynamic>.from(e as Map)).toList();

      final courseIds = favorites
          .where((f) => f['resource_type'] == 'course')
          .map((f) => f['resource_id'] as String)
          .toList();
      final grantIds = favorites
          .where((f) => f['resource_type'] == 'grant')
          .map((f) => f['resource_id'] as String)
          .toList();
      final accelIds = favorites
          .where((f) => f['resource_type'] == 'accelerator')
          .map((f) => f['resource_id'] as String)
          .toList();

      Future<List<Map<String, dynamic>>> fetchBy(
        String table,
        List<String> ids, {
        List<String> columns = const ['id', 'title', 'url'],
      }) async {
        if (ids.isEmpty) return <Map<String, dynamic>>[];
        final rows = await _client
            .from(table)
            .select(columns.join(','))
            .inFilter('id', ids) as List<dynamic>;
        return rows.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }

      final courses = await fetchBy(
        'library_courses',
        courseIds,
        columns: const [
          'id',
          'title',
          'platform',
          'description',
          'target_audience',
          'language',
          'duration',
          'url'
        ],
      );
      final grants = await fetchBy(
        'library_grants',
        grantIds,
        columns: const [
          'id',
          'title',
          'organizer',
          'support_type',
          'amount',
          'target_audience',
          'description',
          'deadline',
          'url'
        ],
      );
      final accels = await fetchBy(
        'library_accelerators',
        accelIds,
        columns: const [
          'id',
          'title',
          'organizer',
          'format',
          'duration',
          'language',
          'benefits',
          'target_audience',
          'description',
          'requirements',
          'url'
        ],
      );

      return {
        'courses': courses,
        'grants': grants,
        'accelerators': accels,
      };
    } on PostgrestException catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      // Для детализированного избранного офлайн-кеш не реализуем (MVP)
      rethrow;
    } on SocketException {
      rethrow;
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      rethrow;
    }
  }
}
