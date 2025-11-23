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
    if (_iapRegistered || kIsWeb || !Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('registerIapPlugin');
      _iapRegistered = true;
      await Sentry.addBreadcrumb(Breadcrumb(
        category: 'iap_bootstrap',
        level: SentryLevel.info,
        message: 'Native IAP plugin registered',
        data: {'caller': caller},
      ));
    } catch (error, stackTrace) {
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }
}
