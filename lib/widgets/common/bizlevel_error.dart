import 'package:flutter/material.dart';
import 'package:bizlevel/theme/spacing.dart';

class BizLevelError extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final bool fullscreen;

  const BizLevelError({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.fullscreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        if (message != null) ...[
          AppSpacing.gapH(AppSpacing.s6),
          Text(message!, textAlign: TextAlign.center),
        ],
        if (onRetry != null) ...[
          AppSpacing.gapH(AppSpacing.md),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Повторить'),
          )
        ]
      ],
    );

    if (fullscreen) {
      return Scaffold(
        body: Center(child: content),
      );
    }
    return Center(child: content);
  }
}
