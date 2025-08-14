// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderCheckModelImpl _$$ReminderCheckModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReminderCheckModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      dayNumber: (json['day_number'] as num).toInt(),
      reminderText: json['reminder_text'] as String?,
      isCompleted: json['is_completed'] as bool,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ReminderCheckModelImplToJson(
        _$ReminderCheckModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'day_number': instance.dayNumber,
      'reminder_text': instance.reminderText,
      'is_completed': instance.isCompleted,
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
