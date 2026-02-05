import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bizlevel/screens/goal/widgets/motivation_card.dart';
import 'package:bizlevel/screens/goal/widgets/practice_journal_section.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/animations.dart';
import 'package:bizlevel/screens/goal/widgets/goal_compact_card.dart';

class GoalScreen extends ConsumerStatefulWidget {
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends ConsumerState<GoalScreen> {
  // New unified goal controllers (user_goal)
  final GlobalKey _goalSectionKey = GlobalKey();
  final GlobalKey _journalSectionKey = GlobalKey();
  bool _forceEditGoal = false;

  void _scrollToJournal() {
    final ctx = _journalSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: AppAnimations.normal);
    }
  }

  // unit resolver moved to GoalCompactCard

  // moved to GoalCompactCard internal state
  // Перенесено в PracticeJournalSection
  // editing state moved to GoalCompactCard
  // Удалены legacy контроллеры версий v1–v4

  // Удалено поле _debounce (не используется)
  // ignore: unused_field
  final bool _saving = false;
  // Упрощённый экран

  @override
  Widget build(BuildContext context) {
    // Перемещено в MotivationCard

    // New simplified Goal Screen flow — single goal + practice log
    // final userGoalAsync = ref.watch(userGoalProvider);
    // Перенесено в PracticeJournalSection

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Назад к Главной',
          onPressed: () {
            try {
              // Возврат на Главный экран
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go('/home');
              }
            } catch (_) {}
          },
        ),
        title: const Text('Цель'),
      ),
      // Нижние CTA удалены по новой спецификации
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: AppSpacing.insetsAll(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Автопрокрутка к нужной секции по query param.
                Builder(builder: (context) {
                  try {
                    final loc = GoRouter.of(context)
                        .routeInformationProvider
                        .value
                        .uri
                        .toString();
                    final uri = Uri.parse(loc);
                    final scrollTarget = uri.queryParameters['scroll'];
                    final bool forceEdit =
                        uri.queryParameters['edit'] == '1';
                    _forceEditGoal = forceEdit;
                    if (scrollTarget == 'journal') {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToJournal();
                      });
                    } else if (scrollTarget == 'goal') {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final ctx = _goalSectionKey.currentContext;
                        if (ctx != null) {
                          Scrollable.ensureVisible(ctx,
                              duration: AppAnimations.normal);
                        }
                      });
                    }
                  } catch (_) {}
                  return const SizedBox.shrink();
                }),
                const MotivationCard(),
                AppSpacing.gapH(AppSpacing.lg),
                // Онбординг: вынесен в пустое состояние карточки цели
                // Что дальше? (баннер) — удалён по новой спецификации
                AppSpacing.gapH(AppSpacing.lg),

                // Моя цель (редактируемая)
                Container(
                  key: _goalSectionKey,
                  child: GoalCompactCard(forceEdit: _forceEditGoal),
                ),

                const SizedBox(height: AppSpacing.s20),

                // Журнал применений
                Container(
                    key: _journalSectionKey,
                    child: const PracticeJournalSection()),
              ],
            ),
          ),
        ),
      ),
    );

    // Конец экрана
  }

  // 🗑️ Метод _buildTrackerUserContext удалён - используется метод из GoalScreenController
  // Единственный источник истины для построения контекста

  // Удалены: _getVersionStatus/_getVersionTooltip не используются после упрощения UI переключателя

  // _build7DayTimeline/_buildDayDot удалены — в новой версии не используются

  /* Future<void> _loadSprintIfAny(int sprintNumber) async {
    final existing = await ref.read(weekProvider(sprintNumber).future);
    if (existing == null) {
      _achievementCtrl.text = '';
      _metricActualCtrl.text = '';
      _keyInsightCtrl.text = '';
      _usedArtifacts = false;
      _consultedLeo = false;
      _appliedTechniques = false;
      _artifactsDetailsCtrl.text = '';
      _consultedBenefitCtrl.text = '';
      _techniquesDetailsCtrl.text = '';
      if (mounted) setState(() {});
      return;
    }
    _achievementCtrl.text = (existing['achievement'] ?? '') as String;
    _metricActualCtrl.text = (existing['metric_actual'] ?? '') as String;
    _keyInsightCtrl.text = (existing['key_insight'] ?? '') as String;
    _usedArtifacts = (existing['used_artifacts'] ?? false) as bool;
    _consultedLeo = (existing['consulted_leo'] ?? false) as bool;
    _appliedTechniques = (existing['applied_techniques'] ?? false) as bool;
    _artifactsDetailsCtrl.text =
        (existing['artifacts_details'] ?? '') as String;
    _consultedBenefitCtrl.text =
        (existing['consulted_benefit'] ?? '') as String;
    _techniquesDetailsCtrl.text =
        (existing['techniques_details'] ?? '') as String;
    if (mounted) setState(() {});
  } */

  /* Future<void> _onSaveSprint() async {
    try {
      final repo = ref.read(goalsRepositoryProvider);
      // Валидации 43.30: длина week_result ≤100, metric_value число (если указано)
      if (_achievementCtrl.text.trim().length > 100) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Главное за неделю: максимум 100 символов')),
        );
        return;
      }
      if (_metricActualCtrl.text.trim().isNotEmpty &&
          double.tryParse(_metricActualCtrl.text.trim()) == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Метрика: введите число')),
        );
        return;
      }
      // Собираем чекбоксы в текст деталей техник (минимальная интеграция без DDL)
      final List<String> checks = [];
      if (_chkEisenhower) checks.add('Матрица Эйзенхауэра');
      if (_chkAccounting) checks.add('Финансовый учёт');
      if (_chkUSP) checks.add('УТП');
      if (_chkSMART) checks.add('SMART‑планирование');
      if (_techOtherCtrl.text.trim().isNotEmpty) {
        checks.add('Другое: ${_techOtherCtrl.text.trim()}');
      }
      final String techniquesSummary = checks.join(', ');

      // weekly API удалён
      if (!mounted) return;
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'goal',
        type: 'info',
        message: 'weekly_checkin_saved',
        data: {
          'week': _selectedSprint,
          'has_metric': _metricActualCtrl.text.trim().isNotEmpty,
        },
        level: SentryLevel.info,
      ));
      setState(() => _sprintSaved = true);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Итоги спринта сохранены')));
      /* if (kEnableClientWeeklyReaction) {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'goal',
          type: 'info',
          message: 'weekly_reaction_requested_client',
          data: {'week': _selectedSprint},
          level: SentryLevel.info,
        ));
        _openChatWithMax();
      }*/
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(FriendlyMessages.saveError)));
    }
  } */

  // Helpers for 38.14/38.15

  /* void _scrollToSprintSection() {
    final ctx = _sprintSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: AppAnimations.normal);
    }
  } */

  /* void _openChatWithMax({String? autoMessage, List<String>? chips}) {
    // Открываем полноэкранный чат с Максом
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ref.read(currentUserProvider).when(
              data: (user) => LeoDialogScreen(
                chatId: null,
                userContext: ref
                        .read(goalScreenControllerProvider.notifier)
                        .buildTrackerUserContext(
                          achievement: _achievementCtrl.text.trim(),
                          metricActual: _metricActualCtrl.text.trim(),
                          usedArtifacts: _usedArtifacts,
                          consultedLeo: _consultedLeo,
                          appliedTechniques: _appliedTechniques,
                          keyInsight: _keyInsightCtrl.text.trim(),
                        ) +
                    _buildDailyChatContextTail(),
                levelContext: () {
                  final n = ref.read(currentLevelNumberProvider).asData?.value;
                  return 'level_number: ${n ?? (user?.currentLevel ?? 0)}';
                }(),
                bot: 'max',
                // После сохранения чек‑ина отправляем тонкую реакцию Макса
                autoUserMessage: autoMessage ??
                    (_sprintSaved
                        ? 'weekly_checkin: Неделя $_selectedSprint; Итог: ${_achievementCtrl.text.trim()}; Метрика: ${_metricActualCtrl.text.trim()}'
                        : null),
                skipSpend: _sprintSaved || autoMessage != null,
                recommendedChips: chips ??
                    (false
                        ? _dailyRecommendedChips()
                        : (_sprintSaved ? _weeklyRecommendedChips() : null)),
              ),
              loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator())),
              error: (_, __) => const Scaffold(
                  body: Center(child: Text('Ошибка загрузки профиля'))),
            ),
      ),
    );
  } */

  // 🗑️ Метод _normalizeVersionsForProgress удалён - ProgressWidget больше не используется

  // List<String> _weeklyRecommendedChips() { return []; }

  // ---------- Daily mode helpers ----------

  // bool _dailyModeActive() => false;

  // ({int day, int week, String task}) _currentDayWeekTask() => (day: 1, week: 1, task: '');

  // String _buildDailyChatContextTail() { return ''; }

  // List<String> _dailyRecommendedChips() { return const []; }

  // Авто‑реакции/бонусы удалены
}
