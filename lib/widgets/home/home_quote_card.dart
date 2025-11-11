import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';

/// Компактная карточка цитаты дня без аватара, переиспользуемая на Главной.
class HomeQuoteCard extends ConsumerWidget {
  const HomeQuoteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(dailyQuoteProvider);
    return quoteAsync.when(
      data: (q) {
        if (q == null) return const SizedBox.shrink();
        final text = (q['quote_text'] as String?) ?? '';
        final String? author = q['author'] as String?;
        return Semantics(
          label: 'Цитата дня',
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              try {
                Sentry.addBreadcrumb(Breadcrumb(
                  category: 'ui.tap',
                  message: 'home_quote_tap',
                  level: SentryLevel.info,
                ));
              } catch (_) {}
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.s14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColor.appBgColor, AppColor.appBarColor],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(color: AppColor.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadow.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '«$text»',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  if (author != null && author.isNotEmpty) ...[
                    AppSpacing.gapH(6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        author,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColor.onSurfaceSubtle,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}


