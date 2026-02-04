import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/theme/effects.dart';
import 'package:bizlevel/widgets/common/glass_container.dart';

/// Компактная карточка цитаты дня без аватара, переиспользуемая на Главной.
class HomeQuoteCard extends ConsumerWidget {
  const HomeQuoteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(dailyQuoteProvider);
    final quoteValue = quoteAsync.value;
    if (quoteValue == null) {
      return quoteAsync.when(
        data: (q) =>
            q == null ? const SizedBox.shrink() : _buildQuote(context, q),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      );
    }
    return _buildQuote(context, quoteValue);
  }

  Widget _buildQuote(BuildContext context, Map<String, dynamic> q) {
    final text = (q['quote_text'] as String?) ?? '';
    final String? author = q['author'] as String?;
    return Semantics(
      label: 'Цитата дня',
      child: GlassContainer(
        radius: AppDimensions.radiusLg,
        padding: const EdgeInsets.all(AppSpacing.md),
        showHighlightBorder: false,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.colorAccentWarmLight.withValues(alpha: 0.4),
              AppColor.colorAccentWarmLight.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColor.colorAccentWarm.withValues(alpha: 0.3)),
          boxShadow: AppEffects.glassCardShadowSm,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: () {
            try {
              Sentry.addBreadcrumb(Breadcrumb(
                category: 'ui.tap',
                message: 'home_quote_tap',
                level: SentryLevel.info,
              ));
            } catch (_) {}
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColor.colorAccentWarm,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusRound),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '«$text»',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.quote.copyWith(
                        color: AppColor.colorTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              if (author != null && author.isNotEmpty) ...[
                AppSpacing.gapH(6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    author,
                    style: AppTypography.caption.copyWith(
                      color: AppColor.colorTextSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
