import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/user_info_bar.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/widgets/common/gp_balance_widget.dart';

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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: UserInfoBar(showGp: false),
                        ),
                      ),
                      GpBalanceWidget(),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _MainActionsGrid(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                            return SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  try {
                                    final int? gver =
                                        next['goalCheckpointVersion'] as int?;
                                    if (gver != null) {
                                      context.go('/goal-checkpoint/$gver');
                                      return;
                                    }
                                    final int? miniCaseId =
                                        next['miniCaseId'] as int?;
                                    if (miniCaseId != null) {
                                      context.go('/case/$miniCaseId');
                                      return;
                                    }
                                    if (isLocked) {
                                      context
                                          .go('/tower?scrollTo=$targetScroll');
                                      return;
                                    }
                                    final levelNumber =
                                        next['levelNumber'] as int? ?? 0;
                                    final levelId =
                                        next['levelId'] as int? ?? 0;
                                    context.go(
                                        '/levels/$levelId?num=$levelNumber');
                                  } catch (e, st) {
                                    Sentry.captureException(e, stackTrace: st);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Не удалось открыть уровень')),
                                    );
                                  }
                                },
                                child: Text('Продолжить: $label'),
                              ),
                            );
                          },
                          loading: () => const SizedBox(
                            height: 48,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (error, stack) {
                            Sentry.captureException(error, stackTrace: stack);
                            return SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () => context.go('/tower'),
                                child: const Text('Продолжить: Башня'),
                              ),
                            );
                          },
                        );
                      }),
                    ],
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
    // Простой градиентный фон вместо отсутствующего background.svg
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.appBgColor,
            AppColor.appBgColor.withValues(alpha: 0.8),
          ],
        ),
      ),
    );
  }
}

// Анимация облаков и интерактивные SVG удалены (задача 33.20)

class _MainActionsGrid extends ConsumerWidget {
  const _MainActionsGrid();

  void _showSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Скоро')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      const double gap = 12;
      final double rowHeight = (constraints.maxHeight - 2 * gap) / 3;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                Expanded(
                  child: _MainActionCard(
                    key: const Key('ms_card_coworking'),
                    title: 'Коворкинг',
                    icon: Icons.workspaces_outline,
                    svgAsset: 'assets/images/street/coworking.svg',
                    state: _CardState.soon,
                    onTap: () => _showSoonSnackBar(context),
                  ),
                ),
                const SizedBox(width: gap),
                Expanded(
                  child: _MainActionCard(
                    key: const Key('ms_card_marketplace'),
                    title: 'Маркетплейс',
                    icon: Icons.storefront,
                    svgAsset: 'assets/images/street/marketplace.svg',
                    state: _CardState.soon,
                    onTap: () => _showSoonSnackBar(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: gap),
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                Expanded(
                  child: _MainActionCard(
                    key: const Key('ms_card_trainers'),
                    title: 'База тренеров',
                    icon: Icons.chat_bubble,
                    svgAsset: 'assets/images/street/training_base.svg',
                    state: _CardState.active,
                    onTap: () {
                      try {
                        context.go('/chat');
                      } catch (e, st) {
                        Sentry.captureException(e, stackTrace: st);
                        // Падение навигации не критично — показать дружелюбный тост
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Не удалось открыть страницу')),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: gap),
                Expanded(
                  child: _MainActionCard(
                    key: const Key('ms_card_library'),
                    title: 'Библиотека',
                    icon: Icons.menu_book,
                    svgAsset: 'assets/images/street/library.svg',
                    state: _CardState.active,
                    onTap: () {
                      try {
                        context.go('/library');
                      } catch (e, st) {
                        Sentry.captureException(e, stackTrace: st);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Не удалось открыть страницу')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: gap),
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                Expanded(
                  child: _MainActionCard(
                    key: const Key('ms_card_tower'),
                    title: 'Башня БизЛевел',
                    icon: Icons.apartment,
                    svgAsset: 'assets/images/street/tower.svg',
                    state: _CardState.active,
                    onTap: () {
                      try {
                        context.go('/tower');
                      } catch (e, st) {
                        Sentry.captureException(e, stackTrace: st);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Не удалось открыть башню')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

enum _CardState { active, soon }

class _MainActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final _CardState state;
  final VoidCallback? onTap;
  final String? svgAsset;

  const _MainActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.state,
    required this.onTap,
    this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSoon = state == _CardState.soon;
    final Color foreground = isSoon
        ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6)
        : Theme.of(context).textTheme.bodyMedium!.color!;
    final Color border = AppColor.borderColor.withValues(alpha: 0.25);

    return Semantics(
      label: title,
      button: true,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          color: AppColor.surface,
          elevation: 6, // более выраженная тень
          shadowColor: AppColor.shadowColor,
          surfaceTintColor: AppColor.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: border),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Stack(
              children: [
                // Иконка на весь доступный размер (пониженная насыщенность для "Скоро")
                Positioned.fill(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.9, // -10%
                      heightFactor: 0.9, // -10%
                      child: Opacity(
                        opacity: isSoon ? 0.45 : 1.0,
                        child: svgAsset != null
                            ? SvgPicture.asset(
                                svgAsset!,
                              )
                            : Icon(
                                icon,
                                size: 64,
                                color: foreground,
                              ),
                      ),
                    ),
                  ),
                ),
                // Заголовок над пиктограммой, по центру, с лёгкой тенью для читаемости
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      shadows: [
                        const Shadow(
                          color: AppColor.shadowColor,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                // Lock‑чип в правом верхнем углу для состояния "Скоро"
                if (isSoon)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColor.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock,
                              size: 12, color: AppColor.labelColor),
                          SizedBox(width: 4),
                          Text(
                            'Скоро',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColor.labelColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
