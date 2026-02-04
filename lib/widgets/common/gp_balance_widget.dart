import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/utils/hive_box_helper.dart';

/// Компактный общий виджет баланса GP (иконка + число)
/// Использование: GP выводится из `gpBalanceProvider`; по тапу → /gp-store
class GpBalanceWidget extends ConsumerStatefulWidget {
  const GpBalanceWidget({super.key});

  @override
  ConsumerState<GpBalanceWidget> createState() => _GpBalanceWidgetState();
}

class _GpBalanceWidgetState extends ConsumerState<GpBalanceWidget> {
  static bool _zeroDialogShownInSession = false;

  void _maybeShowZeroDialog(BuildContext context, int balance) {
    if (balance != 0 || _zeroDialogShownInSession) return;
    _zeroDialogShownInSession = true;
    HiveBoxHelper.readValue('gp', 'zero_dialog_seen').then((seen) {
      if (!mounted || seen == true) return;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('GP закончились'),
            content: const Text(
              'Сообщения менторам требуют GP. Пополните баланс, чтобы продолжить диалог.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Позже'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (mounted) context.go('/gp-store');
                },
                child: const Text('Пополнить'),
              ),
            ],
          ),
        );
        HiveBoxHelper.putDeferred('gp', 'zero_dialog_seen', true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final gpAsync = ref.watch(gpBalanceProvider);
    final balance = gpAsync.value?['balance'] ?? 0;
    _maybeShowZeroDialog(context, balance);

    const height = 32.0;

    final bool isZero = balance <= 0;
    final Color bgColor =
        isZero ? AppColor.colorWarningLight : AppColor.colorAccentWarmLight;
    final Color borderColor =
        isZero ? AppColor.colorWarning : AppColor.colorAccentWarm;
    final Color iconColor =
        isZero ? AppColor.colorWarning : AppColor.colorAccentWarm;

    return InkWell(
      onTap: () {
        try {
          if (context.mounted) context.go('/gp-store');
        } catch (_) {}
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        constraints: const BoxConstraints(minWidth: 70, maxWidth: 110),
        height: height,
        padding: AppSpacing.insetsSymmetric(h: AppSpacing.sm),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/gp_coin.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: balance.toDouble()),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, _) => Text(
                  value.toInt().toString(),
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: AppColor.colorTextPrimary,
                    fontWeight: FontWeight.w700,
                    fontFeatures: AppTypography.number.fontFeatures,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
