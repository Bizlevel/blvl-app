// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'motivational_quote_model.freezed.dart';
part 'motivational_quote_model.g.dart';

@freezed
class MotivationalQuoteModel with _$MotivationalQuoteModel {
  const factory MotivationalQuoteModel({
    required String id,
    @JsonKey(name: 'quote_text') required String quoteText,
    String? author,
    String? category,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _MotivationalQuoteModel;

  factory MotivationalQuoteModel.fromJson(Map<String, dynamic> json) =>
      _$MotivationalQuoteModelFromJson(json);
}
