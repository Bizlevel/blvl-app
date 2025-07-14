import 'package:freezed_annotation/freezed_annotation.dart';

part 'level_model.freezed.dart';
part 'level_model.g.dart';

@freezed
class LevelModel with _$LevelModel {
  const factory LevelModel({
    required int id,
    required int number,
    required String title,
    required String description,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'is_free') @Default(false) bool isFree,
    @JsonKey(name: 'artifact_title') String? artifactTitle,
    @JsonKey(name: 'artifact_description') String? artifactDescription,
    
    @JsonKey(name: 'artifact_url') String? artifactUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _LevelModel;

  factory LevelModel.fromJson(Map<String, dynamic> json) =>
      _$LevelModelFromJson(json);
}
