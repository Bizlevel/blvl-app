// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motivational_quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MotivationalQuoteModelImpl _$$MotivationalQuoteModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MotivationalQuoteModelImpl(
      id: json['id'] as String,
      quoteText: json['quote_text'] as String,
      author: json['author'] as String?,
      category: json['category'] as String?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$MotivationalQuoteModelImplToJson(
        _$MotivationalQuoteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quote_text': instance.quoteText,
      'author': instance.author,
      'category': instance.category,
      'is_active': instance.isActive,
    };
