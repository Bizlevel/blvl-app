import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bizlevel/theme/color.dart';

/// Дневная карточка «Сегодня» для 28-дневного режима
class DailyTodayCard extends StatefulWidget {
  const DailyTodayCard({
    super.key,
    required this.dayNumber,
    required this.taskText,
    required this.status,
    required this.onChangeStatus,
    required this.onSaveNote,
    this.currentStreak = 0,
  });

  final int dayNumber; // 1..28
  final String taskText;
  final String status; // 'completed'|'partial'|'missed'|'pending'
  final void Function(String newStatus) onChangeStatus;
  final void Function(String note) onSaveNote;
  final int currentStreak; // Текущая серия дней

  @override
  State<DailyTodayCard> createState() => _DailyTodayCardState();
}

class _DailyTodayCardState extends State<DailyTodayCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Запускаем анимацию при milestone (7/14/21/28)
    if (_isMilestone(widget.currentStreak)) {
      _animController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(DailyTodayCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если streak достиг milestone — запускаем анимацию
    if (widget.currentStreak != oldWidget.currentStreak &&
        _isMilestone(widget.currentStreak)) {
      _animController.repeat(reverse: true);
    } else if (!_isMilestone(widget.currentStreak)) {
      _animController.stop();
      _animController.value = 0;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  bool _isMilestone(int streak) {
    return streak == 7 || streak == 14 || streak == 21 || streak == 28;
  }

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
            Text('День ${widget.dayNumber} из 28',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const Spacer(),
            // Счётчик серии (streak) с анимацией при milestone
            if (widget.currentStreak > 0)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.red.shade400,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _isMilestone(widget.currentStreak)
                        ? [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '🔥',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.currentStreak}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _bonusHint(widget.currentStreak),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 10),
          _segmentedStatus(context),
          const SizedBox(height: 10),
          Text('Задача дня', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(widget.taskText.isEmpty ? '—' : widget.taskText,
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
              onPressed: () => widget.onSaveNote(noteCtrl.text.trim()),
              child: const Text('Сохранить'),
            ),
          ),
        ],
      ),
    );
  }

  String _bonusHint(int streak) {
    // Подсказки о бонусах GP на milestone
    if (streak < 7) return '';
    switch (streak) {
      case 7:
        return '+100 GP';
      case 14:
        return '+250 GP';
      case 21:
        return '+500 GP';
      case 28:
        return '+1000 GP';
      default:
        return '';
    }
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
                    widget.onChangeStatus(items[i]['code']!);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.status == items[i]['code']
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
                            fontWeight: widget.status == items[i]['code']
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
