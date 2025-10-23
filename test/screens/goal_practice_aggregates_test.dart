import 'package:bizlevel/providers/goals_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('Агрегаты журнала: daysApplied/topTools считаются корректно', () async {
    final container = ProviderContainer(overrides: [
      practiceLogProvider.overrideWith((ref) async => [
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
          ]),
    ]);
    addTearDown(container.dispose);

    final agg = await container.read(practiceLogAggregatesProvider.future);
    expect(agg['daysApplied'], 2);
    expect(agg['totalApplied'], 3);
    final List top = agg['topTools'] as List;
    expect(top.first['label'], 'A');
    expect(top.first['count'], 2);
  });
}
