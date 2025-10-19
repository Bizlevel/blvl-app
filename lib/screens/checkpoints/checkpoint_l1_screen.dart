import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CheckpointL1Screen extends ConsumerStatefulWidget {
  const CheckpointL1Screen({super.key});

  @override
  ConsumerState<CheckpointL1Screen> createState() => _CheckpointL1ScreenState();
}

class _CheckpointL1ScreenState extends ConsumerState<CheckpointL1Screen> {
  final TextEditingController _currentCtrl = TextEditingController();
  String _metric = 'Клиенты';
  final TextEditingController _targetCtrl = TextEditingController();
  DateTime? _deadline;

  bool _showReview = false;
  bool _loadingReview = false;
  String? _assistantReply;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
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
      setState(() {
        _showReview = true;
        _loadingReview = true;
        _assistantReply = null;
      });
      // Загружаем короткий комментарий Макса (встроенно, без отдельного чата)
      final leo = LeoService(Supabase.instance.client);
      final messages = <Map<String, dynamic>>[
        {
          'role': 'system',
          'content':
              'Ты Макс — наставник по целям. Кратко оцени формулировку цели и предложи следующее действие.'
        },
        {
          'role': 'user',
          'content':
              'Итоговая цель: ${_buildGoalText(cur, tgt)}. Проверь формулировку и предложи следующий шаг.'
        }
      ];
      final resp = await leo.sendMessage(messages: messages, bot: 'max');
      final content = (resp['message'] is Map)
          ? (resp['message']['content']?.toString() ?? '')
          : (resp['content']?.toString() ?? '');
      if (!mounted) return;
      setState(() {
        _assistantReply = content.isEmpty
            ? 'Готово. Формулировка выглядит корректно.'
            : content;
        _loadingReview = false;
      });
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

  Widget _stepCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildReviewBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Проверка цели', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _chatBubble(
              user: true,
              text: _buildGoalText(
                double.tryParse(_currentCtrl.text.trim()),
                double.tryParse(_targetCtrl.text.trim()),
              )),
          const SizedBox(height: 8),
          if (_loadingReview)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(minHeight: 2),
            )
          else
            _chatBubble(
                user: false,
                text: _assistantReply ??
                    'Готово. Формулировка выглядит корректно.'),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton(
              onPressed: () {
                if (!mounted) return;
                // Обновим провайдер, чтобы экран «Цель» сразу подтянул сохранённые данные
                ref.invalidate(userGoalProvider);
                context.go('/goal');
              },
              child: const Text('Сохранить'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _showReview = false;
                  _assistantReply = null;
                });
              },
              child: const Text('Редактировать'),
            ),
          ])
        ],
      ),
    );
  }

  Widget _chatBubble({required bool user, required String text}) {
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: user ? const Color(0xFFE8F0FF) : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }
}
