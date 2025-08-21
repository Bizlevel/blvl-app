import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/user_info_bar.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/utils/formatters.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class MainStreetScreen extends ConsumerWidget {
  const MainStreetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: Stack(
        children: [
          const Positioned.fill(child: _BackgroundLayer()),
          // Главный контент без сцены/облаков (задача 33.20)
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar with avatar/name/progress
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: const [
                      Expanded(child: UserInfoBar()),
                    ],
                  ),
                ),
                // Центральный блок: 5 карточек (3 ряда) — задача 33.21
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
                // Actions
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
                            final int floorId = next['floorId'] as int? ?? 1;
                            final int levelNumber =
                                next['levelNumber'] as int? ?? 0;
                            final bool requiresPremium =
                                next['requiresPremium'] as bool? ?? false;
                            final levelCode =
                                formatLevelCode(floorId, levelNumber);
                            return SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  try {
                                    if (requiresPremium) {
                                      context.go('/premium');
                                    } else {
                                      final levelNumber =
                                          next['levelNumber'] as int? ?? 0;
                                      context
                                          .go('/tower?scrollTo=$levelNumber');
                                    }
                                  } catch (e, st) {
                                    Sentry.captureException(e, stackTrace: st);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Не удалось открыть уровень'),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Продолжить: Уровень $levelCode'),
                              ),
                            );
                          },
                          loading: () => const SizedBox(
                            height: 48,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => context.go('/tower'),
                              child: const Text('Открыть башню'),
                            ),
                          ),
                        );
                      }),
                      // Кнопка открытия башни убрана — вход через нажатие на центральное здание
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
    return LayoutBuilder(builder: (context, constraints) {
      return SvgPicture.asset(
        'assets/images/street/background.svg',
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      );
    });
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
      final double maxSquareByWidth = (constraints.maxWidth - gap) / 2;
      final double maxSquareByHeight = (constraints.maxHeight - 2 * gap) / 3;
      final double tileSide =
          math.max(0, math.min(maxSquareByWidth, maxSquareByHeight));

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: tileSide,
            child: Row(
              children: [
                Expanded(
                  child: _MainActionCard(
                    key: const Key('ms_card_library'),
                    title: 'Библиотека',
                    icon: Icons.menu_book,
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
                    state: _CardState.soon,
                    onTap: () => _showSoonSnackBar(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: gap),
          SizedBox(
            height: tileSide,
            child: Row(
              children: [
                Expanded(
                  child: _MainActionCard(
                    key: const Key('ms_card_trainers'),
                    title: 'База тренеров',
                    icon: Icons.chat_bubble,
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
                    key: const Key('ms_card_coworking'),
                    title: 'Коворкинг',
                    icon: Icons.workspaces_outline,
                    state: _CardState.soon,
                    onTap: () => _showSoonSnackBar(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: gap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: SizedBox(
                    height: tileSide,
                    child: _MainActionCard(
                      key: const Key('ms_card_tower'),
                      title: 'Башня БизЛевел',
                      icon: Icons.apartment,
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
                ),
              ),
            ],
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

  const _MainActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSoon = state == _CardState.soon;
    final Color foreground = isSoon
        ? Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6)
        : Theme.of(context).textTheme.bodyMedium!.color!;
    final Color border = Colors.grey.withOpacity(0.25);

    return Semantics(
      label: title,
      button: true,
      child: Card(
        color: Colors.white.withOpacity(isSoon ? 0.8 : 1.0),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: foreground),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w600,
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
