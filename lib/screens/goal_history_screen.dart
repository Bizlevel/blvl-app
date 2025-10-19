import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_providers.dart';

class GoalHistoryScreen extends ConsumerWidget {
  const GoalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int limit = 100;
    final itemsAsync = ref.watch(practiceLogWithLimitProvider(limit));
    return Scaffold(
      appBar: AppBar(title: const Text('История применений')),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Не удалось загрузить')),
        data: (items) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Text('Показать:'),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: limit,
                    items: const [50, 100, 200]
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text('$e')))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      // Простой навигационный перезапуск с другим лимитом
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const GoalHistoryScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, i) {
                  final m = items[i];
                  final tools = ((m['applied_tools'] as List?) ??
                      const <dynamic>[])
                    ..toList();
                  final note = (m['note'] ?? '').toString();
                  final ts = (m['applied_at'] ?? '').toString();
                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline,
                        color: Colors.blueGrey),
                    title: Text(tools.isEmpty ? 'Без метки' : tools.join(', ')),
                    subtitle: Text(note),
                    trailing: Text(ts.split('T').first),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
