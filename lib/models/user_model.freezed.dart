// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get about => throw _privateConstructorUsedError;
  String? get goal => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_premium')
  bool get isPremium => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_level')
  int get currentLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'leo_messages_total')
  int get leoMessagesTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'leo_messages_today')
  int get leoMessagesToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'leo_reset_at')
  DateTime? get leoResetAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'onboarding_completed')
  bool get onboardingCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? about,
      String? goal,
      @JsonKey(name: 'is_premium') bool isPremium,
      @JsonKey(name: 'current_level') int currentLevel,
      @JsonKey(name: 'leo_messages_total') int leoMessagesTotal,
      @JsonKey(name: 'leo_messages_today') int leoMessagesToday,
      @JsonKey(name: 'leo_reset_at') DateTime? leoResetAt,
      @JsonKey(name: 'onboarding_completed') bool onboardingCompleted,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? about = freezed,
    Object? goal = freezed,
    Object? isPremium = null,
    Object? currentLevel = null,
    Object? leoMessagesTotal = null,
    Object? leoMessagesToday = null,
    Object? leoResetAt = freezed,
    Object? onboardingCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      about: freezed == about
          ? _value.about
          : about // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      leoMessagesTotal: null == leoMessagesTotal
          ? _value.leoMessagesTotal
          : leoMessagesTotal // ignore: cast_nullable_to_non_nullable
              as int,
      leoMessagesToday: null == leoMessagesToday
          ? _value.leoMessagesToday
          : leoMessagesToday // ignore: cast_nullable_to_non_nullable
              as int,
      leoResetAt: freezed == leoResetAt
          ? _value.leoResetAt
          : leoResetAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      onboardingCompleted: null == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? about,
      String? goal,
      @JsonKey(name: 'is_premium') bool isPremium,
      @JsonKey(name: 'current_level') int currentLevel,
      @JsonKey(name: 'leo_messages_total') int leoMessagesTotal,
      @JsonKey(name: 'leo_messages_today') int leoMessagesToday,
      @JsonKey(name: 'leo_reset_at') DateTime? leoResetAt,
      @JsonKey(name: 'onboarding_completed') bool onboardingCompleted,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? about = freezed,
    Object? goal = freezed,
    Object? isPremium = null,
    Object? currentLevel = null,
    Object? leoMessagesTotal = null,
    Object? leoMessagesToday = null,
    Object? leoResetAt = freezed,
    Object? onboardingCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      about: freezed == about
          ? _value.about
          : about // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      leoMessagesTotal: null == leoMessagesTotal
          ? _value.leoMessagesTotal
          : leoMessagesTotal // ignore: cast_nullable_to_non_nullable
              as int,
      leoMessagesToday: null == leoMessagesToday
          ? _value.leoMessagesToday
          : leoMessagesToday // ignore: cast_nullable_to_non_nullable
              as int,
      leoResetAt: freezed == leoResetAt
          ? _value.leoResetAt
          : leoResetAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      onboardingCompleted: null == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.email,
      required this.name,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      this.about,
      this.goal,
      @JsonKey(name: 'is_premium') this.isPremium = false,
      @JsonKey(name: 'current_level') this.currentLevel = 1,
      @JsonKey(name: 'leo_messages_total') this.leoMessagesTotal = 30,
      @JsonKey(name: 'leo_messages_today') this.leoMessagesToday = 30,
      @JsonKey(name: 'leo_reset_at') this.leoResetAt,
      @JsonKey(name: 'onboarding_completed') this.onboardingCompleted = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  final String? about;
  @override
  final String? goal;
  @override
  @JsonKey(name: 'is_premium')
  final bool isPremium;
  @override
  @JsonKey(name: 'current_level')
  final int currentLevel;
  @override
  @JsonKey(name: 'leo_messages_total')
  final int leoMessagesTotal;
  @override
  @JsonKey(name: 'leo_messages_today')
  final int leoMessagesToday;
  @override
  @JsonKey(name: 'leo_reset_at')
  final DateTime? leoResetAt;
  @override
  @JsonKey(name: 'onboarding_completed')
  final bool onboardingCompleted;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, about: $about, goal: $goal, isPremium: $isPremium, currentLevel: $currentLevel, leoMessagesTotal: $leoMessagesTotal, leoMessagesToday: $leoMessagesToday, leoResetAt: $leoResetAt, onboardingCompleted: $onboardingCompleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.about, about) || other.about == about) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.leoMessagesTotal, leoMessagesTotal) ||
                other.leoMessagesTotal == leoMessagesTotal) &&
            (identical(other.leoMessagesToday, leoMessagesToday) ||
                other.leoMessagesToday == leoMessagesToday) &&
            (identical(other.leoResetAt, leoResetAt) ||
                other.leoResetAt == leoResetAt) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      avatarUrl,
      about,
      goal,
      isPremium,
      currentLevel,
      leoMessagesTotal,
      leoMessagesToday,
      leoResetAt,
      onboardingCompleted,
      createdAt,
      updatedAt);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
          {required final String id,
          required final String email,
          required final String name,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          final String? about,
          final String? goal,
          @JsonKey(name: 'is_premium') final bool isPremium,
          @JsonKey(name: 'current_level') final int currentLevel,
          @JsonKey(name: 'leo_messages_total') final int leoMessagesTotal,
          @JsonKey(name: 'leo_messages_today') final int leoMessagesToday,
          @JsonKey(name: 'leo_reset_at') final DateTime? leoResetAt,
          @JsonKey(name: 'onboarding_completed') final bool onboardingCompleted,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  String? get about;
  @override
  String? get goal;
  @override
  @JsonKey(name: 'is_premium')
  bool get isPremium;
  @override
  @JsonKey(name: 'current_level')
  int get currentLevel;
  @override
  @JsonKey(name: 'leo_messages_total')
  int get leoMessagesTotal;
  @override
  @JsonKey(name: 'leo_messages_today')
  int get leoMessagesToday;
  @override
  @JsonKey(name: 'leo_reset_at')
  DateTime? get leoResetAt;
  @override
  @JsonKey(name: 'onboarding_completed')
  bool get onboardingCompleted;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
