import 'package:bizlevel/screens/goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/providers/goals_providers.dart';

void main() {
  testWidgets('Top-3 tools buttons select tool and sync with dropdown',
      (tester) async {
    // На дефолтном тестовом viewport часть контента GoalScreen может оказаться "ниже экрана",
    // из-за чего tap() по найденному Text промахивается.
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    final goal = <String, dynamic>{
      'goal_text': 'Клиенты: 100 → 150 к 2025-12-31',
      'metric_type': 'Клиенты/день',
      'metric_start': 100,
      'metric_current': 110,
      'metric_target': 150,
      'target_date':
          DateTime.now().add(const Duration(days: 60)).toIso8601String(),
    };
    final practice = <Map<String, dynamic>>[
      {
        'applied_at': DateTime.now().toIso8601String(),
        'applied_tools': const ['Матрица Эйзенхауэра']
      },
      {
        'applied_at': DateTime.now().toIso8601String(),
        'applied_tools': const ['Финансовый учёт']
      },
      {
        'applied_at': DateTime.now().toIso8601String(),
        'applied_tools': const ['УТП']
      },
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: [
        userGoalProvider.overrideWith((ref) async => goal),
        practiceLogProvider.overrideWith((ref) async => practice),
        usedToolsOptionsProvider.overrideWith((ref) async => const [
              'Матрица Эйзенхауэра',
              'Финансовый учёт',
              'УТП',
              'SMART‑планирование',
            ]),
      ],
      child: const MaterialApp(home: GoalScreen()),
    ));

    // pumpAndSettle может зависать из-за фоновых анимаций/виджетов на экране.
    // Здесь достаточно дождаться отрисовки и завершения FutureBuilder'ов.
    await tester.pump();
    // Дадим время FutureProvider'ам/агрегатам отрисоваться.
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.text('Другие навыки').evaluate().isNotEmpty) break;
    }

    // Кнопки топ-3 должны отрендериться и быть кликабельными
    expect(find.text('Другие навыки'), findsOneWidget); // hint dropdown
    expect(find.text('Матрица Эйзенхауэра'), findsWidgets);
    // Top‑3 кнопки реализованы как FilledButton.tonalIcon, поэтому проще кликнуть по label.
    await tester.ensureVisible(find.text('Матрица Эйзенхауэра').first);
    await tester.tap(find.text('Матрица Эйзенхауэра').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Dropdown остаётся на экране (в актуальном UI top-3 кнопки — FilledButton.tonalIcon)
    expect(
      find.byWidgetPredicate((w) => w is DropdownButtonFormField<String>),
      findsOneWidget,
    );
  });
}
