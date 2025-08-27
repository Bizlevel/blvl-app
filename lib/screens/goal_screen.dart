import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/widgets/custom_textfield.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/floating_chat_bubble.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

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
  // ignore: unused_field
  bool _saving = false;
  int _selectedVersion = 1;
  Map<int, Map<String, dynamic>> _versions = {};
  int _selectedSprint = 1;
  // Редактирование отключено на странице «Цель» (read-only таблица)
  // ignore: unused_field
  bool _isEditing = false;
  bool _sprintSaved = false; // флаг успешного сохранения спринта
  bool _goalCardExpanded =
      false; // компактная карточка цели: свёрнута/развёрнута
  bool _historyExpanded = false; // история версий: свёрнута/развёрнута
  final GlobalKey _sprintSectionKey = GlobalKey();
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
      // По умолчанию стартуем в режиме просмотра (в т.ч. когда v1 ещё нет — раздел заблокирован)
      _isEditing = false;
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

  // 1) Компактная карточка цели
  Widget _buildCompactGoalCard(BuildContext context) {
    final latest = _versions.isEmpty
        ? null
        : _versions[_versions.keys.reduce((a, b) => a > b ? a : b)];
    final latestVersion = latest == null ? 0 : latest['version'] as int? ?? 0;
    final data = latest == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from((latest['version_data'] as Map?) ?? {});

    final String title = latestVersion == 4
        ? (data['final_what']?.toString() ?? 'Цель пока не сформулирована')
        : latestVersion == 3
            ? (data['goal_smart']?.toString() ?? 'Цель пока не сформулирована')
            : latestVersion == 2
                ? (data['goal_refined']?.toString() ??
                    'Цель пока не сформулирована')
                : (data['goal_initial']?.toString() ??
                    'Цель пока не сформулирована');

    final String? metricName =
        latestVersion >= 2 ? (data['metric_name'] as String?) : null;
    final String? fromV =
        latestVersion >= 2 ? data['metric_from']?.toString() : null;
    final String? toV =
        latestVersion >= 2 ? data['metric_to']?.toString() : null;
    final String? startDate =
        latestVersion >= 4 ? (data['final_when'] as String?) : null;
    final int currentStage = latestVersion.clamp(1, 4);
    final int readinessScore = ((currentStage * 10) / 4).round();

    return InkWell(
      onTap: () => setState(() => _goalCardExpanded = !_goalCardExpanded),
      child: Container(
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
            Text(
              title.isEmpty ? 'Цель пока не сформулирована' : title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: _goalCardExpanded ? null : 1,
              overflow: _goalCardExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Прогресс-бар (значение позже подтянем из weekly_progress)
            LinearProgressIndicator(
              value: _calcOverallProgressPercent(),
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: AppColor.primary,
            ),
            const SizedBox(height: 8),
            if (metricName != null &&
                metricName.isNotEmpty &&
                fromV != null &&
                toV != null)
              Text('Метрика: $metricName • Сейчас: $fromV → Цель: $toV',
                  style: Theme.of(context).textTheme.bodySmall),
            if (startDate != null && startDate.isNotEmpty)
              Text('Дней осталось: ${_daysLeft(startDate)} из 28',
                  style: Theme.of(context).textTheme.bodySmall),
            // Готовность/Статус (простая эвристика на основе этапа)
            Text('Готовность: $readinessScore/10',
                style: Theme.of(context).textTheme.bodySmall),
            Text('Статус: В процессе',
                style: Theme.of(context).textTheme.bodySmall),
            if (_goalCardExpanded) ...[
              const SizedBox(height: 12),
              // Детальный вид: недельный план из v3 (если есть)
              if (latestVersion >= 3) ...[
                _GroupHeader('План по неделям'),
                _bullet(context, 'Неделя 1: ${data['sprint1_goal'] ?? '—'}'),
                _bullet(context, 'Неделя 2: ${data['sprint2_goal'] ?? '—'}'),
                _bullet(context, 'Неделя 3: ${data['sprint3_goal'] ?? '—'}'),
                _bullet(context, 'Неделя 4: ${data['sprint4_goal'] ?? '—'}'),
                const SizedBox(height: 8),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Обсудить с Максом'),
                  onPressed: _openChatWithMax,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  double _calcOverallProgressPercent() {
    final dataV2 = _getV2Data();
    final double? from = dataV2.$2;
    final double? to = dataV2.$3;
    final double? current = _getCurrentMetricActual();
    if (from != null && to != null && current != null && to != from) {
      final pct = ((current - from) / (to - from)).clamp(0.0, 1.0);
      return pct.isNaN ? 0.0 : pct;
    }
    return 0.0;
  }

  int _daysLeft(String startDateIso) {
    try {
      final start = DateTime.tryParse(startDateIso)?.toUtc();
      if (start == null) return 28;
      final diff = DateTime.now().toUtc().difference(start).inDays;
      final left = 28 - diff;
      return left.clamp(0, 28);
    } catch (_) {
      return 28;
    }
  }

  Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  // 2) Мой прогресс — горизонтальная линия + подписи
  Widget _buildProgressWidget(BuildContext context) {
    final pct = (_calcOverallProgressPercent() * 100).round();
    // Попробуем получить данные текущей недели (v4 от даты старта)
    final int week = _currentWeekNumber();
    // NB: sprintProvider — async, здесь берём только быстрые поля из контроллеров,
    // которые заполняются при выборе недели/сохранении. Для полноты можно добавить
    // отдельную подзагрузку по провайдеру, но сохраним минимальные изменения.
    final String achievement = _achievementCtrl.text.trim();
    final String metricActual = _metricActualCtrl.text.trim();
    final String insight = _keyInsightCtrl.text.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text('Мой прогресс',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (pct / 100).clamp(0, 1).toDouble(),
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            color: AppColor.primary,
          ),
          const SizedBox(height: 12),
          // Подписи «X из Y …», «Динамика», «Прогноз»
          Builder(builder: (context) {
            final (String? metricName, double? from, double? to) = _getV2Data();
            final double? current = _getCurrentMetricActual();
            final int weeksPassed = (_currentWeekNumber() - 1).clamp(0, 4);
            final List<Widget> lines = [];
            if (metricName != null &&
                metricName.isNotEmpty &&
                to != null &&
                current != null) {
              lines.add(Text(
                '${_fmt(current)} из ${_fmt(to)} $metricName',
                style: Theme.of(context).textTheme.bodyMedium,
              ));
            }
            if (from != null && current != null && from != 0) {
              final deltaPct = (((current - from) / from) * 100).round();
              lines.add(Text(
                'Динамика: ${deltaPct >= 0 ? '+' : ''}$deltaPct% за $weeksPassed недель',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade700),
              ));
            }
            if (from != null && to != null && current != null && to != from) {
              final forecast = (((current - from) / (to - from)) * 100)
                  .clamp(0, 100)
                  .round();
              lines.add(Text(
                'Прогноз: $forecast% от цели',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade700),
              ));
            }
            // Промежуточные показатели недели
            lines.add(const SizedBox(height: 8));
            lines.add(Text(
              'Неделя $week — промежуточные результаты',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ));
            if (achievement.isNotEmpty) {
              lines.add(Text('Достижение: $achievement',
                  style: Theme.of(context).textTheme.bodySmall));
            }
            if (metricActual.isNotEmpty) {
              lines.add(Text('Факт метрики: $metricActual',
                  style: Theme.of(context).textTheme.bodySmall));
            }
            if (insight.isNotEmpty) {
              lines.add(Text('Инсайт: $insight',
                  style: Theme.of(context).textTheme.bodySmall));
            }
            return Column(
              children: [
                ...lines.map((w) =>
                    Padding(padding: const EdgeInsets.only(top: 2), child: w)),
                const SizedBox(height: 8),
              ],
            );
          }),
          // Убрали мини-метрики — достаточно строк выше
        ],
      ),
    );
  }

  // _miniMetric удалён — не используется в новой версии прогресс‑виджета

  // _buildCurrentWeekSummary удалён — блок «Текущая неделя» исключён

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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF8FAFC), Color(0xFFE0F2FE)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.shadowColor.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: quoteAsync.when(
                      data: (q) {
                        if (q == null) {
                          // Данных нет (пусто/офлайн без кеша) — показываем компактный плейсхолдер с аватаром
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage(
                                    'assets/images/avatars/avatar_max.png'),
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Цитата недоступна',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey.shade600,
                                        height: 1.4,
                                      ),
                                ),
                              )
                            ],
                          );
                        }
                        final text = (q['quote_text'] as String?) ?? '';
                        final String? author = q['author'] as String?;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Аватар Макса
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: const AssetImage(
                                  'assets/images/avatars/avatar_max.png'),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(width: 16),
                            // Цитата и автор
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final isDesktop =
                                          constraints.maxWidth > 600;
                                      return Text(
                                        'Мотивация от Макса',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: isDesktop
                                                  ? (Theme.of(context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.fontSize ??
                                                          16) +
                                                      1
                                                  : null,
                                            ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '"$text"',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          height: 1.4,
                                        ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  if (author != null && author.isNotEmpty)
                                    Text(
                                      '— $author',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColor.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Скелетон аватара
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Скелетон текста
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 120,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 80,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      error: (_, __) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                                'assets/images/avatars/avatar_max.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Цитата недоступна',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Единый блок: Моя цель + Кристаллизация цели
                  Container(
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
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        _buildCompactGoalCard(context),
                        const SizedBox(height: 16),
                        // Заголовок секции «Кристаллизация цели»
                        Text(
                          'Кристаллизация цели',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        // Индикатор кристаллизации 4-сегментный + подпись «Этап N из 4»
                        Builder(builder: (context) {
                          final bool hasAny = _versions.isNotEmpty;
                          final int latest = hasAny
                              ? _versions.keys.reduce((a, b) => a > b ? a : b)
                              : 1;
                          final int currentStage = latest.clamp(1, 4);
                          if (latest >= 4) {
                            // Завершено: показываем строку с Историей справа
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Кристаллизация завершена',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                TextButton.icon(
                                  icon: Icon(
                                    _historyExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.history,
                                  ),
                                  label: Text(_historyExpanded
                                      ? 'Свернуть историю'
                                      : 'История'),
                                  onPressed: () {
                                    setState(() =>
                                        _historyExpanded = !_historyExpanded);
                                    Sentry.addBreadcrumb(Breadcrumb(
                                      category: 'ui',
                                      type: 'click',
                                      message: 'goal_history_toggle',
                                      data: {'expanded': _historyExpanded},
                                      level: SentryLevel.info,
                                    ));
                                  },
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Этап $currentStage из 4: ${_getVersionLabel(currentStage)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(4, (i) {
                                  final s = i + 1;
                                  final filled = s <= currentStage;
                                  return Expanded(
                                    child: Container(
                                      height: 8,
                                      margin:
                                          EdgeInsets.only(right: i < 3 ? 6 : 0),
                                      decoration: BoxDecoration(
                                        color: filled
                                            ? AppColor.primary
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 12),
                        Builder(builder: (context) {
                          final bool hasAny = _versions.isNotEmpty;
                          final int latest = hasAny
                              ? _versions.keys.reduce((a, b) => a > b ? a : b)
                              : 0;
                          if (latest >= 4) {
                            // Показать историю при развороте
                            return _historyExpanded
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildHistoryTimeline(context),
                                    ],
                                  )
                                : const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Переключатель версий 1..4: один ряд, компактные кнопки, без галочек
                              Row(
                                children: List.generate(4, (i) {
                                  final v = i + 1;
                                  final isSelected = _selectedVersion == v;
                                  final available = v <= allowedMax &&
                                      ((!hasAny && v == 1) ||
                                          _versions.containsKey(v) ||
                                          (hasAny && v == latest + 1));

                                  final String labelText = _getVersionLabel(v);

                                  final chip = ChoiceChip(
                                    showCheckmark: false,
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    visualDensity: const VisualDensity(
                                        horizontal: -3, vertical: -3),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    label: Text(
                                      labelText,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    selected: isSelected,
                                    selectedColor: AppColor.premium
                                        .withValues(alpha: 0.18),
                                    backgroundColor: Colors.white,
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppColor.premium
                                            : AppColor.borderColor,
                                      ),
                                    ),
                                    onSelected: available
                                        ? (sel) {
                                            if (!sel) return;
                                            setState(() {
                                              _selectedVersion = v;
                                              _fillControllersFor(v);
                                              _isEditing = false;
                                            });
                                          }
                                        : null,
                                  );

                                  return Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: i < 3 ? 8 : 0),
                                      child: SizedBox(height: 36, child: chip),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 12),
                              _buildVersionTable(context, _selectedVersion),
                              const SizedBox(height: 12),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2) Прогресс-виджет (визуальная мотивация)
                  _buildProgressWidget(context),

                  const SizedBox(height: 20),

                  // Блок «Текущая неделя» удалён по новой спецификации
                  // Путь к цели (28-дневный спринт)
                  _buildSprintSection(context),
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

  String _getVersionLabel(int version) {
    switch (version) {
      case 1:
        return '1. Набросок';
      case 2:
        return '2. Метрики';
      case 3:
        return '3. SMART';
      case 4:
        return '4. Финал';
      default:
        return '$version';
    }
  }

  // Удалены: _getVersionStatus/_getVersionTooltip не используются после упрощения UI переключателя

  Widget _buildHistoryTimeline(BuildContext context) {
    List<Widget> items = [];
    for (int v = 1; v <= 4; v++) {
      final ver = _versions[v];
      final present = ver != null;
      final data =
          (ver?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
      String title;
      List<String> lines;
      switch (v) {
        case 1:
          title = 'v1: Набросок';
          lines = [
            (data['goal_initial'] ?? '').toString(),
            if ((data['goal_why'] ?? '').toString().isNotEmpty)
              'Почему: ${data['goal_why']}',
            if ((data['main_obstacle'] ?? '').toString().isNotEmpty)
              'Препятствие: ${data['main_obstacle']}',
          ];
          break;
        case 2:
          title = 'v2: Метрики';
          lines = [
            'Метрика: ${(data['metric_name'] ?? '').toString()}',
            'Сейчас: ${(data['metric_from'] ?? '').toString()} → Цель: ${(data['metric_to'] ?? '').toString()}',
          ];
          break;
        case 3:
          title = 'v3: SMART';
          lines = [
            (data['goal_smart'] ?? '').toString(),
            if ((data['sprint1_goal'] ?? '').toString().isNotEmpty)
              'План по неделям есть',
          ];
          break;
        default:
          title = 'v4: Финал';
          lines = [
            (data['final_what'] ?? '').toString(),
            if ((data['final_when'] ?? '').toString().isNotEmpty)
              'Старт: ${data['final_when']}',
            'Готовность: ${((data['commitment'] ?? false) == true) ? 'Да' : 'Нет'}',
          ];
      }

      items.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: present ? AppColor.primary : Colors.grey.shade300,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                ...lines.where((e) => e.trim().isNotEmpty).map((t) => Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        t,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                      ),
                    )),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
      ));
    }

    return Container(
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
          Text('Эволюция моей цели:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }

  Widget _buildVersionTable(BuildContext context, int version) {
    final Map<String, dynamic> vData =
        (_versions[version]?['version_data'] as Map?)
                ?.cast<String, dynamic>() ??
            {};
    List<List<String>> rows;
    if (version == 1) {
      rows = [
        ['Основная цель', (vData['goal_initial'] ?? '').toString()],
        ['Почему сейчас', (vData['goal_why'] ?? '').toString()],
        ['Препятствие', (vData['main_obstacle'] ?? '').toString()],
      ];
    } else if (version == 2) {
      rows = [
        ['Уточненная цель', (vData['goal_refined'] ?? '').toString()],
        ['Метрика', (vData['metric_name'] ?? '').toString()],
        ['Текущее значение', (vData['metric_from'] ?? '').toString()],
        ['Целевое значение', (vData['metric_to'] ?? '').toString()],
        ['Финансовая цель', (vData['financial_goal'] ?? '').toString()],
      ];
    } else if (version == 3) {
      rows = [
        ['SMART‑формулировка', (vData['goal_smart'] ?? '').toString()],
        ['Спринт 1', (vData['sprint1_goal'] ?? '').toString()],
        ['Спринт 2', (vData['sprint2_goal'] ?? '').toString()],
        ['Спринт 3', (vData['sprint3_goal'] ?? '').toString()],
        ['Спринт 4', (vData['sprint4_goal'] ?? '').toString()],
      ];
    } else {
      rows = [
        ['Что достигну', (vData['final_what'] ?? '').toString()],
        ['К какой дате', (vData['final_when'] ?? '').toString()],
        ['Ключевые действия', (vData['final_how'] ?? '').toString()],
        ['Готовность', ((vData['commitment'] ?? false) == true) ? 'Да' : 'Нет'],
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...rows.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      r[0],
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      r[1].isEmpty ? '—' : r[1],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  // _build7DayTimeline/_buildDayDot удалены — в новой версии не используются

  Widget _buildCheckInForm() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Основные поля
            _GroupHeader('Итоги спринта'),
            _LabeledField(
                label: 'Что достигнуто',
                child: CustomTextBox(
                    controller: _achievementCtrl,
                    hint: 'Опишите главное достижение недели')),
            const SizedBox(height: 12),

            if (isDesktop)
              // Desktop layout - две колонки
              Row(children: [
                Expanded(
                  child: _LabeledField(
                      label: 'Ключевая метрика (факт)',
                      child: CustomTextBox(
                          controller: _metricActualCtrl,
                          keyboardType: TextInputType.number,
                          hint: 'Фактическое значение')),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _LabeledField(
                      label: 'Главный инсайт недели',
                      child: CustomTextBox(
                          controller: _keyInsightCtrl,
                          hint: 'Что поняли или узнали нового')),
                ),
              ])
            else
              // Mobile layout - одна колонка
              Column(children: [
                _LabeledField(
                    label: 'Ключевая метрика (факт)',
                    child: CustomTextBox(
                        controller: _metricActualCtrl,
                        keyboardType: TextInputType.number,
                        hint: 'Фактическое значение')),
                const SizedBox(height: 12),
                _LabeledField(
                    label: 'Главный инсайт недели',
                    child: CustomTextBox(
                        controller: _keyInsightCtrl,
                        hint: 'Что поняли или узнали нового')),
              ]),

            const SizedBox(height: 16),

            // Проверки недели — чекбоксы + «Другое»
            _GroupHeader('Проверки недели'),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Матрица Эйзенхауэра (Ур. 3)'),
                  selected: _chkEisenhower,
                  onSelected: (v) => setState(() => _chkEisenhower = v),
                ),
                FilterChip(
                  label: const Text('Финансовый учёт (Ур. 4)'),
                  selected: _chkAccounting,
                  onSelected: (v) => setState(() => _chkAccounting = v),
                ),
                FilterChip(
                  label: const Text('УТП (Ур. 5)'),
                  selected: _chkUSP,
                  onSelected: (v) => setState(() => _chkUSP = v),
                ),
                FilterChip(
                  label: const Text('SMART‑планирование (Ур. 7)'),
                  selected: _chkSMART,
                  onSelected: (v) => setState(() => _chkSMART = v),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Другое',
              child: CustomTextBox(
                controller: _techOtherCtrl,
                hint: 'Что ещё применяли из уроков',
              ),
            ),
            const SizedBox(height: 16),

            // Кнопки
            Row(
              children: [
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.checklist),
                    label: const Text('📝 Записать итоги недели'),
                    onPressed: _onSaveSprint,
                  ),
                ),
                if (_sprintSaved) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Обсудить с Максом'),
                      onPressed: _openChatWithMax,
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
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
              color: AppColor.shadowColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔒 Путь к цели заблокирован',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Завершите версию v4 для разблокировки 28-дневного пути к цели',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      key: _sprintSectionKey,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          // Заголовок секции
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 600;
              return Text(
                'Путь к цели',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: isDesktop
                          ? (Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontSize ??
                                  16) +
                              1
                          : null,
                    ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Timeline недель 1..4 (горизонтальная лента со статусами)
          _buildWeeksTimelineRow(),
          const SizedBox(height: 12),

          // Переключатель спринтов удалён — выбор через карточки «Нед N» выше
          const SizedBox(height: 12),

          // Мини-таймлайн дней убран по новой спецификации

          // Форма чек-ина спринта
          _buildCheckInForm(),
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

  // 38.16: Горизонтальная лента недель 1..4 со статусами и тапом
  Widget _buildWeeksTimelineRow() {
    final int current = _currentWeekNumber();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(4, (i) {
          final s = i + 1;
          final bool completed = s < current;
          final bool active = s == current;
          final String status = completed
              ? '✅'
              : active
                  ? '⚡'
                  : '⏳';
          final String plan = _getWeekGoalFromV3(s);
          return Padding(
            padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedSprint = s;
                  _sprintSaved = false;
                });
                _loadSprintIfAny(s);
                _scrollToSprintSection();
              },
              child: Container(
                width: 120,
                padding: const EdgeInsets.all(12),
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
                  border: Border.all(
                    color: active ? AppColor.primary : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Нед $s  $status',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      plan.isEmpty ? 'План: —' : 'План: ${plan}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Helpers for 38.14/38.15
  (String?, double?, double?) _getV2Data() {
    final Map<String, dynamic> v2 =
        (_versions[2]?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final String? metricName = (v2['metric_name'] ?? '') as String?;
    final double? from = double.tryParse('${v2['metric_from'] ?? ''}'.trim());
    final double? to = double.tryParse('${v2['metric_to'] ?? ''}'.trim());
    return (metricName, from, to);
  }

  double? _getCurrentMetricActual() {
    final val = _metricActualCtrl.text.trim();
    if (val.isEmpty) return null;
    return double.tryParse(val);
  }

  int _currentWeekNumber() {
    // Если есть дата старта из v4 — вычислим неделю от неё, иначе 1
    final Map<String, dynamic> v4 =
        (_versions[4]?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final String when = (v4['final_when'] ?? '').toString();
    final start = DateTime.tryParse(when)?.toUtc();
    if (start == null) return 1;
    final int days = DateTime.now().toUtc().difference(start).inDays;
    final int week = (days ~/ 7) + 1;
    return week.clamp(1, 4);
  }

  String _getWeekGoalFromV3(int week) {
    final Map<String, dynamic> v3 =
        (_versions[3]?['version_data'] as Map?)?.cast<String, dynamic>() ?? {};
    final key = switch (week) {
      1 => 'sprint1_goal',
      2 => 'sprint2_goal',
      3 => 'sprint3_goal',
      _ => 'sprint4_goal',
    };
    return (v3[key] ?? '').toString();
  }

  void _scrollToSprintSection() {
    final ctx = _sprintSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 300));
    }
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  void _openChatWithMax() {
    // Открываем полноэкранный чат с Максом
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ref.read(currentUserProvider).when(
              data: (user) => LeoDialogScreen(
                chatId: null,
                userContext: _buildTrackerUserContext(),
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

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColor.primary,
            ),
      ),
    );
  }
}
