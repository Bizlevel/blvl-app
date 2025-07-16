// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
class LessonModel with _$LessonModel {
  const factory LessonModel({
    required int id,
    @JsonKey(name: 'level_id') required int levelId,
    @JsonKey(name: 'order') required int order,
    required String title,
    required String description,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'vimeo_id') String? vimeoId,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    @JsonKey(name: 'quiz_questions') required List<dynamic> quizQuestions,
    @JsonKey(name: 'correct_answers') required List<int> correctAnswers,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}
