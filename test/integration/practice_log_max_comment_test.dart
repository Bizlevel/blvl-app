import 'package:bizlevel/screens/goal_screen.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/repositories/goals_repository.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeGoalsRepo extends GoalsRepository {
  _FakeGoalsRepo() : super(Supabase.instance.client);

  @override
  Future<void> logPracticeAndUpdateMetricTx({
    List<String> appliedTools = const <String>[],
    String? note,
    DateTime? appliedAt,
    num? metricCurrent,
  }) async {
    // Успешный no-op: нам важно пройти happy-path UI (показать snackbar + открыть чат).
  }
}

class _FakeLeoService extends LeoService {
  _FakeLeoService() : super(Supabase.instance.client);

  @override
  Future<String> saveConversation({
    required String role,
    required String content,
    String? chatId,
    String bot = 'leo',
  }) async {
    return chatId ?? 'fake-chat-id';
  }

  @override
  Future<Map<String, dynamic>> sendMessageWithRAG({
    required List<Map<String, dynamic>> messages,
    required String userContext,
    required String levelContext,
    String bot = 'leo',
    String? chatId,
    bool skipSpend = false,
    bool caseMode = false,
  }) async {
    return <String, dynamic>{
      'message': <String, dynamic>{
        'content': 'Ок, принято.',
      },
      'recommended_chips': const <String>[],
    };
  }

  @override
  Future<List<String>> fetchRecommendedChips({
    required String bot,
    String? chatId,
    String? userContext,
    String? levelContext,
  }) async {
    return const <String>[];
  }
}

void main() {
  testWidgets('Saving practice entry opens Max chat (smoke)', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        goalsRepositoryProvider.overrideWithValue(_FakeGoalsRepo()),
        leoServiceProvider.overrideWithValue(_FakeLeoService()),
        dailyQuoteProvider.overrideWith((ref) async => null),
        userGoalProvider.overrideWith((ref) async => {
              'goal_text': 'Цель',
              'metric_type': 'Клиенты/день',
              'metric_start': 0,
              'metric_current': 0,
              'metric_target': 10,
              'target_date': DateTime.now()
                  .add(const Duration(days: 30))
                  .toIso8601String(),
            }),
        practiceLogProvider
            .overrideWith((ref) async => const <Map<String, dynamic>>[]),
        usedToolsOptionsProvider
            .overrideWith((ref) async => const <String>['Матрица Эйзенхауэра'])
      ],
      child: const MaterialApp(home: GoalScreen()),
    ));

    await tester.pumpAndSettle();

    // Введём заметку и сохраним
    await tester.enterText(find.byType(TextField).last, 'Тестовая запись');
    final saveBtn = find.text('Сохранить запись');
    await tester.ensureVisible(saveBtn);
    await tester.pump();
    await tester.tap(saveBtn);
    // В UI перед открытием чата есть delay 800ms
    await tester.pump(const Duration(milliseconds: 900));
    // В LeoDialogScreen есть анимации (индикаторы/скролл), поэтому pumpAndSettle может не "успокоиться".
    await tester.pump();

    // Должен открыться экран с чатом
    expect(find.byType(LeoDialogScreen), findsOneWidget);
  });
}
