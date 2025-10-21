import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/repositories/goals_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late GoalsRepository repo;

  setUp(() {
    repo = GoalsRepository(_MockSupabaseClient());
  });

  group('computeGoalProgressPercent', () {
    test('returns null when goal is null', () {
      expect(repo.computeGoalProgressPercent(null), isNull);
    });

    test('returns null when any of start/current/target is missing', () {
      expect(repo.computeGoalProgressPercent({}), isNull);
      expect(
          repo.computeGoalProgressPercent({
            'metric_start': 0,
            'metric_target': 10,
          }),
          isNull);
      expect(
          repo.computeGoalProgressPercent({
            'metric_current': 0,
            'metric_target': 10,
          }),
          isNull);
      expect(
          repo.computeGoalProgressPercent({
            'metric_start': 0,
            'metric_current': 5,
          }),
          isNull);
    });

    test('returns null when denominator is zero (target == start)', () {
      expect(
          repo.computeGoalProgressPercent({
            'metric_start': 10,
            'metric_current': 10,
            'metric_target': 10,
          }),
          isNull);
    });

    test('computes ratio and clamps between 0 and 1', () {
      // Normal case
      expect(
          repo.computeGoalProgressPercent({
            'metric_start': 0,
            'metric_current': 5,
            'metric_target': 10,
          }),
          closeTo(0.5, 1e-9));

      // Below 0 → clamp to 0
      expect(
          repo.computeGoalProgressPercent({
            'metric_start': 10,
            'metric_current': 5,
            'metric_target': 20,
          }),
          0.0);

      // Above 1 → clamp to 1
      expect(
          repo.computeGoalProgressPercent({
            'metric_start': 0,
            'metric_current': 15,
            'metric_target': 10,
          }),
          1.0);
    });
  });
}
