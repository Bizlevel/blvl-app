import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Репозиторий Библиотеки (курсы/гранты/акселераторы/избранное) с SWR‑кешем на Hive.
class LibraryRepository {
  final SupabaseClient _client;
  LibraryRepository(this._client);

  Future<Box> _openBox() => Hive.openBox('library');

  // === Общие хелперы кеша/логирования ===
  Future<void> _capture(Object error, StackTrace st) async {
    await Sentry.captureException(error, stackTrace: st);
  }

  List<Map<String, dynamic>>? _readCached(Box box, String cacheKey) {
    final cached = box.get(cacheKey);
    if (cached == null) return null;
    return List<Map<String, dynamic>>.from(cached as List);
  }

  Future<void> _saveCached(
    Box box,
    String cacheKey,
    List<Map<String, dynamic>> data,
  ) async {
    await box.put(cacheKey, data);
  }

  Future<List<Map<String, dynamic>>> _fetchListSWR({
    required String cacheKey,
    required Future<List<dynamic>> Function() fetch,
  }) async {
    final box = await _openBox();
    int? prevCount;
    DateTime? lastDigest;
    try {
      final cached = _readCached(box, cacheKey);
      prevCount = cached?.length;
      final ts = box.get('digest_ts') as String?;
      if (ts != null) lastDigest = DateTime.tryParse(ts);
    } catch (_) {}
    try {
      final rows = await fetch();
      final data =
          rows.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      await _saveCached(box, cacheKey, data);
      try {
        // Уведомление о новых материалах (простая эвристика): выросло количество
        final now = DateTime.now().toUtc();
        final bool cooldownPassed =
            lastDigest == null || now.difference(lastDigest).inHours >= 24;
        if ((prevCount ?? 0) < data.length && cooldownPassed) {
          // Отправим локальный пуш (образовательный канал)
          // Игнорируем ошибки — нет жёсткой зависимости в репозитории
          // Пользователь увидит один пуш не чаще 1 раза в 24ч
          // ignore: unnecessary_statements
          // NotificationsService.instance.showLibraryDigestOnce();
          await box.put('digest_ts', now.toIso8601String());
        }
      } catch (_) {}
      return data;
    } catch (e, st) {
      await _capture(e, st);
      final cached = _readCached(box, cacheKey);
      if (cached != null) return cached;
      rethrow;
    }
  }

  // === Унификация выборок разделов ===
  Future<List<Map<String, dynamic>>> _swrSelectList({
    required String cacheKey,
    required String table,
    required String columns,
    required String orderBy,
    String? category,
  }) async {
    return _fetchListSWR(
      cacheKey: cacheKey,
      fetch: () async {
        var q = _client.from(table).select(columns).eq('is_active', true);
        if (category != null && category.isNotEmpty) {
          q = q.eq('category', category);
        }
        return await q.order(orderBy) as List<dynamic>;
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchCourses({String? category}) async {
    const cols =
        'id,title,platform,url,description,category,sort_order,is_active,target_audience,language,duration';
    return _swrSelectList(
      cacheKey: 'courses.v3:${category ?? '_all'}',
      table: 'library_courses',
      columns: cols,
      orderBy: 'sort_order',
      category: category,
    );
  }

  Future<List<Map<String, dynamic>>> fetchGrants({String? category}) async {
    const cols =
        'id,title,organizer,url,description,category,sort_order,is_active,support_type,amount,deadline,target_audience';
    return _swrSelectList(
      cacheKey: 'grants.v3:${category ?? '_all'}',
      table: 'library_grants',
      columns: cols,
      orderBy: 'sort_order',
      category: category,
    );
  }

  Future<List<Map<String, dynamic>>> fetchAccelerators(
      {String? category}) async {
    const cols =
        'id,title,organizer,url,description,category,sort_order,is_active,format,duration,language,benefits,requirements,target_audience';
    return _swrSelectList(
      cacheKey: 'accelerators.v3:${category ?? '_all'}',
      table: 'library_accelerators',
      columns: cols,
      orderBy: 'sort_order',
      category: category,
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
      final favorites = await _loadFavoritesRows();
      final ids = _splitFavoriteIds(favorites);

      final courses = await _fetchByIds(
        table: 'library_courses',
        ids: ids.courseIds,
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
      final grants = await _fetchByIds(
        table: 'library_grants',
        ids: ids.grantIds,
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
      final accels = await _fetchByIds(
        table: 'library_accelerators',
        ids: ids.accelIds,
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
      await _capture(e, st);
      rethrow;
    } on SocketException {
      rethrow;
    } catch (e, st) {
      await _capture(e, st);
      rethrow;
    }
  }

  // === Хелперы для избранного ===
  Future<List<Map<String, dynamic>>> _loadFavoritesRows() async {
    final rows = await _client
        .from('library_favorites')
        .select('id, resource_type, resource_id, created_at')
        .order('created_at', ascending: false) as List<dynamic>;
    return rows.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  _FavoriteIdGroups _splitFavoriteIds(List<Map<String, dynamic>> favorites) {
    final courseIds = <String>[];
    final grantIds = <String>[];
    final accelIds = <String>[];

    for (final f in favorites) {
      final type = f['resource_type']?.toString();
      final id = f['resource_id']?.toString();
      if (id == null || id.isEmpty) continue;
      if (type == 'course') {
        courseIds.add(id);
      } else if (type == 'grant') {
        grantIds.add(id);
      } else if (type == 'accelerator') {
        accelIds.add(id);
      }
    }
    return _FavoriteIdGroups(
      courseIds: courseIds,
      grantIds: grantIds,
      accelIds: accelIds,
    );
  }

  Future<List<Map<String, dynamic>>> _fetchByIds({
    required String table,
    required List<String> ids,
    required List<String> columns,
  }) async {
    if (ids.isEmpty) return <Map<String, dynamic>>[];
    final rows = await _client
        .from(table)
        .select(columns.join(','))
        .inFilter('id', ids) as List<dynamic>;
    return rows.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}

class _FavoriteIdGroups {
  final List<String> courseIds;
  final List<String> grantIds;
  final List<String> accelIds;
  const _FavoriteIdGroups({
    required this.courseIds,
    required this.grantIds,
    required this.accelIds,
  });
}
