// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_goal_model.freezed.dart';
part 'core_goal_model.g.dart';

@freezed
class CoreGoalModel with _$CoreGoalModel {
  const factory CoreGoalModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required int version,
    @JsonKey(name: 'goal_text') String? goalText,
    @JsonKey(name: 'version_data') Map<String, dynamic>? versionData,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CoreGoalModel;

  factory CoreGoalModel.fromJson(Map<String, dynamic> json) =>
      _$CoreGoalModelFromJson(json);
}
