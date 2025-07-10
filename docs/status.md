## Задача 1.1
- Task 1.1 completed: updated dependencies and dev_dependencies in pubspec.yaml, removed carousel_slider.
- Added Sentry initialization in lib/main.dart with placeholder DSN via environment variable.
- Ran `flutter pub get` and code generation, no conflicts.
- No blocking issues found.

## Задача 1.2
- Task 1.2 completed: created directories lib/models, lib/services, lib/providers, lib/screens/auth, assets/images/onboarding. Updated pubspec.yaml to include images asset path.
- No issues; ready for next steps.

## Задача 1.3
- Task 1.3 completed: added SupabaseService singleton with initialize() method using compile-time env vars; updated main.dart to call initialization before Sentry.
- .env keys set as defaults for compile-time env variables.

## Задача 1.4
- Task 1.4 completed: Applied `initial_schema` migration to Supabase (tables, indexes, RLS policies) using mcp_supabase_apply_migration.
- Migration executed successfully on project acevqbdpzgbtqznbpgzr.

## Задача 1.5
- Task 1.5 completed: added `test/infrastructure_test.dart` verifying Supabase initialization, levels query and RLS; configured shared_preferences mock; removed obsolete widget_test to avoid carousel dependency.
- All tests pass.

## Задача 2.1
- Task 2.1 completed: integrated Riverpod in main.dart, added ProviderScope wrapper and flutter_riverpod import, preserved existing initialization logic.
- No blocking issues found.

## Задача 2.2
- Task 2.2 completed: added UserModel, LevelModel, LessonModel with Freezed & JSON serialization under lib/models/.
- Build_runner generation pending; will run after cleaning obsolete carousel_slider usage.

## Задача 2.3
- Task 2.3 completed: implemented AuthService with signIn, signUp, signOut, getCurrentUser and error handling.
- Added AuthFailure for consistent error messages.

## Задача 2.4
- Task 2.4 completed: added authStateProvider (StreamProvider<AuthState>) and currentUserProvider (FutureProvider<UserModel?>).
- Providers use Supabase streams and users table; null-safe handling implemented.
