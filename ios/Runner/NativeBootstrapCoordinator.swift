import Foundation
import Flutter

final class NativeBootstrapCoordinator {
  static let shared = NativeBootstrapCoordinator()

  private let channelName = "bizlevel/native_bootstrap"
  private var bootstrapChannel: FlutterMethodChannel?
  private weak var attachedController: FlutterViewController?
  private weak var attachedEngine: FlutterEngine?

  private init() {}

  func attach(to controller: FlutterViewController) {
    if attachedController === controller {
      return
    }

    attachedController = controller
    attachedEngine = controller.engine
    bootstrapChannel = nil

    setupBootstrapChannel(on: controller)
    // StoreKit2Bridge intentionally NOT installed here.
    // BizLevel strategy: install StoreKit 2 channels lazily on first use
    // (purchase / fetchProducts / restore / transactionUpdates), to keep cold start minimal.
  }

  private func setupBootstrapChannel(
    on controller: FlutterViewController
  ) {
    guard bootstrapChannel == nil else { return }

    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: controller.binaryMessenger
    )
    NSLog("NativeBootstrapCoordinator: native bootstrap channel created")
    channel.setMethodCallHandler { [weak self, weak controller] call, result in
      guard let self else {
        result(FlutterError(code: "bootstrap_disposed", message: "Coordinator deallocated", details: nil))
        return
      }
      switch call.method {
      case "registerIapPlugin":
        if let engine = controller?.engine ?? self.attachedEngine {
          BizPluginRegistrant.registerDeferredIap(engine)
          NSLog("NativeBootstrapCoordinator: registerDeferredIap triggered from Flutter")
          result(nil)
        } else {
          NSLog("NativeBootstrapCoordinator: unable to locate engine for deferred IAP")
          result(FlutterError(code: "engine_missing", message: "No FlutterEngine for deferred IAP", details: nil))
        }
      case "registerMediaPlugins":
        if let engine = controller?.engine ?? self.attachedEngine {
          BizPluginRegistrant.registerMediaPlugins(engine)
          NSLog("NativeBootstrapCoordinator: registerMediaPlugins triggered from Flutter")
          result(nil)
        } else {
          NSLog("NativeBootstrapCoordinator: unable to locate engine for media plugins")
          result(FlutterError(code: "engine_missing", message: "No FlutterEngine for media plugins", details: nil))
        }
      case "installStoreKit2Bridge":
        if let vc = controller ?? self.attachedController {
          DispatchQueue.main.async {
            StoreKit2Bridge.shared.install(on: vc)
            NSLog("NativeBootstrapCoordinator: installStoreKit2Bridge triggered from Flutter")
            result(nil)
          }
        } else {
          NSLog("NativeBootstrapCoordinator: unable to locate controller for StoreKit2Bridge")
          result(FlutterError(code: "controller_missing", message: "No FlutterViewController for StoreKit2Bridge", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    bootstrapChannel = channel
  }
}

