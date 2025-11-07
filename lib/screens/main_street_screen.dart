// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:bizlevel/widgets/custom_image.dart';
import 'package:bizlevel/providers/library_providers.dart';
import 'package:bizlevel/widgets/home/top_gp_badge.dart';
import 'package:bizlevel/widgets/home/home_goal_card.dart';
import 'package:bizlevel/widgets/home/home_cta.dart';
import 'package:bizlevel/widgets/common/list_row_tile.dart';

class MainStreetScreen extends ConsumerStatefulWidget {
  const MainStreetScreen({super.key});

  @override
  ConsumerState<MainStreetScreen> createState() => _MainStreetScreenState();
}

class _MainStreetScreenState extends ConsumerState<MainStreetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: Stack(
        children: [
          const Positioned.fill(child: _BackgroundLayer()),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                // Greeting block with avatar, name/level, GP badge
                SizedBox(
                  height: AppDimensions.homeGreetingHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _GreetingHeader(),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Карточка «Моя цель» по макету
                            const HomeGoalCard(),
                            const SizedBox(height: 20),
                            // Большая кнопка «Продолжить обучение» (мобайл)
                            Consumer(
                              builder: (context, ref, _) {
                                final nextAsync = ref.watch(
                                  nextLevelToContinueProvider,
                                );
                                return nextAsync.when(
                                  data: (next) {
                                    final String label =
                                        (next['label'] as String?) ?? 'Далее';
                                    final bool isLocked =
                                        next['isLocked'] as bool? ?? false;
                                    final int targetScroll =
                                        next['targetScroll'] as int? ?? 0;
                                    final levelNum =
                                        next['levelNumber'] as int?;
                                    final levelTitle =
                                        (next['levelTitle'] as String?)?.trim();
                                    // Формируем подзаголовок «Уровень N: Название» при наличии title
                                    String subtitle;
                                    if (levelTitle != null &&
                                        levelTitle.isNotEmpty) {
                                      final hasPrefix = levelTitle
                                          .trimLeft()
                                          .toLowerCase()
                                          .startsWith('уровень');
                                      if (levelNum != null && !hasPrefix) {
                                        subtitle =
                                            'Уровень $levelNum: $levelTitle';
                                      } else {
                                        subtitle = levelTitle;
                                      }
                                    } else if (levelNum != null) {
                                      subtitle = 'Уровень $levelNum: $label';
                                    } else {
                                      subtitle = label;
                                    }
                                    return HomeCta(
                                      title: 'ПРОДОЛЖИТЬ ОБУЧЕНИЕ',
                                      subtitle: subtitle,
                                      height: AppDimensions.homeCtaHeight,
                                      onTap: () {
                                        try {
                                          final int? gver =
                                              next['goalCheckpointVersion']
                                                  as int?;
                                          if (gver != null) {
                                            context.go(
                                              '/goal-checkpoint/$gver',
                                            );
                                            return;
                                          }
                                          final int? miniCaseId =
                                              next['miniCaseId'] as int?;
                                          if (miniCaseId != null) {
                                            context.go('/case/$miniCaseId');
                                            return;
                                          }
                                          if (isLocked) {
                                            context.go(
                                              '/tower?scrollTo=$targetScroll',
                                            );
                                            return;
                                          }
                                          final levelNumber =
                                              next['levelNumber'] as int? ?? 0;
                                          final levelId =
                                              next['levelId'] as int? ?? 0;
                                          context.go(
                                            '/levels/$levelId?num=$levelNumber',
                                          );
                                        } catch (e, st) {
                                          Sentry.captureException(
                                            e,
                                            stackTrace: st,
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Не удалось открыть уровень',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (error, stack) {
                                    Sentry.captureException(
                                      error,
                                      stackTrace: stack,
                                    );
                                    return HomeCta(
                                      title: 'ПРОДОЛЖИТЬ ОБУЧЕНИЕ',
                                      subtitle: 'Башня',
                                      height: AppDimensions.homeCtaHeight,
                                      onTap: () => context.go('/tower'),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            const _QuickAccessSection(),
                            AppSpacing.gapH(12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Сцена и подписи удалены (задача 33.20)

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();
  @override
  Widget build(BuildContext context) {
    // Локальный мягкий градиент фона для Main Street
    return Container(
      decoration: const BoxDecoration(
        // fix: заменить хардкод-градиент на токен AppColor.bgGradient
        gradient: AppColor.bgGradient,
      ),
    );
  }
}

// Анимация облаков и интерактивные SVG удалены (задача 33.20)

class _GreetingHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return Row(
          children: [
            // Large avatar on the left
            _GreetingAvatar(user.avatarId, user.avatarUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    overflow: TextOverflow.ellipsis,
                    // fix: inline типографика → Theme.textTheme
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 2),
                  FutureBuilder<int>(
                    future: SupabaseService.resolveCurrentLevelNumber(
                      user.currentLevel,
                    ),
                    builder: (context, snap) {
                      final level = snap.data ?? 0;
                      return Text(
                        'Уровень $level',
                        overflow: TextOverflow.ellipsis,
                        // fix: inline типографика/цвет → Theme + токен
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppColor.onSurfaceSubtle),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const TopGpBadge(),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _GreetingAvatar extends StatelessWidget {
  final int? avatarId;
  final String? avatarUrl;
  const _GreetingAvatar(this.avatarId, this.avatarUrl);
  @override
  Widget build(BuildContext context) {
    String avatarPath;
    bool isNetwork;
    if ((avatarUrl ?? '').isNotEmpty) {
      avatarPath = avatarUrl!;
      isNetwork = true;
    } else if (avatarId != null) {
      avatarPath = 'assets/images/avatars/avatar_$avatarId.png';
      isNetwork = false;
    } else {
      avatarPath = 'assets/images/avatars/avatar_1.png';
      isNetwork = false;
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: AppColor.card,
          shape: BoxShape.circle,
        ),
        child: CustomImage(
          avatarPath,
          width: 80,
          height: 80,
          radius: 40,
          isNetwork: isNetwork,
          isShadow: false,
        ),
      ),
    );
  }
}

// Удалены устаревшие приватные виджеты главной страницы

class _QuickAccessSection extends ConsumerWidget {
  const _QuickAccessSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelsProvider).value ?? const [];
    final collected =
        levels.where((l) => (l['isCompleted'] as bool? ?? false)).length;
    final totalAsync = ref.watch(libraryTotalCountProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title removed per requirement
        GridView.count(
          crossAxisCount: 2,
          // Flatter cards so section fits on one screen
          childAspectRatio: 3.2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _QuickTile(
              icon: Icons.menu_book,
              title: 'Библиотека',
              subtitle: totalAsync.when(
                data: (v) => '$v материалов',
                loading: () => 'Загрузка…',
                error: (_, __) => 'Материалы',
              ),
              onTap: () => context.go('/library'),
            ),
            _QuickTile(
              icon: Icons.inventory_2_outlined,
              title: 'Мои артефакты',
              subtitle: '$collected инструментов',
              onTap: () => context.go('/artifacts'),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _QuickTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title, $subtitle',
      button: true,
      child: Material(
        // fix: цвет поверхности → AppColor.card
        color: AppColor.card,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // fix: цвет границы → токен
              border: Border.all(color: AppColor.border),
            ),
            child: ListRowTile(
              leadingIcon: icon,
              title: title,
              subtitle: subtitle,
              onTap: onTap,
              semanticsLabel: '$title, $subtitle',
            ),
          ),
        ),
      ),
    );
  }
}
