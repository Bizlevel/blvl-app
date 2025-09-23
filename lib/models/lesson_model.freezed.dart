// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) {
  return _LessonModel.fromJson(json);
}

/// @nodoc
mixin _$LessonModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'level_id')
  int get levelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order')
  int get order => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'vimeo_id')
  String? get vimeoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_questions')
  List<dynamic> get quizQuestions => throw _privateConstructorUsedError;
  @JsonKey(name: 'correct_answers')
  List<int> get correctAnswers => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LessonModelCopyWith<LessonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonModelCopyWith<$Res> {
  factory $LessonModelCopyWith(
          LessonModel value, $Res Function(LessonModel) then) =
      _$LessonModelCopyWithImpl<$Res, LessonModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'level_id') int levelId,
      @JsonKey(name: 'order') int order,
      String title,
      String description,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'vimeo_id') String? vimeoId,
      @JsonKey(name: 'duration_minutes') int durationMinutes,
      @JsonKey(name: 'quiz_questions') List<dynamic> quizQuestions,
      @JsonKey(name: 'correct_answers') List<int> correctAnswers,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$LessonModelCopyWithImpl<$Res, $Val extends LessonModel>
    implements $LessonModelCopyWith<$Res> {
  _$LessonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? levelId = null,
    Object? order = null,
    Object? title = null,
    Object? description = null,
    Object? videoUrl = freezed,
    Object? vimeoId = freezed,
    Object? durationMinutes = null,
    Object? quizQuestions = null,
    Object? correctAnswers = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      levelId: null == levelId
          ? _value.levelId
          : levelId // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      vimeoId: freezed == vimeoId
          ? _value.vimeoId
          : vimeoId // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      quizQuestions: null == quizQuestions
          ? _value.quizQuestions
          : quizQuestions // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as List<int>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LessonModelImplCopyWith<$Res>
    implements $LessonModelCopyWith<$Res> {
  factory _$$LessonModelImplCopyWith(
          _$LessonModelImpl value, $Res Function(_$LessonModelImpl) then) =
      __$$LessonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'level_id') int levelId,
      @JsonKey(name: 'order') int order,
      String title,
      String description,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'vimeo_id') String? vimeoId,
      @JsonKey(name: 'duration_minutes') int durationMinutes,
      @JsonKey(name: 'quiz_questions') List<dynamic> quizQuestions,
      @JsonKey(name: 'correct_answers') List<int> correctAnswers,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$LessonModelImplCopyWithImpl<$Res>
    extends _$LessonModelCopyWithImpl<$Res, _$LessonModelImpl>
    implements _$$LessonModelImplCopyWith<$Res> {
  __$$LessonModelImplCopyWithImpl(
      _$LessonModelImpl _value, $Res Function(_$LessonModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? levelId = null,
    Object? order = null,
    Object? title = null,
    Object? description = null,
    Object? videoUrl = freezed,
    Object? vimeoId = freezed,
    Object? durationMinutes = null,
    Object? quizQuestions = null,
    Object? correctAnswers = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$LessonModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      levelId: null == levelId
          ? _value.levelId
          : levelId // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      vimeoId: freezed == vimeoId
          ? _value.vimeoId
          : vimeoId // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      quizQuestions: null == quizQuestions
          ? _value._quizQuestions
          : quizQuestions // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      correctAnswers: null == correctAnswers
          ? _value._correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as List<int>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonModelImpl implements _LessonModel {
  const _$LessonModelImpl(
      {required this.id,
      @JsonKey(name: 'level_id') required this.levelId,
      @JsonKey(name: 'order') required this.order,
      required this.title,
      required this.description,
      @JsonKey(name: 'video_url') this.videoUrl,
      @JsonKey(name: 'vimeo_id') this.vimeoId,
      @JsonKey(name: 'duration_minutes') required this.durationMinutes,
      @JsonKey(name: 'quiz_questions')
      required final List<dynamic> quizQuestions,
      @JsonKey(name: 'correct_answers') required final List<int> correctAnswers,
      @JsonKey(name: 'created_at') this.createdAt})
      : _quizQuestions = quizQuestions,
        _correctAnswers = correctAnswers;

  factory _$LessonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'level_id')
  final int levelId;
  @override
  @JsonKey(name: 'order')
  final int order;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @override
  @JsonKey(name: 'vimeo_id')
  final String? vimeoId;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  final List<dynamic> _quizQuestions;
  @override
  @JsonKey(name: 'quiz_questions')
  List<dynamic> get quizQuestions {
    if (_quizQuestions is EqualUnmodifiableListView) return _quizQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_quizQuestions);
  }

  final List<int> _correctAnswers;
  @override
  @JsonKey(name: 'correct_answers')
  List<int> get correctAnswers {
    if (_correctAnswers is EqualUnmodifiableListView) return _correctAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_correctAnswers);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'LessonModel(id: $id, levelId: $levelId, order: $order, title: $title, description: $description, videoUrl: $videoUrl, vimeoId: $vimeoId, durationMinutes: $durationMinutes, quizQuestions: $quizQuestions, correctAnswers: $correctAnswers, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.levelId, levelId) || other.levelId == levelId) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.vimeoId, vimeoId) || other.vimeoId == vimeoId) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            const DeepCollectionEquality()
                .equals(other._quizQuestions, _quizQuestions) &&
            const DeepCollectionEquality()
                .equals(other._correctAnswers, _correctAnswers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      levelId,
      order,
      title,
      description,
      videoUrl,
      vimeoId,
      durationMinutes,
      const DeepCollectionEquality().hash(_quizQuestions),
      const DeepCollectionEquality().hash(_correctAnswers),
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonModelImplCopyWith<_$LessonModelImpl> get copyWith =>
      __$$LessonModelImplCopyWithImpl<_$LessonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonModelImplToJson(
      this,
    );
  }
}

abstract class _LessonModel implements LessonModel {
  const factory _LessonModel(
      {required final int id,
      @JsonKey(name: 'level_id') required final int levelId,
      @JsonKey(name: 'order') required final int order,
      required final String title,
      required final String description,
      @JsonKey(name: 'video_url') final String? videoUrl,
      @JsonKey(name: 'vimeo_id') final String? vimeoId,
      @JsonKey(name: 'duration_minutes') required final int durationMinutes,
      @JsonKey(name: 'quiz_questions')
      required final List<dynamic> quizQuestions,
      @JsonKey(name: 'correct_answers') required final List<int> correctAnswers,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$LessonModelImpl;

  factory _LessonModel.fromJson(Map<String, dynamic> json) =
      _$LessonModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'level_id')
  int get levelId;
  @override
  @JsonKey(name: 'order')
  int get order;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  @JsonKey(name: 'vimeo_id')
  String? get vimeoId;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;
  @override
  @JsonKey(name: 'quiz_questions')
  List<dynamic> get quizQuestions;
  @override
  @JsonKey(name: 'correct_answers')
  List<int> get correctAnswers;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$LessonModelImplCopyWith<_$LessonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
