import 'dart:async';
import 'dart:io' show Platform;

import 'package:in_app_purchase/in_app_purchase.dart';

/// Сервис для работы с In‑App Purchases (StoreKit 2 / Google Billing)
/// Минимальная обёртка: загрузка продуктов и покупка одного consumable товара.
class IapService {
  IapService._();

  static final IapService instance = IapService._();
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _sub;

  Future<bool> isAvailable() async {
    try {
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  /// Загружает детали продуктов по списку идентификаторов.
  Future<ProductDetailsResponse> queryProducts(Set<String> productIds) async {
    return _iap.queryProductDetails(productIds);
  }

  /// Покупка одного consumable продукта и одноразовое ожидание результата.
  /// Возвращает [PurchaseDetails] в статусе purchased или pending/failed при ошибке.
  Future<PurchaseDetails?> buyConsumableOnce(ProductDetails product) async {
    final available = await isAvailable();
    if (!available) return null;

    final completer = Completer<PurchaseDetails?>();

    _sub?.cancel();
    _sub = _iap.purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        if (p.productID == product.id) {
          // Сообщаем вызывающему коду как только появится результат.
          if (!completer.isCompleted) completer.complete(p);
          // Для consumable требуется завершить покупку.
          if (p.pendingCompletePurchase) {
            try {
              await _iap.completePurchase(p);
            } catch (_) {}
          }
        }
      }
    }, onError: (_) {
      if (!completer.isCompleted) completer.complete(null);
    });

    final param = PurchaseParam(productDetails: product);
    await _iap.buyConsumable(purchaseParam: param, autoConsume: true);

    final result = await completer.future
        .timeout(const Duration(seconds: 90), onTimeout: () => null);
    await _sub?.cancel();
    _sub = null;
    return result;
  }

  /// Возвращает платформу: ios/android/other.
  static String currentPlatform() {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'other';
  }
}
