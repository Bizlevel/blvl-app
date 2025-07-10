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
