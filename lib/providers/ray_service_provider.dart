import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/services/ray_service.dart';

import 'auth_provider.dart';

/// DI-провайдер для [RayService].
final rayServiceProvider = Provider<RayService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RayService(client);
});


