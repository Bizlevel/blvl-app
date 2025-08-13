// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motivational_quote_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MotivationalQuoteModel _$MotivationalQuoteModelFromJson(
    Map<String, dynamic> json) {
  return _MotivationalQuoteModel.fromJson(json);
}

/// @nodoc
mixin _$MotivationalQuoteModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_text')
  String get quoteText => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this MotivationalQuoteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MotivationalQuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotivationalQuoteModelCopyWith<MotivationalQuoteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotivationalQuoteModelCopyWith<$Res> {
  factory $MotivationalQuoteModelCopyWith(MotivationalQuoteModel value,
          $Res Function(MotivationalQuoteModel) then) =
      _$MotivationalQuoteModelCopyWithImpl<$Res, MotivationalQuoteModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'quote_text') String quoteText,
      String? author,
      String? category,
      @JsonKey(name: 'is_active') bool? isActive});
}

/// @nodoc
class _$MotivationalQuoteModelCopyWithImpl<$Res,
        $Val extends MotivationalQuoteModel>
    implements $MotivationalQuoteModelCopyWith<$Res> {
  _$MotivationalQuoteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MotivationalQuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteText = null,
    Object? author = freezed,
    Object? category = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _value.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MotivationalQuoteModelImplCopyWith<$Res>
    implements $MotivationalQuoteModelCopyWith<$Res> {
  factory _$$MotivationalQuoteModelImplCopyWith(
          _$MotivationalQuoteModelImpl value,
          $Res Function(_$MotivationalQuoteModelImpl) then) =
      __$$MotivationalQuoteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'quote_text') String quoteText,
      String? author,
      String? category,
      @JsonKey(name: 'is_active') bool? isActive});
}

/// @nodoc
class __$$MotivationalQuoteModelImplCopyWithImpl<$Res>
    extends _$MotivationalQuoteModelCopyWithImpl<$Res,
        _$MotivationalQuoteModelImpl>
    implements _$$MotivationalQuoteModelImplCopyWith<$Res> {
  __$$MotivationalQuoteModelImplCopyWithImpl(
      _$MotivationalQuoteModelImpl _value,
      $Res Function(_$MotivationalQuoteModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MotivationalQuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteText = null,
    Object? author = freezed,
    Object? category = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$MotivationalQuoteModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _value.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MotivationalQuoteModelImpl implements _MotivationalQuoteModel {
  const _$MotivationalQuoteModelImpl(
      {required this.id,
      @JsonKey(name: 'quote_text') required this.quoteText,
      this.author,
      this.category,
      @JsonKey(name: 'is_active') this.isActive});

  factory _$MotivationalQuoteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotivationalQuoteModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'quote_text')
  final String quoteText;
  @override
  final String? author;
  @override
  final String? category;
  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;

  @override
  String toString() {
    return 'MotivationalQuoteModel(id: $id, quoteText: $quoteText, author: $author, category: $category, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotivationalQuoteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quoteText, author, category, isActive);

  /// Create a copy of MotivationalQuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotivationalQuoteModelImplCopyWith<_$MotivationalQuoteModelImpl>
      get copyWith => __$$MotivationalQuoteModelImplCopyWithImpl<
          _$MotivationalQuoteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MotivationalQuoteModelImplToJson(
      this,
    );
  }
}

abstract class _MotivationalQuoteModel implements MotivationalQuoteModel {
  const factory _MotivationalQuoteModel(
          {required final String id,
          @JsonKey(name: 'quote_text') required final String quoteText,
          final String? author,
          final String? category,
          @JsonKey(name: 'is_active') final bool? isActive}) =
      _$MotivationalQuoteModelImpl;

  factory _MotivationalQuoteModel.fromJson(Map<String, dynamic> json) =
      _$MotivationalQuoteModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'quote_text')
  String get quoteText;
  @override
  String? get author;
  @override
  String? get category;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;

  /// Create a copy of MotivationalQuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotivationalQuoteModelImplCopyWith<_$MotivationalQuoteModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
