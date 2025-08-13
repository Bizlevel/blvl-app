// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoreGoalModelImpl _$$CoreGoalModelImplFromJson(Map<String, dynamic> json) =>
    _$CoreGoalModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      version: (json['version'] as num).toInt(),
      goalText: json['goal_text'] as String?,
      versionData: json['version_data'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CoreGoalModelImplToJson(_$CoreGoalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'version': instance.version,
      'goal_text': instance.goalText,
      'version_data': instance.versionData,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
