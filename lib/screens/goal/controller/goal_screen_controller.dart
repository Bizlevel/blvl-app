import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';

/// Состояние экрана «Цель». Держит только данные и флаги UI, без контроллеров ввода.
@immutable
class GoalScreenState {
  const GoalScreenState({
    required this.versions,
    required this.selectedVersion,
    required this.goalCardExpanded,
    required this.historyExpanded,
    required this.selectedSprint,
    required this.sprintSaved,
  });

  final Map<int, Map<String, dynamic>> versions; // version -> version_data row
  final int selectedVersion;
  final bool goalCardExpanded;
  final bool historyExpanded;
  final int selectedSprint; // 1..4
  final bool sprintSaved;

  GoalScreenState copyWith({
    Map<int, Map<String, dynamic>>? versions,
    int? selectedVersion,
    bool? goalCardExpanded,
    bool? historyExpanded,
    int? selectedSprint,
    bool? sprintSaved,
  }) {
    return GoalScreenState(
      versions: versions ?? this.versions,
      selectedVersion: selectedVersion ?? this.selectedVersion,
      goalCardExpanded: goalCardExpanded ?? this.goalCardExpanded,
      historyExpanded: historyExpanded ?? this.historyExpanded,
      selectedSprint: selectedSprint ?? this.selectedSprint,
      sprintSaved: sprintSaved ?? this.sprintSaved,
    );
  }

  static const empty = GoalScreenState(
    versions: <int, Map<String, dynamic>>{},
    selectedVersion: 1,
    goalCardExpanded: false,
    historyExpanded: false,
    selectedSprint: 1,
    sprintSaved: false,
  );
}

/// Контроллер экрана «Цель».
/// Инкапсулирует загрузку версий, выбор версии/спринта и базовые вычисления.
class GoalScreenController extends StateNotifier<GoalScreenState> {
  GoalScreenController(this._ref) : super(GoalScreenState.empty);

  final Ref _ref;

  Future<void> loadVersions() async {
    final all = await _ref.read(goalVersionsProvider.future);
    final map = {
      for (final m in all) (m['version'] as int): Map<String, dynamic>.from(m)
    };
    final hasAny = map.isNotEmpty;
    final int last = hasAny ? map.keys.reduce((a, b) => a > b ? a : b) : 1;
    state = state.copyWith(versions: map, selectedVersion: last);
  }

  void selectVersion(int version) {
    state = state.copyWith(selectedVersion: version);
  }

  void toggleHistory() {
    state = state.copyWith(historyExpanded: !state.historyExpanded);
  }

  void toggleGoalCardExpanded() {
    state = state.copyWith(goalCardExpanded: !state.goalCardExpanded);
  }

  void selectSprint(int sprint) {
    state = state.copyWith(selectedSprint: sprint, sprintSaved: false);
  }

  Future<Map<String, dynamic>?> loadSprintIfAny(int sprintNumber) async {
    try {
      final dynamic data = await _ref.read(sprintProvider(sprintNumber).future);
      if (data == null) return null;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSprint({
    required int sprintNumber,
    String? achievement,
    String? metricActual,
    bool? usedArtifacts,
    bool? consultedLeo,
    bool? appliedTechniques,
    String? keyInsight,
    String? artifactsDetails,
    String? consultedBenefit,
    String? techniquesDetails,
  }) async {
    final repo = _ref.read(goalsRepositoryProvider);
    await repo.upsertSprint(
      sprintNumber: sprintNumber,
      achievement: (achievement == null || achievement.trim().isEmpty)
          ? null
          : achievement.trim(),
      metricActual: (metricActual == null || metricActual.trim().isEmpty)
          ? null
          : metricActual.trim(),
      usedArtifacts: usedArtifacts ?? false,
      consultedLeo: consultedLeo ?? false,
      appliedTechniques: appliedTechniques ?? false,
      keyInsight: (keyInsight == null || keyInsight.trim().isEmpty)
          ? null
          : keyInsight.trim(),
      artifactsDetails:
          (artifactsDetails == null || artifactsDetails.trim().isEmpty)
              ? null
              : artifactsDetails.trim(),
      consultedBenefit:
          (consultedBenefit == null || consultedBenefit.trim().isEmpty)
              ? null
              : consultedBenefit.trim(),
      techniquesDetails:
          (techniquesDetails == null || techniquesDetails.trim().isEmpty)
              ? null
              : techniquesDetails.trim(),
    );
    state = state.copyWith(sprintSaved: true);
  }

  // ===== Вычисления / хелперы (без побочных эффектов) =====

  int allowedMaxVersion(int currentLevel) {
    if (currentLevel >= 11) return 4; // после Уровня 10
    if (currentLevel >= 8) return 3; // после Уровня 7
    if (currentLevel >= 5) return 2; // после Уровня 4
    return 1; // после Уровня 1
  }

  (String?, double?, double?) getV2Data() {
    final v2 =
        (state.versions[2]?['version_data'] as Map?)?.cast<String, dynamic>() ??
            {};
    final String? metricName = (v2['metric_type'] ?? '') as String?;
    final double? from =
        double.tryParse('${v2['metric_current'] ?? ''}'.trim());
    final double? to = double.tryParse('${v2['metric_target'] ?? ''}'.trim());
    return (metricName, from, to);
  }

  double calcOverallProgressPercent({double? metricActual}) {
    final (String?, double?, double?) data = getV2Data();
    final double? from = data.$2;
    final double? to = data.$3;
    final double? current = metricActual;
    if (from != null && to != null && current != null && to != from) {
      final pct = ((current - from) / (to - from)).clamp(0.0, 1.0);
      return pct.isNaN ? 0.0 : pct;
    }
    return 0.0;
  }

  int daysLeft(String startDateIso) {
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

  int currentWeekNumber() {
    final Map<String, dynamic> v4 =
        (state.versions[4]?['version_data'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{};
    final String when =
        (state.versions[4]?['sprint_start_date'] ?? v4['start_date'] ?? '')
            .toString();
    final DateTime? start = DateTime.tryParse(when)?.toUtc();
    if (start == null) return 1;
    final int days = DateTime.now().toUtc().difference(start).inDays;
    final int week = (days ~/ 7) + 1;
    return week.clamp(1, 4);
  }

  String getWeekGoalFromV3(int week) {
    final v3 =
        (state.versions[3]?['version_data'] as Map?)?.cast<String, dynamic>() ??
            {};
    final String key = 'week${week}_focus';
    return (v3[key] ?? v3['sprint${week}_goal'] ?? '').toString();
  }

  String getVersionLabel(int version) {
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

  String formatNumber(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  String buildTrackerUserContext({
    String achievement = '',
    String metricActual = '',
    bool usedArtifacts = false,
    bool consultedLeo = false,
    bool appliedTechniques = false,
    String keyInsight = '',
  }) {
    final vData =
        (state.versions[state.selectedVersion]?['version_data'] as Map?) ?? {};
    final sb = StringBuffer('goal_version: ${state.selectedVersion}\n');
    if (state.selectedVersion == 1) {
      sb.writeln('concrete_result: ${vData['concrete_result'] ?? ''}');
      sb.writeln('main_pain: ${vData['main_pain'] ?? ''}');
      sb.writeln('first_action: ${vData['first_action'] ?? ''}');
    } else if (state.selectedVersion == 2) {
      sb.writeln('concrete_result: ${vData['concrete_result'] ?? ''}');
      sb.writeln('metric_type: ${vData['metric_type'] ?? ''}');
      sb.writeln(
          'metric_current: ${vData['metric_current'] ?? ''} metric_target: ${vData['metric_target'] ?? ''}');
      sb.writeln('financial_goal: ${vData['financial_goal'] ?? ''}');
    } else if (state.selectedVersion == 3) {
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
    if (achievement.isNotEmpty ||
        metricActual.isNotEmpty ||
        keyInsight.isNotEmpty) {
      sb.writeln('last_sprint_achievement: $achievement');
      sb.writeln('last_sprint_metric_actual: $metricActual');
      sb.writeln('last_sprint_used_artifacts: $usedArtifacts');
      sb.writeln('last_sprint_consulted_leo: $consultedLeo');
      sb.writeln('last_sprint_applied_techniques: $appliedTechniques');
      sb.writeln('last_sprint_insight: $keyInsight');
    }
    return sb.toString();
  }
}

final goalScreenControllerProvider =
    StateNotifierProvider<GoalScreenController, GoalScreenState>((ref) {
  return GoalScreenController(ref);
});
