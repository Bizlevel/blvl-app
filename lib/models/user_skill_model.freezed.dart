// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_skill_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSkillModel _$UserSkillModelFromJson(Map<String, dynamic> json) {
  return _UserSkillModel.fromJson(json);
}

/// @nodoc
mixin _$UserSkillModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_id')
  int get skillId => throw _privateConstructorUsedError;
  int get points =>
      throw _privateConstructorUsedError; // This field will be populated by a JOIN query
  @JsonKey(name: 'name')
  String get skillName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSkillModelCopyWith<UserSkillModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSkillModelCopyWith<$Res> {
  factory $UserSkillModelCopyWith(
          UserSkillModel value, $Res Function(UserSkillModel) then) =
      _$UserSkillModelCopyWithImpl<$Res, UserSkillModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'skill_id') int skillId,
      int points,
      @JsonKey(name: 'name') String skillName});
}

/// @nodoc
class _$UserSkillModelCopyWithImpl<$Res, $Val extends UserSkillModel>
    implements $UserSkillModelCopyWith<$Res> {
  _$UserSkillModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? skillId = null,
    Object? points = null,
    Object? skillName = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      skillId: null == skillId
          ? _value.skillId
          : skillId // ignore: cast_nullable_to_non_nullable
              as int,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSkillModelImplCopyWith<$Res>
    implements $UserSkillModelCopyWith<$Res> {
  factory _$$UserSkillModelImplCopyWith(_$UserSkillModelImpl value,
          $Res Function(_$UserSkillModelImpl) then) =
      __$$UserSkillModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'skill_id') int skillId,
      int points,
      @JsonKey(name: 'name') String skillName});
}

/// @nodoc
class __$$UserSkillModelImplCopyWithImpl<$Res>
    extends _$UserSkillModelCopyWithImpl<$Res, _$UserSkillModelImpl>
    implements _$$UserSkillModelImplCopyWith<$Res> {
  __$$UserSkillModelImplCopyWithImpl(
      _$UserSkillModelImpl _value, $Res Function(_$UserSkillModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? skillId = null,
    Object? points = null,
    Object? skillName = null,
  }) {
    return _then(_$UserSkillModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      skillId: null == skillId
          ? _value.skillId
          : skillId // ignore: cast_nullable_to_non_nullable
              as int,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSkillModelImpl implements _UserSkillModel {
  const _$UserSkillModelImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'skill_id') required this.skillId,
      this.points = 0,
      @JsonKey(name: 'name') required this.skillName});

  factory _$UserSkillModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSkillModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'skill_id')
  final int skillId;
  @override
  @JsonKey()
  final int points;
// This field will be populated by a JOIN query
  @override
  @JsonKey(name: 'name')
  final String skillName;

  @override
  String toString() {
    return 'UserSkillModel(userId: $userId, skillId: $skillId, points: $points, skillName: $skillName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSkillModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.skillId, skillId) || other.skillId == skillId) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.skillName, skillName) ||
                other.skillName == skillName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, skillId, points, skillName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSkillModelImplCopyWith<_$UserSkillModelImpl> get copyWith =>
      __$$UserSkillModelImplCopyWithImpl<_$UserSkillModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSkillModelImplToJson(
      this,
    );
  }
}

abstract class _UserSkillModel implements UserSkillModel {
  const factory _UserSkillModel(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'skill_id') required final int skillId,
          final int points,
          @JsonKey(name: 'name') required final String skillName}) =
      _$UserSkillModelImpl;

  factory _UserSkillModel.fromJson(Map<String, dynamic> json) =
      _$UserSkillModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'skill_id')
  int get skillId;
  @override
  int get points;
  @override // This field will be populated by a JOIN query
  @JsonKey(name: 'name')
  String get skillName;
  @override
  @JsonKey(ignore: true)
  _$$UserSkillModelImplCopyWith<_$UserSkillModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
