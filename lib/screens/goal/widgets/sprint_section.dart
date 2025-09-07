import 'package:flutter/material.dart';

import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:bizlevel/screens/goal/widgets/weeks_timeline_row.dart';
import 'package:bizlevel/screens/goal/widgets/checkin_form.dart';
import 'package:bizlevel/theme/spacing.dart';

class SprintSection extends StatelessWidget {
  const SprintSection({
    super.key,
    required this.versions,
    required this.selectedSprint,
    required this.onSelectSprint,
    this.weekSummaries = const <int, Map<String, dynamic>>{},
    this.currentWeek = 1,
    required this.achievementCtrl,
    required this.metricActualCtrl,
    required this.keyInsightCtrl,
    required this.techOtherCtrl,
    required this.chkEisenhower,
    required this.chkAccounting,
    required this.chkUSP,
    required this.chkSMART,
    required this.onToggleEisenhower,
    required this.onToggleAccounting,
    required this.onToggleUSP,
    required this.onToggleSMART,
    required this.onSave,
    required this.showChatButton,
    required this.onOpenChat,
    this.sectionKey,
  });

  final Map<int, Map<String, dynamic>> versions;
  final int selectedSprint;
  final ValueChanged<int> onSelectSprint;
  final Map<int, Map<String, dynamic>> weekSummaries;
  final int currentWeek;
  final TextEditingController achievementCtrl;
  final TextEditingController metricActualCtrl;
  final TextEditingController keyInsightCtrl;
  final TextEditingController techOtherCtrl;
  final bool chkEisenhower;
  final bool chkAccounting;
  final bool chkUSP;
  final bool chkSMART;
  final ValueChanged<bool> onToggleEisenhower;
  final ValueChanged<bool> onToggleAccounting;
  final ValueChanged<bool> onToggleUSP;
  final ValueChanged<bool> onToggleSMART;
  final VoidCallback onSave;
  final bool showChatButton;
  final VoidCallback onOpenChat;
  final Key? sectionKey;

  @override
  Widget build(BuildContext context) {
    final bool hasV4 = versions.containsKey(4);
    if (!hasV4) {
      return Container(
        width: double.infinity,
        padding: AppSpacing.insetsAll(16),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: AppColor.labelColor, size: 28),
            AppSpacing.gapW(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔒 Путь к цели заблокирован',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  AppSpacing.gapH(4),
                  Text(
                    'Завершите версию v4 для разблокировки 28-дневного пути к цели',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColor.labelColor,
                          height: 1.3,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: AppSpacing.insetsAll(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 600;
              return Text(
                'Путь к цели',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
          AppSpacing.gapH(16),
          WeeksTimelineRow(
            versions: versions,
            selectedSprint: selectedSprint,
            onSelectSprint: onSelectSprint,
          ),
          AppSpacing.gapH(12),
          // Краткие карточки недель (аккордеон): текущая открыта, прошлые свернуты
          Column(
            children: List.generate(4, (i) {
              final w = i + 1;
              final summary = weekSummaries[w] ?? const <String, dynamic>{};
              final bool isCurrent = w == selectedSprint;
              final String title = 'Неделя $w';
              final String subtitle = (summary['achievement'] ??
                      summary['key_insight'] ??
                      '') as String? ??
                  '';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadowColor.withValues(alpha: 0.06),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: AppSpacing.insetsSymmetric(h: 12, v: 6),
                  leading: Icon(
                    isCurrent
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isCurrent ? AppColor.primary : AppColor.labelColor,
                  ),
                  title: Text(title),
                  subtitle: subtitle.isNotEmpty
                      ? Text(subtitle,
                          maxLines: 1, overflow: TextOverflow.ellipsis)
                      : null,
                  trailing: w > currentWeek
                      ? const Icon(Icons.lock_outline,
                          size: 18, color: AppColor.labelColor)
                      : const Icon(Icons.chevron_right),
                  onTap: () => onSelectSprint(w),
                ),
              );
            }),
          ),
          AppSpacing.gapH(12),
          CheckInForm(
            achievementCtrl: achievementCtrl,
            metricActualCtrl: metricActualCtrl,
            keyInsightCtrl: keyInsightCtrl,
            techOtherCtrl: techOtherCtrl,
            chkEisenhower: chkEisenhower,
            chkAccounting: chkAccounting,
            chkUSP: chkUSP,
            chkSMART: chkSMART,
            onToggleEisenhower: onToggleEisenhower,
            onToggleAccounting: onToggleAccounting,
            onToggleUSP: onToggleUSP,
            onToggleSMART: onToggleSMART,
            onSave: onSave,
            showChatButton: showChatButton,
            onOpenChat: onOpenChat,
          ),
        ],
      ),
    );
  }
}
