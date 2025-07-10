import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Course App',
      theme: ThemeData(
        primaryColor: AppColor.primary,
      ),
      home: const RootApp(),
    );
  }
}
