import 'dart:async';
import 'dart:io';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static bool _initialized = false;

  /// Initializes Supabase. Call once at app startup.
  static Future<void> initialize() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://acevqbdpzgbtqznbpgzr.supabase.co',
      ),
      anonKey: const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFjZXZxYmRwemdidHF6bmJwZ3pyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5NzcwOTcsImV4cCI6MjA2NzU1MzA5N30.0CUdl2VhvaBfKLLhMnU1yH2mL9cI01DtX6Hrtq48dyw',
      ),
    );

    _initialized = true;
  }

  /// Convenient accessor to the Supabase client.
  static SupabaseClient get client => Supabase.instance.client;

  /// Fetches all levels ordered by number.
  static Future<List<Map<String, dynamic>>> fetchLevelsRaw() async {
    return _withRetry(() async {
      try {
        final response = await client
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
          await client.auth.signOut();
        }
        rethrow;
      } on SocketException catch (e) {
        throw Exception('Нет соединения с интернетом');
      }
    });
  }

  /// Fetches lessons for a given level ID ordered by order field.
  static Future<List<Map<String, dynamic>>> fetchLessonsRaw(int levelId) async {
    return _withRetry(() async {
      try {
        final response = await client
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
          await client.auth.signOut();
        }
        rethrow;
      } on SocketException catch (_) {
        throw Exception('Нет соединения с интернетом');
      }
    });
  }

  static Future<String?> getArtifactSignedUrl(String relativePath) async {
    return _withRetry(() async {
      try {
        final response = await client.storage
            .from('artifacts')
            .createSignedUrl(relativePath, 60 * 60);
        return response;
      } on StorageException catch (e, st) {
        await Sentry.captureException(e, stackTrace: st);
        return null;
      } on SocketException {
        throw Exception('Нет соединения с интернетом');
      }
    }, retries: 1);
  }

  static Future<String?> getVideoSignedUrl(String relativePath) async {
    return _withRetry(() async {
      try {
        final response = await client.storage
            .from('video')
            .createSignedUrl(relativePath, 60 * 60);
        return response;
      } on StorageException catch (e, st) {
        await Sentry.captureException(e, stackTrace: st);
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
