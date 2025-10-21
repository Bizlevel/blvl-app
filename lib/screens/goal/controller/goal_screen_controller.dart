import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class GoalScreenState {
  const GoalScreenState();
  static const empty = GoalScreenState();
}

class GoalScreenController extends StateNotifier<GoalScreenState> {
  GoalScreenController() : super(GoalScreenState.empty);
}

final goalScreenControllerProvider =
    StateNotifierProvider<GoalScreenController, GoalScreenState>((ref) {
  return GoalScreenController();
});
