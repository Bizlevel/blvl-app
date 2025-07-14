import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/services/supabase_service.dart';

/// Streams `unread_count` for a given chat.
final leoUnreadProvider = StreamProvider.family<int, String>((ref, chatId) {
  final stream = SupabaseService.client
      .from('leo_chats')
      .stream(primaryKey: ['id'])
      .eq('id', chatId)
      .map((rows) {
    if (rows.isEmpty) return 0;
    final unread = rows.first['unread_count'] as int? ?? 0;
    return unread;
  });
  return stream;
});
