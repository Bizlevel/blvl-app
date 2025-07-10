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
    final response =
        await client.from('levels').select().order('number', ascending: true);
    // Supabase returns dynamic; ensure casting to List<Map<String, dynamic>>
    return (response as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Fetches lessons for a given level ID ordered by order field.
  static Future<List<Map<String, dynamic>>> fetchLessonsRaw(int levelId) async {
    final response = await client
        .from('lessons')
        .select()
        .eq('level_id', levelId)
        .order('order', ascending: true);

    return (response as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }
}
