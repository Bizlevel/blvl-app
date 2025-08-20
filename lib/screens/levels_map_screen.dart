import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/widgets/level_card.dart';
import 'package:bizlevel/widgets/user_info_bar.dart';
import 'package:bizlevel/widgets/notification_box.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';

class LevelsMapScreen extends ConsumerWidget {
  const LevelsMapScreen({super.key, this.floorMode = false});

  final bool floorMode;

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
          if (floorMode)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 3,
                      color: Colors.black26,
                      margin: const EdgeInsets.symmetric(horizontal: 16)),
                  const SizedBox(height: 24),
                  SizedBox(
                      height: 320, child: _buildHorizontalLevels(context, ref)),
                  const SizedBox(height: 16),
                  // Индикатор прогресса из 10 точек для этажа 1
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _FloorProgressDots(),
                  ),
                  const SizedBox(height: 48),
                  Container(
                      height: 3,
                      color: Colors.black26,
                      margin: const EdgeInsets.symmetric(horizontal: 16)),
                ],
              ),
            )
          else
            _buildLevels(context, ref),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    if (!floorMode) {
      // Используем переиспользуемый виджет UserInfoBar
      return Row(
        children: const [
          UserInfoBar(),
          Spacer(),
          NotificationBox(notifiedNumber: 1),
        ],
      );
    }

    return Row(
      children: [
        TextButton.icon(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
          label: const Text('Выйти на улицу'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Level 1', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 2),
              Text('База предпринимательства',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
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
                return LevelCard(
                  data: levelData,
                  width: double.infinity,
                  compact: true,
                  onTap: () {
                    try {
                      final id = levelData['id'] as int;
                      final num = levelData['level'] as int;
                      context.push('/levels/$id?num=$num');
                    } catch (e, st) {
                      Sentry.captureException(e, stackTrace: st);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Не удалось открыть уровень')),
                      );
                    }
                  },
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
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 290,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            childCount: 4,
          ),
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('Ошибка: ${error.toString()}'),
        ),
      ),
    );
  }

  // Горизонтальная лента уровней для режима этажа
  Widget _buildHorizontalLevels(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider);
    return levelsAsync.when(
      data: (levels) {
        // Скрываем уровень 0 (Ресепшн) на ленте этажа 1
        final floorLevels = levels
            .where((l) => (l['level'] as int? ?? 0) != 0)
            .toList(growable: false);
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: floorLevels.length,
          itemBuilder: (context, index) {
            final l = floorLevels[index];
            final bool isCurrent = l['isCurrent'] == true;
            final double cardWidth =
                isCurrent ? 340 : 180; // ниже высота на ~40%
            return SizedBox(
              width: cardWidth,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LevelCard(
                  data: l,
                  compact: !isCurrent,
                  onTap: () {
                    try {
                      final id = l['id'] as int;
                      final num = l['level'] as int;
                      context.push('/levels/$id?num=$num');
                    } catch (e, st) {
                      Sentry.captureException(e, stackTrace: st);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Не удалось открыть уровень')),
                      );
                    }
                  },
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 12),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text('Ошибка: ${e.toString()}'),
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

class _FloorProgressDots extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider);
    return levelsAsync.when(
      data: (levels) {
        final floorLevels = levels
            .where((l) => (l['level'] as int? ?? 0) > 0)
            .toList(growable: false);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(floorLevels.length, (i) {
            final isCompleted = floorLevels[i]['isCompleted'] == true;
            return Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isCompleted ? AppColor.success : Colors.white,
                border: Border.all(color: Colors.black26),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
