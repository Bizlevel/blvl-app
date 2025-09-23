// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_check_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReminderCheckModel _$ReminderCheckModelFromJson(Map<String, dynamic> json) {
  return _ReminderCheckModel.fromJson(json);
}

/// @nodoc
mixin _$ReminderCheckModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'day_number')
  int get dayNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_text')
  String? get reminderText => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReminderCheckModelCopyWith<ReminderCheckModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderCheckModelCopyWith<$Res> {
  factory $ReminderCheckModelCopyWith(
          ReminderCheckModel value, $Res Function(ReminderCheckModel) then) =
      _$ReminderCheckModelCopyWithImpl<$Res, ReminderCheckModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'day_number') int dayNumber,
      @JsonKey(name: 'reminder_text') String? reminderText,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$ReminderCheckModelCopyWithImpl<$Res, $Val extends ReminderCheckModel>
    implements $ReminderCheckModelCopyWith<$Res> {
  _$ReminderCheckModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? dayNumber = null,
    Object? reminderText = freezed,
    Object? isCompleted = null,
    Object? completedAt = freezed,
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
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      reminderText: freezed == reminderText
          ? _value.reminderText
          : reminderText // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReminderCheckModelImplCopyWith<$Res>
    implements $ReminderCheckModelCopyWith<$Res> {
  factory _$$ReminderCheckModelImplCopyWith(_$ReminderCheckModelImpl value,
          $Res Function(_$ReminderCheckModelImpl) then) =
      __$$ReminderCheckModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'day_number') int dayNumber,
      @JsonKey(name: 'reminder_text') String? reminderText,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$ReminderCheckModelImplCopyWithImpl<$Res>
    extends _$ReminderCheckModelCopyWithImpl<$Res, _$ReminderCheckModelImpl>
    implements _$$ReminderCheckModelImplCopyWith<$Res> {
  __$$ReminderCheckModelImplCopyWithImpl(_$ReminderCheckModelImpl _value,
      $Res Function(_$ReminderCheckModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? dayNumber = null,
    Object? reminderText = freezed,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ReminderCheckModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      reminderText: freezed == reminderText
          ? _value.reminderText
          : reminderText // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReminderCheckModelImpl implements _ReminderCheckModel {
  const _$ReminderCheckModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'day_number') required this.dayNumber,
      @JsonKey(name: 'reminder_text') this.reminderText,
      @JsonKey(name: 'is_completed') required this.isCompleted,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$ReminderCheckModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderCheckModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'day_number')
  final int dayNumber;
  @override
  @JsonKey(name: 'reminder_text')
  final String? reminderText;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ReminderCheckModel(id: $id, userId: $userId, dayNumber: $dayNumber, reminderText: $reminderText, isCompleted: $isCompleted, completedAt: $completedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderCheckModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.reminderText, reminderText) ||
                other.reminderText == reminderText) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, dayNumber,
      reminderText, isCompleted, completedAt, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderCheckModelImplCopyWith<_$ReminderCheckModelImpl> get copyWith =>
      __$$ReminderCheckModelImplCopyWithImpl<_$ReminderCheckModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderCheckModelImplToJson(
      this,
    );
  }
}

abstract class _ReminderCheckModel implements ReminderCheckModel {
  const factory _ReminderCheckModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'day_number') required final int dayNumber,
          @JsonKey(name: 'reminder_text') final String? reminderText,
          @JsonKey(name: 'is_completed') required final bool isCompleted,
          @JsonKey(name: 'completed_at') final DateTime? completedAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$ReminderCheckModelImpl;

  factory _ReminderCheckModel.fromJson(Map<String, dynamic> json) =
      _$ReminderCheckModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'day_number')
  int get dayNumber;
  @override
  @JsonKey(name: 'reminder_text')
  String? get reminderText;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ReminderCheckModelImplCopyWith<_$ReminderCheckModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
