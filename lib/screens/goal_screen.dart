import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/widgets/stat_card.dart';
import 'package:bizlevel/widgets/custom_textfield.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/floating_chat_bubble.dart';
import 'package:bizlevel/providers/auth_provider.dart';

class GoalScreen extends ConsumerStatefulWidget {
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends ConsumerState<GoalScreen> {
  final TextEditingController _goalInitialCtrl = TextEditingController();
  final TextEditingController _goalWhyCtrl = TextEditingController();
  final TextEditingController _mainObstacleCtrl = TextEditingController();

  // v2
  final TextEditingController _goalRefinedCtrl = TextEditingController();
  final TextEditingController _metricNameCtrl = TextEditingController();
  final TextEditingController _metricFromCtrl = TextEditingController();
  final TextEditingController _metricToCtrl = TextEditingController();
  final TextEditingController _financialGoalCtrl = TextEditingController();

  // v3
  final TextEditingController _goalSmartCtrl = TextEditingController();
  final TextEditingController _s1Ctrl = TextEditingController();
  final TextEditingController _s2Ctrl = TextEditingController();
  final TextEditingController _s3Ctrl = TextEditingController();
  final TextEditingController _s4Ctrl = TextEditingController();

  // v4
  final TextEditingController _finalWhatCtrl = TextEditingController();
  final TextEditingController _finalWhenCtrl = TextEditingController();
  final TextEditingController _finalHowCtrl = TextEditingController();
  bool _commitment = false;

  Timer? _debounce;
  bool _saving = false;
  int _selectedVersion = 1;
  Map<int, Map<String, dynamic>> _versions = {};
  int _selectedSprint = 1;
  bool _isEditing = false; // режим редактирования текущей версии

  // Sprint check-in form
  final TextEditingController _achievementCtrl = TextEditingController();
  final TextEditingController _metricActualCtrl = TextEditingController();
  bool _usedArtifacts = false;
  bool _consultedLeo = false;
  bool _appliedTechniques = false;
  final TextEditingController _keyInsightCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Загружаем все версии и заполняем контроллеры по текущей
    Future.microtask(() async {
      final all = await ref.read(goalVersionsProvider.future);
      _versions = {
        for (final m in all) m['version'] as int: Map<String, dynamic>.from(m)
      };
      final hasAny = _versions.isNotEmpty;
      // Показываем последнюю версию, если есть, иначе v1
      _selectedVersion =
          hasAny ? (_versions.keys.reduce((a, b) => a > b ? a : b)) : 1;
      // Если записей ещё нет — сразу редактируем v1; если есть — стартуем в просмотре
      _isEditing = !hasAny;
      _fillControllersFor(_selectedVersion);
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
    super.dispose();
  }

  // Автосохранение отключено

  bool _isValidV1() {
    String s(String v) => v.trim();
    return s(_goalInitialCtrl.text).length >= 10 &&
        s(_goalWhyCtrl.text).length >= 10 &&
        s(_mainObstacleCtrl.text).length >= 10;
  }

  bool _isValidV2() {
    String s(String v) => v.trim();
    return s(_goalRefinedCtrl.text).length >= 10 &&
        s(_metricNameCtrl.text).isNotEmpty &&
        double.tryParse(_metricFromCtrl.text.trim()) != null &&
        double.tryParse(_metricToCtrl.text.trim()) != null &&
        double.tryParse(_financialGoalCtrl.text.trim()) != null;
  }

  bool _isValidV3() {
    String s(String v) => v.trim();
    return s(_goalSmartCtrl.text).length >= 10 &&
        s(_s1Ctrl.text).length >= 5 &&
        s(_s2Ctrl.text).length >= 5 &&
        s(_s3Ctrl.text).length >= 5 &&
        s(_s4Ctrl.text).length >= 5;
  }

  bool _isValidV4() {
    String s(String v) => v.trim();
    return s(_finalWhatCtrl.text).length >= 10 &&
        s(_finalWhenCtrl.text).isNotEmpty &&
        s(_finalHowCtrl.text).length >= 10 &&
        _commitment;
  }

  Future<void> _saveGoal({bool silent = false}) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(goalsRepositoryProvider);
      // Определяем существующие версии и последнюю
      final all = await ref.read(goalVersionsProvider.future);
      final byVersion = {
        for (final m in all) m['version'] as int: Map<String, dynamic>.from(m)
      };
      final latestVersion = byVersion.keys.isEmpty
          ? 0
          : byVersion.keys.reduce((a, b) => a > b ? a : b);

      // Сборка данных по выбранной версии
      Map<String, dynamic> versionData;
      String goalText;
      if (_selectedVersion == 1) {
        if (!_isValidV1()) throw 'Заполните все поля v1';
        versionData = {
          'goal_initial': _goalInitialCtrl.text.trim(),
          'goal_why': _goalWhyCtrl.text.trim(),
          'main_obstacle': _mainObstacleCtrl.text.trim(),
        };
        goalText = _goalInitialCtrl.text.trim();
      } else if (_selectedVersion == 2) {
        if (!_isValidV2()) throw 'Заполните все поля v2 корректно';
        versionData = {
          'goal_refined': _goalRefinedCtrl.text.trim(),
          'metric_name': _metricNameCtrl.text.trim(),
          'metric_from': double.parse(_metricFromCtrl.text.trim()),
          'metric_to': double.parse(_metricToCtrl.text.trim()),
          'financial_goal': double.parse(_financialGoalCtrl.text.trim()),
        };
        goalText = _goalRefinedCtrl.text.trim();
      } else if (_selectedVersion == 3) {
        if (!_isValidV3()) throw 'Заполните все поля v3';
        versionData = {
          'goal_smart': _goalSmartCtrl.text.trim(),
          'sprint1_goal': _s1Ctrl.text.trim(),
          'sprint2_goal': _s2Ctrl.text.trim(),
          'sprint3_goal': _s3Ctrl.text.trim(),
          'sprint4_goal': _s4Ctrl.text.trim(),
        };
        goalText = _goalSmartCtrl.text.trim();
      } else {
        if (!_isValidV4())
          throw 'Заполните все поля v4 и подтвердите готовность';
        versionData = {
          'final_what': _finalWhatCtrl.text.trim(),
          'final_when': _finalWhenCtrl.text.trim(),
          'final_how': _finalHowCtrl.text.trim(),
          'commitment': _commitment,
        };
        goalText = _finalWhatCtrl.text.trim();
      }

      // Создание/обновление в зависимости от существования записи для выбранной версии
      if (byVersion.containsKey(_selectedVersion)) {
        final row = byVersion[_selectedVersion]!;
        // Редактируем только последнюю доступную версию
        if (_selectedVersion != latestVersion) {
          throw 'Редактировать можно только текущую версию';
        }
        await repo.updateGoalById(
          id: row['id'] as String,
          goalText: goalText,
          versionData: versionData,
        );
      } else {
        // Создаём новую версию только если выбранная = последняя + 1
        if (_selectedVersion != latestVersion + 1) {
          throw 'Нельзя пропустить версии';
        }
        await repo.upsertGoalVersion(
          version: _selectedVersion,
          goalText: goalText,
          versionData: versionData,
        );
      }

      if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Цель сохранена')),
        );
      }

      // Инвалидируем провайдеры
      ref.invalidate(goalLatestProvider);
      ref.invalidate(goalVersionsProvider);
      setState(() {
        _saving = false;
        _isEditing = false; // после сохранения показываем режим просмотра
      });
    } catch (e) {
      setState(() => _saving = false);
      if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      }
    }
  }

  void _fillControllersFor(int version) {
    // Очистка или заполнение из данных
    Map<String, dynamic>? v(int idx) {
      final raw = _versions[idx]?['version_data'];
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

  @override
  Widget build(BuildContext context) {
    final quoteAsync = ref.watch(dailyQuoteProvider);

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
      appBar: AppBar(title: const Text('Цель')),
      body: Stack(children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Мотивация от Leo
              Row(
                children: [
                  const StatCard(title: 'Фокус', icon: Icons.bolt),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.shadowColor.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: quoteAsync.when(
                        data: (q) {
                          final text = q?['quote_text'] as String? ??
                              '«Каждый день — новый шаг к цели»';
                          final author = q?['author'] as String? ?? 'Leo';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Мотивация от Leo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text('“$text” — $author'),
                            ],
                          );
                        },
                        loading: () => const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, __) =>
                            const Text('Не удалось загрузить цитату'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Переключатель версий v1..v4
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (i) {
                  final v = i + 1;
                  final isSelected = _selectedVersion == v;
                  final bool hasAny = _versions.isNotEmpty;
                  final int latest = hasAny
                      ? _versions.keys.reduce((a, b) => a > b ? a : b)
                      : 0;
                  final available = v <= allowedMax &&
                      ((!hasAny && v == 1) ||
                          _versions.containsKey(v) ||
                          (hasAny && v == latest + 1));
                  return ChoiceChip(
                    label: Text('v$v'),
                    selected: isSelected,
                    onSelected: available
                        ? (sel) {
                            if (!sel) return;
                            setState(() {
                              _selectedVersion = v;
                              _fillControllersFor(v);
                              // Логика редактирования при переключении версий:
                              final hasAny = _versions.isNotEmpty;
                              final latest = hasAny
                                  ? _versions.keys
                                      .reduce((a, b) => a > b ? a : b)
                                  : 0;
                              final exists = _versions.containsKey(v);
                              // Если выбираем новую (latest+1) → сразу редактируем без карандаша
                              if (!exists && v == latest + 1) {
                                _isEditing = true;
                              } else {
                                // Для существующих версий по умолчанию просмотр
                                _isEditing = false;
                              }
                            });
                          }
                        : null,
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Кристаллизация цели (динамично по версии) + иконка «Редактировать»
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Кристаллизация цели v$_selectedVersion',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Builder(builder: (context) {
                    final hasAny = _versions.isNotEmpty;
                    final latest = hasAny
                        ? _versions.keys.reduce((a, b) => a > b ? a : b)
                        : 0;
                    final exists = _versions.containsKey(_selectedVersion);
                    final canEdit = exists && _selectedVersion == latest;
                    return IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      tooltip: 'Редактировать',
                      onPressed: (canEdit && !_isEditing)
                          ? () => setState(() => _isEditing = true)
                          : null,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 12),

              if (_selectedVersion == 1) ...[
                _LabeledField(
                    label: 'Чего хочу достичь за 28 дней*',
                    child: CustomTextBox(
                        controller: _goalInitialCtrl,
                        readOnly: !_isEditing,
                        hint: 'Опишите цель (мин. 10 символов)')),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Почему это важно именно сейчас*',
                    child: CustomTextBox(
                        controller: _goalWhyCtrl,
                        readOnly: !_isEditing,
                        hint: 'Обоснование (мин. 10 символов)')),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Главное препятствие*',
                    child: CustomTextBox(
                        controller: _mainObstacleCtrl,
                        readOnly: !_isEditing,
                        hint: 'Что мешает? (мин. 10 символов)')),
              ] else if (_selectedVersion == 2) ...[
                _LabeledField(
                    label: 'Конкретная цель*',
                    child: CustomTextBox(
                        controller: _goalRefinedCtrl,
                        readOnly: !_isEditing,
                        hint: 'Уточнённая формулировка (мин. 10)')),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Ключевая метрика*',
                    child: CustomTextBox(
                        controller: _metricNameCtrl,
                        readOnly: !_isEditing,
                        hint: 'Напр. «клиенты»')),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: _LabeledField(
                        label: 'Текущее значение*',
                        child: CustomTextBox(
                            controller: _metricFromCtrl,
                            readOnly: !_isEditing,
                            hint: 'число')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LabeledField(
                        label: 'Целевое значение*',
                        child: CustomTextBox(
                            controller: _metricToCtrl,
                            readOnly: !_isEditing,
                            hint: 'число')),
                  ),
                ]),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Финансовый результат в ₸*',
                    child: CustomTextBox(
                        controller: _financialGoalCtrl,
                        readOnly: !_isEditing,
                        hint: 'число')),
              ] else if (_selectedVersion == 3) ...[
                _LabeledField(
                    label: 'SMART-формулировка цели*',
                    child: CustomTextBox(
                        controller: _goalSmartCtrl,
                        readOnly: !_isEditing,
                        hint: 'SMART')),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Спринт 1 (1–7)*',
                    child: CustomTextBox(
                        controller: _s1Ctrl,
                        hint: 'кратко',
                        readOnly: !_isEditing)),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Спринт 2 (8–14)*',
                    child: CustomTextBox(
                        controller: _s2Ctrl,
                        hint: 'кратко',
                        readOnly: !_isEditing)),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Спринт 3 (15–21)*',
                    child: CustomTextBox(
                        controller: _s3Ctrl,
                        hint: 'кратко',
                        readOnly: !_isEditing)),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Спринт 4 (22–28)*',
                    child: CustomTextBox(
                        controller: _s4Ctrl,
                        hint: 'кратко',
                        readOnly: !_isEditing)),
              ] else ...[
                _LabeledField(
                    label: 'Что именно достигну*',
                    child: CustomTextBox(
                        controller: _finalWhatCtrl,
                        readOnly: !_isEditing,
                        hint: 'конкретно')),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'К какой дате (28 дней)*',
                    child: CustomTextBox(
                        controller: _finalWhenCtrl,
                        readOnly: !_isEditing,
                        hint: 'дата')),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Через какие ключевые действия*',
                    child: CustomTextBox(
                        controller: _finalHowCtrl,
                        readOnly: !_isEditing,
                        hint: '3 шага')),
                const SizedBox(height: 8),
                Row(children: [
                  Checkbox(
                      value: _commitment,
                      onChanged: _isEditing
                          ? (v) => setState(() => _commitment = v ?? false)
                          : null),
                  const Text('✓ Я готов к реализации'),
                ]),
              ],

              const SizedBox(height: 12),
              Row(children: [
                ElevatedButton(
                  onPressed:
                      (!_saving && _isEditing) ? () => _saveGoal() : null,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Сохранить'),
                ),
                const SizedBox(width: 12),
                Text(
                  _isEditing
                      ? 'Автосохранение каждые 200 мс'
                      : 'Режим просмотра',
                  style: const TextStyle(color: Colors.grey),
                ),
              ]),

              const SizedBox(height: 24),
              // Путь к цели (28-дневный спринт)
              _buildSprintSection(context),
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20 + kBottomNavigationBarHeight,
          child: FloatingChatBubble(
            chatId: null,
            systemPrompt:
                'Режим трекера цели: обсуждаем версию v$_selectedVersion и прогресс спринтов. Будь краток, поддерживай фокус, предлагай следующий шаг.',
            userContext: _buildTrackerUserContext(),
            levelContext: 'current_level: $currentLevel',
            bot: 'max',
          ),
        )
      ]),
    );
  }

  String _buildTrackerUserContext() {
    final vData = (_versions[_selectedVersion]?['version_data'] as Map?) ?? {};
    final sb = StringBuffer('goal_version: $_selectedVersion\n');
    if (_selectedVersion == 1) {
      sb.writeln('goal_initial: ${vData['goal_initial'] ?? ''}');
      sb.writeln('goal_why: ${vData['goal_why'] ?? ''}');
      sb.writeln('main_obstacle: ${vData['main_obstacle'] ?? ''}');
    } else if (_selectedVersion == 2) {
      sb.writeln('goal_refined: ${vData['goal_refined'] ?? ''}');
      sb.writeln('metric: ${vData['metric_name'] ?? ''}');
      sb.writeln(
          'from: ${vData['metric_from'] ?? ''} to: ${vData['metric_to'] ?? ''}');
      sb.writeln('financial_goal: ${vData['financial_goal'] ?? ''}');
    } else if (_selectedVersion == 3) {
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

  Widget _buildSprintSection(BuildContext context) {
    // Доступно после v4: если нет v4 — показываем 🔒
    final hasV4 = _versions.containsKey(4);
    if (!hasV4) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.lock, color: Colors.grey),
            SizedBox(width: 8),
            Expanded(
              child: Text('Путь к цели доступен после заполнения v4',
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Путь к цели • Спринт $_selectedSprint',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          // Переключатель спринтов 1..4
          Row(
            children: List.generate(4, (i) {
              final s = i + 1;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('Спринт $s'),
                  selected: _selectedSprint == s,
                  onSelected: (sel) {
                    if (!sel) return;
                    setState(() => _selectedSprint = s);
                    // Попробуем подгрузить сохранённый чек-ин
                    _loadSprintIfAny(s);
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Форма чек-ина спринта
          _LabeledField(
              label: 'Что достигнуто',
              child:
                  CustomTextBox(controller: _achievementCtrl, hint: 'кратко')),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _LabeledField(
                  label: 'Ключевая метрика (факт)',
                  child: CustomTextBox(
                      controller: _metricActualCtrl, hint: 'значение')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _LabeledField(
                  label: 'Главный инсайт недели',
                  child: CustomTextBox(
                      controller: _keyInsightCtrl, hint: 'кратко')),
            ),
          ]),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              FilterChip(
                label: const Text('Использовал артефакты'),
                selected: _usedArtifacts,
                onSelected: (v) => setState(() => _usedArtifacts = v),
              ),
              FilterChip(
                label: const Text('Консультировался с Leo'),
                selected: _consultedLeo,
                onSelected: (v) => setState(() => _consultedLeo = v),
              ),
              FilterChip(
                label: const Text('Применял техники из уроков'),
                selected: _appliedTechniques,
                onSelected: (v) => setState(() => _appliedTechniques = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.checklist),
              label: const Text('📝 Записать итоги спринта'),
              onPressed: _onSaveSprint,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadSprintIfAny(int sprintNumber) async {
    final existing = await ref.read(sprintProvider(sprintNumber).future);
    if (existing == null) {
      _achievementCtrl.text = '';
      _metricActualCtrl.text = '';
      _keyInsightCtrl.text = '';
      _usedArtifacts = false;
      _consultedLeo = false;
      _appliedTechniques = false;
      if (mounted) setState(() {});
      return;
    }
    _achievementCtrl.text = (existing['achievement'] ?? '') as String;
    _metricActualCtrl.text = (existing['metric_actual'] ?? '') as String;
    _keyInsightCtrl.text = (existing['key_insight'] ?? '') as String;
    _usedArtifacts = (existing['used_artifacts'] ?? false) as bool;
    _consultedLeo = (existing['consulted_leo'] ?? false) as bool;
    _appliedTechniques = (existing['applied_techniques'] ?? false) as bool;
    if (mounted) setState(() {});
  }

  Future<void> _onSaveSprint() async {
    try {
      final repo = ref.read(goalsRepositoryProvider);
      await repo.upsertSprint(
        sprintNumber: _selectedSprint,
        achievement: _achievementCtrl.text.trim().isEmpty
            ? null
            : _achievementCtrl.text.trim(),
        metricActual: _metricActualCtrl.text.trim().isEmpty
            ? null
            : _metricActualCtrl.text.trim(),
        usedArtifacts: _usedArtifacts,
        consultedLeo: _consultedLeo,
        appliedTechniques: _appliedTechniques,
        keyInsight: _keyInsightCtrl.text.trim().isEmpty
            ? null
            : _keyInsightCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Итоги спринта сохранены')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения итогов: $e')));
    }
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
