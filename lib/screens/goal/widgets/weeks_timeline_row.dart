import 'package:flutter/material.dart';

import 'package:bizlevel/theme/color.dart';

class WeeksTimelineRow extends StatelessWidget {
  const WeeksTimelineRow({
    super.key,
    required this.versions,
    required this.selectedSprint,
    required this.onSelectSprint,
  });

  final Map<int, Map<String, dynamic>> versions;
  final int selectedSprint; // 1..4
  final ValueChanged<int> onSelectSprint;

  @override
  Widget build(BuildContext context) {
    final int current = _currentWeekNumber(versions);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(4, (i) {
          final s = i + 1;
          final bool completed = s < current;
          final bool active = s == current;
          final String status = completed
              ? '✅'
              : active
                  ? '⚡'
                  : '⏳';
          final String plan = _getWeekGoalFromV3(versions, s);
          return Padding(
            padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
            child: InkWell(
              onTap: () => onSelectSprint(s),
              child: Container(
                width: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadowColor.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: (s == selectedSprint)
                        ? AppColor.primary
                        : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Нед $s  $status',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      plan.isEmpty ? 'План: —' : 'План: $plan',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  static int _currentWeekNumber(Map<int, Map<String, dynamic>> versions) {
    final Map<String, dynamic> v4 =
        (versions[4]?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final String when = (v4['final_when'] ?? '').toString();
    final start = DateTime.tryParse(when)?.toUtc();
    if (start == null) return 1;
    final int days = DateTime.now().toUtc().difference(start).inDays;
    final int week = (days ~/ 7) + 1;
    return week.clamp(1, 4);
  }

  static String _getWeekGoalFromV3(
      Map<int, Map<String, dynamic>> versions, int week) {
    final Map<String, dynamic> v3 =
        (versions[3]?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final key = switch (week) {
      1 => 'sprint1_goal',
      2 => 'sprint2_goal',
      3 => 'sprint3_goal',
      _ => 'sprint4_goal',
    };
    return (v3[key] ?? '').toString();
  }
}

