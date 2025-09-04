import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/user_info_bar.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/utils/formatters.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/providers/gp_providers.dart';

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
                // Top bar: аватар/имя слева, GP справа
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: const [
                      // Левая часть — аватар/имя/уровень
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: UserInfoBar(showGp: false),
                        ),
                      ),
                      // Правая часть — только GP с кликом в /gp-store
                      _TopBarGp(),
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
                            final levelCode =
                                formatLevelCode(floorId, levelNumber);
                            return SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  try {
                                    final int? gver =
                                        next['goalCheckpointVersion'] as int?;
                                    if (gver != null) {
                                      context.go('/goal-checkpoint/$gver');
                                    } else {
                                      final levelNumber =
                                          next['levelNumber'] as int? ?? 0;
                                      final levelId =
                                          next['levelId'] as int? ?? 0;
                                      context.go(
                                          '/levels/$levelId?num=$levelNumber');
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
    // Простой градиентный фон вместо отсутствующего background.svg
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.appBgColor,
            AppColor.appBgColor.withOpacity(0.8),
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
                    key: const Key('ms_card_library'),
                    title: 'Библиотека',
                    icon: Icons.menu_book,
                    svgAsset: 'assets/images/street/library.svg',
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
                    key: const Key('ms_card_coworking'),
                    title: 'Коворкинг',
                    icon: Icons.workspaces_outline,
                    svgAsset: 'assets/images/street/coworking.svg',
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

class _TopBarGp extends ConsumerWidget {
  const _TopBarGp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gpAsync = ref.watch(gpBalanceProvider);
    final balance = gpAsync.value?['balance'];
    if (balance == null) return const SizedBox.shrink();
    return InkWell(
      onTap: () {
        try {
          GoRouter.of(context).go('/gp-store');
        } catch (_) {}
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/gp_coin.svg', width: 36, height: 36),
          const SizedBox(width: 8),
          Text(
            '$balance',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
          ),
        ],
      ),
    );
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
    final Color border = Colors.grey.withValues(alpha: 0.25);

    return Semantics(
      label: title,
      button: true,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          color: const Color.fromARGB(
              255, 212, 212, 212), // фон карточки = фон иконок
          elevation: 6, // более выраженная тень
          shadowColor: Colors.black.withValues(alpha: 0.15),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: border),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Stack(
              children: [
                // Иконка на весь доступный размер
                Positioned.fill(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.9, // -10%
                      heightFactor: 0.9, // -10%
                      child: svgAsset != null
                          ? SvgPicture.asset(
                              svgAsset!,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              icon,
                              size: 64,
                              color: foreground,
                            ),
                    ),
                  ),
                ),
                // Заголовок в левом верхнем углу внутри карточки
                Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: const Color(0xFF757575),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
