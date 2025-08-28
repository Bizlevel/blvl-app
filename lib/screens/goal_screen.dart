import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/screens/goal/widgets/motivation_card.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';

import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/floating_chat_bubble.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/screens/goal/widgets/goal_compact_card.dart';
import 'package:bizlevel/screens/goal/widgets/crystallization_section.dart';
import 'package:bizlevel/screens/goal/widgets/progress_widget.dart';
import 'package:bizlevel/screens/goal/widgets/sprint_section.dart';
import 'package:bizlevel/screens/goal/controller/goal_screen_controller.dart';

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

  Timer? _debounce;
  // ignore: unused_field
  bool _saving = false;
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
  // details for weekly progress
  final TextEditingController _artifactsDetailsCtrl = TextEditingController();
  final TextEditingController _consultedBenefitCtrl = TextEditingController();
  final TextEditingController _techniquesDetailsCtrl = TextEditingController();

  // Checkboxes for weekly checks
  bool _chkEisenhower = false;
  bool _chkAccounting = false;
  bool _chkUSP = false;
  bool _chkSMART = false;

  @override
  void initState() {
    super.initState();
    // Загружаем версии через контроллер
    Future.microtask(() async {
      await ref.read(goalScreenControllerProvider.notifier).loadVersions();
      final st = ref.read(goalScreenControllerProvider);
      _fillControllersFor(st.selectedVersion, st.versions);
      if (mounted) setState(() {});
    });

    // Автосохранение отключено по требованию: слушателей не добавляем
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _goalInitialCtrl.dispose();
    _goalWhyCtrl.dispose();
    _mainObstacleCtrl.dispose();
    _goalRefinedCtrl.dispose();
    _metricNameCtrl.dispose();
    _metricFromCtrl.dispose();
    _metricToCtrl.dispose();
    _financialGoalCtrl.dispose();
    _goalSmartCtrl.dispose();
    _s1Ctrl.dispose();
    _s2Ctrl.dispose();
    _s3Ctrl.dispose();
    _s4Ctrl.dispose();
    _finalWhatCtrl.dispose();
    _finalWhenCtrl.dispose();
    _finalHowCtrl.dispose();
    _achievementCtrl.dispose();
    _metricActualCtrl.dispose();
    _keyInsightCtrl.dispose();
    _artifactsDetailsCtrl.dispose();
    _consultedBenefitCtrl.dispose();
    _techniquesDetailsCtrl.dispose();
    _techOtherCtrl.dispose();
    super.dispose();
  }

  // Автосохранение отключено

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
      _goalInitialCtrl.text = (data['goal_initial'] ?? '') as String;
      _goalWhyCtrl.text = (data['goal_why'] ?? '') as String;
      _mainObstacleCtrl.text = (data['main_obstacle'] ?? '') as String;
    } else if (version == 2) {
      final data = v(2) ?? v(1) ?? {};
      _goalRefinedCtrl.text =
          (data['goal_refined'] ?? (v(1)?['goal_initial'] ?? '')) as String;
      _metricNameCtrl.text = (data['metric_name'] ?? '') as String;
      _metricFromCtrl.text = (data['metric_from']?.toString() ?? '');
      _metricToCtrl.text = (data['metric_to']?.toString() ?? '');
      _financialGoalCtrl.text = (data['financial_goal']?.toString() ?? '');
    } else if (version == 3) {
      final data = v(3) ?? {};
      _goalSmartCtrl.text = (data['goal_smart'] ?? '') as String;
      _s1Ctrl.text = (data['sprint1_goal'] ?? '') as String;
      _s2Ctrl.text = (data['sprint2_goal'] ?? '') as String;
      _s3Ctrl.text = (data['sprint3_goal'] ?? '') as String;
      _s4Ctrl.text = (data['sprint4_goal'] ?? '') as String;
    } else {
      final data = v(4) ?? {};
      _finalWhatCtrl.text = (data['final_what'] ?? '') as String;
      _finalWhenCtrl.text = (data['final_when'] ?? '') as String;
      _finalHowCtrl.text = (data['final_how'] ?? '') as String;
      _commitment = (data['commitment'] ?? false) as bool;
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
    int _allowedMaxVersion(int lvl) {
      if (lvl >= 11) return 4; // после Уровня 10
      if (lvl >= 8) return 3; // после Уровня 7
      if (lvl >= 5) return 2; // после Уровня 4
      return 1; // после Уровня 1
    }

    final int allowedMax = _allowedMaxVersion(currentLevel);

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
                        'assets/images/avatars/avatar_${avatarId}.png',
                      ),
                      backgroundColor: Colors.transparent,
                    )
                  : const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person_outline, size: 18),
                    );
              return GestureDetector(
                onTap: () {
                  Sentry.addBreadcrumb(Breadcrumb(
                    category: 'ui',
                    type: 'click',
                    message: 'goal_header_avatar_tap',
                    level: SentryLevel.info,
                  ));
                },
                child: avatar,
              );
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
                  const SizedBox(height: 16),

                  // 2) Прогресс-виджет (визуальная мотивация)
                  Builder(builder: (context) {
                    final gs = ref.watch(goalScreenControllerProvider);
                    return ProgressWidget(
                      versions: gs.versions,
                      metricActual:
                          double.tryParse(_metricActualCtrl.text.trim()),
                      achievementText: _achievementCtrl.text.trim(),
                      metricActualText: _metricActualCtrl.text.trim(),
                      insightText: _keyInsightCtrl.text.trim(),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Путь к цели (28-дневный спринт)
                  Builder(builder: (context) {
                    final gs = ref.watch(goalScreenControllerProvider);
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
                ],
              ),
            ),
          ),
        ),
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
        )
      ]),
    );
  }

  String _buildTrackerUserContext(
      Map<int, Map<String, dynamic>> versions, int selectedVersion) {
    final vData = (versions[selectedVersion]?['version_data'] as Map?) ?? {};
    final sb = StringBuffer('goal_version: $selectedVersion\n');
    if (selectedVersion == 1) {
      sb.writeln('goal_initial: ${vData['goal_initial'] ?? ''}');
      sb.writeln('goal_why: ${vData['goal_why'] ?? ''}');
      sb.writeln('main_obstacle: ${vData['main_obstacle'] ?? ''}');
    } else if (selectedVersion == 2) {
      sb.writeln('goal_refined: ${vData['goal_refined'] ?? ''}');
      sb.writeln('metric: ${vData['metric_name'] ?? ''}');
      sb.writeln(
          'from: ${vData['metric_from'] ?? ''} to: ${vData['metric_to'] ?? ''}');
      sb.writeln('financial_goal: ${vData['financial_goal'] ?? ''}');
    } else if (selectedVersion == 3) {
      sb.writeln('goal_smart: ${vData['goal_smart'] ?? ''}');
      sb.writeln('sprint1: ${vData['sprint1_goal'] ?? ''}');
      sb.writeln('sprint2: ${vData['sprint2_goal'] ?? ''}');
      sb.writeln('sprint3: ${vData['sprint3_goal'] ?? ''}');
      sb.writeln('sprint4: ${vData['sprint4_goal'] ?? ''}');
    } else {
      sb.writeln('final_what: ${vData['final_what'] ?? ''}');
      sb.writeln('final_when: ${vData['final_when'] ?? ''}');
      sb.writeln('final_how: ${vData['final_how'] ?? ''}');
      sb.writeln('commitment: ${vData['commitment'] ?? false}');
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
      setState(() => _sprintSaved = true);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Итоги спринта сохранены')));
      _openChatWithMax();
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

  void _openChatWithMax() {
    // Открываем полноэкранный чат с Максом
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ref.read(currentUserProvider).when(
              data: (user) => LeoDialogScreen(
                chatId: null,
                userContext: _buildTrackerUserContext(
                  ref.watch(goalScreenControllerProvider).versions,
                  ref.watch(goalScreenControllerProvider).selectedVersion,
                ),
                levelContext: 'current_level: ${user?.currentLevel ?? 0}',
                bot: 'max',
              ),
              loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator())),
              error: (_, __) => const Scaffold(
                  body: Center(child: Text('Ошибка загрузки профиля'))),
            ),
      ),
    );
  }
}
