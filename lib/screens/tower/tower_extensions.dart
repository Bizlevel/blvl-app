part of '../biz_tower_screen.dart';

// Расширения для безопасного доступа к полям узлов башни
extension TowerNodeX on Map<String, dynamic> {
  String get nodeType => this['type'] as String? ?? 'level';
  Map<String, dynamic> get dataMap =>
      (this['data'] as Map?)?.cast<String, dynamic>() ?? const {};
  bool get isLevel => nodeType == 'level';
  bool get isMiniCase => nodeType == 'mini_case';
  bool get isGoalCheckpoint => nodeType == 'goal_checkpoint';
  int get levelNumber => dataMap['level'] as int? ?? 0;
  bool get isCurrent => dataMap['isCurrent'] == true;
  bool get isLocked => dataMap['isLocked'] == true;
  bool get isCompletedLevel => dataMap['isCompleted'] == true;
  bool get nodeCompleted => this['isCompleted'] as bool? ?? false;
  bool get blockedByCheckpoint => this['blockedByCheckpoint'] as bool? ?? false;
  bool get prevLevelCompleted => this['prevLevelCompleted'] as bool? ?? false;
  int? get caseId => this['caseId'] as int?;
  int get afterLevel => this['afterLevel'] as int? ?? 0;
  int? get goalVersion => this['version'] as int?;
}
