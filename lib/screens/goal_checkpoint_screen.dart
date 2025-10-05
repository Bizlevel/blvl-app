import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/utils/friendly_messages.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/widgets/goal_version_form.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
// removed unused AppColor import after intro block removal
// import removed: no longer using feature flags in simplified mode
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';

class GoalCheckpointScreen extends ConsumerStatefulWidget {
  final int version;
  const GoalCheckpointScreen({super.key, required this.version});

  @override
  ConsumerState<GoalCheckpointScreen> createState() =>
      _GoalCheckpointScreenState();
}

class _GoalCheckpointScreenState extends ConsumerState<GoalCheckpointScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  final Map<String, GlobalKey> _fieldKeys = {
    // v1 new keys
    'concrete_result': GlobalKey(),
    'main_pain': GlobalKey(),
    'first_action': GlobalKey(),
    // v2 new keys (+ историческое financial_goal)
    'metric_type': GlobalKey(),
    'metric_current': GlobalKey(),
    'metric_target': GlobalKey(),
    'financial_goal': GlobalKey(),
    // v3 new keys
    'week1_focus': GlobalKey(),
    'week2_focus': GlobalKey(),
    'week3_focus': GlobalKey(),
    'week4_focus': GlobalKey(),
    // v4 new keys
    'first_three_days': GlobalKey(),
    'start_date': GlobalKey(),
    'accountability_person': GlobalKey(),
    'readiness_score': GlobalKey(),
  };
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
  int? _readinessScore; // Значение ползунка готовности (1-10)
  bool _saving = false;
  Map<int, Map<String, dynamic>> _versions = {};
  bool _loadFailed = false;
  final bool _showIntro = false;
  // В упрощённом режиме сохранения не используем подсказки Макса
  int _latestVersion = 0; // номер последней доступной версии
  // Для перезапуска embedded чата с авто-сообщением после сохранения
  Key _embeddedChatKey = UniqueKey();
  String? _autoMessageForChat;

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
      // Определим последнюю доступную версию
      if (_versions.keys.isNotEmpty) {
        _latestVersion = _versions.keys.reduce((a, b) => a > b ? a : b);
      } else {
        _latestVersion = 0;
      }
      // 43.25: Создать «оболочку» новой версии latest+1 при первом входе — только если версия доступна по уровню
      try {
        final user = await ref.read(currentUserProvider.future);
        final lvl = user?.currentLevel ?? 0;
        final allowedMax = _allowedMaxByLevel(lvl);
        final lockedByLevel = widget.version > allowedMax;
        if (!_versions.containsKey(widget.version) &&
            widget.version == _latestVersion + 1 &&
            !lockedByLevel) {
          try {
            // Breadcrumb: Первый вход на чекпоинт
            Sentry.addBreadcrumb(Breadcrumb(
              level: SentryLevel.info,
              category: 'goal',
              message: 'goal_checkpoint_first_enter',
              data: {'version': widget.version},
            ));

            final repo = ref.read(goalsRepositoryProvider);
            await repo.upsertGoalVersion(
                version: widget.version, goalText: '', versionData: {});
            _versions[widget.version] = {
              'version': widget.version,
              'version_data': <String, dynamic>{},
            };
            _latestVersion = widget.version;
          } catch (e, st) {
            Sentry.captureException(e, stackTrace: st);
          }
        }
      } catch (e, st) {
        Sentry.captureException(e, stackTrace: st);
      }
      _fillControllersFor(widget.version);
      // Упрощённый режим: прогресс по шагам не используем
      if (mounted) setState(() {});
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      setState(() => _loadFailed = true);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(FriendlyMessages.goalLoadError)));
    }
  }

  // Прогресс шагов больше не загружаем в упрощённом режиме

  void _fillControllersFor(int version) {
    Map<String, dynamic>? v(int idx) {
      final raw = _versions[idx]?['version_data'];
      if (raw is Map) return Map<String, dynamic>.from(raw);
      return null;
    }

    if (version == 2) {
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
    } else if (version == 4) {
      final data = v(4) ?? {};
      _finalWhatCtrl.text =
          (data['first_three_days'] ?? data['final_what'] ?? '') as String;
      _finalWhenCtrl.text =
          (data['start_date'] ?? data['final_when'] ?? '') as String;
      _finalHowCtrl.text =
          (data['accountability_person'] ?? data['final_how'] ?? '') as String;
      final dynamic rs = data['readiness_score'];
      if (rs is num) {
        _readinessScore = rs.toInt();
        _commitment = rs >= 7;
      } else {
        _readinessScore = null;
        _commitment = (data['commitment'] ?? false) as bool;
      }
    } else if (version == 1) {
      final data = v(1) ?? {};
      _goalInitialCtrl.text =
          (data['concrete_result'] ?? data['goal_initial'] ?? '') as String;
      _goalWhyCtrl.text =
          (data['main_pain'] ?? data['goal_why'] ?? '') as String;
      _mainObstacleCtrl.text =
          (data['first_action'] ?? data['main_obstacle'] ?? '') as String;
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
          (_readinessScore != null && _readinessScore! >= 1);
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
        // Новые ключи v2
        final String concrete = _goalRefinedCtrl.text.trim();
        final String metricType = _metricNameCtrl.text.trim();
        final double? from = double.tryParse(_metricFromCtrl.text.trim());
        final double? to = double.tryParse(_metricToCtrl.text.trim());
        final double? fin = double.tryParse(_financialGoalCtrl.text.trim());
        if (from == null || to == null || fin == null) {
          throw 'Введите числа в полях метрик/фин. цели';
        }
        versionData = {
          'concrete_result': concrete,
          'metric_type': metricType,
          'metric_current': from,
          'metric_target': to,
          'financial_goal': fin,
        };
        goalText = concrete;

        // Breadcrumb: Заполнены поля v2
        Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'goal',
          message: 'goal_checkpoint_field_filled',
          data: {
            'version': widget.version,
            'fields': [
              'concrete_result',
              'metric_type',
              'metric_current',
              'metric_target',
              'financial_goal'
            ],
          },
        ));
      } else if (widget.version == 3) {
        // Новые ключи v3
        versionData = {
          'goal_smart': _goalSmartCtrl.text.trim(),
          'week1_focus': _s1Ctrl.text.trim(),
          'week2_focus': _s2Ctrl.text.trim(),
          'week3_focus': _s3Ctrl.text.trim(),
          'week4_focus': _s4Ctrl.text.trim(),
        };
        goalText = _goalSmartCtrl.text.trim();

        // Breadcrumb: Заполнены поля v3
        Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'goal',
          message: 'goal_checkpoint_field_filled',
          data: {
            'version': widget.version,
            'fields': [
              'goal_smart',
              'week1_focus',
              'week2_focus',
              'week3_focus',
              'week4_focus'
            ],
          },
        ));
      } else if (widget.version == 4) {
        // Новые ключи v4
        final int readiness = _readinessScore ?? (_commitment ? 8 : 5);
        versionData = {
          'first_three_days': _finalWhatCtrl.text.trim(),
          'start_date': _finalWhenCtrl.text.trim(),
          'accountability_person': _finalHowCtrl.text.trim(),
          'readiness_score': readiness,
        };
        goalText = _finalWhatCtrl.text.trim();

        // Breadcrumb: Заполнены поля v4
        Sentry.addBreadcrumb(Breadcrumb(
          level: SentryLevel.info,
          category: 'goal',
          message: 'goal_checkpoint_field_filled',
          data: {
            'version': widget.version,
            'fields': [
              'first_three_days',
              'start_date',
              'accountability_person',
              'readiness_score'
            ],
            'readiness': readiness,
          },
        ));
      } else {
        // v1
        versionData = {
          'concrete_result': _goalInitialCtrl.text.trim(),
          'main_pain': _goalWhyCtrl.text.trim(),
          'first_action': _mainObstacleCtrl.text.trim(),
        };
        goalText = _goalInitialCtrl.text.trim();
      }

      // Проверяем, существует ли уже запись для этой версии
      if (byVersion.containsKey(widget.version)) {
        final row = byVersion[widget.version]!;
        if (widget.version != latestVersion) {
          throw 'Редактировать можно только текущую версию';
        }
        // Обновляем существующую запись
        await repo.updateGoalById(
            id: row['id'] as String,
            goalText: goalText,
            versionData: versionData);
      } else {
        if (widget.version != latestVersion + 1) {
          throw 'Нельзя пропустить версии';
        }
        // Создаем новую запись с полными данными
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
      // После сохранения — комментарий Макса в embedded-чате
      try {
        final commentMsg =
            'Прокомментируй мою цель v${widget.version}.\n${_buildUserContext()}';
        setState(() {
          _autoMessageForChat = commentMsg;
          _embeddedChatKey =
              UniqueKey(); // пересоздать чат и отправить авто-сообщение
        });
      } catch (e, st) {
        Sentry.captureException(e, stackTrace: st);
      }
      // Короткая пауза для UX и авто-переход к следующему узлу в башне
      try {
        final String action = widget.version < 4 ? 'goal_checkpoint' : 'weeks';
        final int target = _nextLevelNumber();
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'goal',
          type: 'info',
          message: 'goal_next_action_resolved',
          data: {'action': action, 'target': target, 'version': widget.version},
          level: SentryLevel.info,
        ));
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        context.go('/tower?scrollTo=${_nextLevelNumber()}');
      } catch (e, st) {
        Sentry.captureException(e, stackTrace: st);
      }
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(FriendlyMessages.saveError)));
    }
  }

  // Контроллеры полей в упрощённом режиме берутся напрямую при сборке versionData

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

  int _allowedMaxByLevel(int lvl) {
    if (lvl >= 11) return 4; // после Уровня 10
    if (lvl >= 8) return 3; // после Уровня 7
    if (lvl >= 5) return 2; // после Уровня 4
    return 1; // после Уровня 1
  }

  int _requiredLevelForVersion(int v) {
    if (v == 2) return 4;
    if (v == 3) return 7;
    if (v == 4) return 10;
    return 1;
  }

  int _nextLevelNumber() {
    if (widget.version == 2) return 5;
    if (widget.version == 3) return 8;
    if (widget.version == 4) return 11;
    return 1;
  }

  /// Приветственное сообщение от Макса для каждой версии
  String _getWelcomeMessage() {
    switch (widget.version) {
      case 2:
        return '''Привет! 👋 Начинаем этап «Метрики».\n\nЗдесь мы превращаем твою цель в измеримый результат. Заполни поля формы:\n• Конкретный результат\n• Метрика и текущее/целевое значения\n• Финансовая цель\n\nПо ходу я дам советы и задам уточняющие вопросы. Поехали! 🚀''';
      case 3:
        return '''Привет! 👋 Переходим к этапу «План на 4 недели».\n\nТеперь разобьём твою цель на 4 недельных фокуса. Каждая неделя — это конкретный шаг к результату.\n\nЗаполни SMART-формулировку и фокусы по неделям. Я помогу сделать их реалистичными и достижимыми! 💪''';
      case 4:
        return '''Привет! 👋 Финальный этап «Готовность к старту».\n\nОсталось зафиксировать:\n• План на первые 3 дня\n• Дату старта\n• Кому расскажешь о цели (для поддержки)\n• Твою готовность по шкале 1-10\n\nПосле этого запустим твои 28 дней! 🎯''';
      default:
        return 'Привет! Я — Макс, твой трекер целей. Заполни форму ниже, а я помогу советами и вопросами.';
    }
  }

  String _buildUserContext() {
    final sb = StringBuffer('goal_version: ${widget.version}\n');
    if (widget.version == 2) {
      sb.writeln('concrete_result: ${_goalRefinedCtrl.text.trim()}');
      sb.writeln('metric_type: ${_metricNameCtrl.text.trim()}');
      sb.writeln(
          'metric_current: ${_metricFromCtrl.text.trim()} metric_target: ${_metricToCtrl.text.trim()}');
      sb.writeln('financial_goal: ${_financialGoalCtrl.text.trim()}');
    } else if (widget.version == 3) {
      sb.writeln('goal_smart: ${_goalSmartCtrl.text.trim()}');
      sb.writeln('sprint1: ${_s1Ctrl.text.trim()}');
      sb.writeln('sprint2: ${_s2Ctrl.text.trim()}');
      sb.writeln('sprint3: ${_s3Ctrl.text.trim()}');
      sb.writeln('sprint4: ${_s4Ctrl.text.trim()}');
    } else if (widget.version == 4) {
      sb.writeln('first_three_days: ${_finalWhatCtrl.text.trim()}');
      sb.writeln('start_date: ${_finalWhenCtrl.text.trim()}');
      sb.writeln('accountability_person: ${_finalHowCtrl.text.trim()}');
      sb.writeln(
          'readiness_score: ${_readinessScore ?? (_commitment ? 8 : 5)}');
    }
    return sb.toString();
  }

  List<String> _recommendedChips() {
    final List<String> chips = <String>[];
    if (widget.version == 2) {
      if (_metricNameCtrl.text.trim().isEmpty) {
        chips.add('Выбрать метрику');
      }
      if (_metricToCtrl.text.trim().isEmpty ||
          double.tryParse(_metricFromCtrl.text.trim()) == null ||
          double.tryParse(_metricToCtrl.text.trim()) == null) {
        chips.add('Подскажи реалистичную цель');
      }
      if (_financialGoalCtrl.text.trim().isEmpty) {
        chips.add('Предложи финансовую цель');
      }
      if (_goalRefinedCtrl.text.trim().isEmpty) {
        chips.add('Сформулировать конкретный результат');
      }
    } else if (widget.version == 3) {
      if (_goalSmartCtrl.text.trim().isEmpty) {
        chips.add('Сформулировать SMART');
      }
      if (_s1Ctrl.text.trim().isEmpty) chips.add('Фокус недели 1');
      if (_s2Ctrl.text.trim().isEmpty) chips.add('Фокус недели 2');
      if (_s3Ctrl.text.trim().isEmpty) chips.add('Фокус недели 3');
      if (_s4Ctrl.text.trim().isEmpty) chips.add('Фокус недели 4');
    } else if (widget.version == 4) {
      if (_finalWhatCtrl.text.trim().isEmpty) {
        chips.add('Сформировать план на 3 дня');
      }
      if (_finalWhenCtrl.text.trim().isEmpty) {
        chips.add('Выбрать дату старта');
      }
      if (_finalHowCtrl.text.trim().isEmpty) {
        chips.add('Кого позвать в ответственные');
      }
      if (_readinessScore == null) {
        chips.add('Оценить готовность');
      }
    }
    final seen = <String>{};
    final out = <String>[];
    for (final c in chips) {
      if (seen.add(c)) out.add(c);
      if (out.length >= 6) break;
    }
    return out;
  }

  // Прямой колбэк удалён: сообщение сохраняется через лямбда в onAssistantMessage

  // Применение предложений Макса не требуется в упрощённом режиме

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
          controller: _scrollCtrl,
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
                        color: AppColor.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColor.shadowColor,
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
                          SizedBox(
                            height: 44,
                            child: BizLevelButton(
                              label: 'Повторить',
                              onPressed: _loadAndFill,
                              variant: BizLevelButtonVariant.primary,
                              size: BizLevelButtonSize.md,
                            ),
                          )
                        ],
                      ),
                    ),
                  if (!(_loadFailed && _versions.isEmpty)) ...[
                    const SizedBox.shrink(),
                    const SizedBox(height: 16),
                    if (widget.version != _latestVersion)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.warning.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColor.warning.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: AppColor.warning),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Редактировать можно только текущую версию v$_latestVersion',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                try {
                                  context
                                      .go('/goal-checkpoint/$_latestVersion');
                                } catch (e, st) {
                                  Sentry.captureException(e, stackTrace: st);
                                }
                              },
                              child: const Text('Перейти'),
                            ),
                          ],
                        ),
                      ),
                    // Preflight-гейтинг версии по текущему уровню пользователя
                    Builder(builder: (context) {
                      final userAsync = ref.watch(currentUserProvider);
                      final lvl = userAsync.asData?.value?.currentLevel ?? 0;
                      final allowedMax = _allowedMaxByLevel(lvl);
                      final requiredLevel =
                          _requiredLevelForVersion(widget.version);
                      final lockedByLevel = widget.version > allowedMax;
                      if (!lockedByLevel) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.labelColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  AppColor.labelColor.withValues(alpha: 0.4)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.lock_outline,
                              color: AppColor.labelColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Версия v${widget.version} откроется после завершения Уровня $requiredLevel',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ]),
                      );
                    }),
                    if (widget.version != _latestVersion)
                      const SizedBox(height: 12),
                    // Подсказка о последовательном заполнении версий
                    if (!_versions.containsKey(widget.version) &&
                        widget.version != _latestVersion + 1)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.labelColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  AppColor.labelColor.withValues(alpha: 0.4)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.timeline,
                              color: AppColor.labelColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Версии заполняются последовательно. Сначала заполните v${_latestVersion + 1}.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              try {
                                context.go(
                                    '/goal-checkpoint/${_latestVersion + 1}');
                              } catch (e, st) {
                                Sentry.captureException(e, stackTrace: st);
                              }
                            },
                            child: const Text('Перейти'),
                          ),
                        ]),
                      ),
                    if (!_showIntro)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: AppColor.shadowColor,
                                blurRadius: 8,
                                offset: Offset(0, 4))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Встроенный чат Макса (embedded): после сохранения отправится авто‑сообщение
                            SizedBox(
                              height: 420,
                              child: ref.read(currentUserProvider).when(
                                    data: (user) => LeoDialogScreen(
                                      key: _embeddedChatKey,
                                      chatId: null,
                                      userContext: _buildUserContext(),
                                      levelContext:
                                          'current_level: ${user?.currentLevel ?? 0}',
                                      bot: 'max',
                                      embedded: true,
                                      initialAssistantMessage:
                                          _getWelcomeMessage(),
                                      firstPrompt: widget.version == 2
                                          ? 'Сформулируем измеримую цель и метрику. Укажи текущее и целевое значения, затем финансовую цель.'
                                          : (widget.version == 3
                                              ? 'Соберём SMART и 4 недельных фокуса. Начнём с SMART.'
                                              : 'Зафиксируем финальный план, дату старта и готовность. Начнём с плана на 3 дня.'),
                                      recommendedChips: _recommendedChips(),
                                      autoUserMessage: _autoMessageForChat,
                                      skipSpend: true,
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
                              editableFields: null, // все поля доступны сразу
                              completedFields: null,
                              fieldKeys: _fieldKeys,
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
                              readinessScore: _readinessScore,
                              onReadinessScoreChanged: (v) => setState(() {
                                _readinessScore = v;
                                _commitment =
                                    v >= 7; // Синхронизируем с ползунком
                              }),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 44,
                              child: BizLevelButton(
                                label: 'Сохранить',
                                onPressed: _saving ? null : _save,
                                variant: BizLevelButtonVariant.primary,
                                size: BizLevelButtonSize.md,
                              ),
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
