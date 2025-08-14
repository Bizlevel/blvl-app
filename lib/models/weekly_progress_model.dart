// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_progress_model.freezed.dart';
part 'weekly_progress_model.g.dart';

@freezed
class WeeklyProgressModel with _$WeeklyProgressModel {
  const factory WeeklyProgressModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'sprint_number') required int sprintNumber,
    String? achievement,
    @JsonKey(name: 'metric_actual') String? metricActual,
    @JsonKey(name: 'used_artifacts') bool? usedArtifacts,
    @JsonKey(name: 'consulted_leo') bool? consultedLeo,
    @JsonKey(name: 'applied_techniques') bool? appliedTechniques,
    @JsonKey(name: 'key_insight') String? keyInsight,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _WeeklyProgressModel;

  factory WeeklyProgressModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyProgressModelFromJson(json);
}
