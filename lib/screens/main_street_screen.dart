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
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:bizlevel/widgets/custom_image.dart';
import 'package:bizlevel/providers/library_providers.dart';
import 'package:bizlevel/widgets/home/top_gp_badge.dart';
import 'package:bizlevel/widgets/home/home_goal_card.dart';
import 'package:bizlevel/widgets/home/home_continue_card.dart';
import 'package:bizlevel/widgets/home/home_quote_card.dart';
import 'package:bizlevel/widgets/common/notification_center.dart';

class MainStreetScreen extends ConsumerStatefulWidget {
  const MainStreetScreen({super.key});

  @override
  ConsumerState<MainStreetScreen> createState() => _MainStreetScreenState();
}

class _MainStreetScreenState extends ConsumerState<MainStreetScreen> {
  @override
  void initState() {
    super.initState();
    // Аналитика открытия экрана (без PII)
    Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'ui.screen',
        message: 'home_opened',
        level: SentryLevel.info,
      ),
    );
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: _GreetingHeader(),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: RefreshIndicator(
                        color: AppColor.primary,
                        onRefresh: () async {
                          try {
                            // Обновление ключевых провайдеров
                            await Future.wait([
                              ref.refresh(currentUserProvider.future),
                              ref.refresh(gpBalanceProvider.future),
                              ref.refresh(userGoalProvider.future),
                              ref.refresh(levelsProvider.future),
                            ]);
                            if (context.mounted) {
                              NotificationCenter.showSuccess(
                                context,
                                'Обновлено',
                              );
                            }
                          } catch (_) {
                            // Без падения, индикатор скрываем
                          }
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Цитата дня
                              const HomeQuoteCard(),
                              const SizedBox(height: AppSpacing.md),
                              // Карточка «Моя цель»
                              const HomeGoalCard(),
                              const SizedBox(height: AppSpacing.s20),
                              // Карточка «Продолжить обучение»
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
                                      final int levelNum =
                                          next['levelNumber'] as int? ?? 0;
                                      final levelTitle =
                                          (next['levelTitle'] as String?)
                                              ?.trim();
                                      // Подзаголовок: только название уровня без префикса «Уровень N»
                                      String subtitle;
                                      if (levelTitle != null &&
                                          levelTitle.isNotEmpty) {
                                        // Удаляем возможный префикс «Уровень X: »
                                        final cleaned = levelTitle.replaceFirst(
                                          RegExp(
                                            r'^\s*Уровень\s*\d*\s*:?\s*',
                                            caseSensitive: false,
                                          ),
                                          '',
                                        );
                                        subtitle = cleaned.isNotEmpty
                                            ? cleaned
                                            : levelTitle;
                                      } else {
                                        subtitle = label;
                                      }
                                      return HomeContinueCard(
                                        subtitle: subtitle,
                                        levelNumber: levelNum,
                                        onTap: () {
                                          try {
                                            Sentry.addBreadcrumb(
                                              Breadcrumb(
                                                category: 'ui.tap',
                                                message:
                                                    'home_cta_continue_tap',
                                                level: SentryLevel.info,
                                              ),
                                            );
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
                                                next['levelNumber'] as int? ??
                                                0;
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
                                      return HomeContinueCard(
                                        subtitle: 'Башня',
                                        levelNumber: 0,
                                        onTap: () => context.go('/tower'),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              const _QuickAccessSection(),
                              AppSpacing.gapH(12),
                            ],
                          ),
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
            // Compact avatar on the left (56px)
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<int>(
                    future: SupabaseService.resolveCurrentLevelNumber(
                      user.currentLevel,
                    ),
                    builder: (context, snap) {
                      final level = snap.data ?? 0;
                      return Text(
                        'Уровень $level',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColor.onSurfaceSubtle,
                        ),
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
    // Compact size: 56px total
    return Container(
      width: 56,
      height: 56,
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
          width: 52,
          height: 52,
          radius: 26,
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
    final collected = levels
        .where((l) => (l['isCompleted'] as bool? ?? false))
        .length;
    final totalAsync = ref.watch(libraryTotalCountProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title removed per requirement
          GridView.count(
          crossAxisCount: 2,
          // Flatter cards so section fits on one screen
          childAspectRatio: 2.5,
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
              onTap: () {
                Sentry.addBreadcrumb(
                  Breadcrumb(
                    category: 'ui.tap',
                    message: 'home_quick_action_tap:library',
                    level: SentryLevel.info,
                  ),
                );
                context.go('/library');
              },
            ),
            _QuickTile(
              icon: Icons.inventory_2_outlined,
              title: 'Артефакты',
              subtitle: '$collected инструментов',
              onTap: () {
                Sentry.addBreadcrumb(
                  Breadcrumb(
                    category: 'ui.tap',
                    message: 'home_quick_action_tap:artifacts',
                    level: SentryLevel.info,
                  ),
                );
                context.go('/artifacts');
              },
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1, end: 1),
          duration: const Duration(milliseconds: 150),
          builder: (context, scale, child) {
            return Material(
              color: AppColor.card,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 120),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.border),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.shadowSoft,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 20,
                            color: AppColor.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColor.onSurfaceSubtle,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
