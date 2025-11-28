import Foundation
import StoreKit
import Flutter
import os.log

@objc final class StoreKit2Bridge: NSObject, FlutterStreamHandler {
  static let shared = StoreKit2Bridge()

  private let methodChannelName = "bizlevel/storekit2"
  private let transactionChannelName = "bizlevel/storekit2/transactions"
  private var methodChannel: FlutterMethodChannel?
  private var transactionChannel: FlutterEventChannel?
  private var transactionListenerTask: Task<Void, Never>?
  private weak var controller: FlutterViewController?

  private override init() {
    super.init()
  }

  func install(on controller: FlutterViewController) {
    if self.controller === controller, methodChannel != nil {
      return
    }
    self.controller = controller

    let methodChannel = FlutterMethodChannel(
      name: methodChannelName,
      binaryMessenger: controller.binaryMessenger
    )
    methodChannel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call: call, result: result)
    }
    self.methodChannel = methodChannel

    let eventChannel = FlutterEventChannel(
      name: transactionChannelName,
      binaryMessenger: controller.binaryMessenger
    )
    eventChannel.setStreamHandler(self)
    transactionChannel = eventChannel

    os_log("StoreKit2Bridge: channels installed", type: .info)
  }

  private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "fetchProducts":
      guard
        let args = call.arguments as? [String: Any],
        let ids = args["productIds"] as? [String],
        !ids.isEmpty
      else {
        result(FlutterError(code: "invalid_argument", message: "productIds required", details: nil))
        return
      }
      let requestId = UUID().uuidString
      Task {
        os_log("StoreKit2Bridge: fetchProducts [%{public}@] ids=%{public}@", type: .info, requestId, ids.joined(separator: ","))
        do {
          let products = try await Product.products(for: Set(ids))
          let payload = products.map { $0.toDictionary() }
          let foundIds = Set(products.map { $0.id })
          let invalidIds = ids.filter { !foundIds.contains($0) }
          os_log(
            "StoreKit2Bridge: fetchProducts [%{public}@] completed (found=%{public}d, invalid=%{public}d)",
            type: .info,
            requestId,
            payload.count,
            invalidIds.count
          )
          result([
            "requestId": requestId,
            "products": payload,
            "invalidProductIds": invalidIds
          ])
        } catch {
          os_log(
            "StoreKit2Bridge: fetchProducts [%{public}@] failed %{public}@",
            type: .error,
            requestId,
            error.localizedDescription
          )
          result([
            "requestId": requestId,
            "products": [],
            "invalidProductIds": ids,
            "error": error.localizedDescription
          ])
        }
      }
    case "purchaseProduct":
      guard
        let args = call.arguments as? [String: Any],
        let productId = args["productId"] as? String,
        !productId.isEmpty
      else {
        result(FlutterError(code: "invalid_argument", message: "productId required", details: nil))
        return
      }
      Task {
        do {
          guard let product = try await Product.products(for: [productId]).first else {
            result(FlutterError(code: "product_not_found", message: "Product not found: \(productId)", details: nil))
            return
          }
          let purchaseResult = try await product.purchase()
          switch purchaseResult {
          case .success(let verification):
            let (transaction, jws) = try self.unpackVerification(verification)
            result([
              "status": "success",
              "transaction": transaction.toDictionary(jwsRepresentation: jws)
            ])
          case .pending:
            result(["status": "pending"])
          case .userCancelled:
            result(["status": "cancelled"])
          @unknown default:
            result(FlutterError(code: "purchase_unknown", message: "Unknown purchase result", details: nil))
          }
        } catch {
          os_log("StoreKit2Bridge: purchase failed %{public}@", type: .error, error.localizedDescription)
          result(FlutterError(code: "purchase_failed", message: error.localizedDescription, details: nil))
        }
      }
    case "restorePurchases":
      Task {
        do {
          try await AppStore.sync()
          var restored: [[String: Any]] = []
          for await verification in Transaction.currentEntitlements {
            do {
              let (transaction, jws) = try self.unpackVerification(verification)
              restored.append(transaction.toDictionary(jwsRepresentation: jws))
            } catch {
              os_log("StoreKit2Bridge: restore verification failed %{public}@", type: .error, error.localizedDescription)
            }
          }
          result(restored)
        } catch {
          os_log("StoreKit2Bridge: restore failed %{public}@", type: .error, error.localizedDescription)
          result(FlutterError(code: "restore_failed", message: error.localizedDescription, details: nil))
        }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func unpackVerification(
    _ result: VerificationResult<Transaction>
  ) throws -> (transaction: Transaction, jwsRepresentation: String) {
    switch result {
    case .verified(let transaction):
      return (transaction, result.jwsRepresentation)
    case .unverified(_, let error):
      throw error
    }
  }

  // MARK: - FlutterStreamHandler

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    transactionListenerTask?.cancel()
    transactionListenerTask = Task {
      for await verification in Transaction.updates {
        do {
          let (transaction, jws) = try self.unpackVerification(verification)
          events([
            "type": "transactionUpdate",
            "transaction": transaction.toDictionary(jwsRepresentation: jws)
          ])
          await transaction.finish()
        } catch {
          events(FlutterError(code: "transaction_verification_failed", message: error.localizedDescription, details: nil))
        }
      }
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    transactionListenerTask?.cancel()
    transactionListenerTask = nil
    return nil
  }
}

private extension Product {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      "id": id,
      "displayName": displayName,
      "description": description,
      "displayPrice": displayPrice,
      "price": NSDecimalNumber(decimal: price).doubleValue,
      "currencyCode": priceFormatStyle.currencyCode,
      "type": type.rawStoreValue
    ]
    if let subscription = subscription {
      let period = subscription.subscriptionPeriod
      dict["subscriptionPeriodUnit"] = period.unit.storeValue
      dict["subscriptionPeriodValue"] = period.value
      dict["introductoryOfferEligible"] = subscription.introductoryOffer != nil
    }
    dict["isFamilyShareable"] = isFamilyShareable
    return dict
  }
}

private extension Transaction {
  func toDictionary(jwsRepresentation: String? = nil) -> [String: Any] {
    var dict: [String: Any] = [
      "productId": productID,
      "transactionId": id.description,
      "originalTransactionId": originalID.description,
      "ownershipType": ownershipType.rawValue
    ]
    if #available(iOS 16.0, *) {
      dict["environment"] = environment.rawValue
    } else {
      dict["environment"] = "unknown"
    }
    if let jws = jwsRepresentation {
      dict["jwsRepresentation"] = jws
      dict["signedPayload"] = jws
    }
    dict["purchaseDateMs"] = purchaseDate.millisecondsSince1970
    if let expiration = expirationDate {
      dict["expirationDateMs"] = expiration.millisecondsSince1970
    }
    if let revocationDate = revocationDate {
      dict["revocationDateMs"] = revocationDate.millisecondsSince1970
    }
    if let reason = revocationReason {
      dict["revocationReason"] = String(describing: reason)
    }
    if let appAccountToken = appAccountToken {
      dict["appAccountToken"] = appAccountToken.uuidString
    }
    if let subscriptionGroupID = subscriptionGroupID {
      dict["subscriptionGroupId"] = subscriptionGroupID
    }
    if let receipt = StoreKit2Bridge.loadAppStoreReceipt() {
      dict["appStoreReceipt"] = receipt
    }
    return dict
  }
}

private extension Product.SubscriptionPeriod.Unit {
  var storeValue: String {
    switch self {
    case .day:
      return "day"
    case .week:
      return "week"
    case .month:
      return "month"
    case .year:
      return "year"
    @unknown default:
      return "unknown"
    }
  }
}

private extension Product.ProductType {
  var rawStoreValue: String {
    switch self {
    case .autoRenewable:
      return "auto_renewable"
    case .nonRenewable:
      return "non_renewable"
    case .nonConsumable:
      return "non_consumable"
    case .consumable:
      return "consumable"
    default:
      if #available(iOS 17.4, *), String(describing: self) == "subscription" {
        return "subscription"
      }
      return "unknown"
    }
  }
}

private extension Date {
  var millisecondsSince1970: Int {
    return Int((timeIntervalSince1970 * 1000).rounded())
  }
}

private extension StoreKit2Bridge {
  static func loadAppStoreReceipt() -> String? {
    guard
      let url = Bundle.main.appStoreReceiptURL,
      let data = try? Data(contentsOf: url)
    else {
      return nil
    }
    return data.base64EncodedString()
  }
}

