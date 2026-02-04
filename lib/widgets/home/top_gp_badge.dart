import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/animations.dart';
import 'package:bizlevel/theme/typography.dart';

class TopGpBadge extends ConsumerStatefulWidget {
  const TopGpBadge({super.key});

  @override
  ConsumerState<TopGpBadge> createState() => _TopGpBadgeState();
}

class _TopGpBadgeState extends ConsumerState<TopGpBadge>
    with SingleTickerProviderStateMixin {
  int _lastBalance = 0;
  int _delta = 0;
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: AppAnimations.quick,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gpAsync = ref.watch(gpBalanceProvider);
    final map = gpAsync.asData?.value;
    final int balance =
        (map != null && map['balance'] is int) ? map['balance'] as int : 0;

    // Вычисляем дельту и запускаем пульс при изменении
    if (balance != _lastBalance) {
      _delta = balance - _lastBalance;
      _lastBalance = balance;
      // короткий pulse
      _ctrl
        ..reset()
        ..forward();
      // Авто скрытие дельты
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _delta = 0);
      });
    }

    final bool isZero = balance <= 0;
    final Color bgColor =
        isZero ? AppColor.colorWarningLight : AppColor.colorAccentWarmLight;
    final Color borderColor =
        isZero ? AppColor.colorWarning : AppColor.colorAccentWarm;
    final Color iconColor =
        isZero ? AppColor.colorWarning : AppColor.colorAccentWarm;

    return Semantics(
      label: 'Баланс GP: $balance',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/gp-store'),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              final scale = 1.0 + (_ctrl.value * 0.06);
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusXxl),
                    border: Border.all(color: borderColor),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.shadow,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/gp_coin.svg',
                        width: 18,
                        height: 18,
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$balance',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppColor.colorTextPrimary,
                              fontWeight: FontWeight.w700,
                              fontFeatures: AppTypography.number.fontFeatures,
                            ),
                      ),
                      if (_delta != 0) ...[
                        const SizedBox(width: 6),
                        AnimatedOpacity(
                          opacity: _delta == 0 ? 0 : 1,
                          duration: AppAnimations.quick,
                          child: Text(
                            _delta > 0 ? '+$_delta' : '$_delta',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: _delta > 0
                                      ? AppColor.success
                                      : AppColor.error,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
