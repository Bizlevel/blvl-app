import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bizlevel/theme/color.dart';

/// Дневная карточка «Сегодня» для 28-дневного режима
class DailyTodayCard extends StatelessWidget {
  const DailyTodayCard({
    super.key,
    required this.dayNumber,
    required this.taskText,
    required this.status,
    required this.onChangeStatus,
    required this.onSaveNote,
  });

  final int dayNumber; // 1..28
  final String taskText;
  final String status; // 'completed'|'partial'|'missed'|'pending'
  final void Function(String newStatus) onChangeStatus;
  final void Function(String note) onSaveNote;

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteCtrl = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('День $dayNumber из 28',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
          ]),
          const SizedBox(height: 10),
          _segmentedStatus(context),
          const SizedBox(height: 10),
          Text('Задача дня', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(taskText.isEmpty ? '—' : taskText,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          TextField(
            controller: noteCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Что помогло/мешало сегодня? (опционально)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => onSaveNote(noteCtrl.text.trim()),
              child: const Text('Сохранить'),
            ),
          ),
        ],
      ),
    );
  }

  // _statusChip был заменён на сегмент‑переключатель

  Widget _segmentedStatus(BuildContext context) {
    final List<Map<String, String>> items = [
      {'code': 'completed', 'label': 'Выполнено'},
      {'code': 'partial', 'label': 'Частично'},
      {'code': 'missed', 'label': 'Не удалось'},
    ];
    return LayoutBuilder(builder: (context, c) {
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.labelColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onChangeStatus(items[i]['code']!);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: status == items[i]['code']
                          ? AppColor.primary.withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: i == 0
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            )
                          : (i == items.length - 1
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                )
                              : BorderRadius.zero),
                    ),
                    child: Text(
                      items[i]['label']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: status == items[i]['code']
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
