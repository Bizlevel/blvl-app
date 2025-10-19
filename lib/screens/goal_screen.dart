// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/screens/goal/widgets/motivation_card.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/utils/constant.dart';
// import 'package:bizlevel/widgets/floating_chat_bubble.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
// import 'package:bizlevel/screens/goal/widgets/goal_compact_card.dart';
// import 'package:bizlevel/screens/goal/widgets/crystallization_section.dart';
// import 'package:bizlevel/screens/goal/widgets/progress_widget.dart'; // 🗑️ Удалён - виджет больше не используется
// import 'package:bizlevel/screens/goal/widgets/sprint_section.dart';
// import 'package:bizlevel/screens/goal/widgets/daily_card.dart'; // 🗑️ Перенесён в DailySprint28Widget
// import 'package:bizlevel/screens/goal/widgets/daily_calendar.dart'; // 🗑️ Перенесён в DailySprint28Widget
import 'package:bizlevel/screens/goal/widgets/next_action_banner.dart';
// import 'package:bizlevel/screens/goal/widgets/version_navigation_chips.dart';
// import 'package:bizlevel/screens/goal/widgets/daily_sprint_28_widget.dart';
// import 'package:bizlevel/screens/goal/controller/goal_screen_controller.dart';
// import 'package:bizlevel/utils/constant.dart';
// import 'package:bizlevel/services/notifications_service.dart';
// import 'package:bizlevel/utils/friendly_messages.dart';
// import 'package:bizlevel/providers/gp_providers.dart'; // streak claim removed; keep provider unused
import 'package:bizlevel/theme/color.dart';

class GoalScreen extends ConsumerStatefulWidget {
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends ConsumerState<GoalScreen> {
  // New unified goal controllers (user_goal)
  final GlobalKey _journalSectionKey = GlobalKey();

  void _scrollToJournal() {
    final ctx = _journalSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 300));
    }
  }

  String _unitForMetricType(String? metricType) {
    final s = (metricType ?? '').toLowerCase();
    if (s.contains('день') || s.contains('/день')) return '/день';
    if (s.contains('нед')) return '/нед.';
    if (s.contains('выруч') || s.contains('₸') || s.contains('тен')) return '₸';
    if (s.contains('клиент')) return 'ед.';
    return '';
  }

  final TextEditingController _ugGoalCtrl = TextEditingController();
  final TextEditingController _ugMetricTypeCtrl = TextEditingController();
  final TextEditingController _ugMetricCurrentCtrl = TextEditingController();
  final TextEditingController _ugMetricTargetCtrl = TextEditingController();
  // readiness удалено из концепции
  final TextEditingController _ugTargetDateCtrl = TextEditingController();
  DateTime? _selectedTargetDate;
  final TextEditingController _practiceNoteCtrl = TextEditingController();
  final Set<String> _selectedTools = <String>{};
  bool _isEditing = false;
  // v1 controllers
  final TextEditingController _goalInitialCtrl = TextEditingController();
  final TextEditingController _goalWhyCtrl = TextEditingController();
  final TextEditingController _mainObstacleCtrl = TextEditingController();

  // v2 controllers
  final TextEditingController _goalRefinedCtrl = TextEditingController();
  final TextEditingController _metricNameCtrl = TextEditingController();
  final TextEditingController _metricFromCtrl = TextEditingController();
  final TextEditingController _metricToCtrl = TextEditingController();
  final TextEditingController _financialGoalCtrl = TextEditingController();

  // v3 controllers
  final TextEditingController _goalSmartCtrl = TextEditingController();
  final TextEditingController _s1Ctrl = TextEditingController();
  final TextEditingController _s2Ctrl = TextEditingController();
  final TextEditingController _s3Ctrl = TextEditingController();
  final TextEditingController _s4Ctrl = TextEditingController();

  // v4 controllers
  final TextEditingController _finalWhatCtrl = TextEditingController();
  final TextEditingController _finalWhenCtrl = TextEditingController();
  final TextEditingController _finalHowCtrl = TextEditingController();
  bool _commitment = false;

  // Удалено поле _debounce (не используется)
  // ignore: unused_field
  final bool _saving = false;
  // int _selectedSprint = 1;
  // bool _sprintSaved = false;
  // final GlobalKey _sprintSectionKey = GlobalKey();
  // bool _goalCardExpanded = false;
  // Check-in techniques (визуальные чекбоксы вместо текстовых полей)
  // Техники недели (для чек-ина): используем чекбоксы ниже формы
  // Чекбоксы техник удалены — используем текстовое поле ниже по форме чек‑ина
  // final TextEditingController _techOtherCtrl = TextEditingController();

  // Sprint check-in form
  // final TextEditingController _achievementCtrl = TextEditingController();
  // final TextEditingController _metricActualCtrl = TextEditingController();
  // bool _usedArtifacts = false;
  // bool _consultedLeo = false;
  // bool _appliedTechniques = false;
  // final TextEditingController _keyInsightCtrl = TextEditingController();
  // Краткие данные по неделям удалены — аккордеон получает summary из провайдера
  // details for weekly progress
  // final TextEditingController _artifactsDetailsCtrl = TextEditingController();
  // final TextEditingController _consultedBenefitCtrl = TextEditingController();
  // final TextEditingController _techniquesDetailsCtrl = TextEditingController();

  // Checkboxes for weekly checks
  // bool _chkEisenhower = false;
  // bool _chkAccounting = false;
  // bool _chkUSP = false;
  // bool _chkSMART = false;

  // Авто‑реакции/бонусы: в рамках сессии защищаемся от повторных триггеров
  // static final Set<String> _autoReactionsFired = <String>{};
  // static final Set<int> _bonusesClaimedInSession = <int>{}; // no direct client-claim

  // Упрощённый экран: initState и логика версий/спринтов удалены

  // Автосохранение отключено по требованию: слушателей не добавляем

  // ignore: unused_element
  bool _isValidV1() {
    String s(String v) => v.trim();
    return s(_goalInitialCtrl.text).length >= 10 &&
        s(_goalWhyCtrl.text).length >= 10 &&
        s(_mainObstacleCtrl.text).length >= 10;
  }

  // ignore: unused_element
  bool _isValidV2() {
    String s(String v) => v.trim();
    return s(_goalRefinedCtrl.text).length >= 10 &&
        s(_metricNameCtrl.text).isNotEmpty &&
        double.tryParse(_metricFromCtrl.text.trim()) != null &&
        double.tryParse(_metricToCtrl.text.trim()) != null &&
        double.tryParse(_financialGoalCtrl.text.trim()) != null;
  }

  // ignore: unused_element
  bool _isValidV3() {
    String s(String v) => v.trim();
    return s(_goalSmartCtrl.text).length >= 10 &&
        s(_s1Ctrl.text).length >= 5 &&
        s(_s2Ctrl.text).length >= 5 &&
        s(_s3Ctrl.text).length >= 5 &&
        s(_s4Ctrl.text).length >= 5;
  }

  // ignore: unused_element
  bool _isValidV4() {
    String s(String v) => v.trim();
    return s(_finalWhatCtrl.text).length >= 10 &&
        s(_finalWhenCtrl.text).isNotEmpty &&
        s(_finalHowCtrl.text).length >= 10 &&
        _commitment;
  }

  // Сохранение версий отключено на странице «Цель». Редактирование доступно только в чекпоинтах.

  // Удалены контроллеры/заполнение для версий цели (v1–v4)

  // _miniMetric удалён — не используется в новой версии прогресс‑виджета

  // _buildCurrentWeekSummary удалён — блок «Текущая неделя» исключён

  @override
  Widget build(BuildContext context) {
    // Перемещено в MotivationCard

    // New simplified Goal Screen flow — single goal + practice log
    final userGoalAsync = ref.watch(userGoalProvider);
    final practiceAsync = ref.watch(practiceLogProvider);
    final toolsAsync = ref.watch(usedToolsOptionsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Цель'),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, cons) {
          // Простая эвристика мобайла: ширина < 600
          if (cons.maxWidth >= 600 || !kGoalStickyCta)
            return const SizedBox.shrink();
          return SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _scrollToJournal,
                      child: const Text('Добавить запись'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        try {
                          Sentry.addBreadcrumb(Breadcrumb(
                              category: 'goal',
                              message: 'chat_opened_from_goal',
                              level: SentryLevel.info));
                        } catch (_) {}
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => LeoDialogScreen(
                            bot: 'max',
                            chatId: null,
                            userContext: [
                              'goal_text: ${_ugGoalCtrl.text.trim()}',
                              if (_ugMetricTypeCtrl.text.trim().isNotEmpty)
                                'metric_type: ${_ugMetricTypeCtrl.text.trim()}',
                              if (_ugMetricCurrentCtrl.text.trim().isNotEmpty)
                                'metric_current: ${_ugMetricCurrentCtrl.text.trim()}',
                              if (_ugMetricTargetCtrl.text.trim().isNotEmpty)
                                'metric_target: ${_ugMetricTargetCtrl.text.trim()}',
                            ].join('\n'),
                            levelContext: '',
                          ),
                        ));
                      },
                      child: const Text('Обсудить с Максом'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MotivationCard(),
                const SizedBox(height: 16),
                // Что дальше? (баннер)
                Consumer(builder: (context, ref, _) {
                  final levelNumAsync = ref.watch(currentLevelNumberProvider);
                  return levelNumAsync.when(
                    data: (n) => NextActionBanner(
                      currentLevel: n,
                      onScrollToSprint: () {
                        final ctx = _journalSectionKey.currentContext;
                        if (ctx != null) {
                          Scrollable.ensureVisible(ctx,
                              duration: const Duration(milliseconds: 300));
                        }
                      },
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                }),
                const SizedBox(height: 16),

                // Моя цель (редактируемая)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.shadowColor.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: userGoalAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text('Не удалось загрузить цель'),
                    data: (goal) {
                      // Prefill controllers once per build (lightweight)
                      if (goal != null) {
                        _ugGoalCtrl.text = (goal['goal_text'] ?? '').toString();
                        _ugMetricTypeCtrl.text =
                            (goal['metric_type'] ?? '').toString();
                        _ugMetricCurrentCtrl.text =
                            (goal['metric_current'] ?? '').toString();
                        _ugMetricTargetCtrl.text =
                            (goal['metric_target'] ?? '').toString();
                        // readiness_score больше не используется
                        final String td =
                            (goal['target_date'] ?? '').toString();
                        try {
                          final dt = DateTime.tryParse(td)?.toLocal();
                          _selectedTargetDate = dt;
                          _ugTargetDateCtrl.text = dt == null
                              ? ''
                              : dt.toIso8601String().split('T').first;
                        } catch (_) {
                          _selectedTargetDate = null;
                          _ugTargetDateCtrl.text = '';
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Моя цель',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          // Статус‑чипы L1/L4/L7 + финфокус
                          Consumer(builder: (context, ref, _) {
                            final st =
                                ref.watch(goalStateProvider).asData?.value ??
                                    const <String, dynamic>{};
                            final bool l1 = st['l1Done'] == true;
                            final bool l4 = st['l4Done'] == true;
                            final bool l7 = st['l7Done'] == true;
                            final String fin = (goal?['financial_focus'] ?? '')
                                .toString()
                                .trim();
                            final chips = <Widget>[
                              Chip(
                                  label: Text(l1
                                      ? 'L1: сформулирована'
                                      : 'L1: не задана')),
                              const SizedBox(width: 6),
                              Chip(
                                  label: Text(l4
                                      ? 'L4: финфокус'
                                      : 'L4: без финфокуса')),
                              const SizedBox(width: 6),
                              Chip(
                                  label: Text(l7
                                      ? 'L7: проверена'
                                      : 'L7: без проверки')),
                            ];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                    spacing: 6, runSpacing: 6, children: chips),
                                if (fin.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text('Финфокус: ' + fin,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ]
                              ],
                            );
                          }),
                          const SizedBox(height: 8),
                          if (goal == null ||
                              (goal['goal_text'] ?? '').toString().isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.flag_outlined,
                                      color: Colors.black54),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                          'Пока цель не задана. Начните с простого описания и метрики.')),
                                  TextButton(
                                    onPressed: () {
                                      try {
                                        GoRouter.of(context)
                                            .push('/tower?scrollTo=1');
                                      } catch (_) {}
                                    },
                                    child: const Text('Перейти к обучению'),
                                  ),
                                ],
                              ),
                            ),
                          TextField(
                            controller: _ugGoalCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Короткое описание цели'),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _ugMetricTypeCtrl,
                            readOnly: true,
                            decoration: const InputDecoration(
                                labelText:
                                    'Метрика (например, Клиенты/Выручка)'),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                try {
                                  GoRouter.of(context).push('/checkpoint/l4');
                                } catch (_) {}
                              },
                              child: const Text('Изменить метрику'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            Expanded(
                              child: TextField(
                                controller: _ugTargetDateCtrl,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText:
                                      'Дедлайн (YYYY-MM-DD) — необязательно',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      final now = DateTime.now();
                                      final initial =
                                          _selectedTargetDate ?? now;
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: initial,
                                        firstDate: now
                                            .subtract(const Duration(days: 0)),
                                        lastDate: now
                                            .add(const Duration(days: 365 * 3)),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          _selectedTargetDate = picked;
                                          _ugTargetDateCtrl.text = picked
                                              .toLocal()
                                              .toIso8601String()
                                              .split('T')
                                              .first;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          // Прогресс‑бар и дедлайн + три метрики (start/current/target)
                          Builder(builder: (context) {
                            final num? start = num.tryParse(
                                (goal?['metric_start'] ?? '').toString());
                            final num? cur =
                                num.tryParse(_ugMetricCurrentCtrl.text.trim());
                            final num? tgt =
                                num.tryParse(_ugMetricTargetCtrl.text.trim());
                            final String td =
                                (goal?['target_date'] ?? '').toString();
                            DateTime? target;
                            try {
                              target = DateTime.tryParse(td)?.toLocal();
                            } catch (_) {}
                            double perc = 0;
                            if (start != null && tgt != null && tgt != start) {
                              final double nume =
                                  (cur == null ? 0 : (cur - start).toDouble());
                              final double deno = (tgt - start).toDouble();
                              perc = (nume / deno).clamp(0, 1);
                            }
                            String left = '';
                            if (target != null) {
                              final int d =
                                  target.difference(DateTime.now()).inDays;
                              if (d > 0) {
                                // Лёгкая локализация без intl
                                final String form =
                                    (d % 10 == 1 && d % 100 != 11)
                                        ? 'день'
                                        : ((d % 10 >= 2 &&
                                                d % 10 <= 4 &&
                                                (d % 100 < 10 || d % 100 >= 20))
                                            ? 'дня'
                                            : 'дней');
                                left = '$d $form';
                              }
                            }
                            if (perc == 0 && left.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: SizedBox(
                                    height: 12,
                                    child: LinearProgressIndicator(
                                      value: perc,
                                      backgroundColor: Colors.blueGrey
                                          .withValues(alpha: 0.15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      left.isEmpty
                                          ? 'Прогресс: ${(perc * 100).toStringAsFixed(0)}%'
                                          : 'Прогресс: ${(perc * 100).toStringAsFixed(0)}%  •  Осталось: $left',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (perc >= 0.5 && perc < 1.0)
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          await Supabase.instance.client.rpc(
                                              'gp_claim_goal_progress',
                                              params: {
                                                'p_key': 'goal_progress_50'
                                              });
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Бонус за 50% прогресса начислен')),
                                          );
                                        } catch (_) {}
                                      },
                                      child: const Text('+GP за 50%'),
                                    ),
                                  if (perc >= 1.0)
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          await Supabase.instance.client.rpc(
                                              'gp_claim_goal_progress',
                                              params: {
                                                'p_key': 'goal_progress_100'
                                              });
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Бонус за 100% прогресса начислен')),
                                          );
                                        } catch (_) {}
                                      },
                                      child: const Text('+GP за 100%'),
                                    ),
                                ]),
                                const SizedBox(height: 6),
                                // Z/W строка и подсказка
                                Builder(builder: (context) {
                                  // Пытаемся вычислить Z по последним записям и W по цели
                                  // Берём practice из асинхронного провайдера выше
                                  final practiceAsync =
                                      ref.watch(practiceLogProvider);
                                  final List<Map<String, dynamic>> practice =
                                      practiceAsync.maybeWhen(
                                    data: (items) => items,
                                    orElse: () =>
                                        const <Map<String, dynamic>>[],
                                  );
                                  final repo =
                                      ref.read(goalsRepositoryProvider);
                                  final double z =
                                      repo.computeRecentPace(practice);
                                  final double w =
                                      repo.computeRequiredPace(goal);
                                  if (!kShowZWOnGoal)
                                    return const SizedBox.shrink();
                                  return InkWell(
                                    onTap: () {
                                      try {
                                        Sentry.addBreadcrumb(Breadcrumb(
                                            category: 'goal',
                                            message: 'zw_info_opened',
                                            level: SentryLevel.info));
                                      } catch (_) {}
                                      showModalBottomSheet(
                                        context: context,
                                        showDragHandle: true,
                                        builder: (_) => Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text('Что такое Z и W',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              SizedBox(height: 8),
                                              Text(
                                                  'Z — ваш средний темп применений за 14 дней.\nW — необходимый темп, чтобы прийти к цели к дедлайну.'),
                                              SizedBox(height: 12),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Текущий темп Z: ${z.toStringAsFixed(2)}/день  •  Нужный темп W: ${w.toStringAsFixed(2)}/день',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),
                          const SizedBox(height: 8),
                          Row(children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Старт',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54)),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${(goal?['metric_start'] ?? '').toString()} ${_unitForMetricType(_ugMetricTypeCtrl.text.isNotEmpty ? _ugMetricTypeCtrl.text : (goal?['metric_type'] ?? '').toString())}'
                                        .trim(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _ugMetricCurrentCtrl,
                                readOnly: !_isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Текущее',
                                  hintText: 'Например: 5',
                                  suffixText: _unitForMetricType(
                                      _ugMetricTypeCtrl.text.isNotEmpty
                                          ? _ugMetricTypeCtrl.text
                                          : (goal?['metric_type'] ?? '')
                                              .toString()),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _ugMetricTargetCtrl,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Цель',
                                  suffixText: _unitForMetricType(
                                      _ugMetricTypeCtrl.text.isNotEmpty
                                          ? _ugMetricTypeCtrl.text
                                          : (goal?['metric_type'] ?? '')
                                              .toString()),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 12),
                          Row(children: [
                            if (!_isEditing)
                              TextButton(
                                onPressed: () {
                                  setState(() => _isEditing = true);
                                },
                                child: const Text('Редактировать'),
                              )
                            else ...[
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    try {
                                      Sentry.addBreadcrumb(Breadcrumb(
                                          category: 'goal',
                                          message: 'goal_edit_saved',
                                          level: SentryLevel.info));
                                    } catch (_) {}
                                    final repo =
                                        ref.read(goalsRepositoryProvider);
                                    await repo.upsertUserGoal(
                                      goalText: _ugGoalCtrl.text.trim(),
                                      metricType:
                                          _ugMetricTypeCtrl.text.trim().isEmpty
                                              ? null
                                              : _ugMetricTypeCtrl.text.trim(),
                                      metricStart: num.tryParse((userGoalAsync
                                                      .value?['metric_start'] ??
                                                  '')
                                              .toString())
                                          ?.toDouble(),
                                      metricCurrent: double.tryParse(
                                          _ugMetricCurrentCtrl.text.trim()),
                                      metricTarget: double.tryParse(
                                          _ugMetricTargetCtrl.text.trim()),
                                      targetDate: _selectedTargetDate,
                                    );
                                    ref.invalidate(userGoalProvider);
                                    if (!mounted) return;
                                    setState(() => _isEditing = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Цель сохранена')));
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Ошибка: $e')));
                                  }
                                },
                                child: const Text('Сохранить'),
                              ),
                              const SizedBox(width: 12),
                              TextButton(
                                onPressed: () {
                                  setState(() => _isEditing = false);
                                },
                                child: const Text('Отмена'),
                              ),
                            ],
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => LeoDialogScreen(
                                    bot: 'max',
                                    chatId: null,
                                    userContext: [
                                      'goal_text: ${_ugGoalCtrl.text.trim()}',
                                      if (_ugMetricTypeCtrl.text
                                          .trim()
                                          .isNotEmpty)
                                        'metric_type: ${_ugMetricTypeCtrl.text.trim()}',
                                      if (_ugMetricCurrentCtrl.text
                                          .trim()
                                          .isNotEmpty)
                                        'metric_current: ${_ugMetricCurrentCtrl.text.trim()}',
                                      if (_ugMetricTargetCtrl.text
                                          .trim()
                                          .isNotEmpty)
                                        'metric_target: ${_ugMetricTargetCtrl.text.trim()}',
                                    ].join('\\n'),
                                    levelContext: '',
                                  ),
                                ));
                              },
                              child: const Text('Обсудить с Максом'),
                            ),
                          ]),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Журнал применений
                Container(
                  key: _journalSectionKey,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.shadowColor.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Журнал применений',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      // Обработка префилла из query: ?prefill=intensive&scroll=journal
                      Builder(builder: (context) {
                        String loc;
                        try {
                          // GoRouter >=10
                          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                          loc = GoRouter.of(context)
                              .routeInformationProvider
                              .value
                              .location;
                        } catch (_) {
                          // Фолбэк: берём RouteInformationParser через ModalRoute
                          final route = ModalRoute.of(context);
                          loc = route?.settings.name ?? '/goal';
                        }
                        final uri = Uri.parse(loc);
                        final prefill = uri.queryParameters['prefill'];
                        final scroll = uri.queryParameters['scroll'];
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (scroll == 'journal' && kGoalStickyCta) {
                            final ctx = _journalSectionKey.currentContext;
                            if (ctx != null) {
                              Scrollable.ensureVisible(ctx,
                                  duration: const Duration(milliseconds: 300));
                            }
                          }
                          if (prefill == 'intensive' &&
                              _selectedTools.isEmpty &&
                              kL7PrefillToJournal) {
                            setState(() {
                              _selectedTools.add('Интенсивное применение');
                              if (_practiceNoteCtrl.text.trim().isEmpty) {
                                _practiceNoteCtrl.text =
                                    'Интенсивное применение на 7 дней: выбрал(а) 1–2 инструмента и делаю каждый день.';
                              }
                            });
                          }
                        });
                        return const SizedBox.shrink();
                      }),
                      const SizedBox(height: 12),
                      toolsAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (opts) {
                          String? selected = _selectedTools.isEmpty
                              ? null
                              : _selectedTools.first;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: selected,
                                hint: const Text('Выбрать навык'),
                                items: opts
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e,
                                              overflow: TextOverflow.ellipsis),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _selectedTools
                                      ..clear()
                                      ..addAll(v == null ? const [] : [v]);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      // Хинт влияния записи на метрику
                      userGoalAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (g) {
                          final mt = (g?['metric_type'] ?? '').toString();
                          if (mt.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text('Эта запись влияет на: ' + mt,
                                style: Theme.of(context).textTheme.bodySmall),
                          );
                        },
                      ),
                      TextField(
                        controller: _practiceNoteCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            labelText: 'Что конкретно сделал(а) сегодня'),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final repo = ref.read(goalsRepositoryProvider);
                              await repo.addPracticeEntry(
                                appliedTools: _selectedTools.toList(),
                                note: _practiceNoteCtrl.text.trim().isEmpty
                                    ? null
                                    : _practiceNoteCtrl.text.trim(),
                                appliedAt: DateTime.now(),
                              );
                              final String note = _practiceNoteCtrl.text.trim();
                              final String tools = _selectedTools.join(', ');
                              _practiceNoteCtrl.clear();
                              _selectedTools.clear();
                              ref.invalidate(practiceLogProvider);
                              ref.invalidate(practiceLogAggregatesProvider);
                              try {
                                Sentry.addBreadcrumb(Breadcrumb(
                                    category: 'goal',
                                    message: 'practice_entry_saved',
                                    level: SentryLevel.info));
                              } catch (_) {}
                              if (!mounted) return;
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => LeoDialogScreen(
                                  bot: 'max',
                                  chatId: null,
                                  userContext: [
                                    if (note.isNotEmpty)
                                      'practice_note: ' + note,
                                    if (tools.isNotEmpty)
                                      'applied_tools: ' + tools,
                                  ].join('\n'),
                                  levelContext: '',
                                  autoUserMessage: note.isNotEmpty
                                      ? 'Сегодня сделал(а): ' + note
                                      : 'Я сделал запись в дневнике применений. Подскажи, как усилить эффект?',
                                ),
                              ));
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка: $e')));
                            }
                          },
                          child: const Text('Сохранить запись'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder(
                        future: ref.read(practiceLogAggregatesProvider.future),
                        builder: (ctx, snap) {
                          if (!snap.hasData) return const SizedBox.shrink();
                          final data = snap.data as Map<String, dynamic>;
                          final days = data['daysApplied'] as int? ?? 0;
                          final total = data['totalApplied'] as int? ?? days;
                          final List top =
                              (data['topTools'] as List?) ?? const <dynamic>[];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: LayoutBuilder(
                              builder: (ctx, cons) {
                                final stats = <Widget>[
                                  Text('Всего: $total'),
                                  const SizedBox(width: 12),
                                  Text('Дней: $days'),
                                  const SizedBox(width: 12),
                                  if (top.isNotEmpty)
                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 200),
                                      child: Text(
                                        'Часто: ${(top.map((e) => e['label']).take(2).join(', '))}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ];
                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    ...stats,
                                    TextButton(
                                      onPressed: () {
                                        try {
                                          GoRouter.of(context)
                                              .push('/goal/history');
                                        } catch (_) {}
                                      },
                                      child: const Text('Вся история →'),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                      practiceAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, __) =>
                            const Text('Не удалось загрузить записи'),
                        data: (items) {
                          if (items.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Пока записей нет'),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Выберите инструмент и кратко опишите, что сделали сегодня. Например: «Матрица приоритетов — разобрал входящие заявки, распределил по важности».',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            );
                          }
                          final recent = items.take(3).toList();
                          String _fmt(String s) {
                            final dt = DateTime.tryParse(s)?.toLocal();
                            if (dt == null) return '';
                            const months = [
                              'янв',
                              'фев',
                              'мар',
                              'апр',
                              'май',
                              'июн',
                              'июл',
                              'авг',
                              'сен',
                              'окт',
                              'ноя',
                              'дек'
                            ];
                            final d = dt.day.toString().padLeft(2, '0');
                            final m3 = months[dt.month - 1];
                            final y = dt.year.toString();
                            return '$d-$m3-$y';
                          }

                          return Column(
                            children: [
                              for (final m in recent)
                                ListTile(
                                  dense: true,
                                  leading: const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.blueGrey),
                                  title: Text(((m['applied_tools'] as List?) ??
                                          const <dynamic>[])
                                      .join(', ')),
                                  subtitle: Text((m['note'] ?? '').toString()),
                                  trailing: Text(
                                      _fmt((m['applied_at'] ?? '').toString())),
                                ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  try {
                                    GoRouter.of(context).push('/goal/history');
                                  } catch (_) {}
                                },
                                child: const Text('Вся история →'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
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
          duration: const Duration(milliseconds: 300));
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
