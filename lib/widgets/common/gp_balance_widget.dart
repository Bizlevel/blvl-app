import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/providers/gp_providers.dart';

/// Компактный общий виджет баланса GP (иконка + число)
/// Использование: GP выводится из `gpBalanceProvider`; по тапу → /gp-store
class GpBalanceWidget extends ConsumerWidget {
  const GpBalanceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gpAsync = ref.watch(gpBalanceProvider);
    final balance = gpAsync.value?['balance'] ?? 0;

    const width = 80.0;
    const height = 32.0;

    return InkWell(
      onTap: () {
        try {
          if (context.mounted) context.go('/gp-store');
        } catch (_) {}
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        width: width,
        height: height,
        padding: AppSpacing.insetsSymmetric(h: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColor.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/gp_coin.svg',
                width: 20, height: 20),
            const SizedBox(width: AppSpacing.s6),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: balance.toDouble()),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, _) => Text(
                value.toInt().toString(),
                style: AppTypography.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
