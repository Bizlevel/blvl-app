import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/screens/goal/widgets/motivation_card.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';

import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/floating_chat_bubble.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/screens/goal/widgets/goal_compact_card.dart';
import 'package:bizlevel/screens/goal/widgets/crystallization_section.dart';
// import 'package:bizlevel/screens/goal/widgets/progress_widget.dart'; // 🗑️ Удалён - виджет больше не используется
import 'package:bizlevel/screens/goal/widgets/sprint_section.dart';
import 'package:bizlevel/screens/goal/widgets/daily_card.dart';
import 'package:bizlevel/screens/goal/widgets/daily_calendar.dart';
import 'package:bizlevel/screens/goal/controller/goal_screen_controller.dart';
import 'package:bizlevel/utils/constant.dart';
import 'package:bizlevel/services/notifications_service.dart';
import 'package:bizlevel/providers/gp_providers.dart';

class GoalScreen extends ConsumerStatefulWidget {
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends ConsumerState<GoalScreen> {
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
  int _selectedSprint = 1;
  bool _sprintSaved = false; // локальный флаг для кнопки чата после сохранения
  final GlobalKey _sprintSectionKey = GlobalKey();
  bool _goalCardExpanded =
      false; // компактная карточка цели: свёрнута/развёрнута
  // Check-in techniques (визуальные чекбоксы вместо текстовых полей)
  // Техники недели (для чек-ина): используем чекбоксы ниже формы
  // Чекбоксы техник удалены — используем текстовое поле ниже по форме чек‑ина
  final TextEditingController _techOtherCtrl = TextEditingController();

  // Sprint check-in form
  final TextEditingController _achievementCtrl = TextEditingController();
  final TextEditingController _metricActualCtrl = TextEditingController();
  bool _usedArtifacts = false;
  bool _consultedLeo = false;
  bool _appliedTechniques = false;
  final TextEditingController _keyInsightCtrl = TextEditingController();
  // Краткие данные по неделям удалены — аккордеон получает summary из провайдера
  // details for weekly progress
  final TextEditingController _artifactsDetailsCtrl = TextEditingController();
  final TextEditingController _consultedBenefitCtrl = TextEditingController();
  final TextEditingController _techniquesDetailsCtrl = TextEditingController();

  // Checkboxes for weekly checks
  bool _chkEisenhower = false;
  bool _chkAccounting = false;
  bool _chkUSP = false;
  bool _chkSMART = false;

  // Авто‑реакции/бонусы: в рамках сессии защищаемся от повторных триггеров
  static final Set<String> _autoReactionsFired = <String>{};
  static final Set<int> _bonusesClaimedInSession = <int>{};

  @override
  void initState() {
    super.initState();
    // Загружаем версии через контроллер
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(goalScreenControllerProvider.notifier).loadVersions();
      final st = ref.read(goalScreenControllerProvider);
      _fillControllersFor(st.selectedVersion, st.versions);
      // Если есть v4 — выбираем текущую неделю по дате старта
      final hasV4 = st.versions.containsKey(4);
      if (hasV4) {
        final currentWeek =
            ref.read(goalScreenControllerProvider.notifier).currentWeekNumber();
        _selectedSprint = currentWeek;
      }
      // Авто‑реакции Макса и бонусы серий, если включены фича‑флаги
      await _maybeAutoReactionsAndBonuses();
      if (mounted) setState(() {});
    });
  }

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

  void _fillControllersFor(
      int version, Map<int, Map<String, dynamic>> versions) {
    // Очистка или заполнение из данных
    Map<String, dynamic>? v(int idx) {
      final raw = versions[idx]?['version_data'];
      if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }
      return null;
    }

    if (version == 1) {
      final data = v(1) ?? {};
      // Новые ключи с fallback к старым
      _goalInitialCtrl.text =
          (data['concrete_result'] ?? data['goal_initial'] ?? '') as String;
      _goalWhyCtrl.text =
          (data['main_pain'] ?? data['goal_why'] ?? '') as String;
      _mainObstacleCtrl.text =
          (data['first_action'] ?? data['main_obstacle'] ?? '') as String;
    } else if (version == 2) {
      final data = v(2) ?? v(1) ?? {};
      _goalRefinedCtrl.text = (data['concrete_result'] ??
          data['goal_refined'] ??
          (v(1)?['goal_initial'] ?? '')) as String;
      _metricNameCtrl.text =
          (data['metric_type'] ?? data['metric_name'] ?? '') as String;
      _metricFromCtrl.text =
          ((data['metric_current'] ?? data['metric_from'])?.toString() ?? '');
      _metricToCtrl.text =
          ((data['metric_target'] ?? data['metric_to'])?.toString() ?? '');
      _financialGoalCtrl.text = (data['financial_goal']?.toString() ?? '');
    } else if (version == 3) {
      final data = v(3) ?? {};
      _goalSmartCtrl.text = (data['goal_smart'] ?? '') as String;
      _s1Ctrl.text =
          (data['week1_focus'] ?? data['sprint1_goal'] ?? '') as String;
      _s2Ctrl.text =
          (data['week2_focus'] ?? data['sprint2_goal'] ?? '') as String;
      _s3Ctrl.text =
          (data['week3_focus'] ?? data['sprint3_goal'] ?? '') as String;
      _s4Ctrl.text =
          (data['week4_focus'] ?? data['sprint4_goal'] ?? '') as String;
    } else {
      final data = v(4) ?? {};
      _finalWhatCtrl.text =
          (data['first_three_days'] ?? data['final_what'] ?? '') as String;
      _finalWhenCtrl.text =
          (data['start_date'] ?? data['final_when'] ?? '') as String;
      _finalHowCtrl.text =
          (data['accountability_person'] ?? data['final_how'] ?? '') as String;
      final dynamic rs = data['readiness_score'];
      if (rs is num) {
        _commitment = rs >= 7;
      } else {
        _commitment = (data['commitment'] ?? false) as bool;
      }
    }
  }

  // _miniMetric удалён — не используется в новой версии прогресс‑виджета

  // _buildCurrentWeekSummary удалён — блок «Текущая неделя» исключён

  @override
  Widget build(BuildContext context) {
    // Перемещено в MotivationCard

    // Определяем максимально доступную версию на основе текущего уровня пользователя
    final currentUserAsync = ref.watch(currentUserProvider);
    final int currentLevel = currentUserAsync.asData?.value?.currentLevel ?? 0;
    int allowedMaxVersion(int lvl) {
      if (lvl >= 11) return 4; // после Уровня 10
      if (lvl >= 8) return 3; // после Уровня 7
      if (lvl >= 5) return 2; // после Уровня 4
      return 1; // после Уровня 1
    }

    final int allowedMax = allowedMaxVersion(currentLevel);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Цель'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Builder(builder: (context) {
              final avatarId = currentUserAsync.asData?.value?.avatarId;
              final Widget avatar = avatarId != null
                  ? CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(
                        'assets/images/avatars/avatar_$avatarId.png',
                      ),
                      backgroundColor: Colors.transparent,
                    )
                  : const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person_outline, size: 18),
                    );
              return Row(children: [
                IconButton(
                  tooltip: 'Напоминания',
                  icon: const Icon(Icons.notifications_active_outlined),
                  onPressed: () {
                    try {
                      GoRouter.of(context).push('/notifications');
                    } catch (e, st) {
                      Sentry.captureException(e, stackTrace: st);
                    }
                  },
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Sentry.addBreadcrumb(Breadcrumb(
                      category: 'ui',
                      type: 'click',
                      message: 'goal_header_avatar_tap',
                      level: SentryLevel.info,
                    ));
                  },
                  child: avatar,
                ),
              ]);
            }),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8FAFC), Color(0xFFE0F2FE)],
            ),
          ),
        ),
      ),
      body: Stack(children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Мини-баннер «Что дальше?» под AppBar (mobile-first)
                  FutureBuilder<Map<String, dynamic>>(
                    future: ref.read(goalsRepositoryProvider).fetchGoalState(),
                    builder: (context, snap) {
                      if (!snap.hasData) return const SizedBox.shrink();
                      final data = snap.data!;
                      final String nextAction =
                          (data['next_action'] as String?) ?? '';
                      final int nextTarget =
                          (data['next_action_target'] as int?) ?? 0;
                      String title;
                      VoidCallback? onTap;
                      if (nextAction == 'goal_checkpoint' &&
                          nextTarget >= 2 &&
                          nextTarget <= 4) {
                        title =
                            'Что дальше: заполнить v$nextTarget на чекпоинте';
                        onTap = () => GoRouter.of(context)
                            .push('/goal-checkpoint/$nextTarget');
                      } else if (nextAction == 'level_up') {
                        // 🆕 Достигнут предел по уровню - нужно пройти больше уроков
                        title =
                            'Что дальше: пройти Уровень $currentLevel для открытия v$nextTarget';
                        onTap = () => GoRouter.of(context)
                            .push('/tower?scrollTo=$currentLevel');
                      } else if (nextAction == 'weeks') {
                        title = 'Что дальше: перейти к 28 дням';
                        onTap = _scrollToSprintSection;
                      } else {
                        title = 'Что дальше: создать v1 на Уровне 1';
                        onTap = () =>
                            GoRouter.of(context).push('/tower?scrollTo=1');
                      }
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColor.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          )),
                          TextButton(
                              onPressed: onTap, child: const Text('Перейти')),
                        ]),
                      );
                    },
                  ),
                  // Мотивация от Макса
                  const MotivationCard(),
                  const SizedBox(height: 20),

                  // Единый блок: Моя цель + Кристаллизация цели
                  Builder(builder: (context) {
                    final gs = ref.watch(goalScreenControllerProvider);
                    final gctrl =
                        ref.read(goalScreenControllerProvider.notifier);
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.shadowColor.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Заголовок «Моя цель» + карточка
                          Text(
                            'Моя цель',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          GoalCompactCard(
                            versions: gs.versions,
                            expanded: _goalCardExpanded,
                            onToggle: () => setState(
                                () => _goalCardExpanded = !_goalCardExpanded),
                            onOpenChat: _openChatWithMax,
                            metricActual:
                                double.tryParse(_metricActualCtrl.text.trim()),
                          ),
                          const SizedBox(height: 8),
                          // Компактный гид по шагам: v1→v4→Недели
                          Builder(builder: (context) {
                            final hasV1 = gs.versions.containsKey(1);
                            final hasV2 = gs.versions.containsKey(2);
                            final hasV3 = gs.versions.containsKey(3);
                            final hasV4 = gs.versions.containsKey(4);
                            String currentStep;
                            if (!hasV1) {
                              currentStep = 'v1';
                            } else if (!hasV2) {
                              currentStep = 'v2';
                            } else if (!hasV3) {
                              currentStep = 'v3';
                            } else if (!hasV4) {
                              currentStep = 'v4';
                            } else {
                              currentStep = 'weeks';
                            }

                            Widget buildChip({
                              required String label,
                              required bool completed,
                              required bool active,
                              required bool locked,
                              required VoidCallback? onTap,
                            }) {
                              final Color bg = locked
                                  ? AppColor.surface
                                  : (active
                                      ? AppColor.primary.withValues(alpha: 0.08)
                                      : Colors.white);
                              final Color border = active
                                  ? AppColor.primary
                                  : (locked
                                      ? AppColor.labelColor
                                          .withValues(alpha: 0.4)
                                      : AppColor.labelColor
                                          .withValues(alpha: 0.3));
                              final TextStyle? ts = Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: active
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: locked
                                        ? AppColor.labelColor
                                        : AppColor.textColor,
                                  );
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 6),
                                child: InkWell(
                                  onTap: locked ? null : onTap,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: bg,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: border),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x08000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (completed)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 4),
                                            child: Icon(Icons.check_circle,
                                                size: 16, color: Colors.green),
                                          )
                                        else if (locked)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 4),
                                            child: Icon(Icons.lock_outline,
                                                size: 16, color: Colors.grey),
                                          ),
                                        Text(label, style: ts),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            void showLockedSnack(String msg) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(msg)));
                            }

                            return Wrap(
                              children: [
                                // v1
                                buildChip(
                                  label: 'v1',
                                  completed: hasV1,
                                  active: currentStep == 'v1',
                                  locked: false,
                                  onTap: () {
                                    if (!hasV1) {
                                      GoRouter.of(context)
                                          .push('/tower?scrollTo=1');
                                    }
                                  },
                                ),
                                // v2
                                buildChip(
                                  label: 'v2',
                                  completed: hasV2,
                                  active: currentStep == 'v2',
                                  locked: (!hasV1) || allowedMax < 2,
                                  onTap: (!hasV1 || allowedMax < 2)
                                      ? () => showLockedSnack(
                                          'Откроется после Уровня 4')
                                      : () => GoRouter.of(context)
                                          .push('/goal-checkpoint/2'),
                                ),
                                // v3
                                buildChip(
                                  label: 'v3',
                                  completed: hasV3,
                                  active: currentStep == 'v3',
                                  locked: (!hasV2) || allowedMax < 3,
                                  onTap: (!hasV2 || allowedMax < 3)
                                      ? () => showLockedSnack(
                                          'Откроется после Уровня 7')
                                      : () => GoRouter.of(context)
                                          .push('/goal-checkpoint/3'),
                                ),
                                // v4
                                buildChip(
                                  label: 'v4',
                                  completed: hasV4,
                                  active: currentStep == 'v4',
                                  locked: (!hasV3) || allowedMax < 4,
                                  onTap: (!hasV3 || allowedMax < 4)
                                      ? () => showLockedSnack(
                                          'Откроется после Уровня 10')
                                      : () => GoRouter.of(context)
                                          .push('/goal-checkpoint/4'),
                                ),
                                // Weeks
                                buildChip(
                                  label: 'Недели',
                                  completed: false,
                                  active: currentStep == 'weeks',
                                  locked: !hasV4,
                                  onTap: !hasV4
                                      ? () => showLockedSnack(
                                          'Доступно после v4 «Финал»')
                                      : () => _scrollToSprintSection(),
                                ),
                              ],
                            );
                          }),
                          // Прогресс и «Что дальше» через fetch_goal_state
                          FutureBuilder<Map<String, dynamic>>(
                            future: ref
                                .read(goalsRepositoryProvider)
                                .fetchGoalState(),
                            builder: (context, snap) {
                              final data =
                                  snap.data ?? const <String, dynamic>{};
                              final bool hasV1 =
                                  (data['has_v1'] as bool?) ?? false;
                              // hasV2, hasV3, hasV4 больше не нужны - прогресс-бар удалён
                              final String nextAction =
                                  (data['next_action'] as String?) ?? '';
                              final int nextTarget =
                                  (data['next_action_target'] as int?) ?? 0;
                              String nextHint;
                              VoidCallback? onCta;
                              if (nextAction == 'goal_checkpoint' &&
                                  nextTarget >= 2 &&
                                  nextTarget <= 4) {
                                nextHint =
                                    'Заполните v$nextTarget на чекпоинте';
                                onCta = () => GoRouter.of(context)
                                    .push('/goal-checkpoint/$nextTarget');
                              } else if (nextAction == 'level_up') {
                                // 🆕 Достигнут предел по уровню
                                nextHint =
                                    'Пройдите Уровень $currentLevel для открытия v$nextTarget';
                                onCta = () => GoRouter.of(context)
                                    .push('/tower?scrollTo=$currentLevel');
                              } else if (nextAction == 'weeks') {
                                nextHint =
                                    'Все версии заполнены — переходите к неделям';
                                onCta = () => _scrollToSprintSection();
                              } else {
                                nextHint = !hasV1
                                    ? 'Создайте v1 «Семя цели» на Уровне 1'
                                    : 'Продолжайте к следующему шагу';
                              }
                              // 🗑️ Убран дублирующий прогресс-бар "Прогресс: N%"
                              // т.к. уже есть галочки на кнопках версий
                              return Row(
                                children: [
                                  Expanded(
                                    child: Text(nextHint,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                  if (onCta != null)
                                    TextButton(
                                      onPressed: onCta,
                                      child: const Text('Что дальше'),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          CrystallizationSection(
                            versions: gs.versions,
                            selectedVersion: gs.selectedVersion,
                            allowedMaxVersion: allowedMax,
                            historyExpanded: gs.historyExpanded,
                            onSelectVersion: (v) {
                              gctrl.selectVersion(v);
                              _fillControllersFor(v, gs.versions);
                              setState(() {});
                            },
                            onToggleHistory: () {
                              gctrl.toggleHistory();
                              setState(() {});
                              Sentry.addBreadcrumb(Breadcrumb(
                                category: 'ui',
                                type: 'click',
                                message: 'goal_history_toggle',
                                data: {'expanded': gs.historyExpanded},
                                level: SentryLevel.info,
                              ));
                            },
                          ),
                        ],
                      ),
                    );
                  }),

                  // 🗑️ ProgressWidget удалён - дублировал информацию из галочек версий
                  // и был пустым при отсутствии метрики

                  const SizedBox(height: 20),

                  // Путь к цели (weekly) — показывать до старта 28 дней; скрывать после
                  Builder(builder: (context) {
                    final gs = ref.watch(goalScreenControllerProvider);
                    final hasV4 = gs.versions.containsKey(4);
                    if (!hasV4) return const SizedBox.shrink();
                    // Если 28 дней активированы — скрываем weekly‑секцию
                    final Map<String, dynamic> v4data =
                        ((gs.versions[4]?['version_data'] as Map?)
                                ?.cast<String, dynamic>()) ??
                            const <String, dynamic>{};
                    final bool dailyStarted =
                        (v4data['start_date']?.toString().isNotEmpty ?? false);
                    if (dailyStarted) return const SizedBox.shrink();
                    return SprintSection(
                      versions: gs.versions,
                      selectedSprint: _selectedSprint,
                      onSelectSprint: (s) {
                        setState(() {
                          _selectedSprint = s;
                          _sprintSaved = false;
                        });
                        _loadSprintIfAny(s);
                        _scrollToSprintSection();
                      },
                      achievementCtrl: _achievementCtrl,
                      metricActualCtrl: _metricActualCtrl,
                      keyInsightCtrl: _keyInsightCtrl,
                      techOtherCtrl: _techOtherCtrl,
                      chkEisenhower: _chkEisenhower,
                      chkAccounting: _chkAccounting,
                      chkUSP: _chkUSP,
                      chkSMART: _chkSMART,
                      onToggleEisenhower: (v) =>
                          setState(() => _chkEisenhower = v),
                      onToggleAccounting: (v) =>
                          setState(() => _chkAccounting = v),
                      onToggleUSP: (v) => setState(() => _chkUSP = v),
                      onToggleSMART: (v) => setState(() => _chkSMART = v),
                      onSave: _onSaveSprint,
                      showChatButton: _sprintSaved,
                      onOpenChat: _openChatWithMax,
                      sectionKey: _sprintSectionKey,
                    );
                  }),

                  // 28-дневный режим: «Готовы к старту» / Дневная карточка + календарь
                  if (kEnableGoalDailyMode)
                    Builder(builder: (context) {
                      final gs = ref.watch(goalScreenControllerProvider);
                      final hasV4 = gs.versions.containsKey(4);

                      // Проверяем что v4 полностью заполнена (commitment=true)
                      final Map<String, dynamic> v4data =
                          ((gs.versions[4]?['version_data'] as Map?)
                                  ?.cast<String, dynamic>()) ??
                              const <String, dynamic>{};
                      final bool v4Completed = (v4data['commitment'] == true ||
                          v4data['commitment'] == 'true');

                      final String startIso =
                          (v4data['start_date'] ?? '').toString();
                      final DateTime? startDate =
                          DateTime.tryParse(startIso)?.toUtc();

                      // Показываем блок "Готовы к старту" только если v4 завершена и спринт не начат
                      if (hasV4 && v4Completed && startDate == null) {
                        // 🎯 Готовы к старту!
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.primary.withValues(alpha: 0.08),
                                  AppColor.primary.withValues(alpha: 0.02),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColor.primary.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColor.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.rocket_launch,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '🎯 Готовы к старту!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColor.primary,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Цель кристаллизована. Запустите 28-дневный спринт!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.black87,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await ref
                                            .read(goalsRepositoryProvider)
                                            .startSprint();
                                        await NotificationsService.instance
                                            .scheduleDailySprint();
                                        if (mounted) {
                                          await ref
                                              .read(goalScreenControllerProvider
                                                  .notifier)
                                              .loadVersions();
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                '🚀 Спринт начат! 28 задач сгенерированы.',
                                              ),
                                              backgroundColor: AppColor.primary,
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Ошибка запуска: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      '🚀 Начать 28 дней к цели',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Если спринт не начат, ничего не показываем
                      if (startDate == null) {
                        return const SizedBox.shrink();
                      }

                      // Активные 28 дней: считаем текущий день (1..28)
                      final int days =
                          DateTime.now().toUtc().difference(startDate).inDays;
                      final int currentDay = (days + 1).clamp(1, 28);

                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Хедер дня с линейным прогрессом N/28
                            Builder(builder: (context) {
                              final int dayNum = currentDay;
                              final int weekNum = ((dayNum - 1) ~/ 7) + 1;
                              final double pct =
                                  (dayNum / 28.0).clamp(0.0, 1.0);
                              return Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'День $dayNum • Неделя $weekNum',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 6),
                                        LinearProgressIndicator(
                                          value: pct,
                                          minHeight: 6,
                                          backgroundColor: AppColor.surface,
                                          color: AppColor.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Настроить напоминания',
                                    icon: const Icon(
                                        Icons.notifications_active_outlined),
                                    onPressed: () => GoRouter.of(context)
                                        .push('/notifications'),
                                  ),
                                ],
                              );
                            }),
                            // Карточка «Сегодня»
                            Consumer(builder: (context, ref, _) {
                              final listAsync =
                                  ref.watch(dailyProgressListProvider);
                              return listAsync.when(
                                data: (list) {
                                  final Map<int, String> statusByDay =
                                      <int, String>{};
                                  for (final m in list) {
                                    final int? dn = m['day_number'] as int?;
                                    if (dn != null) {
                                      statusByDay[dn] =
                                          (m['completion_status'] ?? 'pending')
                                              .toString();
                                    }
                                  }
                                  final String status =
                                      statusByDay[currentDay] ?? 'pending';
                                  // Задача дня из v3 weekN_focus | sprintN_goal
                                  String taskText = '';
                                  try {
                                    final Map<String, dynamic> v3 =
                                        ((gs.versions[3]?['version_data']
                                                    as Map?)
                                                ?.cast<String, dynamic>()) ??
                                            const <String, dynamic>{};
                                    final int w = ((currentDay - 1) ~/ 7) + 1;
                                    final String key = 'week${w}_focus';
                                    taskText =
                                        (v3[key] ?? v3['sprint${w}_goal'] ?? '')
                                            .toString();
                                  } catch (_) {}
                                  return DailyTodayCard(
                                    dayNumber: currentDay,
                                    taskText: taskText,
                                    status: status,
                                    onChangeStatus: (code) async {
                                      await ref
                                          .read(goalsRepositoryProvider)
                                          .upsertDailyProgress(
                                              dayNumber: currentDay,
                                              status: code);
                                      ref.invalidate(dailyProgressListProvider);
                                    },
                                    onSaveNote: (note) async {
                                      await ref
                                          .read(goalsRepositoryProvider)
                                          .upsertDailyProgress(
                                              dayNumber: currentDay,
                                              note: note);
                                    },
                                  );
                                },
                                loading: () => const SizedBox.shrink(),
                                error: (_, __) => const SizedBox.shrink(),
                              );
                            }),
                            const SizedBox(height: 12),
                            // Календарь 28 дней
                            Consumer(builder: (context, ref, _) {
                              final listAsync =
                                  ref.watch(dailyProgressListProvider);
                              return listAsync.when(
                                data: (list) {
                                  final Map<int, String> statusByDay =
                                      <int, String>{};
                                  for (final m in list) {
                                    final int? dn = m['day_number'] as int?;
                                    if (dn != null) {
                                      statusByDay[dn] =
                                          (m['completion_status'] ?? 'pending')
                                              .toString();
                                    }
                                  }
                                  return DailyCalendar28(
                                    statusByDay: statusByDay,
                                    onTapDay: (day) async {
                                      final cur = statusByDay[day] ?? 'pending';
                                      final next = cur == 'completed'
                                          ? 'pending'
                                          : 'completed';
                                      await ref
                                          .read(goalsRepositoryProvider)
                                          .upsertDailyProgress(
                                              dayNumber: day, status: next);
                                      ref.invalidate(dailyProgressListProvider);
                                    },
                                  );
                                },
                                loading: () => const SizedBox.shrink(),
                                error: (_, __) => const SizedBox.shrink(),
                              );
                            }),
                            const SizedBox(height: 12),
                            // Контекстные CTA: помощь Макса и завершение 28 дней
                            Row(
                              children: [
                                TextButton(
                                  onPressed: _openChatWithMax,
                                  child: const Text('Нужна помощь от Макса'),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await ref
                                          .read(goalsRepositoryProvider)
                                          .completeSprint();
                                      await NotificationsService.instance
                                          .cancelDailySprint();
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('28 дней завершены')),
                                        );
                                      }
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Ошибка завершения: $e')),
                                      );
                                    }
                                  },
                                  child: const Text('Завершить 28 дней'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ),
        if (!kHideGoalBubbleOnGoal)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingChatBubble(
              chatId: null,
              systemPrompt:
                  'Режим трекера цели: обсуждаем версию v${ref.watch(goalScreenControllerProvider).selectedVersion} и прогресс спринтов. Будь краток, поддерживай фокус, предлагай следующий шаг.',
              userContext: _buildTrackerUserContext(
                ref.watch(goalScreenControllerProvider).versions,
                ref.watch(goalScreenControllerProvider).selectedVersion,
              ),
              levelContext: 'current_level: $currentLevel',
              bot: 'max',
            ),
          ),
        // Sticky нижняя панель CTA
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 6,
                      offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _openChatWithMax,
                      child: const Text('Нужна помощь от Макса'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Завершить 28 дней?'),
                          content: const Text(
                              'Вы уверены, что хотите завершить текущий цикл 28 дней? Уведомления будут отключены.'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Отмена')),
                            ElevatedButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Завершить')),
                          ],
                        ),
                      );
                      if (ok != true) return;
                      try {
                        await ref
                            .read(goalsRepositoryProvider)
                            .completeSprint();
                        await NotificationsService.instance.cancelDailySprint();
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Цикл 28 дней завершён')),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Не удалось завершить: $e')),
                        );
                      }
                    },
                    child: const Text('Завершить 28 дней'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  String _buildTrackerUserContext(
      Map<int, Map<String, dynamic>> versions, int selectedVersion) {
    final vData = (versions[selectedVersion]?['version_data'] as Map?) ?? {};
    final sb = StringBuffer('goal_version: $selectedVersion\n');
    if (selectedVersion == 1) {
      sb.writeln('concrete_result: ${vData['concrete_result'] ?? ''}');
      sb.writeln('main_pain: ${vData['main_pain'] ?? ''}');
      sb.writeln('first_action: ${vData['first_action'] ?? ''}');
    } else if (selectedVersion == 2) {
      sb.writeln('concrete_result: ${vData['concrete_result'] ?? ''}');
      sb.writeln('metric_type: ${vData['metric_type'] ?? ''}');
      sb.writeln(
          'current: ${vData['metric_current'] ?? ''} target: ${vData['metric_target'] ?? ''}');
      sb.writeln('financial_goal: ${vData['financial_goal'] ?? ''}');
    } else if (selectedVersion == 3) {
      sb.writeln('goal_smart: ${vData['goal_smart'] ?? ''}');
      sb.writeln('week1_focus: ${vData['week1_focus'] ?? ''}');
      sb.writeln('week2_focus: ${vData['week2_focus'] ?? ''}');
      sb.writeln('week3_focus: ${vData['week3_focus'] ?? ''}');
      sb.writeln('week4_focus: ${vData['week4_focus'] ?? ''}');
    } else {
      sb.writeln('first_three_days: ${vData['first_three_days'] ?? ''}');
      sb.writeln('start_date: ${vData['start_date'] ?? ''}');
      sb.writeln(
          'accountability_person: ${vData['accountability_person'] ?? ''}');
      sb.writeln('readiness_score: ${vData['readiness_score'] ?? ''}');
    }
    // Последний чек-ин (если заполнен)
    if (_achievementCtrl.text.isNotEmpty ||
        _metricActualCtrl.text.isNotEmpty ||
        _keyInsightCtrl.text.isNotEmpty) {
      sb.writeln('last_sprint_achievement: ${_achievementCtrl.text.trim()}');
      sb.writeln('last_sprint_metric_actual: ${_metricActualCtrl.text.trim()}');
      sb.writeln('last_sprint_used_artifacts: $_usedArtifacts');
      sb.writeln('last_sprint_consulted_leo: $_consultedLeo');
      sb.writeln('last_sprint_applied_techniques: $_appliedTechniques');
      sb.writeln('last_sprint_insight: ${_keyInsightCtrl.text.trim()}');
    }
    return sb.toString();
  }

  // Удалены: _getVersionStatus/_getVersionTooltip не используются после упрощения UI переключателя

  // _build7DayTimeline/_buildDayDot удалены — в новой версии не используются

  Future<void> _loadSprintIfAny(int sprintNumber) async {
    final existing = await ref.read(sprintProvider(sprintNumber).future);
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
  }

  Future<void> _onSaveSprint() async {
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

      await repo.upsertSprint(
        sprintNumber: _selectedSprint,
        achievement: _achievementCtrl.text.trim().isEmpty
            ? null
            : _achievementCtrl.text.trim(),
        metricActual: _metricActualCtrl.text.trim().isEmpty
            ? null
            : _metricActualCtrl.text.trim(),
        usedArtifacts: _artifactsDetailsCtrl.text.trim().isNotEmpty
            ? true
            : _usedArtifacts,
        consultedLeo:
            _consultedBenefitCtrl.text.trim().isNotEmpty ? true : _consultedLeo,
        appliedTechniques: (techniquesSummary.isNotEmpty || _appliedTechniques),
        keyInsight: _keyInsightCtrl.text.trim().isEmpty
            ? null
            : _keyInsightCtrl.text.trim(),
        artifactsDetails: _artifactsDetailsCtrl.text.trim().isEmpty
            ? null
            : _artifactsDetailsCtrl.text.trim(),
        consultedBenefit: _consultedBenefitCtrl.text.trim().isEmpty
            ? null
            : _consultedBenefitCtrl.text.trim(),
        techniquesDetails: techniquesSummary.isEmpty ? null : techniquesSummary,
      );
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
      if (kEnableClientWeeklyReaction) {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'goal',
          type: 'info',
          message: 'weekly_reaction_requested_client',
          data: {'week': _selectedSprint},
          level: SentryLevel.info,
        ));
        _openChatWithMax();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения итогов: $e')));
    }
  }

  // Helpers for 38.14/38.15

  void _scrollToSprintSection() {
    final ctx = _sprintSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 300));
    }
  }

  void _openChatWithMax({String? autoMessage, List<String>? chips}) {
    // Открываем полноэкранный чат с Максом
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ref.read(currentUserProvider).when(
              data: (user) => LeoDialogScreen(
                chatId: null,
                userContext: _buildTrackerUserContext(
                      ref.watch(goalScreenControllerProvider).versions,
                      ref.watch(goalScreenControllerProvider).selectedVersion,
                    ) +
                    _buildDailyChatContextTail(),
                levelContext: 'current_level: ${user?.currentLevel ?? 0}',
                bot: 'max',
                // После сохранения чек‑ина отправляем тонкую реакцию Макса
                autoUserMessage: autoMessage ??
                    (_sprintSaved
                        ? 'weekly_checkin: Неделя $_selectedSprint; Итог: ${_achievementCtrl.text.trim()}; Метрика: ${_metricActualCtrl.text.trim()}'
                        : null),
                skipSpend: _sprintSaved || autoMessage != null,
                recommendedChips: chips ??
                    (_dailyModeActive()
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
  }

  // 🗑️ Метод _normalizeVersionsForProgress удалён - ProgressWidget больше не используется

  List<String> _weeklyRecommendedChips() {
    final List<String> chips = [];
    chips.add('План на следующую неделю');
    if (_metricActualCtrl.text.trim().isNotEmpty) {
      chips.add('Как ускорить рост метрики');
    } else {
      chips.add('Выбрать метрику для фокуса');
    }
    chips.add('Что мешает, как убрать препятствия');
    return chips;
  }

  // ---------- Daily mode helpers ----------

  bool _dailyModeActive() {
    final gs = ref.read(goalScreenControllerProvider);
    final Map<String, dynamic> v4data =
        ((gs.versions[4]?['version_data'] as Map?)?.cast<String, dynamic>()) ??
            const <String, dynamic>{};
    final String startIso = (v4data['start_date'] ?? '').toString();
    return DateTime.tryParse(startIso) != null;
  }

  ({int day, int week, String task}) _currentDayWeekTask() {
    final gs = ref.read(goalScreenControllerProvider);
    final Map<String, dynamic> v4data =
        ((gs.versions[4]?['version_data'] as Map?)?.cast<String, dynamic>()) ??
            const <String, dynamic>{};
    final Map<String, dynamic> v3data =
        ((gs.versions[3]?['version_data'] as Map?)?.cast<String, dynamic>()) ??
            const <String, dynamic>{};
    final String startIso = (v4data['start_date'] ?? '').toString();
    final DateTime? start = DateTime.tryParse(startIso)?.toUtc();
    if (start == null) return (day: 1, week: 1, task: '');
    final int days = DateTime.now().toUtc().difference(start).inDays;
    final int dayNum = (days + 1).clamp(1, 28);
    final int weekNum = ((dayNum - 1) ~/ 7) + 1;
    final String key = 'week${weekNum}_focus';
    final String task =
        (v3data[key] ?? v3data['sprint${weekNum}_goal'] ?? '').toString();
    return (day: dayNum, week: weekNum, task: task);
  }

  String _buildDailyChatContextTail() {
    if (!_dailyModeActive()) return '';
    final s = _currentDayWeekTask();
    final buf = StringBuffer();
    buf.writeln('\nday_number: ${s.day}');
    buf.writeln('week_number: ${s.week}');
    if (s.task.isNotEmpty) buf.writeln('daily_task: ${s.task}');
    return buf.toString();
  }

  List<String> _dailyRecommendedChips() {
    final s = _currentDayWeekTask();
    final List<String> out = [];
    // Базовые предложения по неделям
    switch (s.week) {
      case 1:
        out.add('Открыть: Стресс-менеджмент');
        out.add('План на 3 дня');
        break;
      case 2:
        out.add('Открыть: Матрица Эйзенхауэра');
        out.add('Настроить приоритеты');
        break;
      case 3:
        out.add('Открыть: Скрипт звонка');
        out.add('Улучшить конверсию');
        break;
      case 4:
        out.add('Открыть: Ретроспектива недели');
        out.add('Подготовить финишные шаги');
        break;
    }
    // По ключевым словам задачи дня
    final t = s.task.toLowerCase();
    if (t.contains('звон')) out.add('Открыть: Блиц-опрос клиентов');
    if (t.contains('клиент')) out.add('Открыть: Скрипт звонка');
    if (t.contains('приоритет')) out.add('Открыть: Матрица Эйзенхауэра');
    // Ограничим до 6 и удалим дубликаты
    final seen = <String>{};
    final dedup = <String>[];
    for (final c in out) {
      if (seen.add(c)) dedup.add(c);
      if (dedup.length >= 6) break;
    }
    return dedup;
  }

  Future<void> _maybeAutoReactionsAndBonuses() async {
    // Еженедельная авто‑реакция
    if (kEnableClientWeeklyReaction && _dailyModeActive()) {
      final s = _currentDayWeekTask();
      if (<int>{7, 14, 21, 28}.contains(s.day)) {
        final key = 'week_react_${s.week}';
        if (!_autoReactionsFired.contains(key)) {
          _autoReactionsFired.add(key);
          _openChatWithMax(
            autoMessage: 'end_of_week_checkin: Неделя ${s.week}',
            chips: _weeklyRecommendedChips(),
          );
        }
      } else {
        // Низкая активность: два подряд пропуска
        try {
          final list = await ref.read(dailyProgressListProvider.future);
          int misses = 0;
          for (int i = s.day - 1; i >= 1 && i >= s.day - 7; i--) {
            final m = list.firstWhere(
              (e) => (e['day_number'] as int?) == i,
              orElse: () => const <String, dynamic>{},
            );
            final st = (m['completion_status'] ?? 'pending').toString();
            if (st == 'missed') {
              misses += 1;
              if (misses >= 2) break;
            } else if (st == 'completed' || st == 'partial') {
              misses = 0;
            }
          }
          if (misses >= 2) {
            final key = 'low_activity_ping_w${s.week}_d${s.day}';
            if (!_autoReactionsFired.contains(key)) {
              _autoReactionsFired.add(key);
              _openChatWithMax(
                autoMessage:
                    'low_activity_ping: Уже ${misses} дня(ей) без активности. Что мешает?',
                chips: _dailyRecommendedChips(),
              );
            }
          }
        } catch (_) {}
      }
    }

    // Бонусы за серии: 7/14/21/28 — сервер обработает идемпотентно
    if (_dailyModeActive()) {
      final s = _currentDayWeekTask();
      if (<int>{7, 14, 21, 28}.contains(s.day) &&
          !_bonusesClaimedInSession.contains(s.day)) {
        _bonusesClaimedInSession.add(s.day);
        try {
          await ref
              .read(gpServiceProvider)
              .claimBonus(ruleKey: 'streak_${s.day}');
          // Баланс обновится через провайдер фоном
        } catch (_) {}
      }
    }
  }
}
