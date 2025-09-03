import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/widgets/goal_version_form.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/theme/color.dart';

class GoalCheckpointScreen extends ConsumerStatefulWidget {
  final int version;
  const GoalCheckpointScreen({super.key, required this.version});

  @override
  ConsumerState<GoalCheckpointScreen> createState() =>
      _GoalCheckpointScreenState();
}

class _GoalCheckpointScreenState extends ConsumerState<GoalCheckpointScreen> {
  final TextEditingController _goalInitialCtrl = TextEditingController();
  final TextEditingController _goalWhyCtrl = TextEditingController();
  final TextEditingController _mainObstacleCtrl = TextEditingController();
  final TextEditingController _goalRefinedCtrl = TextEditingController();
  final TextEditingController _metricNameCtrl = TextEditingController();
  final TextEditingController _metricFromCtrl = TextEditingController();
  final TextEditingController _metricToCtrl = TextEditingController();
  final TextEditingController _financialGoalCtrl = TextEditingController();
  final TextEditingController _goalSmartCtrl = TextEditingController();
  final TextEditingController _s1Ctrl = TextEditingController();
  final TextEditingController _s2Ctrl = TextEditingController();
  final TextEditingController _s3Ctrl = TextEditingController();
  final TextEditingController _s4Ctrl = TextEditingController();
  final TextEditingController _finalWhatCtrl = TextEditingController();
  final TextEditingController _finalWhenCtrl = TextEditingController();
  final TextEditingController _finalHowCtrl = TextEditingController();
  bool _commitment = false;
  bool _saving = false;
  Map<int, Map<String, dynamic>> _versions = {};
  bool _loadFailed = false;
  bool _showIntro = true;
  String? _lastAssistantMessage;

  @override
  void initState() {
    super.initState();
    Sentry.addBreadcrumb(Breadcrumb(
        level: SentryLevel.info,
        category: 'goal',
        message: 'goal_checkpoint_opened v=${widget.version}'));
    Future.microtask(_loadAndFill);
  }

  @override
  void dispose() {
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
    super.dispose();
  }

  Future<void> _loadAndFill() async {
    try {
      setState(() => _loadFailed = false);
      final all = await ref.read(goalVersionsProvider.future);
      _versions = {
        for (final m in all) m['version'] as int: Map<String, dynamic>.from(m)
      };
      _fillControllersFor(widget.version);
      if (mounted) setState(() {});
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      setState(() => _loadFailed = true);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка загрузки данных версии')));
    }
  }

  void _fillControllersFor(int version) {
    Map<String, dynamic>? v(int idx) {
      final raw = _versions[idx]?['version_data'];
      if (raw is Map) return Map<String, dynamic>.from(raw);
      return null;
    }

    if (version == 2) {
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
    } else if (version == 4) {
      final data = v(4) ?? {};
      _finalWhatCtrl.text = (data['final_what'] ?? '') as String;
      _finalWhenCtrl.text = (data['final_when'] ?? '') as String;
      _finalHowCtrl.text = (data['final_how'] ?? '') as String;
      _commitment = (data['commitment'] ?? false) as bool;
    } else if (version == 1) {
      final data = v(1) ?? {};
      _goalInitialCtrl.text = (data['goal_initial'] ?? '') as String;
      _goalWhyCtrl.text = (data['goal_why'] ?? '') as String;
      _mainObstacleCtrl.text = (data['main_obstacle'] ?? '') as String;
    }
  }

  bool _isValid() {
    String s(String v) => v.trim();
    if (widget.version == 2) {
      return s(_goalRefinedCtrl.text).length >= 10 &&
          s(_metricNameCtrl.text).isNotEmpty &&
          double.tryParse(_metricFromCtrl.text.trim()) != null &&
          double.tryParse(_metricToCtrl.text.trim()) != null &&
          double.tryParse(_financialGoalCtrl.text.trim()) != null;
    } else if (widget.version == 3) {
      return s(_goalSmartCtrl.text).length >= 10 &&
          s(_s1Ctrl.text).length >= 5 &&
          s(_s2Ctrl.text).length >= 5 &&
          s(_s3Ctrl.text).length >= 5 &&
          s(_s4Ctrl.text).length >= 5;
    } else if (widget.version == 4) {
      return s(_finalWhatCtrl.text).length >= 10 &&
          s(_finalWhenCtrl.text).isNotEmpty &&
          s(_finalHowCtrl.text).length >= 10 &&
          _commitment;
    } else {
      return s(_goalInitialCtrl.text).length >= 10 &&
          s(_goalWhyCtrl.text).length >= 10 &&
          s(_mainObstacleCtrl.text).length >= 10;
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(goalsRepositoryProvider);
      final all = await ref.read(goalVersionsProvider.future);
      final byVersion = {
        for (final m in all) m['version'] as int: Map<String, dynamic>.from(m)
      };
      final latestVersion = byVersion.keys.isEmpty
          ? 0
          : byVersion.keys.reduce((a, b) => a > b ? a : b);

      if (!_isValid()) {
        throw 'Заполните все поля корректно';
      }
      Map<String, dynamic> versionData;
      String goalText;
      if (widget.version == 2) {
        versionData = {
          'goal_refined': _goalRefinedCtrl.text.trim(),
          'metric_name': _metricNameCtrl.text.trim(),
          'metric_from': double.parse(_metricFromCtrl.text.trim()),
          'metric_to': double.parse(_metricToCtrl.text.trim()),
          'financial_goal': double.parse(_financialGoalCtrl.text.trim()),
        };
        goalText = _goalRefinedCtrl.text.trim();
      } else if (widget.version == 3) {
        versionData = {
          'goal_smart': _goalSmartCtrl.text.trim(),
          'sprint1_goal': _s1Ctrl.text.trim(),
          'sprint2_goal': _s2Ctrl.text.trim(),
          'sprint3_goal': _s3Ctrl.text.trim(),
          'sprint4_goal': _s4Ctrl.text.trim(),
        };
        goalText = _goalSmartCtrl.text.trim();
      } else if (widget.version == 4) {
        versionData = {
          'final_what': _finalWhatCtrl.text.trim(),
          'final_when': _finalWhenCtrl.text.trim(),
          'final_how': _finalHowCtrl.text.trim(),
          'commitment': _commitment,
        };
        goalText = _finalWhatCtrl.text.trim();
      } else {
        versionData = {
          'goal_initial': _goalInitialCtrl.text.trim(),
          'goal_why': _goalWhyCtrl.text.trim(),
          'main_obstacle': _mainObstacleCtrl.text.trim(),
        };
        goalText = _goalInitialCtrl.text.trim();
      }

      if (byVersion.containsKey(widget.version)) {
        final row = byVersion[widget.version]!;
        if (widget.version != latestVersion) {
          throw 'Редактировать можно только текущую версию';
        }
        await repo.updateGoalById(
            id: row['id'] as String,
            goalText: goalText,
            versionData: versionData);
      } else {
        if (widget.version != latestVersion + 1) {
          throw 'Нельзя пропустить версии';
        }
        await repo.upsertGoalVersion(
            version: widget.version,
            goalText: goalText,
            versionData: versionData);
      }

      ref.invalidate(goalLatestProvider);
      ref.invalidate(goalVersionsProvider);
      Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'goal',
          message: 'goal_checkpoint_saved v=${widget.version}'));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Цель сохранена')));
      setState(() => _saving = false);
      // Возврат на башню с автоскроллом к следующему уровню
      try {
        context.go('/tower?scrollTo=${_nextLevelNumber()}');
      } catch (e, st) {
        Sentry.captureException(e, stackTrace: st);
      }
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка сохранения: $e')));
    }
  }

  String _title() {
    switch (widget.version) {
      case 2:
        return 'Чекпоинт цели v2 (Метрики)';
      case 3:
        return 'Чекпоинт цели v3 (SMART)';
      case 4:
        return 'Чекпоинт цели v4 (Финал)';
      default:
        return 'Чекпоинт цели v${widget.version}';
    }
  }

  int _nextLevelNumber() {
    if (widget.version == 2) return 5;
    if (widget.version == 3) return 8;
    if (widget.version == 4) return 11;
    return 1;
  }

  String _buildUserContext() {
    final sb = StringBuffer('goal_version: ${widget.version}\n');
    if (widget.version == 2) {
      sb.writeln('goal_refined: ${_goalRefinedCtrl.text.trim()}');
      sb.writeln('metric: ${_metricNameCtrl.text.trim()}');
      sb.writeln(
          'from: ${_metricFromCtrl.text.trim()} to: ${_metricToCtrl.text.trim()}');
      sb.writeln('financial_goal: ${_financialGoalCtrl.text.trim()}');
    } else if (widget.version == 3) {
      sb.writeln('goal_smart: ${_goalSmartCtrl.text.trim()}');
      sb.writeln('sprint1: ${_s1Ctrl.text.trim()}');
      sb.writeln('sprint2: ${_s2Ctrl.text.trim()}');
      sb.writeln('sprint3: ${_s3Ctrl.text.trim()}');
      sb.writeln('sprint4: ${_s4Ctrl.text.trim()}');
    } else if (widget.version == 4) {
      sb.writeln('final_what: ${_finalWhatCtrl.text.trim()}');
      sb.writeln('final_when: ${_finalWhenCtrl.text.trim()}');
      sb.writeln('final_how: ${_finalHowCtrl.text.trim()}');
      sb.writeln('commitment: ${_commitment.toString()}');
    }
    return sb.toString();
  }

  // Прямой колбэк удалён: сообщение сохраняется через лямбда в onAssistantMessage

  void _applySuggestionToForm() {
    final msg = _lastAssistantMessage?.trim();
    if (msg == null || msg.isEmpty) return;
    // Простейший префилл без агрессивного парсинга — минимальные правки
    if (widget.version == 2) {
      if (_goalRefinedCtrl.text.trim().isEmpty) {
        _goalRefinedCtrl.text = msg.split('\n').first.trim();
      }
      // Попытка вытащить числа для from/to
      final numbers = RegExp(r"[-+]?[0-9]*\.?[0-9]+")
          .allMatches(msg)
          .map((m) => m.group(0)!)
          .toList();
      if (_metricFromCtrl.text.trim().isEmpty && numbers.isNotEmpty) {
        _metricFromCtrl.text = numbers.first;
      }
      if (_metricToCtrl.text.trim().isEmpty && numbers.length >= 2) {
        _metricToCtrl.text = numbers[1];
      }
      if (_metricNameCtrl.text.trim().isEmpty) {
        // Наивная эвристика: искать знакомые метрики
        final lower = msg.toLowerCase();
        if (lower.contains('конверси')) {
          _metricNameCtrl.text = 'Конверсия %';
        } else if (lower.contains('выручк') || lower.contains('доход')) {
          _metricNameCtrl.text = 'Выручка';
        } else if (lower.contains('клиент')) {
          _metricNameCtrl.text = 'Количество клиентов';
        }
      }
    } else if (widget.version == 3) {
      if (_goalSmartCtrl.text.trim().isEmpty) {
        _goalSmartCtrl.text = msg.split('\n').first.trim();
      }
      // Простая разбивка на строки для спринтов, если есть ключевые слова
      final lines = msg.split('\n');
      String pick(String key) => lines
          .firstWhere((l) => l.toLowerCase().contains(key), orElse: () => '');
      if (_s1Ctrl.text.trim().isEmpty)
        _s1Ctrl.text =
            pick('недел').replaceAll(RegExp(r'^[^:]*:\s?'), '').trim();
    } else if (widget.version == 4) {
      if (_finalWhatCtrl.text.trim().isEmpty) {
        _finalWhatCtrl.text = msg.split('.').first.trim();
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Предложение Макса применено')));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            try {
              context.go('/tower?scrollTo=${_nextLevelNumber()}');
            } catch (e, st) {
              Sentry.captureException(e, stackTrace: st);
            }
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_loadFailed && _versions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x11000000),
                              blurRadius: 8,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Не удалось загрузить данные версии',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _loadAndFill,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Повторить'),
                          )
                        ],
                      ),
                    ),
                  if (!(_loadFailed && _versions.isEmpty)) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x11000000),
                              blurRadius: 8,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColor.info.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.flag,
                                    color: AppColor.info),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.version == 2
                                      ? 'Сформулируйте измеримую цель и ключевую метрику. Укажите текущие и целевые значения, финансовую цель.'
                                      : (widget.version == 3
                                          ? 'Опишите SMART‑формулировку и цели спринтов. Конкретика и сроки повысят фокус.'
                                          : 'Зафиксируйте финальную формулировку цели, срок и ключевые действия. Подтвердите готовность.'),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 40,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Перейти к форме'),
                                onPressed: () =>
                                    setState(() => _showIntro = false),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!_showIntro)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x11000000),
                                blurRadius: 8,
                                offset: Offset(0, 4))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Встроенный чат Макса (embedded) с микро‑шеймером при автозаполнении
                            SizedBox(
                              height: 420,
                              child: ref.read(currentUserProvider).when(
                                    data: (user) => LeoDialogScreen(
                                      chatId: null,
                                      userContext: _buildUserContext(),
                                      levelContext:
                                          'current_level: ${user?.currentLevel ?? 0}',
                                      bot: 'max',
                                      embedded: true,
                                      onAssistantMessage: (msg) async {
                                        setState(
                                            () => _lastAssistantMessage = msg);
                                        // Показать микро‑шеймер до применения данных
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Применяем предложение…'),
                                            duration:
                                                Duration(milliseconds: 400),
                                          ),
                                        );
                                      },
                                    ),
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                    error: (_, __) => const Center(
                                        child: Text('Ошибка загрузки профиля')),
                                  ),
                            ),
                            const SizedBox(height: 16),
                            GoalVersionForm(
                              version: widget.version,
                              editing: true,
                              goalInitialCtrl: _goalInitialCtrl,
                              goalWhyCtrl: _goalWhyCtrl,
                              mainObstacleCtrl: _mainObstacleCtrl,
                              goalRefinedCtrl: _goalRefinedCtrl,
                              metricNameCtrl: _metricNameCtrl,
                              metricFromCtrl: _metricFromCtrl,
                              metricToCtrl: _metricToCtrl,
                              financialGoalCtrl: _financialGoalCtrl,
                              goalSmartCtrl: _goalSmartCtrl,
                              s1Ctrl: _s1Ctrl,
                              s2Ctrl: _s2Ctrl,
                              s3Ctrl: _s3Ctrl,
                              s4Ctrl: _s4Ctrl,
                              finalWhatCtrl: _finalWhatCtrl,
                              finalWhenCtrl: _finalWhenCtrl,
                              finalHowCtrl: _finalHowCtrl,
                              commitment: _commitment,
                              onCommitmentChanged: (v) =>
                                  setState(() => _commitment = v),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                if (_lastAssistantMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: SizedBox(
                                      height: 44,
                                      child: OutlinedButton.icon(
                                        icon: const Icon(Icons.content_paste),
                                        label:
                                            const Text('Применить предложение'),
                                        onPressed: _applySuggestionToForm,
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: _saving ? null : _save,
                                    child: _saving
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white))
                                        : const Text('Сохранить'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
