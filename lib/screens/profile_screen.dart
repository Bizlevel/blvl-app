import 'package:bizlevel/providers/user_skills_provider.dart';
import 'package:bizlevel/widgets/skills_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/custom_image.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/widgets/common/bizlevel_error.dart';
import 'package:bizlevel/widgets/common/bizlevel_loading.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/gp_balance_widget.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/bizlevel_text_field.dart';
import 'package:bizlevel/widgets/reminders_settings_sheet.dart';
import 'package:bizlevel/services/media_picker_service.dart';
import 'package:bizlevel/widgets/common/achievement_badge.dart';
import 'package:bizlevel/providers/theme_provider.dart';
import 'package:bizlevel/theme/dimensions.dart';

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
                  BizLevelButton(
                    label: 'Войти',
                    onPressed: () {
                      // Перенаправление через GoRouter
                      context.go('/login');
                    },
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
                      BizLevelButton(
                        label: 'Обновить',
                        onPressed: () {
                          ref.invalidate(currentUserProvider);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            // Премиум отключён; используем только поле БД (будет удалено позже)
            return _buildProfileContent(context, ref, user);
          },
          loading: () => BizLevelLoading.fullscreen(),
          error: (error, stackTrace) {
            if (kDebugMode) {
              debugPrint('ProfileScreen: currentUser error = $error');
            }
            return BizLevelError(
              title: 'Ошибка загрузки профиля',
              fullscreen: true,
              onRetry: () => ref.invalidate(currentUserProvider),
            );
          },
        );
      },
      loading: () => BizLevelLoading.fullscreen(),
      error: (error, stackTrace) {
        if (kDebugMode) {
          debugPrint('ProfileScreen: authState error = $error');
        }
        return BizLevelError(
          title: 'Ошибка авторизации',
          fullscreen: true,
          onRetry: () => ref.invalidate(authStateProvider),
        );
      },
    );
  }

  Widget _buildProfileContent(
      BuildContext context, WidgetRef ref, UserModel user) {
    final gp = ref.watch(gpBalanceProvider).value?['balance'] ?? 0;

    final levelsAsync = ref.watch(levelsProvider);

    return levelsAsync.when(
      loading: () => BizLevelLoading.fullscreen(),
      error: (e, s) =>
          const BizLevelError(title: 'Ошибка уровней', fullscreen: true),
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
            .map((lvl) {
              final int levelNum = (lvl['level'] as int? ?? 0);
              // Для обложек артефактов используем локальные assets lvls/level_X.png
              final String assetCover = levelNum >= 1 && levelNum <= 10
                  ? 'assets/images/lvls/level_$levelNum.png'
                  : (lvl['image'] ?? '');
              return {
                'title': lvl['artifact_title'] ?? 'Артефакт',
                'description': lvl['artifact_description'] ?? '',
                'url': lvl['artifact_url'] ?? '',
                'image': assetCover,
                'level': levelNum,
              };
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
              title: Text(
                'Профиль',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: AppColor.textColor),
              ),
              actions: [
                const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.sm),
                  child: SizedBox(
                    width: 76,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: _ProfileGpBalanceSlot(),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.settings,
                      color: AppColor.onSurfaceSubtle),
                  onSelected: (value) async {
                    switch (value) {
                      case 'theme':
                        final mode = ref.read(themeModeProvider);
                        final next = mode == ThemeMode.light
                            ? ThemeMode.dark
                            : ThemeMode.light;
                        ref.read(themeModeProvider.notifier).state = next;
                        break;
                      case 'notifications':
                        await showRemindersSettingsSheet(context);
                        break;
                      case 'settings':
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Раздел настроек скоро будет доступен')),
                        );
                        break;
                      case 'payments':
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
                      value: 'theme',
                      child: Row(
                        children: [
                          const Icon(Icons.brightness_6, size: 18),
                          AppSpacing.gapW(AppSpacing.s10),
                          const Text('Тема: переключить'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'notifications',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s6),
                            decoration: const BoxDecoration(
                              color: AppColor.blue,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/bell.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColor.onPrimary,
                                BlendMode.srcIn,
                              ),
                              width: 18,
                              height: 18,
                            ),
                          ),
                          AppSpacing.gapW(AppSpacing.s10),
                          const Text('Уведомления'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s6),
                            decoration: const BoxDecoration(
                              color: AppColor.blue,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/setting.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColor.onPrimary,
                                BlendMode.srcIn,
                              ),
                              width: 18,
                              height: 18,
                            ),
                          ),
                          AppSpacing.gapW(AppSpacing.s10),
                          const Text('Настройки'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'payments',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s6),
                            decoration: const BoxDecoration(
                              color: AppColor.orange,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/wallet.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColor.onPrimary,
                                BlendMode.srcIn,
                              ),
                              width: 18,
                              height: 18,
                            ),
                          ),
                          AppSpacing.gapW(AppSpacing.s10),
                          const Text('Платежи'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.s6),
                            decoration: const BoxDecoration(
                              color: AppColor.red,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/logout.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColor.onPrimary,
                                BlendMode.srcIn,
                              ),
                              width: 18,
                              height: 18,
                            ),
                          ),
                          AppSpacing.gapW(AppSpacing.s10),
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
                user: user,
                userName: user.name,
                avatarId: user.avatarId,
                currentLevel:
                    ref.watch(currentLevelNumberProvider).asData?.value ??
                        user.currentLevel,
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

// Локальный слот, чтобы не ломать существующую структуру AppBar
class _ProfileGpBalanceSlot extends StatelessWidget {
  const _ProfileGpBalanceSlot();
  @override
  Widget build(BuildContext context) {
    return const GpBalanceWidget(compact: true);
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.user,
    required this.userName,
    required this.avatarId,
    required this.currentLevel,
    required this.messagesLeft,
    required this.artifactsCount,
    required this.artifacts,
  });

  final UserModel user;
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
  Uint8List? _avatarPreviewBytes;

  Future<void> _pickAvatarFromGallery() async {
    final result =
        await MediaPickerService.instance.pickImageFromGallery(context);
    if (!mounted || result == null) return;
    setState(() {
      _avatarPreviewBytes = result.bytes;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Фото выбрано. Синхронизация с профилем появится позже.'),
      ),
    );
  }

  void _clearAvatarPreview() {
    if (_avatarPreviewBytes == null) return;
    setState(() {
      _avatarPreviewBytes = null;
    });
  }
  // Upload артефактов убран — состояние загрузки не требуется

  // Плюрализация артефактов больше не используется

  // Скачивание артефактов убрано — используйте экран /artifacts

  // Старый модал артефактов убран — вместо этого ведём на экран /artifacts

  Future<void> _openAboutMeModal() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.surface,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          initialChildSize: 0.66,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Информация обо мне',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      // fix: добавить tooltip для IconButton (accessibility)
                      IconButton(
                        tooltip: 'Закрыть',
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: _AboutMeCard(user: widget.user),
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
      backgroundColor: AppColor.surface,
      builder: (ctx) {
        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
          ),
          itemCount: 12,
          itemBuilder: (_, index) {
            final id = index + 1;
            final asset = 'assets/images/avatars/avatar_$id.png';
            final isSelected = id == widget.avatarId;
            return GestureDetector(
              onTap: () => Navigator.of(ctx).pop(id),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusAvatar),
                    child: Image.asset(asset, fit: BoxFit.cover),
                  ),
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primary, width: 3),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusAvatar),
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

  @override
  Widget build(BuildContext context) {
    final skillsAsync = ref.watch(userSkillsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          _buildProfile(),
          const SizedBox(height: AppSpacing.lg),

          // Блок статистики (уровень/артефакты) убран по новой спецификации
          skillsAsync.when(
            data: (skills) => SkillsTreeView(
                skills: skills, currentLevel: widget.currentLevel),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) =>
                const Center(child: Text('Ошибка загрузки навыков')),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Достижения',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          AppSpacing.gapH(AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const AchievementBadge(icon: Icons.flag, label: 'Первая цель'),
                AppSpacing.gapW(AppSpacing.md),
                const AchievementBadge(
                    icon: Icons.rocket_launch,
                    rarity: AchievementRarity.rare,
                    label: '5 уровней'),
                AppSpacing.gapW(AppSpacing.md),
                const AchievementBadge(
                    icon: Icons.stars,
                    rarity: AchievementRarity.epic,
                    label: 'AI‑навык +50'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
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

    final Widget avatarImage = _avatarPreviewBytes != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusAvatar),
            child: Image.memory(
              _avatarPreviewBytes!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          )
        : CustomImage(
            (localAsset.isNotEmpty
                ? localAsset
                : "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=800&q=60"),
            width: 80,
            height: 80,
            radius: 40,
            isNetwork: localAsset.isEmpty,
          );

    return Semantics(
        label: 'Аватар пользователя',
        button: true,
        child: Row(
          children: [
            _AvatarControls(
              avatarImage: avatarImage,
              onPickPreset: _showAvatarPicker,
              onPickGallery: _pickAvatarFromGallery,
              onResetPreview: _clearAvatarPreview,
              hasPreview: _avatarPreviewBytes != null,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Имя и уровень слева, занимают всё доступное пространство
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            AppSpacing.gapH(AppSpacing.s6),
                            Builder(builder: (context) {
                              final n = ref
                                      .watch(currentLevelNumberProvider)
                                      .asData
                                      ?.value ??
                                  widget.currentLevel;
                              return Text(
                                'Уровень $n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColor.onSurfaceSubtle),
                              );
                            }),
                          ],
                        ),
                      ),
                      // Кнопка справа с авто-скейлом (без overflow)
                      SizedBox(
                        height: 80,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: OutlinedButton(
                              onPressed: _openAboutMeModal,
                              style: OutlinedButton.styleFrom(
                                padding: AppSpacing.insetsSymmetric(
                                    h: AppSpacing.s10, v: AppSpacing.s6),
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(
                                    color: AppColor.primary
                                        .withValues(alpha: 0.6)),
                                foregroundColor: AppColor.primary,
                              ),
                              child: const _InfoButtonLabel(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  // Блок статистики удалён (уровень показывается под именем; «Информация обо мне» вынесена в заголовок)

  // Premium кнопка удалена (этап 39.1)

  // Секции настроек/платежей/выхода перенесены в меню шестерёнки AppBar

  // Секция артефактов удалена согласно задаче 31.16 — используется модалка
}

class _AvatarControls extends StatelessWidget {
  const _AvatarControls({
    required this.avatarImage,
    required this.onPickPreset,
    required this.onPickGallery,
    required this.onResetPreview,
    required this.hasPreview,
  });

  final Widget avatarImage;
  final VoidCallback onPickPreset;
  final VoidCallback onPickGallery;
  final VoidCallback onResetPreview;
  final bool hasPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: onPickPreset,
              child: avatarImage,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.shadow,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: AppSpacing.insetsAll(AppSpacing.xs),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ),
            if (hasPreview)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColor.orange,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: const Text(
                    'BETA',
                    style: TextStyle(
                      color: AppColor.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onPickGallery,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.photo_library_outlined, size: 16),
          label: const Text('Галерея (beta)'),
        ),
        if (hasPreview)
          TextButton(
            onPressed: onResetPreview,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Сбросить фото',
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _AboutMeCard extends ConsumerStatefulWidget {
  const _AboutMeCard(
      {required this.user,
      this.showTitle = true}); // ignore: unused_element_parameter
  final UserModel user;
  final bool showTitle;

  @override
  ConsumerState<_AboutMeCard> createState() => _AboutMeCardState();
}

class _AboutMeCardState extends ConsumerState<_AboutMeCard> {
  bool _editing = false;
  bool _expandedDetails = false;

  late final TextEditingController _nameCtrl =
      TextEditingController(text: widget.user.name);
  late final TextEditingController _aboutCtrl =
      TextEditingController(text: widget.user.about ?? '');
  late final TextEditingController _goalCtrl =
      TextEditingController(text: widget.user.goal ?? '');
  late final TextEditingController _businessAreaCtrl =
      TextEditingController(text: widget.user.businessArea ?? '');
  late final TextEditingController _experienceLevelCtrl =
      TextEditingController(text: widget.user.experienceLevel ?? '');
  late final TextEditingController _businessSizeCtrl =
      TextEditingController(text: widget.user.businessSize ?? '');
  late final TextEditingController _learningStyleCtrl =
      TextEditingController(text: widget.user.learningStyle ?? '');
  late final TextEditingController _businessRegionCtrl =
      TextEditingController(text: widget.user.businessRegion ?? '');

  final Set<String> _keyChallenges = {};

  @override
  void initState() {
    super.initState();
    _keyChallenges.addAll(widget.user.keyChallenges ?? const []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _aboutCtrl.dispose();
    _goalCtrl.dispose();
    _businessAreaCtrl.dispose();
    _experienceLevelCtrl.dispose();
    _businessSizeCtrl.dispose();
    _learningStyleCtrl.dispose();
    _businessRegionCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await ref.read(authServiceProvider).updateProfile(
            name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
            about:
                _aboutCtrl.text.trim().isEmpty ? null : _aboutCtrl.text.trim(),
            goal: _goalCtrl.text.trim().isEmpty ? null : _goalCtrl.text.trim(),
            businessArea: _businessAreaCtrl.text.trim().isEmpty
                ? null
                : _businessAreaCtrl.text.trim(),
            experienceLevel: _experienceLevelCtrl.text.trim().isEmpty
                ? null
                : _experienceLevelCtrl.text.trim(),
            businessSize: _businessSizeCtrl.text.trim().isEmpty
                ? null
                : _businessSizeCtrl.text.trim(),
            keyChallenges:
                _keyChallenges.isEmpty ? null : _keyChallenges.toList(),
            learningStyle: _learningStyleCtrl.text.trim().isEmpty
                ? null
                : _learningStyleCtrl.text.trim(),
            businessRegion: _businessRegionCtrl.text.trim().isEmpty
                ? null
                : _businessRegionCtrl.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль обновлён')),
      );
      // Подсказка о возможном бонусе за полный профиль (если все поля заполнены)
      try {
        final nameOk = _nameCtrl.text.trim().isNotEmpty;
        final aboutOk = _aboutCtrl.text.trim().isNotEmpty;
        final goalOk = _goalCtrl.text.trim().isNotEmpty;
        final hasAvatar =
            (ref.read(currentUserProvider).value?.avatarId ?? 0) > 0;
        if (nameOk && aboutOk && goalOk && hasAvatar) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('+50 GP за полный профиль')),
          );
        }
      } catch (_) {}
      ref.invalidate(currentUserProvider);
      setState(() => _editing = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_editing) {
      final chips = (widget.user.keyChallenges ?? const [])
          .map((e) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                margin: const EdgeInsets.only(
                    right: AppSpacing.s6, bottom: AppSpacing.s6),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                      color: AppColor.primary.withValues(alpha: 0.2)),
                ),
                child: Text(e,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColor.primary)),
              ))
          .toList();

      final completion = _computeCompletion();
      return BizLevelCard(
        semanticsLabel: 'Информация обо мне',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.showTitle)
                  Expanded(
                    child: Text('Информация обо мне',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Заполнено ${completion.$2}%',
                        textAlign: TextAlign.right,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColor.onSurfaceSubtle),
                      ),
                      AppSpacing.gapH(AppSpacing.xs),
                      SizedBox(
                        height: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          child: LinearProgressIndicator(
                            value: completion.$1,
                            backgroundColor:
                                AppColor.onSurfaceSubtle.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation(
                              AppColor.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColor.onSurfaceSubtle),
                  onPressed: () => setState(() => _editing = true),
                  tooltip: 'Редактировать',
                )
              ],
            ),
            AppSpacing.gapH(AppSpacing.sm),
            _kv('Как к вам обращаться', widget.user.name),
            _kv('Цель обучения', widget.user.goal ?? '—'),
            _kv('Сфера деятельности', widget.user.businessArea ?? '—'),
            if (_expandedDetails) ...[
              _kv('Кратко о себе', widget.user.about ?? '—'),
              _kv('Уровень опыта', widget.user.experienceLevel ?? '—'),
              _kv('Размер бизнеса', widget.user.businessSize ?? '—'),
              _kv('Предпочитаемый стиль обучения',
                  widget.user.learningStyle ?? '—'),
              _kv('Регион ведения бизнеса', widget.user.businessRegion ?? '—'),
            ],
            if (chips.isNotEmpty) ...[
              AppSpacing.gapH(AppSpacing.sm),
              Wrap(children: chips),
            ],
            AppSpacing.gapH(AppSpacing.sm),
            Text(
              'Чем подробнее вы заполните профиль, тем точнее советы Лео и Макса.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColor.onSurfaceSubtle),
            ),
            AppSpacing.gapH(AppSpacing.s10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () =>
                    setState(() => _expandedDetails = !_expandedDetails),
                child: Text(_expandedDetails
                    ? 'Свернуть подробности'
                    : 'Показать подробности'),
              ),
            ),
          ],
        ),
      );
    }

    // Режим редактирования
    return BizLevelCard(
      semanticsLabel: 'Редактирование профиля',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.showTitle)
                Expanded(
                  child: Text('Информация обо мне',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColor.onSurfaceSubtle),
                onPressed: () => setState(() => _editing = false),
                tooltip: 'Отмена',
              )
            ],
          ),
          AppSpacing.gapH(AppSpacing.sm),
          BizLevelTextField(
              label: 'Как к вам обращаться', controller: _nameCtrl),
          AppSpacing.gapH(AppSpacing.md),
          BizLevelTextField(label: 'Кратко о себе', controller: _aboutCtrl),
          AppSpacing.gapH(AppSpacing.md),
          BizLevelTextField(
            label: 'Ваша цель обучения',
            controller: _goalCtrl,
            hint: 'Ключевой результат и зачем он вам',
          ),
          AppSpacing.gapH(AppSpacing.md),
          BizLevelTextField(
            label: 'Сфера деятельности',
            controller: _businessAreaCtrl,
            hint: 'Например: розница, услуги, производство',
          ),
          AppSpacing.gapH(AppSpacing.md),
          _ExperienceChips(
            label: 'Уровень опыта',
            value: _experienceLevelCtrl.text.isNotEmpty
                ? _experienceLevelCtrl.text
                : null,
            options: const ['Начинающий', '1–3 года', '3–10 лет', '10+ лет'],
            onChanged: (v) {
              _experienceLevelCtrl.text = v ?? '';
              setState(() {});
            },
          ),
          AppSpacing.gapH(AppSpacing.md),
          _DropdownLabeled(
            label: 'Размер бизнеса',
            value: _businessSizeCtrl.text.isNotEmpty
                ? _businessSizeCtrl.text
                : null,
            options: const [
              'Только планирую',
              'до 5 сотрудников',
              '5-50 сотрудников',
              'более 50 сотрудников',
            ],
            onChanged: (v) {
              if (v != null) _businessSizeCtrl.text = v;
              setState(() {});
            },
          ),
          AppSpacing.gapH(AppSpacing.md),
          _ChallengesEditor(
            initial: _keyChallenges,
            onChanged: (set) => setState(() {
              _keyChallenges
                ..clear()
                ..addAll(set);
            }),
          ),
          AppSpacing.gapH(AppSpacing.md),
          _DropdownLabeled(
            label: 'Предпочитаемый стиль обучения',
            value: _learningStyleCtrl.text.isNotEmpty
                ? _learningStyleCtrl.text
                : null,
            options: const [
              'Практические примеры',
              'Теория с разбором',
              'Пошаговые инструкции',
            ],
            onChanged: (v) {
              if (v != null) _learningStyleCtrl.text = v;
              setState(() {});
            },
          ),
          AppSpacing.gapH(AppSpacing.md),
          BizLevelTextField(
            label: 'Регион ведения бизнеса',
            controller: _businessRegionCtrl,
            hint: 'Город/область — влияет на советы',
          ),
          AppSpacing.gapH(AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: BizLevelButton(
                  label: 'Сохранить',
                  onPressed: _save,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Оценка заполненности профиля: возвращает (ratio 0..1, percent)
  (double, int) _computeCompletion() {
    final fields = <bool>[
      widget.user.name.trim().isNotEmpty,
      (widget.user.goal ?? '').trim().isNotEmpty,
      (widget.user.about ?? '').trim().isNotEmpty,
      (widget.user.businessArea ?? '').trim().isNotEmpty,
      (widget.user.experienceLevel ?? '').trim().isNotEmpty,
      (widget.user.businessSize ?? '').trim().isNotEmpty,
      (widget.user.learningStyle ?? '').trim().isNotEmpty,
      (widget.user.businessRegion ?? '').trim().isNotEmpty,
      (widget.user.keyChallenges ?? const []).isNotEmpty,
    ];
    final filled = fields.where((e) => e).length;
    final total = fields.length;
    final ratio = total == 0 ? 0.0 : filled / total;
    return (ratio, (ratio * 100).round());
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColor.onSurfaceSubtle)),
          ),
          AppSpacing.gapW(AppSpacing.sm),
          Expanded(
            child: Text(value.isEmpty ? '—' : value,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  // Компактная двухстрочная надпись для кнопки в шапке
}

class _InfoButtonLabel extends StatelessWidget {
  const _InfoButtonLabel();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('Информация'),
        AppSpacing.gapH(AppSpacing.xs),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('обо мне'),
            AppSpacing.gapW(AppSpacing.s6),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ],
    );
  }
}

class _ChallengesEditor extends StatefulWidget {
  const _ChallengesEditor({required this.initial, required this.onChanged});
  final Set<String> initial;
  final ValueChanged<Set<String>> onChanged;

  @override
  State<_ChallengesEditor> createState() => _ChallengesEditorState();
}

class _ExperienceChips extends StatelessWidget {
  const _ExperienceChips({
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
  });

  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        AppSpacing.gapH(AppSpacing.s6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((o) {
            final isSelected = o == value;
            return Semantics(
              button: true,
              selected: isSelected,
              label: o,
              child: GestureDetector(
                onTap: () => onChanged(isSelected ? null : o),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s10, vertical: AppSpacing.s6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.primary.withValues(alpha: 0.1)
                        : AppColor.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.primary
                          : AppColor.onSurfaceSubtle.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    o,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppColor.primary
                              : AppColor.textColor,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DropdownLabeled extends StatelessWidget {
  const _DropdownLabeled({
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
  });

  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        AppSpacing.gapH(AppSpacing.s6),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: options
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}

class _ChallengesEditorState extends State<_ChallengesEditor> {
  static const _options = <String>[
    'Поиск клиентов',
    'Финансы',
    'Команда',
    'Конкуренты',
    'Масштабирование',
  ];
  final List<String> _custom = [];

  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Основные вызовы',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        AppSpacing.gapH(AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._options.map((o) {
              final isSelected = _selected.contains(o);
              return Semantics(
                button: true,
                selected: isSelected,
                label: o,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(o);
                      } else {
                        _selected.add(o);
                      }
                    });
                    widget.onChanged(_selected);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s10, vertical: AppSpacing.s6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.primary.withValues(alpha: 0.1)
                          : AppColor.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.primary
                            : AppColor.onSurfaceSubtle.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      o,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? AppColor.primary
                                : AppColor.textColor,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                    ),
                  ),
                ),
              );
            }),
            ..._custom.map((o) {
              final isSelected = _selected.contains(o);
              return Semantics(
                button: true,
                selected: isSelected,
                label: o,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(o);
                      } else {
                        _selected.add(o);
                      }
                    });
                    widget.onChanged(_selected);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s10, vertical: AppSpacing.s6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.primary.withValues(alpha: 0.1)
                          : AppColor.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.primary
                            : AppColor.onSurfaceSubtle.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          o,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isSelected
                                        ? AppColor.primary
                                        : AppColor.textColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                        ),
                        AppSpacing.gapW(AppSpacing.s6),
                        const Icon(Icons.close,
                            size: 14, color: AppColor.onSurfaceSubtle),
                      ],
                    ),
                  ),
                ),
              );
            }),
            GestureDetector(
              onTap: _onAddCustomTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s10, vertical: AppSpacing.s6),
                decoration: BoxDecoration(
                  color: AppColor.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: AppColor.onSurfaceSubtle.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add,
                        size: 16, color: AppColor.onSurfaceSubtle),
                    AppSpacing.gapW(AppSpacing.s6),
                    const Text('Добавить своё'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onAddCustomTap() async {
    final ctrl = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Свой вызов'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(hintText: 'Опишите кратко'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
    if (value != null && value.isNotEmpty) {
      setState(() {
        _custom.add(value);
        _selected.add(value);
      });
      widget.onChanged(_selected);
    }
  }
}

class DividerWrapper extends StatelessWidget {
  const DividerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 45),
      child: Divider(
        height: 0,
        color: AppColor.onSurfaceSubtle,
      ),
    );
  }
}
