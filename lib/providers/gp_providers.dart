import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/services/gp_service.dart';
import 'package:bizlevel/providers/auth_provider.dart';

final gpServiceProvider = Provider<GpService>((ref) {
  return GpService(Supabase.instance.client);
});

/// SWR-провайдер баланса GP. Использует локальный кеш Hive.
final gpBalanceProvider = FutureProvider<Map<String, int>>((ref) async {
  // Подписываемся на состояние аутентификации: при смене сессии провайдер
  // будет инвалидирован и перезапрошен, чтобы не залипать на 0 до логина.
  ref.watch(authStateProvider);

  // Гейт: не делаем сетевые вызовы, пока нет user JWT.
  // Это устраняет ранние 401 от gp-balance до появления сессии.
  if (Supabase.instance.client.auth.currentSession == null) {
    final auth = await ref.watch(authStateProvider.future);
    if (auth.session == null) {
      return const {'balance': 0, 'total_earned': 0, 'total_spent': 0};
    }
  }
  // мгновенно отдаём кеш, если есть
  final cached = GpService.readBalanceCache();
  if (cached != null) {
    // Параллельно обновим в фоне (только если есть сессия)
    if (Supabase.instance.client.auth.currentSession != null) {
      Future.microtask(() async {
        try {
          final fresh = await ref.read(gpServiceProvider).getBalance();
          await GpService.saveBalanceCache(fresh);
          // ignore: unused_result
          ref.invalidateSelf();
        } catch (_) {}
      });
    }
    return cached;
  }
  try {
    final fresh = await ref.read(gpServiceProvider).getBalance();
    await GpService.saveBalanceCache(fresh);
    return fresh;
  } catch (_) {
    // Фолбэк: пустой баланс, чтобы не ломать UI, и повторим попытку в фоне
    Future.microtask(() async {
      try {
        final fresh = await ref.read(gpServiceProvider).getBalance();
        await GpService.saveBalanceCache(fresh);
        // ignore: unused_result
        ref.invalidateSelf();
      } catch (_) {}
    });
    return const {'balance': 0, 'total_earned': 0, 'total_spent': 0};
  }
});
