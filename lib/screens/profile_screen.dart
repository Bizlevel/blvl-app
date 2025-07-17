import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/custom_image.dart';
import 'package:online_course/widgets/setting_box.dart';
import 'package:online_course/widgets/setting_item.dart';
import 'package:online_course/widgets/artifact_card.dart';
import 'package:online_course/providers/levels_provider.dart';
import 'package:online_course/screens/payment_screen.dart';
import 'package:online_course/models/user_model.dart';
import 'package:online_course/screens/auth/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Сначала проверяем состояние аутентификации
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (authState) {
        if (kDebugMode) {
          debugPrint(
              'ProfileScreen: authState session = ${authState.session != null}');
        }

        // Если нет сессии - показываем "Не авторизован"
        if (authState.session == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Не авторизован'),
                  ElevatedButton(
                    onPressed: () {
                      // Переход на LoginScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text('Войти'),
                  ),
                ],
              ),
            ),
          );
        }

        // Есть сессия - загружаем пользователя
        final currentUserAsync = ref.watch(currentUserProvider);

        return currentUserAsync.when(
          data: (user) {
            if (kDebugMode) {
              debugPrint(
                  'ProfileScreen: user = ${user?.id}, onboardingCompleted = ${user?.onboardingCompleted}');
            }

            if (user == null) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Профиль не найден'),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(currentUserProvider);
                        },
                        child: const Text('Обновить'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Пользователь загружен - показываем профиль
            return _buildProfileContent(context, ref, user);
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) {
            if (kDebugMode) {
              debugPrint('ProfileScreen: currentUser error = $error');
            }
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ошибка загрузки профиля'),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(currentUserProvider);
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) {
        if (kDebugMode) {
          debugPrint('ProfileScreen: authState error = $error');
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ошибка авторизации'),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(authStateProvider);
                  },
                  child: const Text('Повторить'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(
      BuildContext context, WidgetRef ref, UserModel user) {
    final messagesLeft =
        user.isPremium ? user.leoMessagesToday : user.leoMessagesTotal;

    final levelsAsync = ref.watch(levelsProvider);

    return levelsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text('Ошибка уровней')),
      data: (levelsData) {
        final completedLevelNumbers =
            List.generate(user.currentLevel - 1, (index) => index + 1);

        final accessibleLevels = levelsData.where((lvl) {
          final num = lvl['level'] as int;
          if (user.isPremium) {
            return num <= user.currentLevel; // все до текущего
          }
          return completedLevelNumbers.contains(num);
        }).toList();

        final artifacts = accessibleLevels
            .map((lvl) => {
                  'title': lvl['artifact_title'] ?? 'Артефакт',
                  'description': lvl['artifact_description'] ?? '',
                  'url': lvl['artifact_url'] ?? '',
                  'image': lvl['image'] ?? '',
                })
            .where((a) => (a['url'] as String).isNotEmpty)
            .toList();

        final artifactsCount = artifacts.length;

        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: AppColor.appBgColor,
              pinned: true,
              snap: true,
              floating: true,
              title: Text(
                'Профиль',
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _Body(
                userName: user.name,
                avatarUrl: user.avatarUrl,
                currentLevel: user.currentLevel,
                messagesLeft: messagesLeft,
                artifactsCount: artifactsCount,
                isPremium: user.isPremium,
                artifacts: artifacts,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.userName,
    required this.avatarUrl,
    required this.currentLevel,
    required this.messagesLeft,
    required this.artifactsCount,
    required this.isPremium,
    required this.artifacts,
  });

  final String userName;
  final String? avatarUrl;
  final int currentLevel;
  final int messagesLeft;
  final int artifactsCount;
  final bool isPremium;
  final List<Map<String, dynamic>> artifacts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          _buildProfile(),
          const SizedBox(height: 20),
          _buildRecord(),
          const SizedBox(height: 20),
          if (!isPremium) _buildPremiumButton(context),
          if (!isPremium) const SizedBox(height: 20),
          _buildSection1(context),
          const SizedBox(height: 20),
          _buildSection2(),
          const SizedBox(height: 20),
          _buildSection3(),
          const SizedBox(height: 20),
          _buildArtifactsSection(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        CustomImage(
          avatarUrl ?? 'https://placehold.co/120x120?text=Avatar',
          width: 70,
          height: 70,
          radius: 20,
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecord() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SettingBox(
            title: 'Уровень $currentLevel',
            icon: 'assets/icons/work.svg',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SettingBox(
            title: '$messagesLeft сообщений',
            icon: 'assets/icons/chat.svg',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SettingBox(
            title: '$artifactsCount артефактов',
            icon: 'assets/icons/bag.svg',
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Премиум скоро будет доступен')),
          );
        },
        child: const Text('Получить Premium'),
      ),
    );
  }

  Widget _buildSection1(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          const SettingItem(
            title: 'Настройки',
            leadingIcon: 'assets/icons/setting.svg',
            bgIconColor: AppColor.blue,
          ),
          const DividerWrapper(),
          SettingItem(
            title: 'Оплата',
            leadingIcon: 'assets/icons/wallet.svg',
            bgIconColor: AppColor.green,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PaymentScreen()),
              );
            },
          ),
          const DividerWrapper(),
          const SettingItem(
            title: 'Закладки',
            leadingIcon: 'assets/icons/bookmark.svg',
            bgIconColor: AppColor.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSection2() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Column(
        children: [
          SettingItem(
            title: 'Уведомления',
            leadingIcon: 'assets/icons/bell.svg',
            bgIconColor: AppColor.purple,
          ),
          DividerWrapper(),
          SettingItem(
            title: 'Приватность',
            leadingIcon: 'assets/icons/shield.svg',
            bgIconColor: AppColor.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSection3() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SettingItem(
        title: 'Выйти',
        leadingIcon: 'assets/icons/logout.svg',
        bgIconColor: AppColor.darker,
        onTap: () async {
          await AuthService.signOut();
        },
      ),
    );
  }

  Widget _buildArtifactsSection() {
    if (artifacts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.cardColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Text(
          'Нет доступных артефактов',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Column(
      children: artifacts
          .map(
            (a) => ArtifactCard(
              title: a['title'] as String,
              description: a['description'] as String,
              image: a['image'] as String,
              url: a['url'] as String,
            ),
          )
          .toList(),
    );
  }
}

class DividerWrapper extends StatelessWidget {
  const DividerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Divider(
        height: 0,
        color: Colors.grey.withOpacity(0.8),
      ),
    );
  }
}
