// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_check_model.freezed.dart';
part 'reminder_check_model.g.dart';

@freezed
class ReminderCheckModel with _$ReminderCheckModel {
  const factory ReminderCheckModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'day_number') required int dayNumber,
    @JsonKey(name: 'reminder_text') String? reminderText,
    @JsonKey(name: 'is_completed') required bool isCompleted,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ReminderCheckModel;

  factory ReminderCheckModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderCheckModelFromJson(json);
}
