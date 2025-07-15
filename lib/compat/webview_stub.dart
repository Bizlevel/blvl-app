// Stub for WebView when on Web platform where webview_flutter is unavailable.
// This allows code to compile.
import 'package:flutter/widgets.dart';

enum JavascriptMode { unrestricted }

class WebView extends StatelessWidget {
  const WebView({super.key, this.initialUrl, this.javascriptMode});

  final String? initialUrl;
  final JavascriptMode? javascriptMode;

  @override
  Widget build(BuildContext context) {
    // On web just show nothing; the iframe path should be used instead.
    return const SizedBox.shrink();
  }
}
