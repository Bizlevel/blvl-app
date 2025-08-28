import 'package:flutter/material.dart';

import 'package:bizlevel/theme/color.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    super.key,
    required this.versions,
    required this.metricActual,
    this.achievementText = '',
    this.metricActualText = '',
    this.insightText = '',
  });

  final Map<int, Map<String, dynamic>> versions;
  final double? metricActual;
  final String achievementText;
  final String metricActualText;
  final String insightText;

  @override
  Widget build(BuildContext context) {
    final pct =
        (_calcOverallProgressPercent(versions, metricActual) * 100).round();
    final (String? metricName, double? from, double? to) = _getV2Data(versions);
    final double? current = metricActual;
    final int weeksPassed = (_currentWeekNumber(versions) - 1).clamp(0, 4);

    final List<Widget> lines = [];
    if (metricName != null &&
        metricName.isNotEmpty &&
        to != null &&
        current != null) {
      lines.add(Text(
        '${_fmt(current)} из ${_fmt(to)} $metricName',
        style: Theme.of(context).textTheme.bodyMedium,
      ));
    }
    if (from != null && current != null && from != 0) {
      final deltaPct = (((current - from) / from) * 100).round();
      lines.add(Text(
        'Динамика: ${deltaPct >= 0 ? '+' : ''}$deltaPct% за $weeksPassed недель',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.grey.shade700),
      ));
    }
    if (from != null && to != null && current != null && to != from) {
      final forecast =
          (((current - from) / (to - from)) * 100).clamp(0, 100).round();
      lines.add(Text(
        'Прогноз: $forecast% от цели',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.grey.shade700),
      ));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text('Мой прогресс',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (pct / 100).clamp(0, 1).toDouble(),
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            color: AppColor.primary,
          ),
          const SizedBox(height: 12),
          ...lines.map(
              (w) => Padding(padding: const EdgeInsets.only(top: 2), child: w)),
          const SizedBox(height: 8),
          if (achievementText.isNotEmpty ||
              metricActualText.isNotEmpty ||
              insightText.isNotEmpty) ...[
            Text(
              'Неделя ${_currentWeekNumber(versions)} — промежуточные результаты',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (achievementText.isNotEmpty)
              Text('Достижение: $achievementText',
                  style: Theme.of(context).textTheme.bodySmall),
            if (metricActualText.isNotEmpty)
              Text('Факт метрики: $metricActualText',
                  style: Theme.of(context).textTheme.bodySmall),
            if (insightText.isNotEmpty)
              Text('Инсайт: $insightText',
                  style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }

  static (String?, double?, double?) _getV2Data(
      Map<int, Map<String, dynamic>> versions) {
    final Map<String, dynamic> v2 =
        (versions[2]?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final String? metricName = (v2['metric_name'] ?? '') as String?;
    final double? from = double.tryParse('${v2['metric_from'] ?? ''}'.trim());
    final double? to = double.tryParse('${v2['metric_to'] ?? ''}'.trim());
    return (metricName, from, to);
  }

  static double _calcOverallProgressPercent(
      Map<int, Map<String, dynamic>> versions, double? metricActual) {
    final (String?, double?, double?) data = _getV2Data(versions);
    final double? from = data.$2;
    final double? to = data.$3;
    final double? current = metricActual;
    if (from != null && to != null && current != null && to != from) {
      final pct = ((current - from) / (to - from)).clamp(0.0, 1.0);
      return pct.isNaN ? 0.0 : pct;
    }
    return 0.0;
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

  static String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }
}
