import 'package:bizlevel/models/user_model.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/custom_image.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/services/supabase_service.dart';

/// Универсальный бар с аватаром, именем пользователя
/// и подписью «Ты на N уровне!».
/// Используется в нескольких экранах (карта уровней, профиль и др.).
class UserInfoBar extends ConsumerWidget {
  const UserInfoBar({super.key, this.showGp = true});

  final bool showGp;

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

    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 380;
      final avatar = isNarrow ? 32.0 : 40.0;
      final gpIcon = isNarrow ? 28.0 : 36.0;
      final gpFont = isNarrow ? 14.0 : 16.0;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImage(
            avatarPath,
            width: avatar,
            height: avatar,
            radius: avatar / 2,
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
              FutureBuilder<int>(
                future: SupabaseService.levelNumberFromId(user.currentLevel),
                builder: (context, snap) {
                  final n = snap.data ?? 0;
                  return Text(
                    'Ты на $n уровне!',
                    style: const TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 12),
          if (showGp && gpBalance != null)
            InkWell(
              onTap: () {
                try {
                  if (context.mounted) context.go('/gp-store');
                } catch (_) {}
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/gp_coin.svg',
                    width: gpIcon,
                    height: gpIcon,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$gpBalance',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 56, 56, 56),
                      fontWeight: FontWeight.w600,
                      fontSize: gpFont,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 120,
      height: 40,
      color: Colors.grey.shade200,
    );
  }
}
