import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/models/reminder_prefs.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:bizlevel/services/reminder_prefs_cache.dart';

final reminderPrefsProvider = AsyncNotifierProvider<ReminderPrefsNotifier,
    ReminderPrefs>(ReminderPrefsNotifier.new);

class ReminderPrefsNotifier extends AsyncNotifier<ReminderPrefs> {
  @override
  Future<ReminderPrefs> build() async {
    final cache = ReminderPrefsCache.instance.current;
    if (cache != null) return cache;
    return _loadPrefs();
  }

  Future<void> refreshPrefs() async {
    final current = state.value ?? ReminderPrefsCache.instance.current;
    if (current != null) {
      state = AsyncValue.data(current);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_loadPrefs);
  }

  Future<ReminderPrefs> _loadPrefs() async {
    final prefs =
        await NotificationsService.instance.getPracticeReminderPrefs();
    return ReminderPrefs(
      weekdays: Set<int>.from(prefs.$1),
      hour: prefs.$2,
      minute: prefs.$3,
    );
  }
}

