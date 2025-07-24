import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'utils/deep_link.dart';

import 'routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'services/supabase_service.dart';
import 'theme/color.dart';

Future<void> main() async {
  // КРИТИЧНО для web: Все инициализации должны быть в одной зоне
  WidgetsFlutterBinding.ensureInitialized();

  // Загружаем переменные окружения (если файл есть)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  // Инициализируем Supabase
  await SupabaseService.initialize();

  final dsn = dotenv.env['sentry_dsn'] ??
      const String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  if (dsn.isEmpty) {
    // Без Sentry
    runApp(const ProviderScope(child: MyApp()));
  } else {
    // С Sentry, но в той же зоне
    final packageInfo = await PackageInfo.fromPlatform();
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = dsn
          ..tracesSampleRate = 1.0
          ..environment = kReleaseMode ? 'prod' : 'dev'
          ..release =
              'bizlevel@${packageInfo.version}+${packageInfo.buildNumber}'
          ..enableAutoSessionTracking = true
          ..attachScreenshot = true
          ..attachViewHierarchy = true
          ..beforeSend = (SentryEvent event, Hint hint) {
            event.request?.headers
                .removeWhere((k, _) => k.toLowerCase() == 'authorization');
            return event;
          };
      },
      // НЕ используем appRunner - это создает разные зоны
    );

    // Запускаем приложение в той же зоне
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);

    return _LinkListener(
      router: router,
      child: MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          maxWidth: 480,
          minWidth: 320,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(320, name: MOBILE),
            ResponsiveBreakpoint.autoScale(600, name: TABLET),
            ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
          ],
        ),
        debugShowCheckedModeBanner: false,
        title: 'BizLevel',
        theme: ThemeData(
          primaryColor: AppColor.primary,
        ),
        // Навигатор теперь управляется GoRouter; SentryObserver добавлен в конфигурацию роутера
      ),
    );
  }
}

class _LinkListener extends StatefulWidget {
  final GoRouter router;
  final Widget child;
  const _LinkListener({required this.router, required this.child});

  @override
  State<_LinkListener> createState() => _LinkListenerState();
}

class _LinkListenerState extends State<_LinkListener> {
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    _initLinks();
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        _handleLinkUri(uri);
      }, onError: (_) {});
    }
  }

  Future<void> _initLinks() async {
    try {
      final initial = await getInitialUri();
      _handleLinkUri(initial);
    } catch (_) {}
  }

  void _handleLinkUri(Uri? uri) {
    final path = uri == null ? null : mapBizLevelDeepLink(uri.toString());
    if (path != null) {
      widget.router.go(path);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
