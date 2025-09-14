// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_progress_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyProgressModel _$WeeklyProgressModelFromJson(Map<String, dynamic> json) {
  return _WeeklyProgressModel.fromJson(json);
}

/// @nodoc
mixin _$WeeklyProgressModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sprint_number')
  int get sprintNumber => throw _privateConstructorUsedError;
  String? get achievement => throw _privateConstructorUsedError;
  @JsonKey(name: 'metric_actual')
  String? get metricActual => throw _privateConstructorUsedError;
  @JsonKey(name: 'used_artifacts')
  bool? get usedArtifacts => throw _privateConstructorUsedError;
  @JsonKey(name: 'consulted_leo')
  bool? get consultedLeo => throw _privateConstructorUsedError;
  @JsonKey(name: 'applied_techniques')
  bool? get appliedTechniques => throw _privateConstructorUsedError;
  @JsonKey(name: 'key_insight')
  String? get keyInsight => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyProgressModelCopyWith<WeeklyProgressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyProgressModelCopyWith<$Res> {
  factory $WeeklyProgressModelCopyWith(
          WeeklyProgressModel value, $Res Function(WeeklyProgressModel) then) =
      _$WeeklyProgressModelCopyWithImpl<$Res, WeeklyProgressModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'sprint_number') int sprintNumber,
      String? achievement,
      @JsonKey(name: 'metric_actual') String? metricActual,
      @JsonKey(name: 'used_artifacts') bool? usedArtifacts,
      @JsonKey(name: 'consulted_leo') bool? consultedLeo,
      @JsonKey(name: 'applied_techniques') bool? appliedTechniques,
      @JsonKey(name: 'key_insight') String? keyInsight,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$WeeklyProgressModelCopyWithImpl<$Res, $Val extends WeeklyProgressModel>
    implements $WeeklyProgressModelCopyWith<$Res> {
  _$WeeklyProgressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sprintNumber = null,
    Object? achievement = freezed,
    Object? metricActual = freezed,
    Object? usedArtifacts = freezed,
    Object? consultedLeo = freezed,
    Object? appliedTechniques = freezed,
    Object? keyInsight = freezed,
    Object? createdAt = freezed,
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
      sprintNumber: null == sprintNumber
          ? _value.sprintNumber
          : sprintNumber // ignore: cast_nullable_to_non_nullable
              as int,
      achievement: freezed == achievement
          ? _value.achievement
          : achievement // ignore: cast_nullable_to_non_nullable
              as String?,
      metricActual: freezed == metricActual
          ? _value.metricActual
          : metricActual // ignore: cast_nullable_to_non_nullable
              as String?,
      usedArtifacts: freezed == usedArtifacts
          ? _value.usedArtifacts
          : usedArtifacts // ignore: cast_nullable_to_non_nullable
              as bool?,
      consultedLeo: freezed == consultedLeo
          ? _value.consultedLeo
          : consultedLeo // ignore: cast_nullable_to_non_nullable
              as bool?,
      appliedTechniques: freezed == appliedTechniques
          ? _value.appliedTechniques
          : appliedTechniques // ignore: cast_nullable_to_non_nullable
              as bool?,
      keyInsight: freezed == keyInsight
          ? _value.keyInsight
          : keyInsight // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyProgressModelImplCopyWith<$Res>
    implements $WeeklyProgressModelCopyWith<$Res> {
  factory _$$WeeklyProgressModelImplCopyWith(_$WeeklyProgressModelImpl value,
          $Res Function(_$WeeklyProgressModelImpl) then) =
      __$$WeeklyProgressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'sprint_number') int sprintNumber,
      String? achievement,
      @JsonKey(name: 'metric_actual') String? metricActual,
      @JsonKey(name: 'used_artifacts') bool? usedArtifacts,
      @JsonKey(name: 'consulted_leo') bool? consultedLeo,
      @JsonKey(name: 'applied_techniques') bool? appliedTechniques,
      @JsonKey(name: 'key_insight') String? keyInsight,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$WeeklyProgressModelImplCopyWithImpl<$Res>
    extends _$WeeklyProgressModelCopyWithImpl<$Res, _$WeeklyProgressModelImpl>
    implements _$$WeeklyProgressModelImplCopyWith<$Res> {
  __$$WeeklyProgressModelImplCopyWithImpl(_$WeeklyProgressModelImpl _value,
      $Res Function(_$WeeklyProgressModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sprintNumber = null,
    Object? achievement = freezed,
    Object? metricActual = freezed,
    Object? usedArtifacts = freezed,
    Object? consultedLeo = freezed,
    Object? appliedTechniques = freezed,
    Object? keyInsight = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$WeeklyProgressModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sprintNumber: null == sprintNumber
          ? _value.sprintNumber
          : sprintNumber // ignore: cast_nullable_to_non_nullable
              as int,
      achievement: freezed == achievement
          ? _value.achievement
          : achievement // ignore: cast_nullable_to_non_nullable
              as String?,
      metricActual: freezed == metricActual
          ? _value.metricActual
          : metricActual // ignore: cast_nullable_to_non_nullable
              as String?,
      usedArtifacts: freezed == usedArtifacts
          ? _value.usedArtifacts
          : usedArtifacts // ignore: cast_nullable_to_non_nullable
              as bool?,
      consultedLeo: freezed == consultedLeo
          ? _value.consultedLeo
          : consultedLeo // ignore: cast_nullable_to_non_nullable
              as bool?,
      appliedTechniques: freezed == appliedTechniques
          ? _value.appliedTechniques
          : appliedTechniques // ignore: cast_nullable_to_non_nullable
              as bool?,
      keyInsight: freezed == keyInsight
          ? _value.keyInsight
          : keyInsight // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyProgressModelImpl implements _WeeklyProgressModel {
  const _$WeeklyProgressModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'sprint_number') required this.sprintNumber,
      this.achievement,
      @JsonKey(name: 'metric_actual') this.metricActual,
      @JsonKey(name: 'used_artifacts') this.usedArtifacts,
      @JsonKey(name: 'consulted_leo') this.consultedLeo,
      @JsonKey(name: 'applied_techniques') this.appliedTechniques,
      @JsonKey(name: 'key_insight') this.keyInsight,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$WeeklyProgressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyProgressModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'sprint_number')
  final int sprintNumber;
  @override
  final String? achievement;
  @override
  @JsonKey(name: 'metric_actual')
  final String? metricActual;
  @override
  @JsonKey(name: 'used_artifacts')
  final bool? usedArtifacts;
  @override
  @JsonKey(name: 'consulted_leo')
  final bool? consultedLeo;
  @override
  @JsonKey(name: 'applied_techniques')
  final bool? appliedTechniques;
  @override
  @JsonKey(name: 'key_insight')
  final String? keyInsight;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'WeeklyProgressModel(id: $id, userId: $userId, sprintNumber: $sprintNumber, achievement: $achievement, metricActual: $metricActual, usedArtifacts: $usedArtifacts, consultedLeo: $consultedLeo, appliedTechniques: $appliedTechniques, keyInsight: $keyInsight, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyProgressModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sprintNumber, sprintNumber) ||
                other.sprintNumber == sprintNumber) &&
            (identical(other.achievement, achievement) ||
                other.achievement == achievement) &&
            (identical(other.metricActual, metricActual) ||
                other.metricActual == metricActual) &&
            (identical(other.usedArtifacts, usedArtifacts) ||
                other.usedArtifacts == usedArtifacts) &&
            (identical(other.consultedLeo, consultedLeo) ||
                other.consultedLeo == consultedLeo) &&
            (identical(other.appliedTechniques, appliedTechniques) ||
                other.appliedTechniques == appliedTechniques) &&
            (identical(other.keyInsight, keyInsight) ||
                other.keyInsight == keyInsight) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      sprintNumber,
      achievement,
      metricActual,
      usedArtifacts,
      consultedLeo,
      appliedTechniques,
      keyInsight,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyProgressModelImplCopyWith<_$WeeklyProgressModelImpl> get copyWith =>
      __$$WeeklyProgressModelImplCopyWithImpl<_$WeeklyProgressModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyProgressModelImplToJson(
      this,
    );
  }
}

abstract class _WeeklyProgressModel implements WeeklyProgressModel {
  const factory _WeeklyProgressModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'sprint_number') required final int sprintNumber,
          final String? achievement,
          @JsonKey(name: 'metric_actual') final String? metricActual,
          @JsonKey(name: 'used_artifacts') final bool? usedArtifacts,
          @JsonKey(name: 'consulted_leo') final bool? consultedLeo,
          @JsonKey(name: 'applied_techniques') final bool? appliedTechniques,
          @JsonKey(name: 'key_insight') final String? keyInsight,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$WeeklyProgressModelImpl;

  factory _WeeklyProgressModel.fromJson(Map<String, dynamic> json) =
      _$WeeklyProgressModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'sprint_number')
  int get sprintNumber;
  @override
  String? get achievement;
  @override
  @JsonKey(name: 'metric_actual')
  String? get metricActual;
  @override
  @JsonKey(name: 'used_artifacts')
  bool? get usedArtifacts;
  @override
  @JsonKey(name: 'consulted_leo')
  bool? get consultedLeo;
  @override
  @JsonKey(name: 'applied_techniques')
  bool? get appliedTechniques;
  @override
  @JsonKey(name: 'key_insight')
  String? get keyInsight;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyProgressModelImplCopyWith<_$WeeklyProgressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
