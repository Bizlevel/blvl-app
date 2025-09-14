// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'core_goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoreGoalModel _$CoreGoalModelFromJson(Map<String, dynamic> json) {
  return _CoreGoalModel.fromJson(json);
}

/// @nodoc
mixin _$CoreGoalModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'goal_text')
  String? get goalText => throw _privateConstructorUsedError;
  @JsonKey(name: 'version_data')
  Map<String, dynamic>? get versionData => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoreGoalModelCopyWith<CoreGoalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoreGoalModelCopyWith<$Res> {
  factory $CoreGoalModelCopyWith(
          CoreGoalModel value, $Res Function(CoreGoalModel) then) =
      _$CoreGoalModelCopyWithImpl<$Res, CoreGoalModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      int version,
      @JsonKey(name: 'goal_text') String? goalText,
      @JsonKey(name: 'version_data') Map<String, dynamic>? versionData,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$CoreGoalModelCopyWithImpl<$Res, $Val extends CoreGoalModel>
    implements $CoreGoalModelCopyWith<$Res> {
  _$CoreGoalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? version = null,
    Object? goalText = freezed,
    Object? versionData = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      goalText: freezed == goalText
          ? _value.goalText
          : goalText // ignore: cast_nullable_to_non_nullable
              as String?,
      versionData: freezed == versionData
          ? _value.versionData
          : versionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoreGoalModelImplCopyWith<$Res>
    implements $CoreGoalModelCopyWith<$Res> {
  factory _$$CoreGoalModelImplCopyWith(
          _$CoreGoalModelImpl value, $Res Function(_$CoreGoalModelImpl) then) =
      __$$CoreGoalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      int version,
      @JsonKey(name: 'goal_text') String? goalText,
      @JsonKey(name: 'version_data') Map<String, dynamic>? versionData,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$CoreGoalModelImplCopyWithImpl<$Res>
    extends _$CoreGoalModelCopyWithImpl<$Res, _$CoreGoalModelImpl>
    implements _$$CoreGoalModelImplCopyWith<$Res> {
  __$$CoreGoalModelImplCopyWithImpl(
      _$CoreGoalModelImpl _value, $Res Function(_$CoreGoalModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? version = null,
    Object? goalText = freezed,
    Object? versionData = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CoreGoalModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      goalText: freezed == goalText
          ? _value.goalText
          : goalText // ignore: cast_nullable_to_non_nullable
              as String?,
      versionData: freezed == versionData
          ? _value._versionData
          : versionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoreGoalModelImpl implements _CoreGoalModel {
  const _$CoreGoalModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.version,
      @JsonKey(name: 'goal_text') this.goalText,
      @JsonKey(name: 'version_data') final Map<String, dynamic>? versionData,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _versionData = versionData;

  factory _$CoreGoalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoreGoalModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final int version;
  @override
  @JsonKey(name: 'goal_text')
  final String? goalText;
  final Map<String, dynamic>? _versionData;
  @override
  @JsonKey(name: 'version_data')
  Map<String, dynamic>? get versionData {
    final value = _versionData;
    if (value == null) return null;
    if (_versionData is EqualUnmodifiableMapView) return _versionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CoreGoalModel(id: $id, userId: $userId, version: $version, goalText: $goalText, versionData: $versionData, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoreGoalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.goalText, goalText) ||
                other.goalText == goalText) &&
            const DeepCollectionEquality()
                .equals(other._versionData, _versionData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, version, goalText,
      const DeepCollectionEquality().hash(_versionData), createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoreGoalModelImplCopyWith<_$CoreGoalModelImpl> get copyWith =>
      __$$CoreGoalModelImplCopyWithImpl<_$CoreGoalModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoreGoalModelImplToJson(
      this,
    );
  }
}

abstract class _CoreGoalModel implements CoreGoalModel {
  const factory _CoreGoalModel(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final int version,
      @JsonKey(name: 'goal_text') final String? goalText,
      @JsonKey(name: 'version_data') final Map<String, dynamic>? versionData,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$CoreGoalModelImpl;

  factory _CoreGoalModel.fromJson(Map<String, dynamic> json) =
      _$CoreGoalModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  int get version;
  @override
  @JsonKey(name: 'goal_text')
  String? get goalText;
  @override
  @JsonKey(name: 'version_data')
  Map<String, dynamic>? get versionData;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CoreGoalModelImplCopyWith<_$CoreGoalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
