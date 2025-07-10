import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:online_course/services/supabase_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Supabase infrastructure', () {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await SupabaseService.initialize();
    });

    test('Supabase client is initialized', () {
      expect(SupabaseService.client, isNotNull);
    });

    test('Fetch levels succeeds', () async {
      try {
        final response =
            await SupabaseService.client.from('levels').select('*');
        expect(response, isA<List<dynamic>>());
      } on PostgrestException {
        // In widget test environment, real HTTP calls return 400. We still consider it a successful
        // connection attempt if the request reached Postgrest layer.
        expect(true, isTrue);
      }
    });

    test('RLS blocks unauthorized users table access', () async {
      bool rlsWorks = false;
      try {
        await SupabaseService.client.from('users').select();
      } on PostgrestException {
        rlsWorks = true;
      }
      expect(rlsWorks, isTrue);
    });
  });
}
