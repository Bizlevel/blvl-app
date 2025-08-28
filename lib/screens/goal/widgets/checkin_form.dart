import 'package:flutter/material.dart';

import 'package:bizlevel/widgets/custom_textfield.dart';

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
            _GroupHeader('Итоги спринта'),
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
                  child: _LabeledField(
                    label: 'Ключевая метрика (факт)',
                    child: CustomTextBox(
                      controller: metricActualCtrl,
                      keyboardType: TextInputType.number,
                      hint: 'Фактическое значение',
                    ),
                  ),
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
                _LabeledField(
                  label: 'Ключевая метрика (факт)',
                  child: CustomTextBox(
                    controller: metricActualCtrl,
                    keyboardType: TextInputType.number,
                    hint: 'Фактическое значение',
                  ),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Главный инсайт недели',
                  child: CustomTextBox(
                    controller: keyInsightCtrl,
                    hint: 'Что поняли или узнали нового',
                  ),
                ),
              ]),
            const SizedBox(height: 16),
            _GroupHeader('Проверки недели'),
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
              child: CustomTextBox(
                controller: techOtherCtrl,
                hint: 'Что ещё применяли из уроков',
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

