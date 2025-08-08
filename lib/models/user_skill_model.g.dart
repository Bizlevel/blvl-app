// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_skill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSkillModelImpl _$$UserSkillModelImplFromJson(Map<String, dynamic> json) =>
    _$UserSkillModelImpl(
      userId: json['user_id'] as String,
      skillId: (json['skill_id'] as num).toInt(),
      points: (json['points'] as num?)?.toInt() ?? 0,
      skillName: json['name'] as String,
    );

Map<String, dynamic> _$$UserSkillModelImplToJson(
        _$UserSkillModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'skill_id': instance.skillId,
      'points': instance.points,
      'name': instance.skillName,
    };
