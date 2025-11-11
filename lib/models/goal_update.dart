class GoalUpsertRequest {
  final String userId;
  final String goalText;
  final String? metricType;
  final num? metricStart;
  final num? metricCurrent;
  final num? metricTarget;
  final DateTime? startDate;
  final DateTime? targetDate;
  final String? financialFocus;
  final String? actionPlanNote;

  const GoalUpsertRequest({
    required this.userId,
    required this.goalText,
    this.metricType,
    this.metricStart,
    this.metricCurrent,
    this.metricTarget,
    this.startDate,
    this.targetDate,
    this.financialFocus,
    this.actionPlanNote,
  });
}

class StartNewGoalRequest {
  final String userId;
  final String goalText;
  final DateTime? targetDate;
  final num? metricStart;
  final num? metricCurrent;
  final num? metricTarget;

  const StartNewGoalRequest({
    required this.userId,
    required this.goalText,
    this.targetDate,
    this.metricStart,
    this.metricCurrent,
    this.metricTarget,
  });
}
