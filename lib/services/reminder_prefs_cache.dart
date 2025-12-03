import 'package:bizlevel/models/reminder_prefs.dart';
import 'package:flutter/foundation.dart';

/// In-memory cache for reminder preferences to avoid disk I/O on main thread.
class ReminderPrefsCache {
  ReminderPrefsCache._();
  static final ReminderPrefsCache instance = ReminderPrefsCache._();

  final ValueNotifier<ReminderPrefs?> _notifier =
      ValueNotifier<ReminderPrefs?>(null);

  ReminderPrefs? get current => _notifier.value;

  ValueListenable<ReminderPrefs?> get listenable => _notifier;

  void set(ReminderPrefs prefs) {
    if (_notifier.value == prefs) return;
    _notifier.value = prefs;
  }
}

