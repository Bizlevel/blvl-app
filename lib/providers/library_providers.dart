import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import '../repositories/library_repository.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return LibraryRepository(client);
});

final coursesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>(
        (ref, category) async {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchCourses(category: category);
});

final grantsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>(
        (ref, category) async {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchGrants(category: category);
});

final acceleratorsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>(
        (ref, category) async {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchAccelerators(category: category);
});

final favoritesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchFavorites();
});

final favoritesDetailedProvider =
    FutureProvider<Map<String, List<Map<String, dynamic>>>>((ref) async {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchFavoritesDetailed();
});

// Динамические категории per-type
final libraryCategoriesProvider =
    FutureProvider.family<List<String>, String>((ref, type) async {
  final repo = ref.watch(libraryRepositoryProvider);
  return repo.fetchCategories(type);
});
