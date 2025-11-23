import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NativeBootstrap {
  NativeBootstrap._();

  static const MethodChannel _channel =
      MethodChannel('bizlevel/native_bootstrap');
  static bool _iapRegistered = false;

  static Future<void> ensureIapRegistered({String caller = 'unknown'}) async {
    if (_iapRegistered || kIsWeb || !Platform.isIOS) {
      return;
    }
    final stackPreview = StackTrace.current
        .toString()
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .take(8)
        .join('\n');
    final message =
        '[NativeBootstrap] ensureIapRegistered caller=$caller\n$stackPreview';
    debugPrint(message);
    try {
      await _channel.invokeMethod<void>('registerIapPlugin');
      _iapRegistered = true;
      await Sentry.captureMessage(
        'native_bootstrap.ensure_iap_registered',
        level: SentryLevel.info,
        params: [message],
        withScope: (scope) {
          scope.setExtra('caller', caller);
          scope.setExtra('stack', stackPreview);
        },
      );
    } catch (error, stackTrace) {
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }
}





