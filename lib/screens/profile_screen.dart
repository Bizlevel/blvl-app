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
import 'package:online_course/providers/subscription_provider.dart';
import 'package:online_course/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

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
                      // Перенаправление через GoRouter
                      context.go('/login');
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
        final subAsync = ref.watch(subscriptionProvider);

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

            // определяем премиум по полю БД или активной подписке
            final isPremium = user.isPremium ||
                (subAsync.asData?.value == 'active');
            return _buildProfileContent(context, ref, user,
                isPremiumOverride: isPremium);
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
      BuildContext context, WidgetRef ref, UserModel user,
      {bool? isPremiumOverride}) {
    final isPremium = isPremiumOverride ?? user.isPremium;
    final messagesLeft =
        isPremium ? user.leoMessagesToday : user.leoMessagesTotal;

    final levelsAsync = ref.watch(levelsProvider);

    return levelsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text('Ошибка уровней')),
      data: (levelsData) {
        final completedLevelNumbers =
            List.generate(user.currentLevel - 1, (index) => index + 1);

        final completedLevels = levelsData.where((lvl) {
          final levelNum = lvl['level'] as int;
          final progressArr = lvl['user_progress'] as List?;
          final bool isCompleted = progressArr != null && progressArr.isNotEmpty
              ? (progressArr.first['is_completed'] as bool? ?? false)
              : false;
          return levelNum < user.currentLevel || isCompleted;
        }).toList();

        final artifacts = completedLevels
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
                isPremium: isPremium,
                artifacts: artifacts,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Body extends ConsumerStatefulWidget {
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
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  bool _isUploading = false;

  Future<void> _uploadFile() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        debugPrint('File picking cancelled.');
        setState(() {
          _isUploading = false;
        });
        return;
      }

      final file = result.files.single;
      final filePath = file.path!;
      final fileName = file.name;

      debugPrint('Attempting to upload: $fileName');

      final response = await Supabase.instance.client.storage
          .from('artifacts')
          .upload(
            fileName,
            File(filePath),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      debugPrint('Upload successful: $response');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload successful!')),
      );
    } on StorageException catch (e) {
      debugPrint('Detailed Storage Error: ${e.message}');
      debugPrint('Detailed Storage Error statusCode: ${e.statusCode}');
      debugPrint('Detailed Storage Error error: ${e.error}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage Error: ${e.message}')),
      );
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Column(
        children: [
          _buildProfile(),
          const SizedBox(height: AppSpacing.medium),
          _buildRecord(),
          const SizedBox(height: AppSpacing.medium),
          if (!widget.isPremium) _buildPremiumButton(context),
          if (!widget.isPremium) const SizedBox(height: AppSpacing.medium),
          _buildSection1(context),
          const SizedBox(height: AppSpacing.medium),
          _buildSection2(),
          const SizedBox(height: AppSpacing.medium),
          _buildSection3(),
          const SizedBox(height: AppSpacing.medium),
          _buildArtifactsSection(),
          const SizedBox(height: AppSpacing.medium),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Row(
      children: [
        CustomImage(
          widget.avatarUrl ??
              "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
          width: 80,
          height: 80,
          radius: 40,
        ),
        const SizedBox(width: AppSpacing.small),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                if (widget.isPremium)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: AppSpacing.small / 2),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Premium',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.small),
            const Text(
              "BizLevel",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
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
            title: "${widget.currentLevel} LVL",
            icon: "assets/icons/work.svg",
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: SettingBox(
            title: "${widget.messagesLeft} Leo",
            icon: "assets/icons/chat.svg",
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: SettingBox(
            title: "${widget.artifactsCount} Artfs",
            icon: "assets/icons/shield.svg",
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/premium');
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.primary,
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.white, size: 20),
            SizedBox(width: AppSpacing.small),
            Text(
              "Активировать премиум",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection1(BuildContext context) {
    return SettingItem(
      title: "Настройки",
      leadingIcon: "assets/icons/setting.svg",
      bgIconColor: AppColor.blue,
      onTap: () {},
    );
  }

  Widget _buildSection2() {
    return SettingItem(
      title: "Платежи",
      leadingIcon: "assets/icons/wallet.svg",
      bgIconColor: AppColor.orange,
      onTap: () {},
    );
  }

  Widget _buildSection3() {
    return SettingItem(
      title: "Выход",
      leadingIcon: "assets/icons/logout.svg",
      bgIconColor: AppColor.red,
      onTap: () async {
        await ref.read(authServiceProvider).signOut();
      },
    );
  }

  Widget _buildArtifactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Артефакты",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        if (widget.artifacts.isEmpty)
          const Center(child: Text("У вас пока нет артефактов."))
        else
          ...widget.artifacts.map(
            (artifact) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.small),
              child: ArtifactCard(
                title: artifact['title'],
                description: artifact['description'],
                url: artifact['url'],
                image: artifact['image'],
              ),
            ),
          ),
      ],
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
