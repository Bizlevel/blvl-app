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
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/widgets/home/top_gp_badge.dart';
import 'package:bizlevel/widgets/home/home_goal_card.dart';
import 'package:bizlevel/widgets/home/home_cta.dart';

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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                            Consumer(builder: (context, ref, _) {
                              final nextAsync =
                                  ref.watch(nextLevelToContinueProvider);
                              return nextAsync.when(
                                data: (next) {
                                  final String label =
                                      (next['label'] as String?) ?? 'Далее';
                                  final bool isLocked =
                                      next['isLocked'] as bool? ?? false;
                                  final int targetScroll =
                                      next['targetScroll'] as int? ?? 0;
                                  final levelNum = next['levelNumber'] as int?;
                                  final levelTitle = (next['levelTitle'] as String?)?.trim();
                                  // Формируем подзаголовок «Уровень N: Название» при наличии title
                                  String subtitle;
                                  if (levelTitle != null && levelTitle.isNotEmpty) {
                                    final hasPrefix = levelTitle.trimLeft().toLowerCase().startsWith('уровень');
                                    if (levelNum != null && !hasPrefix) {
                                      subtitle = 'Уровень $levelNum: $levelTitle';
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
                                        final int? gver = next['goalCheckpointVersion'] as int?;
                                        if (gver != null) {
                                          context.go('/goal-checkpoint/$gver');
                                          return;
                                        }
                                        final int? miniCaseId = next['miniCaseId'] as int?;
                                        if (miniCaseId != null) {
                                          context.go('/case/$miniCaseId');
                                          return;
                                        }
                                        if (isLocked) {
                                          context.go('/tower?scrollTo=$targetScroll');
                                          return;
                                        }
                                        final levelNumber = next['levelNumber'] as int? ?? 0;
                                        final levelId = next['levelId'] as int? ?? 0;
                                        context.go('/levels/$levelId?num=$levelNumber');
                                        } catch (e, st) {
                                          Sentry.captureException(e, stackTrace: st);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Не удалось открыть уровень')),
                                          );
                                        }
                                      },
                                  );
                                },
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (error, stack) {
                                  Sentry.captureException(error, stackTrace: stack);
                                  return HomeCta(
                                    title: 'ПРОДОЛЖИТЬ ОБУЧЕНИЕ',
                                    subtitle: 'Башня',
                                    height: AppDimensions.homeCtaHeight,
                                    onTap: () => context.go('/tower'),
                                  );
                                },
                              );
                            }),
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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFAFAFA), Color(0xFFF7F3FF)],
        ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    '${user.name}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 2),
                  FutureBuilder<int>(
                    future: SupabaseService.resolveCurrentLevelNumber(user.currentLevel),
                    builder: (context, snap) {
                      final n = (int? x) => x ?? 0;
                      return Text(
                        'Уровень ${n(snap.data)}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF7F8C8D)),
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
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.white,
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

class _HomeGoalCard extends ConsumerWidget {
  const _HomeGoalCard();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(userGoalProvider);
    return InkWell(
      onTap: () => context.go('/goal'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 160),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: goalAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Text('Не удалось загрузить цель'),
          data: (goal) {
            final repo = ref.read(goalsRepositoryProvider);
            final progress = repo.computeGoalProgressPercent(goal) ?? 0.0;
            final percent = (progress * 100).clamp(0, 100).round();
            DateTime? targetDate;
            try {
              final td = (goal?['target_date'] ?? '').toString();
              targetDate = DateTime.tryParse(td)?.toLocal();
            } catch (_) {}
            int? daysLeft;
            if (targetDate != null) {
              daysLeft = targetDate.difference(DateTime.now()).inDays;
            }
            final goalText = (goal?['goal_text'] ?? '').toString();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('🎯 МОЯ ЦЕЛЬ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                    const Spacer(),
                    Text('$percent%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF4A90E2))),
                  ],
                ),
                const SizedBox(height: 10),
                // Progress bar 8dp with gradient
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EEF4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF5BC0DE)]),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  goalText.isEmpty ? 'Цель не задана' : goalText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, height: 22/15, color: Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 12),
                if (daysLeft != null)
                  Row(
                    children: [
                      const Text('⏱ ', style: TextStyle(fontSize: 16)),
                      Text(
                        daysLeft < 3 ? 'Осталось $daysLeft дней' : 'Осталось $daysLeft дней',
                        style: TextStyle(
                          fontSize: 14,
                          color: daysLeft < 3 ? const Color(0xFFFF6B6B) : const Color(0xFF7F8C8D),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          side: const BorderSide(color: Color(0xFFE1E8ED), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          foregroundColor: const Color(0xFF4A90E2),
                        ),
                        onPressed: () => context.go('/goal'),
                        child: const Text('📝 Прогресс'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          side: const BorderSide(color: Color(0xFFE1E8ED), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          foregroundColor: const Color(0xFF4A90E2),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LeoDialogScreen(
                                bot: 'max',
                                userContext: [
                                  if (goalText.isNotEmpty) 'goal_text: $goalText',
                                ].join('\n'),
                                levelContext: '',
                              ),
                            ),
                          );
                        },
                        child: const Text('💬 Макс'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MainCtaButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MainCtaButton({required this.title, required this.subtitle, required this.onTap});
  @override
  State<_MainCtaButton> createState() => _MainCtaButtonState();
}

class _MainCtaButtonState extends State<_MainCtaButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pulse();
  }
  void _pulse() async {
    try {
      while (mounted) {
        await Future.delayed(const Duration(seconds: 4));
        if (!mounted) break;
        await _ctrl.forward();
        _ctrl.reset();
      }
    } catch (_) {}
  }
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final scale = 1.0 + 0.02 * _ctrl.value; // subtle pulse
          return Transform.scale(
            scale: scale,
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.title.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17)),
                        const SizedBox(height: 4),
                        Text(widget.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        // Время пока опускаем, если появится источник — добавим
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickAccessSection extends ConsumerWidget {
  const _QuickAccessSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelsProvider).value ?? const [];
    final collected = levels.where((l) => (l['isCompleted'] as bool? ?? false)).length;
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
        )
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _QuickTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title, $subtitle',
      button: true,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8EEF4)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 24, color: const Color(0xFF2C3E50)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF95A5A6))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Старая сетка карточек главной удалена в пользу нового упрощённого лэйаута
