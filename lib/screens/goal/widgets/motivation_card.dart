import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/animations.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';

/// Карточка «Мотивация от Макса» с автосворачиванием и кликом для разворота
class MotivationCard extends ConsumerStatefulWidget {
  const MotivationCard({super.key});

  @override
  ConsumerState<MotivationCard> createState() => _MotivationCardState();
}

class _MotivationCardState extends ConsumerState<MotivationCard> {
  @override
  Widget build(BuildContext context) {
    final quoteAsync = ref.watch(dailyQuoteProvider);
    return AnimatedContainer(
      duration: MotionSystem.modalTransition,
      curve: Curves.easeInOut,
      constraints: const BoxConstraints(minHeight: 120),
      child: BizLevelCard(
        tonal: true,
        padding: AppSpacing.insetsAll(AppSpacing.s20),
        child: ClipRect(
          child: quoteAsync.when(
            data: (q) {
              if (q == null) {
                return Text(
                  'Цитата недоступна',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColor.labelColor,
                        height: 1.4,
                      ),
                );
              }
              final text = (q['quote_text'] as String?) ?? '';
              final String? author = q['author'] as String?;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мотивация',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  AppSpacing.gapH(8),
                  Text(
                    '"$text"',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                  ),
                  AppSpacing.gapH(4),
                  if (author != null && author.isNotEmpty)
                    Text(
                      '— $author',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                ],
              );
            },
            loading: () => const SizedBox(
              height: 120,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, __) => Text(
              'Цитата недоступна',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.labelColor,
                    height: 1.4,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
