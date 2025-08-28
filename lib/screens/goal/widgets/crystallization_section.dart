import 'package:flutter/material.dart';

import 'package:bizlevel/theme/color.dart';

class CrystallizationSection extends StatelessWidget {
  const CrystallizationSection({
    super.key,
    required this.versions,
    required this.selectedVersion,
    required this.allowedMaxVersion,
    required this.historyExpanded,
    required this.onSelectVersion,
    required this.onToggleHistory,
  });

  final Map<int, Map<String, dynamic>> versions;
  final int selectedVersion;
  final int allowedMaxVersion;
  final bool historyExpanded;
  final ValueChanged<int> onSelectVersion;
  final VoidCallback onToggleHistory;

  @override
  Widget build(BuildContext context) {
    final bool hasAny = versions.isNotEmpty;
    final int latest =
        hasAny ? versions.keys.reduce((a, b) => a > b ? a : b) : 0;
    final int currentStage = latest == 0 ? 1 : latest.clamp(1, 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Кристаллизация цели',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        if (latest >= 4)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Кристаллизация завершена',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton.icon(
                icon: Icon(
                    historyExpanded ? Icons.keyboard_arrow_up : Icons.history),
                label: Text(historyExpanded ? 'Свернуть историю' : 'История'),
                onPressed: onToggleHistory,
              )
            ],
          )
        else ...[
          Text(
            'Этап $currentStage из 4: ${_getVersionLabel(currentStage)}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(4, (i) {
              final s = i + 1;
              final filled = s <= currentStage;
              return Expanded(
                child: Container(
                  height: 8,
                  margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: filled ? AppColor.primary : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          )
        ],
        const SizedBox(height: 12),
        if (latest >= 4)
          (historyExpanded
              ? _HistoryTimeline(versions: versions)
              : const SizedBox.shrink())
        else ...[
          _VersionChips(
            versions: versions,
            selectedVersion: selectedVersion,
            allowedMaxVersion: allowedMaxVersion,
            onSelect: onSelectVersion,
          ),
          const SizedBox(height: 12),
          _VersionTable(versions: versions, version: selectedVersion),
        ],
      ],
    );
  }

  String _getVersionLabel(int version) {
    switch (version) {
      case 1:
        return '1. Набросок';
      case 2:
        return '2. Метрики';
      case 3:
        return '3. SMART';
      case 4:
        return '4. Финал';
      default:
        return '$version';
    }
  }
}

class _VersionChips extends StatelessWidget {
  const _VersionChips({
    required this.versions,
    required this.selectedVersion,
    required this.allowedMaxVersion,
    required this.onSelect,
  });

  final Map<int, Map<String, dynamic>> versions;
  final int selectedVersion;
  final int allowedMaxVersion;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final bool hasAny = versions.isNotEmpty;
    final int latest =
        hasAny ? versions.keys.reduce((a, b) => a > b ? a : b) : 0;
    return Row(
      children: List.generate(4, (i) {
        final v = i + 1;
        final isSelected = selectedVersion == v;
        final available = v <= allowedMaxVersion &&
            ((!hasAny && v == 1) ||
                versions.containsKey(v) ||
                (hasAny && v == latest + 1));
        final String labelText = _getVersionLabel(v);
        final chip = ChoiceChip(
          showCheckmark: false,
          labelPadding: const EdgeInsets.symmetric(horizontal: 6),
          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: Text(labelText, overflow: TextOverflow.ellipsis),
          selected: isSelected,
          selectedColor: AppColor.premium.withValues(alpha: 0.18),
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? AppColor.premium : AppColor.borderColor,
            ),
          ),
          onSelected: available
              ? (sel) {
                  if (!sel) return;
                  onSelect(v);
                }
              : null,
        );
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
            child: SizedBox(height: 36, child: chip),
          ),
        );
      }),
    );
  }

  String _getVersionLabel(int version) {
    switch (version) {
      case 1:
        return '1. Набросок';
      case 2:
        return '2. Метрики';
      case 3:
        return '3. SMART';
      case 4:
        return '4. Финал';
      default:
        return '$version';
    }
  }
}

class _VersionTable extends StatelessWidget {
  const _VersionTable({required this.versions, required this.version});
  final Map<int, Map<String, dynamic>> versions;
  final int version;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> vData =
        (versions[version]?['version_data'] as Map?)?.cast<String, dynamic>() ??
            {};

    late final List<List<String>> rows;
    if (version == 1) {
      rows = [
        ['Основная цель', (vData['goal_initial'] ?? '').toString()],
        ['Почему сейчас', (vData['goal_why'] ?? '').toString()],
        ['Препятствие', (vData['main_obstacle'] ?? '').toString()],
      ];
    } else if (version == 2) {
      rows = [
        ['Уточненная цель', (vData['goal_refined'] ?? '').toString()],
        ['Метрика', (vData['metric_name'] ?? '').toString()],
        ['Текущее значение', (vData['metric_from'] ?? '').toString()],
        ['Целевое значение', (vData['metric_to'] ?? '').toString()],
        ['Финансовая цель', (vData['financial_goal'] ?? '').toString()],
      ];
    } else if (version == 3) {
      rows = [
        ['SMART‑формулировка', (vData['goal_smart'] ?? '').toString()],
        ['Спринт 1', (vData['sprint1_goal'] ?? '').toString()],
        ['Спринт 2', (vData['sprint2_goal'] ?? '').toString()],
        ['Спринт 3', (vData['sprint3_goal'] ?? '').toString()],
        ['Спринт 4', (vData['sprint4_goal'] ?? '').toString()],
      ];
    } else {
      rows = [
        ['Что достигну', (vData['final_what'] ?? '').toString()],
        ['К какой дате', (vData['final_when'] ?? '').toString()],
        ['Ключевые действия', (vData['final_how'] ?? '').toString()],
        ['Готовность', ((vData['commitment'] ?? false) == true) ? 'Да' : 'Нет'],
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...rows.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      r[0],
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      r[1].isEmpty ? '—' : r[1],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _HistoryTimeline extends StatelessWidget {
  const _HistoryTimeline({required this.versions});
  final Map<int, Map<String, dynamic>> versions;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];
    for (int v = 1; v <= 4; v++) {
      final ver = versions[v];
      final present = ver != null;
      final data =
          (ver?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
      String title;
      List<String> lines;
      switch (v) {
        case 1:
          title = 'v1: Набросок';
          lines = [
            (data['goal_initial'] ?? '').toString(),
            if ((data['goal_why'] ?? '').toString().isNotEmpty)
              'Почему: ${data['goal_why']}',
            if ((data['main_obstacle'] ?? '').toString().isNotEmpty)
              'Препятствие: ${data['main_obstacle']}',
          ];
          break;
        case 2:
          title = 'v2: Метрики';
          lines = [
            'Метрика: ${(data['metric_name'] ?? '').toString()}',
            'Сейчас: ${(data['metric_from'] ?? '').toString()} → Цель: ${(data['metric_to'] ?? '').toString()}',
          ];
          break;
        case 3:
          title = 'v3: SMART';
          lines = [
            (data['goal_smart'] ?? '').toString(),
            if ((data['sprint1_goal'] ?? '').toString().isNotEmpty)
              'План по неделям есть',
          ];
          break;
        default:
          title = 'v4: Финал';
          lines = [
            (data['final_what'] ?? '').toString(),
            if ((data['final_when'] ?? '').toString().isNotEmpty)
              'Старт: ${data['final_when']}',
            'Готовность: ${((data['commitment'] ?? false) == true) ? 'Да' : 'Нет'}',
          ];
      }

      items.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: present ? AppColor.primary : Colors.grey.shade300,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                ...lines.where((e) => e.trim().isNotEmpty).map((t) => Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        t,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey.shade700),
                      ),
                    )),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
      ));
    }

    return Container(
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
            'Эволюция моей цели:',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }
}

