import 'package:flutter/material.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/color.dart';

class ListRowTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final EdgeInsetsGeometry? padding;

  const ListRowTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.semanticsLabel,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColor.colorPrimaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            leadingIcon,
            size: 20,
            color: AppColor.colorPrimary,
          ),
        ),
        AppSpacing.gapW(AppSpacing.itemSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColor.colorTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 1),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: AppColor.colorTextSecondary),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null)
          IconTheme(
            data: const IconThemeData(color: AppColor.colorTextSecondary),
            child: trailing!,
          ),
      ],
    );

    final body = ConstrainedBox(
      constraints:
          const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
      child: Padding(
        padding: padding ??
            AppSpacing.insetsSymmetric(h: AppSpacing.md, v: AppSpacing.s6),
        child: content,
      ),
    );

    if (onTap == null) {
      return body;
    }

    final semantics = semanticsLabel;
    final tappable = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: onTap,
        child: body,
      ),
    );

    return semantics != null
        ? Semantics(label: semantics, button: true, child: tappable)
        : tappable;
  }
}
