import 'package:flutter/material.dart';

import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/screens/goal/widgets/weeks_timeline_row.dart';
import 'package:bizlevel/screens/goal/widgets/checkin_form.dart';

class SprintSection extends StatelessWidget {
  const SprintSection({
    super.key,
    required this.versions,
    required this.selectedSprint,
    required this.onSelectSprint,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔒 Путь к цели заблокирован',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Завершите версию v4 для разблокировки 28-дневного пути к цели',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          const SizedBox(height: 16),
          WeeksTimelineRow(
            versions: versions,
            selectedSprint: selectedSprint,
            onSelectSprint: onSelectSprint,
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
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

