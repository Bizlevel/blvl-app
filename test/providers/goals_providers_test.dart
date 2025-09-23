import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/levels_provider.dart';

void main() {
  test('metricLabelProvider returns metric_type with fallback to metric_name',
      () async {
    final container = ProviderContainer(overrides: [
      goalVersionsProvider.overrideWith((ref) async => [
            {
              'version': 2,
              'version_data': {'metric_type': 'Выручка (тенге)'}
            }
          ]),
    ]);
    addTearDown(container.dispose);
    final label = await container.read(metricLabelProvider.future);
    expect(label, 'Выручка (тенге)');
  });

  test('usedToolsOptionsProvider returns level titles or defaults', () async {
    final container = ProviderContainer(overrides: [
      levelsProvider.overrideWith((ref) async => [
            {'title': 'Эйзенхауэр'},
            {'title': 'Финансы'},
          ]),
    ]);
    addTearDown(container.dispose);
    final tools = await container.read(usedToolsOptionsProvider.future);
    expect(tools.isNotEmpty, true);
  });
}
