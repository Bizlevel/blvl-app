import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

/// Компактный календарь 28 дней (4 недели по 7 дней)
/// statusByDay: индекс 1..28 → 'completed' | 'partial' | 'missed' | 'pending'
class DailyCalendar28 extends StatelessWidget {
  const DailyCalendar28({
    super.key,
    required this.statusByDay,
    this.onTapDay,
  });

  final Map<int, String> statusByDay;
  final void Function(int day)? onTapDay;

  Color _dotColor(String? status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'partial':
        return Colors.orange;
      case 'missed':
        return Colors.black87;
      default:
        return Colors.white;
    }
  }

  Color _dotBorder(String? status) {
    if (status == null || status == 'pending') {
      return AppColor.labelColor.withValues(alpha: 0.3);
    }
    return _dotColor(status).withValues(alpha: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '28 дней к цели',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(4, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 74,
                    child: Text('Неделя ${row + 1}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: List<Widget>.generate(7, (col) {
                        final day = row * 7 + col + 1;
                        final status = statusByDay[day];
                        return Semantics(
                          label: 'День $day: ${status ?? 'ожидает'}',
                          button: true,
                          child: InkWell(
                            onTap:
                                onTapDay == null ? null : () => onTapDay!(day),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _dotColor(status),
                                border: Border.all(color: _dotBorder(status)),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x08000000),
                                      blurRadius: 2,
                                      offset: Offset(0, 1)),
                                ],
                              ),
                              child: _iconForStatus(context, status, day),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _legendDot(context, 'Выполнено', Colors.green),
            const SizedBox(width: 12),
            _legendDot(context, 'Частично', Colors.orange),
            const SizedBox(width: 12),
            _legendDot(context, 'Пропущен', Colors.black87),
          ],
        )
      ],
    );
  }

  Widget _iconForStatus(BuildContext context, String? status, int day) {
    if (status == 'completed') {
      return const Icon(Icons.check, size: 16, color: Colors.white);
    } else if (status == 'partial') {
      return const Icon(Icons.lens, size: 10, color: Colors.white);
    } else if (status == 'missed') {
      return const Icon(Icons.remove, size: 16, color: Colors.white);
    }
    return Text(
      '$day',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 11,
            color: AppColor.textColor,
          ),
    );
  }

  Widget _legendDot(BuildContext context, String label, Color color) {
    return Row(children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
