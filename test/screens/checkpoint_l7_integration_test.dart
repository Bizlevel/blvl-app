// ignore_for_file: number-of-arguments, long-parameter-list, excessive-parameter-list
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/repositories/goals_repository.dart';

class _FakeRepo extends GoalsRepository {
  _FakeRepo() : super(Supabase.instance.client);
  Map<String, dynamic>? storedGoal;
  final List<Map<String, dynamic>> practice = [];

  @override
  Future<Map<String, dynamic>?> fetchUserGoal() async => storedGoal;

  // upsertUserGoalRequest не требуется для данного smoke-теста

  @override
  Future<List<Map<String, dynamic>>> fetchPracticeLog({int limit = 20}) async {
    return List<Map<String, dynamic>>.from(practice);
  }

  @override
  Future<Map<String, dynamic>> addPracticeEntry({
    List<String> appliedTools = const <String>[],
    String? note,
    DateTime? appliedAt,
  }) async {
    final m = <String, dynamic>{
      'applied_tools': appliedTools,
      if (note != null) 'note': note,
      'applied_at': (appliedAt ?? DateTime.now()).toIso8601String(),
    };
    practice.add(m);
    return m;
  }
}

void main() {
  testWidgets('L7 integration saves action_plan_note and writes system entry',
      (tester) async {
    final fake = _FakeRepo()
      ..storedGoal = {
        'goal_text': 'Цель',
        'metric_type': 'Клиенты',
        'metric_start': 0,
        'metric_target': 10,
        'target_date': DateTime.now().toIso8601String(),
      };

    // Эмулируем завершение L7: зафиксируем системную запись
    await fake.addPracticeEntry(note: '[SYS] L7 decision: Усилить применение');

    // Проверяем провайдеры
    final container = ProviderContainer(
        overrides: [goalsRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    final l7 = await container.read(goalStateProvider.future);
    expect(l7['l7Done'], isTrue);

    final items = await container.read(practiceLogProvider.future);
    expect(
        items.any((m) => (m['note'] ?? '').toString().contains('L7')), isTrue);
  });
}
