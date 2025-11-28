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
    StoreKit2Bridge.shared.install(on: controller)
    NSLog("NativeBootstrapCoordinator: StoreKit2Bridge installed on Flutter controller")
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
      guard call.method == "registerIapPlugin" else {
        result(FlutterMethodNotImplemented)
        return
      }
      if let engine = controller?.engine ?? self.attachedEngine {
        BizPluginRegistrant.registerDeferredIap(engine)
        NSLog("NativeBootstrapCoordinator: registerDeferredIap triggered from Flutter")
        result(nil)
      } else {
        NSLog("NativeBootstrapCoordinator: unable to locate engine for deferred IAP")
        result(FlutterError(code: "engine_missing", message: "No FlutterEngine for deferred IAP", details: nil))
      }
    }

    bootstrapChannel = channel
  }
}

