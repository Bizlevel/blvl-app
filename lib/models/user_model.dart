import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? about,
    String? goal,
    @JsonKey(name: 'is_premium') @Default(false) bool isPremium,
    @JsonKey(name: 'current_level') @Default(1) int currentLevel,
    @JsonKey(name: 'leo_messages_total') @Default(30) int leoMessagesTotal,
    @JsonKey(name: 'leo_messages_today') @Default(30) int leoMessagesToday,
    @JsonKey(name: 'leo_reset_at') DateTime? leoResetAt,
    @JsonKey(name: 'onboarding_completed')
    @Default(false)
    bool onboardingCompleted,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
