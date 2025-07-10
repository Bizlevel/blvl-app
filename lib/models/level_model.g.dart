// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LevelModelImpl _$$LevelModelImplFromJson(Map<String, dynamic> json) =>
    _$LevelModelImpl(
      id: (json['id'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      isFree: json['is_free'] as bool? ?? false,
      artifactTitle: json['artifact_title'] as String?,
      artifactDescription: json['artifact_description'] as String?,
      artifactUrl: json['artifact_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$LevelModelImplToJson(_$LevelModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'is_free': instance.isFree,
      'artifact_title': instance.artifactTitle,
      'artifact_description': instance.artifactDescription,
      'artifact_url': instance.artifactUrl,
      'created_at': instance.createdAt?.toIso8601String(),
    };
