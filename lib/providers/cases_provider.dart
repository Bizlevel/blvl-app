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
  // Use read here since we only need to call methods, not rebuild on repo changes
  final repo = ref.read(casesRepositoryProvider);
  return CaseActions(
    start: (id) async {
      await repo.startCase(id);
      // Invalidate the specific case status so consumers pick up the new value
      ref.invalidate(caseStatusProvider(id));
    },
    skip: (id) async {
      await repo.skipCase(id);
      ref.invalidate(caseStatusProvider(id));
    },
    complete: (id) async {
      await repo.completeCase(id);
      ref.invalidate(caseStatusProvider(id));
    },
    incrementHint: (id) async {
      await repo.incrementHint(id);
      ref.invalidate(caseStatusProvider(id));
    },
  );
});
