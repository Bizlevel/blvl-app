import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:bizlevel/theme/spacing.dart';

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
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      constraints: const BoxConstraints(minHeight: 120),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: AppSpacing.insetsAll(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.appBgColor, AppColor.appBarColor],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRect(
            child: quoteAsync.when(
              data: (q) {
                if (q == null) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            AssetImage('assets/images/avatars/avatar_max.png'),
                        backgroundColor: Colors.transparent,
                      ),
                      AppSpacing.gapW(16),
                      Expanded(
                        child: Text(
                          'Цитата недоступна',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColor.labelColor,
                                    height: 1.4,
                                  ),
                        ),
                      )
                    ],
                  );
                }
                final text = (q['quote_text'] as String?) ?? '';
                final String? author = q['author'] as String?;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          AssetImage('assets/images/avatars/avatar_max.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    AppSpacing.gapW(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isDesktop = constraints.maxWidth > 600;
                              return Text(
                                'Мотивация от Макса',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isDesktop
                                          ? (Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.fontSize ??
                                                  16) +
                                              1
                                          : null,
                                    ),
                              );
                            },
                          ),
                          AppSpacing.gapH(8),
                          Text(
                            '"$text"',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                            // Показываем полный текст без обрезки
                          ),
                          AppSpacing.gapH(4),
                          if (author != null && author.isNotEmpty)
                            Text(
                              '— $author',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              loading: () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColor.dividerColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  AppSpacing.gapW(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColor.dividerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        AppSpacing.gapH(12),
                        Container(
                          width: double.infinity,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColor.dividerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        AppSpacing.gapH(8),
                        Container(
                          width: 120,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColor.dividerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        AppSpacing.gapH(8),
                        Container(
                          width: 80,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColor.dividerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              error: (_, __) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        AssetImage('assets/images/avatars/avatar_max.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  AppSpacing.gapW(16),
                  Expanded(
                    child: Text(
                      'Цитата недоступна',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColor.labelColor,
                            height: 1.4,
                          ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
