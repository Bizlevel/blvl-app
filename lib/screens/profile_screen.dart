import 'package:bizlevel/providers/user_skills_provider.dart';
import 'package:bizlevel/widgets/skills_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/custom_image.dart';
import 'package:bizlevel/widgets/stat_card.dart';
// import 'package:bizlevel/widgets/setting_item.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/providers/levels_repository_provider.dart';
import 'package:bizlevel/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizlevel/providers/gp_providers.dart';

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
        // Подписки отключены — провайдер не используется

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

            // Премиум отключён; используем только поле БД (будет удалено позже)
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
    final gp = ref.watch(gpBalanceProvider).value?['balance'] ?? 0;

    final levelsAsync = ref.watch(levelsProvider);

    return levelsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text('Ошибка уровней')),
      data: (levelsData) {
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
                  'level': lvl['level'],
                })
            .where((a) => (a['url'] as String).isNotEmpty)
            .toList();

        final artifactsCount = artifacts.length;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColor.appBgColor,
              pinned: true,
              snap: true,
              floating: true,
              title: const Text(
                'Профиль',
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                // Мини‑баланс GP в шапке профиля
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      try {
                        if (context.mounted) context.go('/gp-store');
                      } catch (_) {}
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/images/gp_coin.svg',
                            width: 28, height: 28),
                        const SizedBox(width: 6),
                        Text('$gp',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.settings, color: Colors.grey),
                  onSelected: (value) async {
                    switch (value) {
                      case 'settings':
                        // Пока отдельного экрана нет — подскажем пользователю
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Раздел настроек скоро будет доступен')),
                        );
                        break;
                      case 'payments':
                        // Платежи Premium отключены на этапе 39.1
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Скоро: покупки GP')),
                        );
                        break;
                      case 'logout':
                        await ref.read(authServiceProvider).signOut();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColor.blue,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/setting.svg',
                              color: Colors.white,
                              width: 18,
                              height: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text('Настройки'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'payments',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColor.orange,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/wallet.svg',
                              color: Colors.white,
                              width: 18,
                              height: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text('Платежи'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColor.red,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/logout.svg',
                              color: Colors.white,
                              width: 18,
                              height: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text('Выход'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: _Body(
                userName: user.name,
                avatarId: user.avatarId,
                currentLevel: user.currentLevel,
                messagesLeft: gp,
                artifactsCount: artifactsCount,
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
    required this.avatarId,
    required this.currentLevel,
    required this.messagesLeft,
    required this.artifactsCount,
    required this.artifacts,
  });

  final String userName;
  final int? avatarId;
  final int currentLevel;
  final int messagesLeft;
  final int artifactsCount;
  final List<Map<String, dynamic>> artifacts;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  // ignore: unused_field
  bool _isUploading = false;

  String _pluralizeArtifacts(int n) {
    final int nMod100 = n % 100;
    if (nMod100 >= 11 && nMod100 <= 14) {
      return 'Артефактов';
    }
    switch (n % 10) {
      case 1:
        return 'Артефакт';
      case 2:
      case 3:
      case 4:
        return 'Артефакта';
      default:
        return 'Артефактов';
    }
  }

  Future<void> _openArtifactUrl(String link) async {
    try {
      String url = link;
      if (!url.startsWith('http')) {
        final repo = ref.read(levelsRepositoryProvider);
        final signed = await repo.getArtifactSignedUrl(url);
        if (signed == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось получить ссылку на файл')),
          );
          return;
        }
        url = signed;
      }
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка открытия файла')),
      );
    }
  }

  Future<void> _openArtifactsModal() async {
    if (widget.artifacts.isEmpty) {
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        builder: (ctx) {
          return SizedBox(
            height: 260,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('Артефактов пока нет',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Проходите уровни, чтобы открывать полезные материалы и шаблоны.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          initialChildSize: 0.6,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.small,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Артефакты',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.artifacts.length} ${_pluralizeArtifacts(widget.artifacts.length)}',
                          style: const TextStyle(color: AppColor.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: widget.artifacts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final a = widget.artifacts[index];
                      final String title =
                          (a['title'] as String?) ?? 'Артефакт';
                      final String desc = (a['description'] as String?) ?? '';
                      final String url = (a['url'] as String?) ?? '';
                      final int? levelNumber = a['level'] as int?;
                      final String subtitleLine = levelNumber == null
                          ? desc
                          : [
                              if (desc.isNotEmpty) desc,
                              'Уровень ${levelNumber.toString()}'
                            ].where((e) => e.isNotEmpty).join(' • ');
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CustomImage(
                              (a['image'] as String?) ?? '',
                              radius: 8,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        title: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: subtitleLine.isEmpty
                            ? null
                            : Text(
                                subtitleLine,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          color: AppColor.primary,
                          onPressed: () => _openArtifactUrl(url),
                        ),
                        onTap: () => _openArtifactUrl(url),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAvatarPicker() async {
    final selectedId = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.medium),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.medium,
            crossAxisSpacing: AppSpacing.medium,
          ),
          itemCount: 12,
          itemBuilder: (_, index) {
            final id = index + 1;
            final asset = 'assets/images/avatars/avatar_${id}.png';
            final isSelected = id == widget.avatarId;
            return GestureDetector(
              onTap: () => Navigator.of(ctx).pop(id),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(asset, fit: BoxFit.cover),
                  ),
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primary, width: 3),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selectedId != null && selectedId != widget.avatarId) {
      // Обновляем аватар в Supabase
      await ref.read(authServiceProvider).updateAvatar(selectedId);
      // Инвалидируем профиль
      ref.invalidate(currentUserProvider);
    }
  }

  // ignore: unused_element
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
    final skillsAsync = ref.watch(userSkillsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Column(
        children: [
          _buildProfile(),
          const SizedBox(height: AppSpacing.medium),
          _buildRecord(),
          const SizedBox(height: AppSpacing.medium),
          skillsAsync.when(
            data: (skills) => SkillsTreeView(
                skills: skills, currentLevel: widget.currentLevel),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) =>
                const Center(child: Text('Ошибка загрузки навыков')),
          ),
          const SizedBox(height: AppSpacing.medium),
          // Premium отключён — кнопка скрыта
          // Секция артефактов скрыта — используйте карточку статистики выше
        ],
      ),
    );
  }

  Widget _buildProfile() {
    final String localAsset = widget.avatarId != null
        ? 'assets/images/avatars/avatar_${widget.avatarId}.png'
        : '';

    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: _showAvatarPicker,
              child: CustomImage(
                (localAsset.isNotEmpty
                    ? localAsset
                    : "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=800&q=60"),
                width: 80,
                height: 80,
                radius: 40,
                isNetwork: localAsset.isEmpty,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 8,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
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
        ),
      ],
    );
  }

  Widget _buildRecord() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: StatCard(
            title: "${widget.currentLevel} Уровень",
            icon: Icons.work,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _openArtifactsModal,
            child: Stack(
              children: [
                // Stack будет принимать размер по ненапозиционированному ребёнку
                StatCard(
                  title:
                      "${widget.artifactsCount} ${_pluralizeArtifacts(widget.artifactsCount)}",
                  icon: Icons.inventory_2_outlined,
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Icon(
                    Icons.expand_more,
                    size: 16,
                    color: Colors.grey.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Premium кнопка удалена (этап 39.1)

  // Секции настроек/платежей/выхода перенесены в меню шестерёнки AppBar

  // Секция артефактов удалена согласно задаче 31.16 — используется модалка
}

class DividerWrapper extends StatelessWidget {
  const DividerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Divider(
        height: 0,
        color: Colors.grey.withValues(alpha: 0.8),
      ),
    );
  }
}
