import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/services/leo_service.dart';
import 'auth_provider.dart';

/// DI-провайдер для [LeoService].
final leoServiceProvider = Provider<LeoService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return LeoService(client);
});
