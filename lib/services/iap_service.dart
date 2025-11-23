import 'dart:async';
import 'dart:io' show Platform;

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'native_bootstrap.dart';

/// Сервис для работы с In‑App Purchases (StoreKit 2 / Google Billing)
/// Минимальная обёртка: загрузка продуктов и покупка одного consumable товара.
class IapService {
  IapService._();

  static IapService? _singleton;
  static IapService get instance => _singleton ??= IapService._();

  StreamSubscription<List<PurchaseDetails>>? _sub;

  Future<bool> isAvailable() async {
    try {
      final iap = await _iapSafe();
      return await iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  /// Загружает детали продуктов по списку идентификаторов.
  Future<ProductDetailsResponse> queryProducts(Set<String> productIds) async {
    final iap = await _iapSafe();
    return iap.queryProductDetails(productIds);
  }

  /// Покупка одного consumable продукта и одноразовое ожидание результата.
  /// Возвращает [PurchaseDetails] в статусе purchased или pending/failed при ошибке.
  Future<PurchaseDetails?> buyConsumableOnce(ProductDetails product) async {
    final available = await isAvailable();
    if (!available) return null;

    final completer = Completer<PurchaseDetails?>();

    final iap = await _iapSafe();
    await _sub?.cancel();
    _sub = iap.purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        if (p.productID == product.id) {
          // Сообщаем вызывающему коду как только появится результат.
          if (!completer.isCompleted) completer.complete(p);
          // Для consumable требуется завершить покупку.
          if (p.pendingCompletePurchase) {
            try {
              await iap.completePurchase(p);
            } catch (_) {}
          }
        }
      }
    }, onError: (_) {
      if (!completer.isCompleted) completer.complete(null);
    });

    final param = PurchaseParam(productDetails: product);
    await iap.buyConsumable(purchaseParam: param);

    final result = await completer.future
        .timeout(const Duration(seconds: 90), onTimeout: () => null);
    await _sub?.cancel();
    _sub = null;
    return result;
  }

  /// Возвращает платформу: ios/android/web/other.
  static String currentPlatform() {
    // На Web нельзя обращаться к dart:io -> Platform.*
    if (kIsWeb) return 'web';
    try {
      if (Platform.isIOS) return 'ios';
      if (Platform.isAndroid) return 'android';
    } catch (_) {
      // На всякий случай гасим любые UnsupportedError
    }
    return 'other';
  }

  Future<InAppPurchase> _iapSafe() async {
    if (!kIsWeb) {
      await NativeBootstrap.ensureIapRegistered(caller: 'iap_service');
    }
    return InAppPurchase.instance;
  }
}
