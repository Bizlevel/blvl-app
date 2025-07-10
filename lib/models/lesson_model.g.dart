// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonModelImpl _$$LessonModelImplFromJson(Map<String, dynamic> json) =>
    _$LessonModelImpl(
      id: (json['id'] as num).toInt(),
      levelId: (json['level_id'] as num).toInt(),
      order: (json['order'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['video_url'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      quizQuestions: json['quiz_questions'] as List<dynamic>,
      correctAnswers: (json['correct_answers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$LessonModelImplToJson(_$LessonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level_id': instance.levelId,
      'order': instance.order,
      'title': instance.title,
      'description': instance.description,
      'video_url': instance.videoUrl,
      'duration_minutes': instance.durationMinutes,
      'quiz_questions': instance.quizQuestions,
      'correct_answers': instance.correctAnswers,
      'created_at': instance.createdAt?.toIso8601String(),
    };
