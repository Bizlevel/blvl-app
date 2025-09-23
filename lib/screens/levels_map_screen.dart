import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/widgets/level_card.dart';
import 'package:bizlevel/widgets/user_info_bar.dart';
import 'package:bizlevel/widgets/notification_box.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';

class LevelsMapScreen extends ConsumerWidget {
  const LevelsMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: const Key('levels_map_screen'),
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.appBarColor,
            pinned: true,
            snap: true,
            floating: true,
            title: _buildAppBar(context, ref),
          ),
          _buildLevels(context, ref),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    // Используем переиспользуемый виджет UserInfoBar
    return const Row(
      children: [
        UserInfoBar(),
        Spacer(),
        NotificationBox(notifiedNumber: 1),
      ],
    );
  }

  Widget _buildLevels(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider);

    return levelsAsync.when(
      data: (levels) {
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.medium,
              AppSpacing.small, AppSpacing.medium, AppSpacing.large),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  _calcCrossAxisCount(MediaQuery.of(context).size.width),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio:
                  _calcChildAspectRatio(MediaQuery.of(context).size.width),
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final levelData = levels[index];
                return Semantics(
                  label: 'Карточка уровня ${levelData['level']}',
                  button: true,
                  child: LevelCard(
                    data: levelData,
                    width: double.infinity,
                    compact: true,
                    onTap: () {
                      try {
                        final num = levelData['level'] as int;
                        context.go('/tower?scrollTo=$num');
                      } catch (e, st) {
                        Sentry.captureException(e, stackTrace: st);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Не удалось открыть башню')),
                        );
                      }
                    },
                  ),
                );
              },
              childCount: levels.length,
            ),
          ),
        );
      },
      loading: () => SliverPadding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.medium, AppSpacing.small,
            AppSpacing.medium, AppSpacing.large),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                _calcCrossAxisCount(MediaQuery.of(context).size.width),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio:
                _calcChildAspectRatio(MediaQuery.of(context).size.width),
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => Shimmer.fromColors(
              baseColor: AppColor.divider,
              highlightColor: AppColor.labelColor.withValues(alpha: 0.2),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox.expand(),
              ),
            ),
            childCount: 4,
          ),
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ошибка загрузки уровней'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(levelsProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calcChildAspectRatio(double width) {
    if (width < 600) {
      return 1.25; // Mobile: Taller card, works well in a single column.
    } else if (width < 1024) {
      return 1.1; // Tablet: A bit wider than tall.
    } else {
      return 1.0; // Desktop: Square cards to ensure enough height for text.
    }
  }

  int _calcCrossAxisCount(double width) {
    if (width < 600) {
      return 1; // mobile
    } else if (width < 1024) {
      return 2; // tablet
    } else if (width < 1400) {
      return 3; // small desktop
    } else {
      return 4; // large desktop
    }
  }
}

// _FloorProgressDots удалён вместе с режимом floorMode
