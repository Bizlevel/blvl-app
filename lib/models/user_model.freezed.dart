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
  @JsonKey(name: 'avatar_id')
  int? get avatarId => throw _privateConstructorUsedError;
  String? get about => throw _privateConstructorUsedError;
  String? get goal => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_area')
  String? get businessArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'experience_level')
  String? get experienceLevel => throw _privateConstructorUsedError;
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
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Новые поля персонализации профиля (этап draft-2)
  @JsonKey(name: 'business_size')
  String? get businessSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'key_challenges')
  List<String>? get keyChallenges => throw _privateConstructorUsedError;
  @JsonKey(name: 'learning_style')
  String? get learningStyle => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_region')
  String? get businessRegion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      @JsonKey(name: 'avatar_id') int? avatarId,
      String? about,
      String? goal,
      @JsonKey(name: 'business_area') String? businessArea,
      @JsonKey(name: 'experience_level') String? experienceLevel,
      @JsonKey(name: 'is_premium') bool isPremium,
      @JsonKey(name: 'current_level') int currentLevel,
      @JsonKey(name: 'leo_messages_total') int leoMessagesTotal,
      @JsonKey(name: 'leo_messages_today') int leoMessagesToday,
      @JsonKey(name: 'leo_reset_at') DateTime? leoResetAt,
      @JsonKey(name: 'onboarding_completed') bool onboardingCompleted,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'business_size') String? businessSize,
      @JsonKey(name: 'key_challenges') List<String>? keyChallenges,
      @JsonKey(name: 'learning_style') String? learningStyle,
      @JsonKey(name: 'business_region') String? businessRegion});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? avatarId = freezed,
    Object? about = freezed,
    Object? goal = freezed,
    Object? businessArea = freezed,
    Object? experienceLevel = freezed,
    Object? isPremium = null,
    Object? currentLevel = null,
    Object? leoMessagesTotal = null,
    Object? leoMessagesToday = null,
    Object? leoResetAt = freezed,
    Object? onboardingCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? businessSize = freezed,
    Object? keyChallenges = freezed,
    Object? learningStyle = freezed,
    Object? businessRegion = freezed,
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
      avatarId: freezed == avatarId
          ? _value.avatarId
          : avatarId // ignore: cast_nullable_to_non_nullable
              as int?,
      about: freezed == about
          ? _value.about
          : about // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      businessArea: freezed == businessArea
          ? _value.businessArea
          : businessArea // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceLevel: freezed == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
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
      businessSize: freezed == businessSize
          ? _value.businessSize
          : businessSize // ignore: cast_nullable_to_non_nullable
              as String?,
      keyChallenges: freezed == keyChallenges
          ? _value.keyChallenges
          : keyChallenges // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      learningStyle: freezed == learningStyle
          ? _value.learningStyle
          : learningStyle // ignore: cast_nullable_to_non_nullable
              as String?,
      businessRegion: freezed == businessRegion
          ? _value.businessRegion
          : businessRegion // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'avatar_id') int? avatarId,
      String? about,
      String? goal,
      @JsonKey(name: 'business_area') String? businessArea,
      @JsonKey(name: 'experience_level') String? experienceLevel,
      @JsonKey(name: 'is_premium') bool isPremium,
      @JsonKey(name: 'current_level') int currentLevel,
      @JsonKey(name: 'leo_messages_total') int leoMessagesTotal,
      @JsonKey(name: 'leo_messages_today') int leoMessagesToday,
      @JsonKey(name: 'leo_reset_at') DateTime? leoResetAt,
      @JsonKey(name: 'onboarding_completed') bool onboardingCompleted,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'business_size') String? businessSize,
      @JsonKey(name: 'key_challenges') List<String>? keyChallenges,
      @JsonKey(name: 'learning_style') String? learningStyle,
      @JsonKey(name: 'business_region') String? businessRegion});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? avatarId = freezed,
    Object? about = freezed,
    Object? goal = freezed,
    Object? businessArea = freezed,
    Object? experienceLevel = freezed,
    Object? isPremium = null,
    Object? currentLevel = null,
    Object? leoMessagesTotal = null,
    Object? leoMessagesToday = null,
    Object? leoResetAt = freezed,
    Object? onboardingCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? businessSize = freezed,
    Object? keyChallenges = freezed,
    Object? learningStyle = freezed,
    Object? businessRegion = freezed,
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
      avatarId: freezed == avatarId
          ? _value.avatarId
          : avatarId // ignore: cast_nullable_to_non_nullable
              as int?,
      about: freezed == about
          ? _value.about
          : about // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      businessArea: freezed == businessArea
          ? _value.businessArea
          : businessArea // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceLevel: freezed == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
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
      businessSize: freezed == businessSize
          ? _value.businessSize
          : businessSize // ignore: cast_nullable_to_non_nullable
              as String?,
      keyChallenges: freezed == keyChallenges
          ? _value._keyChallenges
          : keyChallenges // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      learningStyle: freezed == learningStyle
          ? _value.learningStyle
          : learningStyle // ignore: cast_nullable_to_non_nullable
              as String?,
      businessRegion: freezed == businessRegion
          ? _value.businessRegion
          : businessRegion // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'avatar_id') this.avatarId,
      this.about,
      this.goal,
      @JsonKey(name: 'business_area') this.businessArea,
      @JsonKey(name: 'experience_level') this.experienceLevel,
      @JsonKey(name: 'is_premium') this.isPremium = false,
      @JsonKey(name: 'current_level') this.currentLevel = 1,
      @JsonKey(name: 'leo_messages_total') this.leoMessagesTotal = 30,
      @JsonKey(name: 'leo_messages_today') this.leoMessagesToday = 30,
      @JsonKey(name: 'leo_reset_at') this.leoResetAt,
      @JsonKey(name: 'onboarding_completed') this.onboardingCompleted = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'business_size') this.businessSize,
      @JsonKey(name: 'key_challenges') final List<String>? keyChallenges,
      @JsonKey(name: 'learning_style') this.learningStyle,
      @JsonKey(name: 'business_region') this.businessRegion})
      : _keyChallenges = keyChallenges;

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
  @JsonKey(name: 'avatar_id')
  final int? avatarId;
  @override
  final String? about;
  @override
  final String? goal;
  @override
  @JsonKey(name: 'business_area')
  final String? businessArea;
  @override
  @JsonKey(name: 'experience_level')
  final String? experienceLevel;
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
// Новые поля персонализации профиля (этап draft-2)
  @override
  @JsonKey(name: 'business_size')
  final String? businessSize;
  final List<String>? _keyChallenges;
  @override
  @JsonKey(name: 'key_challenges')
  List<String>? get keyChallenges {
    final value = _keyChallenges;
    if (value == null) return null;
    if (_keyChallenges is EqualUnmodifiableListView) return _keyChallenges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'learning_style')
  final String? learningStyle;
  @override
  @JsonKey(name: 'business_region')
  final String? businessRegion;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, avatarId: $avatarId, about: $about, goal: $goal, businessArea: $businessArea, experienceLevel: $experienceLevel, isPremium: $isPremium, currentLevel: $currentLevel, leoMessagesTotal: $leoMessagesTotal, leoMessagesToday: $leoMessagesToday, leoResetAt: $leoResetAt, onboardingCompleted: $onboardingCompleted, createdAt: $createdAt, updatedAt: $updatedAt, businessSize: $businessSize, keyChallenges: $keyChallenges, learningStyle: $learningStyle, businessRegion: $businessRegion)';
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
            (identical(other.avatarId, avatarId) ||
                other.avatarId == avatarId) &&
            (identical(other.about, about) || other.about == about) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.businessArea, businessArea) ||
                other.businessArea == businessArea) &&
            (identical(other.experienceLevel, experienceLevel) ||
                other.experienceLevel == experienceLevel) &&
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
                other.updatedAt == updatedAt) &&
            (identical(other.businessSize, businessSize) ||
                other.businessSize == businessSize) &&
            const DeepCollectionEquality()
                .equals(other._keyChallenges, _keyChallenges) &&
            (identical(other.learningStyle, learningStyle) ||
                other.learningStyle == learningStyle) &&
            (identical(other.businessRegion, businessRegion) ||
                other.businessRegion == businessRegion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        email,
        name,
        avatarUrl,
        avatarId,
        about,
        goal,
        businessArea,
        experienceLevel,
        isPremium,
        currentLevel,
        leoMessagesTotal,
        leoMessagesToday,
        leoResetAt,
        onboardingCompleted,
        createdAt,
        updatedAt,
        businessSize,
        const DeepCollectionEquality().hash(_keyChallenges),
        learningStyle,
        businessRegion
      ]);

  @JsonKey(ignore: true)
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
          @JsonKey(name: 'avatar_id') final int? avatarId,
          final String? about,
          final String? goal,
          @JsonKey(name: 'business_area') final String? businessArea,
          @JsonKey(name: 'experience_level') final String? experienceLevel,
          @JsonKey(name: 'is_premium') final bool isPremium,
          @JsonKey(name: 'current_level') final int currentLevel,
          @JsonKey(name: 'leo_messages_total') final int leoMessagesTotal,
          @JsonKey(name: 'leo_messages_today') final int leoMessagesToday,
          @JsonKey(name: 'leo_reset_at') final DateTime? leoResetAt,
          @JsonKey(name: 'onboarding_completed') final bool onboardingCompleted,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'business_size') final String? businessSize,
          @JsonKey(name: 'key_challenges') final List<String>? keyChallenges,
          @JsonKey(name: 'learning_style') final String? learningStyle,
          @JsonKey(name: 'business_region') final String? businessRegion}) =
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
  @JsonKey(name: 'avatar_id')
  int? get avatarId;
  @override
  String? get about;
  @override
  String? get goal;
  @override
  @JsonKey(name: 'business_area')
  String? get businessArea;
  @override
  @JsonKey(name: 'experience_level')
  String? get experienceLevel;
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
  @override // Новые поля персонализации профиля (этап draft-2)
  @JsonKey(name: 'business_size')
  String? get businessSize;
  @override
  @JsonKey(name: 'key_challenges')
  List<String>? get keyChallenges;
  @override
  @JsonKey(name: 'learning_style')
  String? get learningStyle;
  @override
  @JsonKey(name: 'business_region')
  String? get businessRegion;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
