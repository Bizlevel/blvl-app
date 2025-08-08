// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_skill_model.freezed.dart';
part 'user_skill_model.g.dart';

@freezed
class UserSkillModel with _$UserSkillModel {
  const factory UserSkillModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'skill_id') required int skillId,
    @Default(0) int points,
    // This field will be populated by a JOIN query
    @JsonKey(name: 'name') required String skillName, 
  }) = _UserSkillModel;

  factory UserSkillModel.fromJson(Map<String, dynamic> json) =>
      _$UserSkillModelFromJson(json);
}

