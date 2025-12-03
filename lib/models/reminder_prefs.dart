import 'package:flutter/foundation.dart';

/// Immutable representation of reminder preferences.
@immutable
class ReminderPrefs {
  const ReminderPrefs({
    required this.weekdays,
    required this.hour,
    required this.minute,
  });

  /// Weekday numbers (DateTime.monday..sunday).
  final Set<int> weekdays;
  final int hour;
  final int minute;

  ReminderPrefs copyWith({
    Set<int>? weekdays,
    int? hour,
    int? minute,
  }) {
    return ReminderPrefs(
      weekdays: weekdays ?? this.weekdays,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}



