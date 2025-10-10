import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/widgets/custom_textfield.dart';
import 'package:bizlevel/providers/goals_providers.dart';

class CheckInForm extends StatelessWidget {
  const CheckInForm({
    super.key,
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
  });

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _GroupHeader('Итоги спринта'),
            _LabeledField(
              label: 'Что достигнуто',
              child: CustomTextBox(
                controller: achievementCtrl,
                hint: 'Опишите главное достижение недели',
              ),
            ),
            const SizedBox(height: 12),
            if (isDesktop)
              Row(children: [
                Expanded(
                  child: Consumer(builder: (context, ref, _) {
                    final metricAsync = ref.watch(metricLabelProvider);
                    final String dynamicLabel = metricAsync.maybeWhen(
                      data: (s) => (s == null || s.isEmpty)
                          ? 'Ключевая метрика (факт)'
                          : 'Ключевая метрика — $s (факт)',
                      orElse: () => 'Ключевая метрика (факт)',
                    );
                    return _LabeledField(
                      label: dynamicLabel,
                      child: CustomTextBox(
                        controller: metricActualCtrl,
                        keyboardType: TextInputType.number,
                        hint: 'Фактическое значение',
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _LabeledField(
                    label: 'Главный инсайт недели',
                    child: CustomTextBox(
                      controller: keyInsightCtrl,
                      hint: 'Что поняли или узнали нового',
                    ),
                  ),
                ),
              ])
            else
              Column(children: [
                Consumer(builder: (context, ref, _) {
                  final metricAsync = ref.watch(metricLabelProvider);
                  final String dynamicLabel = metricAsync.maybeWhen(
                    data: (s) => (s == null || s.isEmpty)
                        ? 'Ключевая метрика (факт)'
                        : 'Ключевая метрика — $s (факт)',
                    orElse: () => 'Ключевая метрика (факт)',
                  );
                  return _LabeledField(
                    label: dynamicLabel,
                    child: CustomTextBox(
                      controller: metricActualCtrl,
                      keyboardType: TextInputType.number,
                      hint: 'Фактическое значение',
                    ),
                  );
                }),
                const SizedBox(height: 12),
                // Прогресс недели в % относительно цели v2
                Consumer(builder: (context, ref, _) {
                  final allAsync = ref.watch(goalVersionsProvider);
                  return allAsync.maybeWhen(
                    data: (all) {
                      try {
                        final Map<int, Map<String, dynamic>> map = {
                          for (final m in all)
                            (m['version'] as int): Map<String, dynamic>.from(m)
                        };
                        final Map<String, dynamic> v2 =
                            (map[2]?['version_data'] as Map?)
                                    ?.cast<String, dynamic>() ??
                                const <String, dynamic>{};
                        final double? from = double.tryParse(
                            '${v2['metric_current'] ?? ''}'.trim());
                        final double? to = double.tryParse(
                            '${v2['metric_target'] ?? ''}'.trim());
                        final double? current =
                            double.tryParse(metricActualCtrl.text.trim());
                        if (from != null &&
                            to != null &&
                            current != null &&
                            to != from) {
                          final double pct =
                              ((current - from) / (to - from)).clamp(0.0, 1.0) *
                                  100;
                          final value = pct.isNaN ? 0 : pct;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Прогресс к цели: ${value.toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        }
                      } catch (_) {}
                      return const SizedBox.shrink();
                    },
                    orElse: () => const SizedBox.shrink(),
                  );
                }),
                _LabeledField(
                  label: 'Главный инсайт недели',
                  child: CustomTextBox(
                    controller: keyInsightCtrl,
                    hint: 'Что поняли или узнали нового',
                  ),
                ),
              ]),
            const SizedBox(height: 16),
            const _GroupHeader('Проверки недели'),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Матрица Эйзенхауэра (Ур. 3)'),
                  selected: chkEisenhower,
                  onSelected: (v) => onToggleEisenhower(v),
                ),
                FilterChip(
                  label: const Text('Финансовый учёт (Ур. 4)'),
                  selected: chkAccounting,
                  onSelected: (v) => onToggleAccounting(v),
                ),
                FilterChip(
                  label: const Text('УТП (Ур. 5)'),
                  selected: chkUSP,
                  onSelected: (v) => onToggleUSP(v),
                ),
                FilterChip(
                  label: const Text('SMART‑планирование (Ур. 7)'),
                  selected: chkSMART,
                  onSelected: (v) => onToggleSMART(v),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Другое',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextBox(
                    controller: techOtherCtrl,
                    hint: 'Что ещё применяли из уроков',
                  ),
                  const SizedBox(height: 8),
                  Consumer(builder: (context, ref, _) {
                    final optionsAsync = ref.watch(usedToolsOptionsProvider);
                    return optionsAsync.maybeWhen(
                      data: (opts) {
                        if (opts.isEmpty) return const SizedBox.shrink();
                        return Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: opts.map((o) {
                            return InputChip(
                              label: Text(o),
                              onPressed: () {
                                final current = techOtherCtrl.text.trim();
                                if (current.contains(o)) return;
                                techOtherCtrl.text =
                                    current.isEmpty ? o : '$current, $o';
                              },
                            );
                          }).toList(),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.checklist),
                    label: const Text('📝 Записать итоги недели'),
                    onPressed: onSave,
                  ),
                ),
                if (showChatButton) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Обсудить с Максом'),
                      onPressed: onOpenChat,
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        child,
      ],
    );
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
            ),
      ),
    );
  }
}
