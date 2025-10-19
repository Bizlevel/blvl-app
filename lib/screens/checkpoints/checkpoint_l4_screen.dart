import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// sentry import не требуется здесь
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:go_router/go_router.dart';

class CheckpointL4Screen extends ConsumerStatefulWidget {
  const CheckpointL4Screen({super.key});

  @override
  ConsumerState<CheckpointL4Screen> createState() => _CheckpointL4ScreenState();
}

class _CheckpointL4ScreenState extends ConsumerState<CheckpointL4Screen> {
  String _finMetric = 'Общая выручка';
  final TextEditingController _avgCheckCtrl =
      TextEditingController(text: '2000');

  @override
  void dispose() {
    _avgCheckCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goalAsync = ref.watch(userGoalProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Чекпоинт: Финансовый фокус')),
      body: goalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Не удалось загрузить цель')),
        data: (goal) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Текущая цель',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text((goal?['goal_text'] ?? '').toString()),
                const SizedBox(height: 16),
                const Text('Добавить финансовую метрику?'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _finMetric,
                  items: const [
                    DropdownMenuItem(
                        value: 'Общая выручка', child: Text('Общая выручка')),
                    DropdownMenuItem(
                        value: 'Средний чек', child: Text('Средний чек')),
                    DropdownMenuItem(value: 'Маржа', child: Text('Маржа')),
                  ],
                  onChanged: (v) =>
                      setState(() => _finMetric = v ?? _finMetric),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Зачем финансовая метрика?\nОна позволяет видеть денежный эффект от ваших действий.\nПример: Выручка = Клиенты × Средний чек.',
                  ),
                ),
                const SizedBox(height: 16),
                // Кнопки действий (сохранены)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await ref.read(goalsRepositoryProvider).upsertUserGoal(
                              goalText: (goal?['goal_text'] ?? '').toString(),
                              financialFocus: _finMetric,
                            );
                        ref.invalidate(userGoalProvider);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Фин. метрика добавлена')));
                        GoRouter.of(context).push('/goal');
                      } catch (_) {}
                    },
                    child: const Text('Добавить метрику'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Можно вернуться к финансовой метрике позже')));
                      GoRouter.of(context).push('/goal');
                    },
                    child: const Text('Оставить как есть'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // удалены неиспользуемые вспомогательные виджеты/парсеры
}
