import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/custom_image.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Универсальный бар с аватаром, именем пользователя
/// и подписью «Ты на N уровне!».
/// Используется в нескольких экранах (карта уровней, профиль и др.).
class UserInfoBar extends ConsumerWidget {
  const UserInfoBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        // Если пользователя нет (редкий случай) — показываем плейсхолдер
        if (user == null) {
          return const SizedBox.shrink();
        }
        // Подключаемся к балансу ТОЛЬКО после загрузки пользователя/сессии,
        // чтобы не стрелять ранний gp-balance без Authorization.
        final gpAsync = ref.watch(gpBalanceProvider);
        return _buildContent(context, user, gpAsync.value?['balance']);
      },
      loading: () => _buildPlaceholder(),
      error: (err, st) {
        // Показываем SnackBar один раз после пост-фрейма,
        // чтобы не бросать исключение во время билда.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Не удалось загрузить профиль')),
            );
          }
        });
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildContent(BuildContext context, UserModel user, int? gpBalance) {
    // Выбираем изображение аватара: URL из БД либо локальный ресурс по id.
    String avatarPath;
    bool isNetwork;
    if ((user.avatarUrl ?? '').isNotEmpty) {
      avatarPath = user.avatarUrl!;
      isNetwork = true;
    } else if (user.avatarId != null) {
      avatarPath = 'assets/images/avatars/avatar_${user.avatarId}.png';
      isNetwork = false;
    } else {
      // placeholder asset
      avatarPath = 'assets/images/avatars/avatar_1.png';
      isNetwork = false;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomImage(
          avatarPath,
          width: 40,
          height: 40,
          radius: 20,
          isNetwork: isNetwork,
          isShadow: false,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                color: AppColor.labelColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ты на ${user.currentLevel} уровне!',
              style: const TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        if (gpBalance != null)
          Row(
            children: [
              const Icon(Icons.change_circle_outlined,
                  color: AppColor.textColor, size: 18),
              const SizedBox(width: 4),
              Text(
                '${gpBalance} GP',
                style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 120,
      height: 40,
      color: Colors.grey.shade200,
    );
  }
}
