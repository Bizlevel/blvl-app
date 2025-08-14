// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyProgressModelImpl _$$WeeklyProgressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WeeklyProgressModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      sprintNumber: (json['sprint_number'] as num).toInt(),
      achievement: json['achievement'] as String?,
      metricActual: json['metric_actual'] as String?,
      usedArtifacts: json['used_artifacts'] as bool?,
      consultedLeo: json['consulted_leo'] as bool?,
      appliedTechniques: json['applied_techniques'] as bool?,
      keyInsight: json['key_insight'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$WeeklyProgressModelImplToJson(
        _$WeeklyProgressModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'sprint_number': instance.sprintNumber,
      'achievement': instance.achievement,
      'metric_actual': instance.metricActual,
      'used_artifacts': instance.usedArtifacts,
      'consulted_leo': instance.consultedLeo,
      'applied_techniques': instance.appliedTechniques,
      'key_insight': instance.keyInsight,
      'created_at': instance.createdAt?.toIso8601String(),
    };
