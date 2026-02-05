const String kCheckpointGoalPlaceholder = '__checkpoint_goal_placeholder__';

bool isCheckpointGoalPlaceholder(String value) {
  return value.trim() == kCheckpointGoalPlaceholder;
}
