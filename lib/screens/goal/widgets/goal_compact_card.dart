import 'package:flutter/material.dart';

import 'package:bizlevel/theme/color.dart';

class GoalCompactCard extends StatelessWidget {
  const GoalCompactCard({
    super.key,
    required this.versions,
    required this.expanded,
    required this.onToggle,
    required this.onOpenChat,
    this.metricActual,
  });

  final Map<int, Map<String, dynamic>> versions;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onOpenChat;
  final double? metricActual;

  @override
  Widget build(BuildContext context) {
    final hasAny = versions.isNotEmpty;
    final latestVersion =
        hasAny ? versions.keys.reduce((a, b) => a > b ? a : b) : 0;
    final data = hasAny
        ? Map<String, dynamic>.from(
            (versions[latestVersion]?['version_data'] as Map?) ?? {})
        : <String, dynamic>{};

    final String title = latestVersion == 4
        ? (data['final_what']?.toString() ?? 'Цель пока не сформулирована')
        : latestVersion == 3
            ? (data['goal_smart']?.toString() ?? 'Цель пока не сформулирована')
            : latestVersion == 2
                ? (data['goal_refined']?.toString() ??
                    'Цель пока не сформулирована')
                : (data['goal_initial']?.toString() ??
                    'Цель пока не сформулирована');

    final String? metricName =
        latestVersion >= 2 ? (data['metric_name'] as String?) : null;
    final String? fromV =
        latestVersion >= 2 ? data['metric_from']?.toString() : null;
    final String? toV =
        latestVersion >= 2 ? data['metric_to']?.toString() : null;
    final String? startDate =
        latestVersion >= 4 ? (data['final_when'] as String?) : null;
    final int currentStage = latestVersion.clamp(1, 4);
    final int readinessScore = ((currentStage * 10) / 4).round();

    final double progress = _calcOverallProgressPercent(versions, metricActual);

    return InkWell(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.isEmpty ? 'Цель пока не сформулирована' : title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: expanded ? null : 1,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: AppColor.primary,
            ),
            const SizedBox(height: 8),
            if (metricName != null &&
                metricName.isNotEmpty &&
                fromV != null &&
                toV != null)
              Text('Метрика: $metricName • Сейчас: $fromV → Цель: $toV',
                  style: Theme.of(context).textTheme.bodySmall),
            if (startDate != null && startDate.isNotEmpty)
              Text('Дней осталось: ${_daysLeft(startDate)} из 28',
                  style: Theme.of(context).textTheme.bodySmall),
            Text('Готовность: $readinessScore/10',
                style: Theme.of(context).textTheme.bodySmall),
            Text('Статус: В процессе',
                style: Theme.of(context).textTheme.bodySmall),
            if (expanded) ...[
              const SizedBox(height: 12),
              if (latestVersion >= 3) ...[
                const _GroupHeader('План по неделям'),
                _bullet(context, 'Неделя 1: ${data['sprint1_goal'] ?? '—'}'),
                _bullet(context, 'Неделя 2: ${data['sprint2_goal'] ?? '—'}'),
                _bullet(context, 'Неделя 3: ${data['sprint3_goal'] ?? '—'}'),
                _bullet(context, 'Неделя 4: ${data['sprint4_goal'] ?? '—'}'),
                const SizedBox(height: 8),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Обсудить с Максом'),
                  onPressed: onOpenChat,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  static Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  static double _calcOverallProgressPercent(
      Map<int, Map<String, dynamic>> versions, double? metricActual) {
    final v2 =
        (versions[2]?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final double? from = double.tryParse('${v2['metric_from'] ?? ''}'.trim());
    final double? to = double.tryParse('${v2['metric_to'] ?? ''}'.trim());
    final double? current = metricActual;
    if (from != null && to != null && current != null && to != from) {
      final pct = ((current - from) / (to - from)).clamp(0.0, 1.0);
      return pct.isNaN ? 0.0 : pct;
    }
    return 0.0;
  }

  static int _daysLeft(String startDateIso) {
    try {
      final start = DateTime.tryParse(startDateIso)?.toUtc();
      if (start == null) return 28;
      final diff = DateTime.now().toUtc().difference(start).inDays;
      final left = 28 - diff;
      return left.clamp(0, 28);
    } catch (_) {
      return 28;
    }
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColor.primary,
            ),
      ),
    );
  }
}

