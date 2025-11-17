// removed need for 'collection' by using core Iterable.nonNulls

String buildMaxUserContext({
  Map<String, dynamic>? goal,
  String? practiceNote,
  List<String>? appliedTools,
  num? metricCurrentUpdated,
  DateTime? targetDate,
}) {
  final List<String> lines = [];
  if (goal != null) {
    final String goalText = (goal['goal_text'] ?? '').toString().trim();
    final String metricCurrent =
        (goal['metric_current'] ?? '').toString().trim();
    final String metricTarget = (goal['metric_target'] ?? '').toString().trim();
    final String targetDateStr = (goal['target_date'] ?? '').toString().trim();
    if (goalText.isNotEmpty) lines.add('goal_text: $goalText');
    if (metricCurrent.isNotEmpty) lines.add('metric_current: $metricCurrent');
    if (metricTarget.isNotEmpty) lines.add('metric_target: $metricTarget');
    if (targetDateStr.isNotEmpty) lines.add('target_date: $targetDateStr');
  }
  if (practiceNote != null && practiceNote.trim().isNotEmpty) {
    lines.add('practice_note: ${practiceNote.trim()}');
  }
  if (appliedTools != null && appliedTools.isNotEmpty) {
    final String tools = appliedTools
        .nonNulls
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join(', ');
    if (tools.isNotEmpty) lines.add('applied_tools: $tools');
  }
  if (metricCurrentUpdated != null) {
    lines.add('metric_current_updated: $metricCurrentUpdated');
  }
  if (targetDate != null) {
    lines.add('target_date: ${targetDate.toIso8601String()}');
  }
  return lines.join('\n');
}
