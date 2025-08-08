// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LevelModel _$LevelModelFromJson(Map<String, dynamic> json) {
  return _LevelModel.fromJson(json);
}

/// @nodoc
mixin _$LevelModel {
  int get id => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_free')
  bool get isFree => throw _privateConstructorUsedError;
  @JsonKey(name: 'artifact_title')
  String? get artifactTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'artifact_description')
  String? get artifactDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'artifact_url')
  String? get artifactUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_id')
  int? get skillId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LevelModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LevelModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LevelModelCopyWith<LevelModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LevelModelCopyWith<$Res> {
  factory $LevelModelCopyWith(
          LevelModel value, $Res Function(LevelModel) then) =
      _$LevelModelCopyWithImpl<$Res, LevelModel>;
  @useResult
  $Res call(
      {int id,
      int number,
      String title,
      String description,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'is_free') bool isFree,
      @JsonKey(name: 'artifact_title') String? artifactTitle,
      @JsonKey(name: 'artifact_description') String? artifactDescription,
      @JsonKey(name: 'artifact_url') String? artifactUrl,
      @JsonKey(name: 'skill_id') int? skillId,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$LevelModelCopyWithImpl<$Res, $Val extends LevelModel>
    implements $LevelModelCopyWith<$Res> {
  _$LevelModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LevelModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? isFree = null,
    Object? artifactTitle = freezed,
    Object? artifactDescription = freezed,
    Object? artifactUrl = freezed,
    Object? skillId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      artifactTitle: freezed == artifactTitle
          ? _value.artifactTitle
          : artifactTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      artifactDescription: freezed == artifactDescription
          ? _value.artifactDescription
          : artifactDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      artifactUrl: freezed == artifactUrl
          ? _value.artifactUrl
          : artifactUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      skillId: freezed == skillId
          ? _value.skillId
          : skillId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LevelModelImplCopyWith<$Res>
    implements $LevelModelCopyWith<$Res> {
  factory _$$LevelModelImplCopyWith(
          _$LevelModelImpl value, $Res Function(_$LevelModelImpl) then) =
      __$$LevelModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int number,
      String title,
      String description,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'is_free') bool isFree,
      @JsonKey(name: 'artifact_title') String? artifactTitle,
      @JsonKey(name: 'artifact_description') String? artifactDescription,
      @JsonKey(name: 'artifact_url') String? artifactUrl,
      @JsonKey(name: 'skill_id') int? skillId,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$LevelModelImplCopyWithImpl<$Res>
    extends _$LevelModelCopyWithImpl<$Res, _$LevelModelImpl>
    implements _$$LevelModelImplCopyWith<$Res> {
  __$$LevelModelImplCopyWithImpl(
      _$LevelModelImpl _value, $Res Function(_$LevelModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LevelModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? isFree = null,
    Object? artifactTitle = freezed,
    Object? artifactDescription = freezed,
    Object? artifactUrl = freezed,
    Object? skillId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$LevelModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      artifactTitle: freezed == artifactTitle
          ? _value.artifactTitle
          : artifactTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      artifactDescription: freezed == artifactDescription
          ? _value.artifactDescription
          : artifactDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      artifactUrl: freezed == artifactUrl
          ? _value.artifactUrl
          : artifactUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      skillId: freezed == skillId
          ? _value.skillId
          : skillId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LevelModelImpl implements _LevelModel {
  const _$LevelModelImpl(
      {required this.id,
      required this.number,
      required this.title,
      required this.description,
      @JsonKey(name: 'image_url') required this.imageUrl,
      @JsonKey(name: 'is_free') this.isFree = false,
      @JsonKey(name: 'artifact_title') this.artifactTitle,
      @JsonKey(name: 'artifact_description') this.artifactDescription,
      @JsonKey(name: 'artifact_url') this.artifactUrl,
      @JsonKey(name: 'skill_id') this.skillId,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$LevelModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LevelModelImplFromJson(json);

  @override
  final int id;
  @override
  final int number;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'is_free')
  final bool isFree;
  @override
  @JsonKey(name: 'artifact_title')
  final String? artifactTitle;
  @override
  @JsonKey(name: 'artifact_description')
  final String? artifactDescription;
  @override
  @JsonKey(name: 'artifact_url')
  final String? artifactUrl;
  @override
  @JsonKey(name: 'skill_id')
  final int? skillId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'LevelModel(id: $id, number: $number, title: $title, description: $description, imageUrl: $imageUrl, isFree: $isFree, artifactTitle: $artifactTitle, artifactDescription: $artifactDescription, artifactUrl: $artifactUrl, skillId: $skillId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.artifactTitle, artifactTitle) ||
                other.artifactTitle == artifactTitle) &&
            (identical(other.artifactDescription, artifactDescription) ||
                other.artifactDescription == artifactDescription) &&
            (identical(other.artifactUrl, artifactUrl) ||
                other.artifactUrl == artifactUrl) &&
            (identical(other.skillId, skillId) || other.skillId == skillId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      number,
      title,
      description,
      imageUrl,
      isFree,
      artifactTitle,
      artifactDescription,
      artifactUrl,
      skillId,
      createdAt);

  /// Create a copy of LevelModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelModelImplCopyWith<_$LevelModelImpl> get copyWith =>
      __$$LevelModelImplCopyWithImpl<_$LevelModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LevelModelImplToJson(
      this,
    );
  }
}

abstract class _LevelModel implements LevelModel {
  const factory _LevelModel(
      {required final int id,
      required final int number,
      required final String title,
      required final String description,
      @JsonKey(name: 'image_url') required final String imageUrl,
      @JsonKey(name: 'is_free') final bool isFree,
      @JsonKey(name: 'artifact_title') final String? artifactTitle,
      @JsonKey(name: 'artifact_description') final String? artifactDescription,
      @JsonKey(name: 'artifact_url') final String? artifactUrl,
      @JsonKey(name: 'skill_id') final int? skillId,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$LevelModelImpl;

  factory _LevelModel.fromJson(Map<String, dynamic> json) =
      _$LevelModelImpl.fromJson;

  @override
  int get id;
  @override
  int get number;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'is_free')
  bool get isFree;
  @override
  @JsonKey(name: 'artifact_title')
  String? get artifactTitle;
  @override
  @JsonKey(name: 'artifact_description')
  String? get artifactDescription;
  @override
  @JsonKey(name: 'artifact_url')
  String? get artifactUrl;
  @override
  @JsonKey(name: 'skill_id')
  int? get skillId;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of LevelModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LevelModelImplCopyWith<_$LevelModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
