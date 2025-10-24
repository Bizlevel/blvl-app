import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Провайдер для отслеживания завершения чекпойнтов
class CheckpointsNotifier extends StateNotifier<Map<String, bool>> {
  CheckpointsNotifier() : super({}) {
    _load();
  }

  static const String _prefsKey = 'checkpoints_completed';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;
        state = data.map((key, value) => MapEntry(key, value as bool));
      } catch (e) {
        // Если ошибка парсинга, используем пустое состояние
        state = {};
      }
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(state));
  }

  /// Отмечает чекпойнт как завершенный
  Future<void> completeCheckpoint(String checkpointId) async {
    if (!state.containsKey(checkpointId) || !state[checkpointId]!) {
      state = Map.from(state)..[checkpointId] = true;
      await _save();
    }
  }

  /// Проверяет, завершен ли чекпойнт
  bool isCheckpointCompleted(String checkpointId) {
    return state[checkpointId] ?? false;
  }

  /// Сбрасывает состояние чекпойнта (для тестирования)
  Future<void> resetCheckpoint(String checkpointId) async {
    state = Map.from(state)..remove(checkpointId);
    await _save();
  }
}

final checkpointsProvider = StateNotifierProvider<CheckpointsNotifier, Map<String, bool>>((ref) {
  return CheckpointsNotifier();
});
