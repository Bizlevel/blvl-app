import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/services/vali_service.dart';
import 'auth_provider.dart';

/// DI-провайдер для [ValiService].
final valiServiceProvider = Provider<ValiService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ValiService(client);
});
