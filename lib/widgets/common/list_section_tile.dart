import 'package:flutter/material.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/color.dart';

class ListSectionTile extends StatelessWidget {
  final Widget leading; // аватар или иконка
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  const ListSectionTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        leading,
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
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: AppColor.onSurfaceSubtle),
                ),
              ],
            ],
          ),
        ),
        const Icon(Icons.chevron_right, size: 20),
      ],
    );

    final body = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: row,
      ),
    );

    final tappable = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: body,
      ),
    );

    return semanticsLabel != null
        ? Semantics(label: semanticsLabel, button: true, child: tappable)
        : tappable;
  }
}


