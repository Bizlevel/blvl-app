import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/widgets/level_card.dart';
import 'package:bizlevel/widgets/notification_box.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bizlevel/screens/level_detail_screen.dart';

class LevelsMapScreen extends ConsumerWidget {
  const LevelsMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.appBarColor,
            pinned: true,
            snap: true,
            floating: true,
            title: _buildAppBar(ref),
          ),
          _buildLevels(context, ref),
        ],
      ),
    );
  }

  Widget _buildAppBar(WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    String userName = 'Добро пожаловать';
    userAsync.whenData((user) {
      if (user != null && user.name.isNotEmpty) {
        userName = user.name;
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  color: AppColor.labelColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Good Morning!",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        const NotificationBox(notifiedNumber: 1),
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
              childAspectRatio: 0.9,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final levelData = levels[index];
                return LevelCard(
                  data: levelData,
                  width: double.infinity,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LevelDetailScreen(
                            levelId: levelData['id'] as int,
                            levelNumber: levelData['level'] as int),
                      ),
                    );
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
            childAspectRatio: 0.9,
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
