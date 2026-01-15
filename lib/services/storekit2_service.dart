import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Обёртка над нативным StoreKit 2 мостом.
class StoreKit2Service {
  StoreKit2Service._();

  static final StoreKit2Service instance = StoreKit2Service._();

  static const _methodChannel = MethodChannel('bizlevel/storekit2');
  static const _transactionChannel =
      EventChannel('bizlevel/storekit2/transactions');
  static const _bootstrapChannel = MethodChannel('bizlevel/native_bootstrap');

  static bool _nativeBridgeInstalled = false;
  static Future<void>? _nativeBridgeInstallFuture;

  Stream<StoreKitTransaction>? _transactionStream;

  static bool get _isIos =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static Future<void> _ensureNativeBridgeInstalled(String caller) async {
    if (!_isIos) return;
    if (_nativeBridgeInstalled) return;

    _nativeBridgeInstallFuture ??= _bootstrapChannel
        .invokeMethod<void>('installStoreKit2Bridge')
        .then<void>((_) {
      _nativeBridgeInstalled = true;
    });

    try {
      await _nativeBridgeInstallFuture;
    } catch (error) {
      // Сбрасываем future, чтобы следующая попытка могла повторить установку.
      _nativeBridgeInstallFuture = null;
      debugPrint(
        '[StoreKit2Service] failed to install native bridge (caller=$caller): $error',
      );
      rethrow;
    }
  }

  Future<StoreKitFetchResponse> fetchProducts(List<String> productIds) async {
    if (productIds.isEmpty) {
      return const StoreKitFetchResponse(products: []);
    }
    await _ensureNativeBridgeInstalled('fetchProducts');
    try {
      final raw = await _methodChannel.invokeMethod<dynamic>(
        'fetchProducts',
        {'productIds': productIds},
      );
      return _parseFetchResponse(raw);
    } on MissingPluginException catch (error) {
      debugPrint(
        '[StoreKit2Service] fetchProducts unavailable: ${error.message}',
      );
      return StoreKitFetchResponse(
        products: const [],
        errorCode: 'missing_plugin',
        errorMessage: error.message,
      );
    } catch (error) {
      debugPrint('[StoreKit2Service] fetchProducts failed: $error');
      return StoreKitFetchResponse(
        products: const [],
        errorCode: 'fetch_failed',
        errorMessage: '$error',
      );
    }
  }

  Future<StoreKitPurchaseResult> purchase(String productId) async {
    await _ensureNativeBridgeInstalled('purchase');
    try {
      final payload = await _methodChannel.invokeMapMethod<String, dynamic>(
        'purchaseProduct',
        {'productId': productId},
      );
      final status = payload?['status'] as String? ?? 'unknown';
      final transactionMap = payload?['transaction'];
      final transaction = transactionMap is Map
          ? StoreKitTransaction.fromJson(
              Map<String, dynamic>.from(transactionMap),
            )
          : null;
      return StoreKitPurchaseResult(status: status, transaction: transaction);
    } on MissingPluginException catch (error) {
      debugPrint(
        '[StoreKit2Service] purchase unavailable: ${error.message}',
      );
      return const StoreKitPurchaseResult(status: 'unavailable');
    }
  }

  /// Завершает (finish) конкретную транзакцию StoreKit2 по её id.
  /// Важно: вызывать только после успешной "доставки" (начисления GP на сервере),
  /// иначе можно потерять возможность повторно обработать покупку при сбоях сети.
  Future<bool> finishTransaction(String transactionId) async {
    if (!_isIos) return false;
    if (transactionId.isEmpty) return false;
    await _ensureNativeBridgeInstalled('finishTransaction');
    try {
      final payload = await _methodChannel.invokeMapMethod<String, dynamic>(
        'finishTransaction',
        {'transactionId': transactionId},
      );
      final status = payload?['status'] as String? ?? 'unknown';
      return status == 'finished';
    } catch (error) {
      debugPrint('[StoreKit2Service] finishTransaction failed: $error');
      return false;
    }
  }

  Future<List<StoreKitTransaction>> restorePurchases() async {
    await _ensureNativeBridgeInstalled('restorePurchases');
    try {
      final response =
          await _methodChannel.invokeListMethod<dynamic>('restorePurchases');
      if (response == null) return const [];
      return response
          .whereType<Map>()
          .map((e) => StoreKitTransaction.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList(growable: false);
    } on MissingPluginException catch (error) {
      debugPrint(
        '[StoreKit2Service] restore unavailable: ${error.message}',
      );
      return const [];
    }
  }

  Stream<StoreKitTransaction> transactionUpdates() {
    if (!_isIos) return const Stream.empty();

    return _transactionStream ??= () {
      StreamSubscription<dynamic>? sub;
      late final StreamController<StoreKitTransaction> controller;

      controller = StreamController<StoreKitTransaction>.broadcast(
        onListen: () async {
          try {
            await _ensureNativeBridgeInstalled('transactionUpdates');
          } catch (error, stackTrace) {
            controller.addError(error, stackTrace);
            return;
          }

          sub ??= _transactionChannel
              .receiveBroadcastStream()
              .where((event) => event is Map)
              .map((event) => Map<String, dynamic>.from(event as Map))
              .where((event) => event['type'] == 'transactionUpdate')
              .map((event) {
            final tx = event['transaction'];
            if (tx is Map) {
              return StoreKitTransaction.fromJson(
                  Map<String, dynamic>.from(tx));
            }
            throw StateError('Malformed StoreKit transaction event');
          }).listen(controller.add, onError: controller.addError);
        },
        onCancel: () async {
          await sub?.cancel();
          sub = null;
        },
      );

      return controller.stream;
    }();
  }
}

StoreKitFetchResponse _parseFetchResponse(dynamic raw) {
  if (raw is Map) {
    final productsRaw = raw['products'];
    final invalidRaw = raw['invalidProductIds'];
    final requestId = raw['requestId'] as String?;
    final errorCode = raw['errorCode'] as String?;
    final errorMessage =
        raw['error'] as String? ?? raw['errorMessage'] as String?;
    final products = _decodeProducts(productsRaw);
    final invalid = _stringList(invalidRaw);
    return StoreKitFetchResponse(
      products: products,
      invalidProductIds: invalid,
      requestId: requestId,
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
  }
  if (raw is List) {
    return StoreKitFetchResponse(products: _decodeProducts(raw));
  }
  return const StoreKitFetchResponse(products: []);
}

List<StoreKitProduct> _decodeProducts(dynamic input) {
  if (input is! List) return const [];
  return input
      .whereType<Map>()
      .map(
        (e) => StoreKitProduct.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
      .toList(growable: false);
}

List<String> _stringList(dynamic input) {
  if (input is! List) return const [];
  return input.whereType<String>().toList(growable: false);
}

class StoreKitFetchResponse {
  const StoreKitFetchResponse({
    required this.products,
    this.invalidProductIds = const [],
    this.requestId,
    this.errorCode,
    this.errorMessage,
  });

  final List<StoreKitProduct> products;
  final List<String> invalidProductIds;
  final String? requestId;
  final String? errorCode;
  final String? errorMessage;

  bool get hasError =>
      (errorCode != null && errorCode!.isNotEmpty) ||
      (errorMessage != null && errorMessage!.isNotEmpty);
}

class StoreKitProduct {
  const StoreKitProduct({
    required this.id,
    required this.displayName,
    required this.description,
    required this.displayPrice,
    required this.price,
    required this.currencyCode,
    required this.type,
    required this.isFamilyShareable,
    this.subscriptionPeriodUnit,
    this.subscriptionPeriodValue,
    this.introductoryOfferEligible,
  });

  final String id;
  final String displayName;
  final String description;
  final String displayPrice;
  final double price;
  final String currencyCode;
  final String type;
  final bool isFamilyShareable;
  final String? subscriptionPeriodUnit;
  final int? subscriptionPeriodValue;
  final bool? introductoryOfferEligible;

  factory StoreKitProduct.fromJson(Map<String, dynamic> json) {
    return StoreKitProduct(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      displayPrice: json['displayPrice'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currencyCode: json['currencyCode'] as String? ?? '',
      type: json['type'] as String? ?? 'unknown',
      isFamilyShareable: json['isFamilyShareable'] as bool? ?? false,
      subscriptionPeriodUnit: json['subscriptionPeriodUnit'] as String?,
      subscriptionPeriodValue: json['subscriptionPeriodValue'] as int?,
      introductoryOfferEligible:
          json['introductoryOfferEligible'] as bool? ?? false,
    );
  }
}

class StoreKitTransaction {
  const StoreKitTransaction({
    required this.productId,
    required this.transactionId,
    required this.originalTransactionId,
    required this.environment,
    required this.ownershipType,
    required this.jwsRepresentation,
    this.purchaseDateMs,
    this.expirationDateMs,
    this.revocationDateMs,
    this.revocationReason,
    this.subscriptionGroupId,
    this.appAccountToken,
    this.appStoreReceipt,
  });

  final String productId;
  final String transactionId;
  final String originalTransactionId;
  final String environment;
  final String ownershipType;
  final String jwsRepresentation;
  final int? purchaseDateMs;
  final int? expirationDateMs;
  final int? revocationDateMs;
  final String? revocationReason;
  final String? subscriptionGroupId;
  final String? appAccountToken;
  final String? appStoreReceipt;

  factory StoreKitTransaction.fromJson(Map<String, dynamic> json) {
    return StoreKitTransaction(
      productId: json['productId'] as String? ?? '',
      transactionId:
          json['transactionId']?.toString() ?? json['id']?.toString() ?? '',
      originalTransactionId: json['originalTransactionId']?.toString() ??
          json['originalId']?.toString() ??
          '',
      environment: json['environment'] as String? ?? 'production',
      ownershipType: json['ownershipType'] as String? ?? 'purchased',
      jwsRepresentation: json['jwsRepresentation'] as String? ??
          json['signedPayload'] as String? ??
          '',
      purchaseDateMs: json['purchaseDateMs'] as int?,
      expirationDateMs: json['expirationDateMs'] as int?,
      revocationDateMs: json['revocationDateMs'] as int?,
      revocationReason: json['revocationReason'] as String?,
      subscriptionGroupId: json['subscriptionGroupId'] as String?,
      appAccountToken: json['appAccountToken'] as String?,
      appStoreReceipt: json['appStoreReceipt'] as String?,
    );
  }
}

class StoreKitPurchaseResult {
  const StoreKitPurchaseResult({
    required this.status,
    this.transaction,
  });

  final String status;
  final StoreKitTransaction? transaction;

  bool get isSuccess => status == 'success' && transaction != null;
  bool get isCancelled => status == 'cancelled';
  bool get isPending => status == 'pending';
}
