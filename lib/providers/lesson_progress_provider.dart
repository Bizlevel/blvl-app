import 'dart:convert';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonProgressState {
  final int unlockedPage;
  final Set<int> watchedVideos;
  final Set<int> passedQuizzes;

  const LessonProgressState({
    required this.unlockedPage,
    required this.watchedVideos,
    required this.passedQuizzes,
  });

  LessonProgressState copyWith({
    int? unlockedPage,
    Set<int>? watchedVideos,
    Set<int>? passedQuizzes,
  }) {
    return LessonProgressState(
      unlockedPage: unlockedPage ?? this.unlockedPage,
      watchedVideos: watchedVideos ?? this.watchedVideos,
      passedQuizzes: passedQuizzes ?? this.passedQuizzes,
    );
  }

  Map<String, dynamic> toJson() => {
        'unlockedPage': unlockedPage,
        'watched': watchedVideos.toList(),
        'quizzes': passedQuizzes.toList(),
      };

  factory LessonProgressState.fromJson(Map<String, dynamic> json) {
    return LessonProgressState(
      unlockedPage: json['unlockedPage'] as int? ?? 0,
      watchedVideos:
          (json['watched'] as List<dynamic>? ?? []).cast<int>().toSet(),
      passedQuizzes:
          (json['quizzes'] as List<dynamic>? ?? []).cast<int>().toSet(),
    );
  }

  static const empty = LessonProgressState(
      unlockedPage: 1, watchedVideos: {}, passedQuizzes: {});
}

class LessonProgressNotifier extends StateNotifier<LessonProgressState> {
  final int levelId;
  LessonProgressNotifier(this.levelId) : super(LessonProgressState.empty) {
    _load();
  }

  Timer? _debounce;

  String get _prefsKey => 'level_progress_$levelId';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      state =
          LessonProgressState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (state.unlockedPage < 1) {
        state = state.copyWith(unlockedPage: 1);
        _scheduleSave();
      }
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(state.toJson()));
  }

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), _save);
  }

  void unlockPage(int page) {
    if (page > state.unlockedPage) {
      state = state.copyWith(unlockedPage: page);
      _scheduleSave();
    }
  }

  void markVideoWatched(int page) {
    if (!state.watchedVideos.contains(page)) {
      final updated = Set<int>.from(state.watchedVideos)..add(page);
      state = state.copyWith(watchedVideos: updated);
      _scheduleSave();
    }
  }

  void markQuizPassed(int page) {
    if (!state.passedQuizzes.contains(page)) {
      final updated = Set<int>.from(state.passedQuizzes)..add(page);
      state = state.copyWith(passedQuizzes: updated);
      _scheduleSave();
    }
  }
}

final lessonProgressProvider = StateNotifierProvider.family<
    LessonProgressNotifier, LessonProgressState, int>(
  (ref, levelId) => LessonProgressNotifier(levelId),
);
