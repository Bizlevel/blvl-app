import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/root_app.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  await SentryFlutter.init(
    (options) {
      // TODO: Replace with your DSN via --dart-define=SENTRY_DSN=YOUR_DSN
      options.dsn =
          const String.fromEnvironment('SENTRY_DSN', defaultValue: '');
    },
    appRunner: () => runApp(ProviderScope(child: MyApp())),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    Widget home = authAsync.when(
      data: (authState) {
        final session = authState.session;
        final isLoggedIn = session != null && session.user != null;
        return isLoggedIn ? const RootApp() : const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => const LoginScreen(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizLevel',
      theme: ThemeData(
        primaryColor: AppColor.primary,
      ),
      home: home,
    );
  }
}
