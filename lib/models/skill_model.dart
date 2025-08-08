// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_model.freezed.dart';
part 'skill_model.g.dart';

@freezed
class SkillModel with _$SkillModel {
  const factory SkillModel({
    required int id,
    required String name,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _SkillModel;

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);
}

