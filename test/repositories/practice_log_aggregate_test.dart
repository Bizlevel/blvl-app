import 'package:bizlevel/repositories/goals_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _DummyClient extends SupabaseClient {
  _DummyClient() : super('http://localhost', 'key');
}

void main() {
  test('aggregatePracticeLog computes daysApplied and topTools', () {
    final repo = GoalsRepository(_DummyClient());
    final items = <Map<String, dynamic>>[
      {
        'applied_at': '2025-10-01T10:00:00Z',
        'applied_tools': <String>['A', 'B'],
      },
      {
        'applied_at': '2025-10-01T18:00:00Z',
        'applied_tools': <String>['A'],
      },
      {
        'applied_at': '2025-10-02T09:00:00Z',
        'applied_tools': <String>['C'],
      },
    ];
    final agg = repo.aggregatePracticeLog(items);
    expect(agg['daysApplied'], 2);
    expect(agg['totalApplied'], 3);
    final List topTools = agg['topTools'] as List;
    expect(topTools.first['label'], 'A');
    expect(topTools.first['count'], 2);
  });

  test('computeRecentPace and computeRequiredPace basic math', () {
    final repo = GoalsRepository(_DummyClient());
    final now = DateTime(2025, 10, 16);
    final items = <Map<String, dynamic>>[
      {'applied_at': now.subtract(const Duration(days: 1)).toIso8601String()},
      {'applied_at': now.subtract(const Duration(days: 2)).toIso8601String()},
      {'applied_at': now.subtract(const Duration(days: 15)).toIso8601String()},
    ];
    final z = repo.computeRecentPace(items, windowDays: 14, now: now);
    expect(z, closeTo(2 / 14, 1e-9));

    final goal = <String, dynamic>{
      'metric_current': 10,
      'metric_target': 24,
      'target_date': DateTime(2025, 10, 30).toIso8601String(),
    };
    final w = repo.computeRequiredPace(goal, now: now);
    // remain=14, daysLeft=14 → 1.0
    expect(w, closeTo(1.0, 1e-9));
  });
}
