import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Стрим-провайдер статуса подписки текущего пользователя.
/// Возвращает строку статуса (active/past_due/..). null, если подписка не найдена.
final subscriptionProvider = StreamProvider<String?>((ref) {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) {
    return const Stream.empty();
  }

  return Supabase.instance.client
      .from('subscriptions')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map((rows) {
        if (rows.isEmpty) return null;
        return rows.first['status'] as String?;
      });
});
