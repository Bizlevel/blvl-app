import UIKit
import Flutter
#if canImport(firebase_messaging)
import firebase_messaging
#endif
import FirebaseCore

@objc class AppDelegate: FlutterAppDelegate {
  private let messagingChannelName = "bizlevel/native/fcm"
  private var messagingChannel: FlutterMethodChannel?

  override init() {
    super.init()
    Self.configureFirebaseIfNeeded()
  }

  @objc static func configureFirebaseBeforeMain() {
    Self.configureFirebaseIfNeeded()
  }

  @objc static func configureFirebaseIfNeeded() {
    guard FirebaseApp.app() == nil else { return }
    if let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
       let options = FirebaseOptions(contentsOfFile: filePath) {
      FirebaseApp.configure(options: options)
      NSLog("Firebase configured with plist at \(filePath)")
    } else {
      NSLog("ERROR: GoogleService-Info.plist not found. Firebase not configured.")
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    Self.configureFirebaseIfNeeded()
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    GeneratedPluginRegistrant.register(with: self)
    setupDeferredMessagingChannel()
    return result
  }

  override func application(
    _ application: UIApplication,
    willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    Self.configureFirebaseIfNeeded()
    return super.application(application, willFinishLaunchingWithOptions: launchOptions)
  }

  private func setupDeferredMessagingChannel() {
    guard messagingChannel == nil,
          let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: messagingChannelName,
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "registerMessagingPlugin" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let self else {
        result(FlutterError(code: "no_app_delegate", message: "AppDelegate released", details: nil))
        return
      }
      FirebaseMessagingDeferredRegister.registerIfNeeded(with: self)
      result(true)
    }

    messagingChannel = channel
  }
}

@objc final class FirebaseMessagingDeferredRegister: NSObject {
  private static var didRegister = false

  @objc static func registerIfNeeded(with registry: FlutterPluginRegistry) {
    guard !didRegister else { return }
#if canImport(firebase_messaging)
    guard let registrar = registry.registrar(forPlugin: "FLTFirebaseMessagingPlugin") else {
      NSLog("FCM deferred register: registrar missing")
      return
    }
    FLTFirebaseMessagingPlugin.register(with: registrar)
    didRegister = true
#endif
  }
}
