import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/cases_repository_provider.dart';

/// Статус мини‑кейса для текущего пользователя.
final caseStatusProvider =
    FutureProvider.family<Map<String, dynamic>?, int>((ref, caseId) async {
  final repo = ref.watch(casesRepositoryProvider);
  return repo.getCaseStatus(caseId);
});

/// Действия над прогрессом мини‑кейсов.
class CaseActions {
  final Future<void> Function(int caseId) start;
  final Future<void> Function(int caseId) skip;
  final Future<void> Function(int caseId) complete;
  final Future<void> Function(int caseId) incrementHint;

  CaseActions(
      {required this.start,
      required this.skip,
      required this.complete,
      required this.incrementHint});
}

final caseActionsProvider = Provider<CaseActions>((ref) {
  final repo = ref.watch(casesRepositoryProvider);
  return CaseActions(
    start: (id) => repo.startCase(id),
    skip: (id) => repo.skipCase(id),
    complete: (id) => repo.completeCase(id),
    incrementHint: (id) => repo.incrementHint(id),
  );
});

