import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/widgets/goal_version_form.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
// removed unused AppColor import after intro block removal
import 'package:bizlevel/utils/constant.dart';
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
  bool _saving = false;
  Map<int, Map<String, dynamic>> _versions = {};
  bool _loadFailed = false;
  bool _showIntro = false;
  String? _lastAssistantMessage;
  Set<String> _completedFields = <String>{};
  String? _activeField;
  int _totalFields = 0;
  String? _pendingAutoMessage; // сообщение для тонкой реакции Макса
  int _latestVersion = 0; // номер последней доступной версии

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
      // 43.25: Создать «оболочку» новой версии latest+1 при первом входе
      if (!_versions.containsKey(widget.version) &&
          widget.version == _latestVersion + 1) {
        try {
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
      _fillControllersFor(widget.version);
      await _loadProgress();
      if (mounted) setState(() {});
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      setState(() => _loadFailed = true);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка загрузки данных версии')));
    }
  }

  Future<void> _loadProgress() async {
    try {
      final progress =
          await ref.read(goalProgressProvider(widget.version).future);
      final List<dynamic> raw =
          (progress['completedFields'] as List<dynamic>? ?? <dynamic>[]);
      _completedFields =
          _normalizeCompletedFields(raw.whereType<String>().toSet());
      final req = _requiredFieldsForVersion(widget.version);
      _totalFields = req.length;
      final String? nextField = req.firstWhere(
        (k) => !_completedFields.contains(k),
        orElse: () => req.isEmpty ? '' : req.last,
      );
      _activeField =
          (nextField == null || nextField.isEmpty) ? null : nextField;
      // Автоскролл к активному полю после построения
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
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
        _commitment = rs >= 7;
      } else {
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
      } else if (widget.version == 4) {
        // Новые ключи v4
        final int readiness = _commitment ? 8 : 5; // мягкая проекция
        versionData = {
          'first_three_days': _finalWhatCtrl.text.trim(),
          'start_date': _finalWhenCtrl.text.trim(),
          'accountability_person': _finalHowCtrl.text.trim(),
          'readiness_score': readiness,
        };
        goalText = _finalWhatCtrl.text.trim();
      } else {
        // v1
        versionData = {
          'concrete_result': _goalInitialCtrl.text.trim(),
          'main_pain': _goalWhyCtrl.text.trim(),
          'first_action': _mainObstacleCtrl.text.trim(),
        };
        goalText = _goalInitialCtrl.text.trim();
      }

      // Partial field updates first (atomic JSONB merge on server)
      for (final entry in versionData.entries) {
        try {
          await repo.upsertGoalField(
              version: widget.version, field: entry.key, value: entry.value);
        } catch (e, st) {
          Sentry.captureException(e, stackTrace: st);
          rethrow;
        }
      }

      // Ensure goal_text consistency for latest version (minimal change)
      if (byVersion.containsKey(widget.version)) {
        final row = byVersion[widget.version]!;
        if (widget.version != latestVersion) {
          throw 'Редактировать можно только текущую версию';
        }
        await repo.updateGoalById(
            id: row['id'] as String, goalText: goalText, versionData: {});
      } else {
        if (widget.version != latestVersion + 1) {
          throw 'Нельзя пропустить версии';
        }
        // Create shell version with goal_text (version_data уже частично есть через RPC)
        await repo.upsertGoalVersion(
            version: widget.version, goalText: goalText, versionData: {});
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

  List<String> _requiredFieldsForVersion(int version) {
    if (version == 2) {
      return const [
        'concrete_result',
        'metric_type',
        'metric_current',
        'metric_target',
      ];
    } else if (version == 3) {
      return const [
        'goal_smart',
        'week1_focus',
        'week2_focus',
        'week3_focus',
        'week4_focus',
      ];
    } else if (version == 4) {
      return const [
        'first_three_days',
        'start_date',
        'accountability_person',
        'readiness_score',
      ];
    }
    return const [
      'concrete_result',
      'main_pain',
      'first_action',
    ];
  }

  TextEditingController? _controllerForField(String field) {
    switch (field) {
      case 'concrete_result':
        return _goalInitialCtrl;
      case 'main_pain':
        return _goalWhyCtrl;
      case 'first_action':
        return _mainObstacleCtrl;
      case 'goal_refined':
        return _goalRefinedCtrl; // исторический ключ, маппим на тот же контроллер
      case 'metric_type':
      case 'metric_name':
        return _metricNameCtrl;
      case 'metric_current':
      case 'metric_from':
        return _metricFromCtrl;
      case 'metric_target':
      case 'metric_to':
        return _metricToCtrl;
      case 'financial_goal':
        return _financialGoalCtrl;
      case 'goal_smart':
        return _goalSmartCtrl;
      case 'sprint1_goal':
      case 'week1_focus':
        return _s1Ctrl;
      case 'sprint2_goal':
      case 'week2_focus':
        return _s2Ctrl;
      case 'sprint3_goal':
      case 'week3_focus':
        return _s3Ctrl;
      case 'sprint4_goal':
      case 'week4_focus':
        return _s4Ctrl;
      case 'final_what':
      case 'first_three_days':
        return _finalWhatCtrl;
      case 'final_when':
      case 'start_date':
        return _finalWhenCtrl;
      case 'final_how':
      case 'accountability_person':
        return _finalHowCtrl;
      case 'readiness_score':
        return null; // маппится с переключателя _commitment
    }
    return null;
  }

  Set<String> _normalizeCompletedFields(Set<String> raw) {
    final Set<String> out = {...raw};
    void mapBoth(String oldKey, String newKey) {
      if (raw.contains(oldKey)) out.add(newKey);
      if (raw.contains(newKey)) out.add(oldKey);
    }

    mapBoth('goal_initial', 'concrete_result');
    mapBoth('goal_why', 'main_pain');
    mapBoth('main_obstacle', 'first_action');
    mapBoth('metric_name', 'metric_type');
    mapBoth('metric_from', 'metric_current');
    mapBoth('metric_to', 'metric_target');
    mapBoth('sprint1_goal', 'week1_focus');
    mapBoth('sprint2_goal', 'week2_focus');
    mapBoth('sprint3_goal', 'week3_focus');
    mapBoth('sprint4_goal', 'week4_focus');
    mapBoth('final_what', 'first_three_days');
    mapBoth('final_when', 'start_date');
    mapBoth('final_how', 'accountability_person');
    mapBoth('commitment', 'readiness_score');
    return out;
  }

  Future<void> _saveActiveField() async {
    final String? field = _activeField;
    if (field == null) return;
    final repo = ref.read(goalsRepositoryProvider);
    try {
      // 43.24: Разрешено редактировать только последнюю версию
      if (widget.version != _latestVersion) {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'goal',
          type: 'error',
          level: SentryLevel.warning,
          message: 'goal_edit_blocked_non_latest',
          data: {'version': widget.version, 'latest': _latestVersion},
        ));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Редактировать можно только текущую версию цели')));
        return;
      }
      dynamic value;
      if (field == 'readiness_score') {
        value = _commitment ? 8 : 5; // проекция переключателя в диапазон 1–10
      } else {
        final ctrl = _controllerForField(field);
        value = ctrl?.text.trim();
        if (value is String && value.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Заполните поле перед сохранением')));
          return;
        }
        // Числовые поля
        if (field == 'metric_from' ||
            field == 'metric_current' ||
            field == 'metric_to' ||
            field == 'metric_target' ||
            field == 'financial_goal') {
          final parsed = double.tryParse(value as String);
          if (parsed == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Введите корректное число')));
            return;
          }
          value = parsed;
        }
        // Дополнительные валидации по версии/полю
        if (widget.version == 1) {
          if (field == 'concrete_result' && (value as String).length < 10) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Конкретный результат: минимум 10 символов')));
            return;
          }
          if (field == 'concrete_result' &&
              !(RegExp(r"[0-9]").hasMatch(value as String))) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Добавьте цифру в конкретный результат')));
            return;
          }
          if (field == 'main_pain' && (value as String).length < 10) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Главная проблема: минимум 10 символов')));
            return;
          }
          if (field == 'first_action') {
            final txt = (value as String).toLowerCase();
            final startsLikeVerb = txt.startsWith('позвон') ||
                txt.startsWith('напис') ||
                txt.startsWith('встрет') ||
                txt.startsWith('изуч') ||
                txt.startsWith('сдел') ||
                txt.startsWith('подготов') ||
                txt.split(' ').first.endsWith('ть');
            if (txt.length < 10 || !startsLikeVerb) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Действие: ≥10 символов и начинаться с глагола')));
              return;
            }
          }
        } else if (widget.version == 2) {
          if (field == 'metric_type' && (value as String).isEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Укажите метрику')));
            return;
          }
          if (field == 'metric_target') {
            final curr = double.tryParse(_metricFromCtrl.text.trim());
            final targ = double.tryParse(value.toString());
            if (curr != null && targ != null && targ <= curr) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Целевое должно быть больше текущего')),
              );
              return;
            }
          }
        } else if (widget.version == 3) {
          if ((value as String).length < 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Поле должно содержать ≥ 10 символов')),
            );
            return;
          }
        } else if (widget.version == 4) {
          if (field == 'start_date') {
            final now = DateTime.now();
            DateTime? dt;
            try {
              dt = DateTime.parse(value as String);
            } catch (_) {}
            if (dt == null ||
                dt.isBefore(DateTime(now.year, now.month, now.day)) ||
                dt.isAfter(now.add(const Duration(days: 7)))) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Дата старта: от сегодня до +7 дней')),
              );
              return;
            }
          }
          if (field == 'first_three_days' && (value as String).length < 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('План на 3 дня: минимум 10 символов')),
            );
            return;
          }
        }
      }

      await repo.upsertGoalField(
          version: widget.version, field: field, value: value);
      // Breadcrumb: поле сохранено
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'goal',
        type: 'info',
        level: SentryLevel.info,
        message: 'goal_field_saved',
        data: {'version': widget.version, 'field': field},
      ));
      // Обновить локальный прогресс и перейти к следующему полю
      _completedFields = {..._completedFields, field};
      final req = _requiredFieldsForVersion(widget.version);
      final String? next = req.firstWhere(
        (k) => !_completedFields.contains(k),
        orElse: () => req.isEmpty ? '' : req.last,
      );
      setState(() {
        _activeField = (next == null || next.isEmpty) ? null : next;
      });
      if (_activeField != null) {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'goal',
          type: 'navigation',
          level: SentryLevel.info,
          message: 'goal_next_field_activated',
          data: {'version': widget.version, 'field': _activeField},
        ));
      }
      ref.invalidate(goalProgressProvider);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Сохранено. Следующее поле открыто')));
      // Запросить «тонкую реакцию» Макса: авто‑сообщение без списаний GP (под флагом)
      try {
        if (kEnableClientGoalReactions) {
          final String valStr = value is String ? value : value.toString();
          setState(() {
            _pendingAutoMessage = 'v${widget.version} → $field: ' +
                valStr +
                '\nПодскажи следующий шаг.';
          });
          Sentry.addBreadcrumb(Breadcrumb(
            category: 'goal',
            type: 'info',
            message: 'goal_reaction_requested_client',
            data: {'version': widget.version, 'field': field},
            level: SentryLevel.info,
          ));
        }
      } catch (_) {}
      _scrollToActive();
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка сохранения поля: $e')));
    }
  }

  void _scrollToActive() {
    final String? field = _activeField;
    if (field == null) return;
    final key = _fieldKeys[field];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  List<String> _chipsForActiveField(String field) {
    switch (widget.version) {
      case 1:
        if (field == 'concrete_result')
          return const ['Главная проблема', 'Что мешает сейчас?'];
        if (field == 'main_pain')
          return const ['Действие на завтра', 'Начну с …'];
        return const ['Уточнить результат', 'Добавить цифру в цель'];
      case 2:
        if (field == 'metric_type')
          return const ['Сколько сейчас?', 'Текущее значение'];
        if (field == 'metric_current')
          return const ['Целевое значение', 'Хочу к концу месяца …'];
        return const ['Пересчитать % роста'];
      case 3:
        return const [
          'Неделя 1: фокус',
          'Неделя 2: фокус',
          'Неделя 3: фокус',
          'Неделя 4: фокус'
        ];
      case 4:
        if (field == 'readiness_score')
          return const ['Дата старта', 'Начать в понедельник'];
        if (field == 'start_date') return const ['Кому расскажу', 'Никому'];
        if (field == 'accountability_person') return const ['План на 3 дня'];
        return const ['Готовность 7/10'];
      default:
        return const [];
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
                                      firstPrompt: widget.version == 2
                                          ? 'Сформулируем измеримую цель и метрику. Укажи текущее и целевое значения, затем финансовую цель.'
                                          : (widget.version == 3
                                              ? 'Соберём SMART и 4 недельных фокуса. Начнём с SMART.'
                                              : 'Зафиксируем финальный план, дату старта и готовность. Начнём с плана на 3 дня.'),
                                      recommendedChips: _activeField == null
                                          ? const []
                                          : _chipsForActiveField(_activeField!),
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
                                      // Тонкая реакция Макса: отправить описание сохранённого шага
                                      autoUserMessage: _pendingAutoMessage,
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
                              editableFields:
                                  _activeField == null ? null : {_activeField!},
                              completedFields: _completedFields,
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
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // Компактная «вставка предложения» рядом с полем — оставляем как ActionChip
                                if (_lastAssistantMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ActionChip(
                                      avatar: const Icon(Icons.content_paste,
                                          size: 16),
                                      label: const Text('Вставить предложение'),
                                      onPressed: _applySuggestionToForm,
                                    ),
                                  ),
                                SizedBox(
                                  height: 44,
                                  child: BizLevelButton(
                                    label: 'Сохранить шаг →',
                                    onPressed: _saveActiveField,
                                    variant: BizLevelButtonVariant.secondary,
                                    size: BizLevelButtonSize.md,
                                  ),
                                ),
                                const Spacer(),
                                // Финальная кнопка «Готово → к Башне» показывается, когда все поля заполнены
                                if (_completedFields.length >= _totalFields &&
                                    _totalFields > 0)
                                  SizedBox(
                                    height: 44,
                                    child: BizLevelButton(
                                      label: 'Готово → к Башне',
                                      onPressed: _saving ? null : _save,
                                      variant: BizLevelButtonVariant.primary,
                                      size: BizLevelButtonSize.md,
                                    ),
                                  ),
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
