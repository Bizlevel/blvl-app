import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:in_app_purchase/in_app_purchase.dart';

import 'native_bootstrap.dart';
import 'storekit2_service.dart';

/// Сервис для работы с In‑App Purchases (StoreKit 2 / Google Billing)
class IapService {
  IapService._();

  static IapService? _singleton;
  static IapService get instance => _singleton ??= IapService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  bool get _isIos => !kIsWeb && Platform.isIOS;

  Future<bool> isAvailable() async {
    if (_isIos) {
      // StoreKit 2 не требует отдельной проверки доступности.
      return true;
    }
    try {
      await _ensurePluginRegistered('isAvailable');
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  /// Загружает детали продуктов для Android (StoreKit 1 не используется).
  Future<ProductDetailsResponse> queryProducts(Set<String> ids) async {
    await _ensurePluginRegistered('queryProducts');
    return _iap.queryProductDetails(ids);
  }

  /// Загружает продукты из StoreKit 2 (iOS).
  Future<List<StoreKitProduct>> queryStoreKitProducts(
    List<String> productIds,
  ) async {
    if (!_isIos) return const [];
    final response = await StoreKit2Service.instance.fetchProducts(productIds);
    if (response.hasError) {
      debugPrint(
        '[IapService] StoreKit fetch error ${response.errorCode ?? ''} ${response.errorMessage ?? ''}',
      );
    }
    return response.products;
  }

  /// Покупка consumable через Google Billing / StoreKit 1 (Android).
  Future<PurchaseDetails?> buyConsumableOnce(ProductDetails product) async {
    if (_isIos) {
      throw UnsupportedError('Use buyStoreKitProduct on iOS');
    }
    final available = await isAvailable();
    if (!available) return null;

    final completer = Completer<PurchaseDetails?>();

    _sub?.cancel();
    _sub = _iap.purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        if (p.productID == product.id) {
          if (!completer.isCompleted) completer.complete(p);
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
    await _iap.buyConsumable(purchaseParam: param);

    final result = await completer.future
        .timeout(const Duration(seconds: 90), onTimeout: () => null);
    await _sub?.cancel();
    _sub = null;
    return result;
  }

  /// Покупка StoreKit 2 продукта.
  Future<StoreKitPurchaseResult> buyStoreKitProduct(String productId) async {
    if (!_isIos) {
      throw UnsupportedError('StoreKit purchases доступны только на iOS');
    }
    return StoreKit2Service.instance.purchase(productId);
  }

  Future<List<StoreKitTransaction>> restoreStoreKitPurchases() async {
    if (!_isIos) return const [];
    return StoreKit2Service.instance.restorePurchases();
  }

  Stream<StoreKitTransaction> transactionUpdates() {
    return StoreKit2Service.instance.transactionUpdates();
  }

  /// Возвращает платформу: ios/android/web/other.
  static String currentPlatform() {
    if (kIsWeb) return 'web';
    try {
      if (Platform.isIOS) return 'ios';
      if (Platform.isAndroid) return 'android';
    } catch (_) {}
    return 'other';
  }

  Future<void> _ensurePluginRegistered(String caller) async {
    if (kIsWeb || Platform.isIOS) return;
    await NativeBootstrap.ensureIapRegistered(caller: caller);
  }
}
