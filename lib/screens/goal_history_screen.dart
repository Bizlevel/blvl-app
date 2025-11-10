import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/theme/color.dart';

class GoalHistoryScreen extends ConsumerWidget {
  const GoalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(practiceLogByCurrentHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('История применений')),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Не удалось загрузить')),
        data: (items) => Column(
          children: [
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
                        color: AppColor.success),
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
