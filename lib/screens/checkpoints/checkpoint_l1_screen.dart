import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CheckpointL1Screen extends ConsumerStatefulWidget {
  const CheckpointL1Screen({super.key});

  @override
  ConsumerState<CheckpointL1Screen> createState() => _CheckpointL1ScreenState();
}

class _CheckpointL1ScreenState extends ConsumerState<CheckpointL1Screen> {
  final TextEditingController _currentCtrl = TextEditingController();
  String _metric = 'Клиенты/день';
  final TextEditingController _targetCtrl = TextEditingController();
  DateTime? _deadline;

  // Удалены неиспользуемые поля быстрого ревью

  @override
  void dispose() {
    _currentCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    try {
      final goal = ref.read(userGoalProvider).asData?.value;
      final m = (goal?['metric_type'] ?? '').toString();
      const allowed = ['Клиенты/день', 'Заказы/неделю', 'Общая выручка'];
      if (allowed.contains(m)) {
        _metric = m;
      }
    } catch (_) {}
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _saveAndOpenMax() async {
    final repo = ref.read(goalsRepositoryProvider);
    final double? cur = double.tryParse(_currentCtrl.text.trim());
    final double? tgt = double.tryParse(_targetCtrl.text.trim());
    try {
      await repo.upsertUserGoal(
        goalText: _buildGoalText(cur, tgt),
        metricType: _metric,
        metricStart: cur,
        metricCurrent: cur,
        metricTarget: tgt,
        targetDate: _deadline,
      );
      try {
        Sentry.addBreadcrumb(Breadcrumb(
            category: 'checkpoint',
            message: 'l1_saved',
            level: SentryLevel.info));
      } catch (_) {}
      ref.invalidate(userGoalProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Цель сохранена')));
      GoRouter.of(context).push('/goal');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  String _buildGoalText(double? cur, double? tgt) {
    final curStr = cur?.toStringAsFixed(0) ?? '?';
    final tgtStr = tgt?.toStringAsFixed(0) ?? '?';
    final dateStr = _deadline == null
        ? ''
        : _deadline!.toLocal().toIso8601String().split('T').first;
    return '$_metric: $curStr → $tgtStr${dateStr.isEmpty ? '' : ' к $dateStr'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чекпоинт: Первая цель')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Текущая цель',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text((ref.watch(userGoalProvider).asData?.value?['goal_text'] ?? '')
                .toString()),
            const SizedBox(height: 16),
            const Text('Шаг 1: Выберите основную метрику'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _metric,
              items: const [
                DropdownMenuItem(
                    value: 'Клиенты/день', child: Text('Клиенты/день')),
                DropdownMenuItem(
                    value: 'Заказы/неделю', child: Text('Заказы/неделю')),
                DropdownMenuItem(
                    value: 'Общая выручка', child: Text('Общая выручка')),
              ],
              onChanged: (v) => setState(() => _metric = v ?? _metric),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                  'Подсказка: выбирайте метрику, которую вы реально можете изменять своими действиями. Пример формулы: Выручка = Клиенты × Средний чек.'),
            ),
            const SizedBox(height: 16),
            const Text('Шаг 2: Текущее значение'),
            const SizedBox(height: 8),
            TextField(
              controller: _currentCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: _metric.contains('выручка')
                    ? 'Например: 200000'
                    : 'Например: 5',
                suffixText: _metric.contains('выручка')
                    ? '₸'
                    : (_metric.contains('день')
                        ? '/день'
                        : (_metric.contains('нед') ? '/нед.' : 'ед.')),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Шаг 3: Целевое значение'),
            const SizedBox(height: 8),
            TextField(
              controller: _targetCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: _metric.contains('выручка')
                    ? 'Например: 300000'
                    : 'Например: 10',
                suffixText: _metric.contains('выручка')
                    ? '₸'
                    : (_metric.contains('день')
                        ? '/день'
                        : (_metric.contains('нед') ? '/нед.' : 'ед.')),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Шаг 4: Срок достижения'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(_deadline == null
                      ? 'Не выбрано'
                      : _deadline!.toIso8601String().split('T').first),
                ),
                TextButton(
                    onPressed: _pickDate, child: const Text('Выбрать дату')),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveAndOpenMax,
              child: const Text('Сформулировать цель'),
            ),
          ],
        ),
      ),
    );
  }

  // chat bubble удалён как неиспользуемый
}
