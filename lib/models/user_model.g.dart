// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      about: json['about'] as String?,
      goal: json['goal'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      currentLevel: (json['current_level'] as num?)?.toInt() ?? 1,
      leoMessagesTotal: (json['leo_messages_total'] as num?)?.toInt() ?? 30,
      leoMessagesToday: (json['leo_messages_today'] as num?)?.toInt() ?? 30,
      leoResetAt: json['leo_reset_at'] == null
          ? null
          : DateTime.parse(json['leo_reset_at'] as String),
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'about': instance.about,
      'goal': instance.goal,
      'is_premium': instance.isPremium,
      'current_level': instance.currentLevel,
      'leo_messages_total': instance.leoMessagesTotal,
      'leo_messages_today': instance.leoMessagesToday,
      'leo_reset_at': instance.leoResetAt?.toIso8601String(),
      'onboarding_completed': instance.onboardingCompleted,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
