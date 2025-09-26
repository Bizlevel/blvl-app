import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/screens/goal_screen.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GoalScreen renders steps guide and week header; no Save button',
      (tester) async {
    // Подготавливаем данные версий: только v1
    final v1 = {
      'id': 'uuid-1',
      'version': 1,
      'goal_text': 'Стартовая цель',
      'version_data': {
        'goal_initial': 'Запустить MVP',
        'goal_why': 'Проверить гипотезы',
        'main_obstacle': 'Нехватка времени',
      },
      'updated_at': DateTime.now().toIso8601String(),
    };

    await tester.pumpWidget(ProviderScope(
      overrides: [
        // Версии цели — одна запись v1
        goalVersionsProvider.overrideWith((ref) async => [v1]),
        // Цитата — отключаем сеть
        dailyQuoteProvider.overrideWith((ref) async => null),
        // Профиль — не нужен для теста, возвращаем null
        currentUserProvider.overrideWith((ref) async => null),
      ],
      child: const MaterialApp(home: GoalScreen()),
    ));

    await tester.pumpAndSettle();

    // Есть секция «Кристаллизация цели» и компактный гид по шагам (v1..v4..Недели)
    expect(find.text('Кристаллизация цели'), findsOneWidget);
    expect(find.text('v1'), findsWidgets);
    expect(find.text('v2'), findsWidgets);
    expect(find.text('v3'), findsWidgets);
    expect(find.text('v4'), findsWidgets);
    expect(find.text('Недели'), findsWidgets);
    // Новые секции этапа 38.3 присутствуют (хотя бы прогресс-бар из компактной карточки)
    expect(find.byType(LinearProgressIndicator), findsWidgets);
    // Хедер недели
    expect(find.textContaining('Неделя'), findsWidgets);
    // Табличные лейблы из v1 видны
    expect(find.text('Основная цель'), findsOneWidget);
    expect(find.text('Почему сейчас'), findsOneWidget);
    expect(find.text('Препятствие'), findsOneWidget);
    // Кнопки сохранения/редактирования отсутствуют
    expect(find.text('Сохранить'), findsNothing);
  });
}
