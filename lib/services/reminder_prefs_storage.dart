import 'package:shared_preferences/shared_preferences.dart';

const _kWeekdaysKey = 'practice_reminder_weekdays_v2';
const _kHourKey = 'practice_reminder_hour_v2';
const _kMinuteKey = 'practice_reminder_minute_v2';
const _kTimezoneKey = 'practice_reminder_timezone_v2';

/// Lightweight storage for reminder prefs backed by SharedPreferences.
class ReminderPrefsStorage {
  ReminderPrefsStorage._();
  static final ReminderPrefsStorage instance = ReminderPrefsStorage._();

  Future<(Set<int>, int, int)> load() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? raw = prefs.getStringList(_kWeekdaysKey);
    final Set<int> days = raw == null || raw.isEmpty
        ? {DateTime.monday, DateTime.wednesday, DateTime.friday}
        : raw
            .map((e) => int.tryParse(e) ?? 0)
            .where((v) => v >= DateTime.monday && v <= DateTime.sunday)
            .toSet();
    final hour = prefs.getInt(_kHourKey) ?? 19;
    final minute = prefs.getInt(_kMinuteKey) ?? 0;
    return (days, hour, minute);
  }

  Future<void> save(
    Set<int> days,
    int hour,
    int minute, {
    String? timezone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kWeekdaysKey,
      days.map((e) => e.toString()).toList(),
    );
    await prefs.setInt(_kHourKey, hour);
    await prefs.setInt(_kMinuteKey, minute);
    if (timezone != null && timezone.isNotEmpty) {
      await prefs.setString(_kTimezoneKey, timezone);
    }
  }

  Future<String?> loadTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTimezoneKey);
  }
}



