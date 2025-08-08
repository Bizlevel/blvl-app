import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_skill_model.dart';
import 'auth_provider.dart';

/// Провайдер для получения списка навыков и очков текущего пользователя.
///
/// Зависит от [authStateProvider] для получения ID пользователя и
/// от [userRepositoryProvider] для выполнения запроса к базе данных.
///
/// Возвращает пустой список, если пользователь не аутентифицирован.
final userSkillsProvider =
    FutureProvider.autoDispose<List<UserSkillModel>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.value?.session?.user;

  if (user == null) {
    // Пользователь не залогинен, возвращаем пустой список.
    return [];
  }

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUserSkills(user.id);
});
