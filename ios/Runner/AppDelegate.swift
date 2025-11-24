import UIKit
import Flutter
import FirebaseCore
import FirebaseAppCheck
import FirebaseMessaging
import DeviceCheck
import Darwin

@objc class AppDelegate: FlutterAppDelegate {
  private static var didConfigureFirebase = false
  private static var didLogBootstrap = false
  private static var isIosFcmEnabled: Bool {
    Bundle.main.object(forInfoDictionaryKey: "EnableIosFcm") as? Bool ?? false
  }
  private var cachedFlutterController: FlutterViewController?
  private lazy var sharedEngineInstance: FlutterEngine = {
    FlutterEngine(name: "bizlevel_engine", project: nil, allowHeadlessExecution: false)
  }()
  private var didRunSharedEngine = false
  private var didRegisterPlugins = false
  private static var isAppCheckDebugEnabled: Bool {
    #if DEBUG
    return true
    #else
    let value = Bundle.main.object(forInfoDictionaryKey: "FirebaseAppCheckUseDebugProvider") as? Bool
    return value ?? false
    #endif
  }

  @objc static func configureFirebaseBeforeMain() {
    guard !didConfigureFirebase else { return }

    let didEnableDebugLogging = enableFirebaseDebugLoggingIfNeeded()

    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    } else {
      NSLog("AppDelegate: FIRApp was already configured before configureFirebaseBeforeMain()")
    }

    configureAppCheck()
    if FirebaseApp.app() == nil {
      NSLog("AppDelegate: Firebase default app is still nil after configure()")
    }
    if !didEnableDebugLogging {
      FirebaseConfiguration.shared.setLoggerLevel(.min)
    }
    if !didLogBootstrap {
      NSLog("AppDelegate: Firebase configured before UIApplicationMain (debugProvider=%@)",
            isAppCheckDebugEnabled ? "ON" : "OFF")
      NSLog("AppDelegate: iOS FCM enabled=%@", isIosFcmEnabled ? "YES" : "NO")
      didLogBootstrap = true
    }

    didConfigureFirebase = true
  }

  private static func configureAppCheck() {
    if isAppCheckDebugEnabled {
      AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
      NSLog("AppDelegate: App Check uses Debug provider (toggle in Info.plist)")
      return
    }

    AppCheck.setAppCheckProviderFactory(DeviceCheckProviderFactory())
    NSLog("AppDelegate: App Check uses DeviceCheck provider")
  }

  @discardableResult
  private static func enableFirebaseDebugLoggingIfNeeded() -> Bool {
    let plistValue = Bundle.main.object(forInfoDictionaryKey: "FirebaseEnableDebugLogging") as? Bool ?? false
    guard plistValue else { return false }
    setenv("FIRDebugEnabled", "1", 1)
    setenv("FIRAppDiagnosticsEnabled", "1", 1)
    FirebaseConfiguration.shared.setLoggerLevel(.debug)
    NSLog("AppDelegate: Firebase debug logging enabled (FIRDebugEnabled=1)")
    return true
  }

  func prepareSharedEngine() -> FlutterEngine {
    let engine = sharedEngineInstance
    if !didRunSharedEngine {
      engine.run()
      didRunSharedEngine = true
      registerPluginsIfNeeded(on: engine)
    } else if !didRegisterPlugins {
      registerPluginsIfNeeded(on: engine)
    }
    return engine
  }

  private func registerPluginsIfNeeded(on engine: FlutterEngine) {
    guard !didRegisterPlugins else { return }
    BizPluginRegistrant.registerEssentialPlugins(engine)
    didRegisterPlugins = true
  }

  func sharedFlutterController() -> FlutterViewController {
    if let controller = cachedFlutterController {
      return controller
    }

    let engine = prepareSharedEngine()
    let controller = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    cachedFlutterController = controller
    NativeBootstrapCoordinator.shared.attach(to: controller)
    return controller
  }

  override func application(
    _ application: UIApplication,
    willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    Self.configureFirebaseBeforeMain()
    return super.application(application, willFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    Self.configureFirebaseBeforeMain()
    UNUserNotificationCenter.current().delegate = self
    if #available(iOS 13.0, *) {
      // SceneDelegate управляет окном/контроллером.
    } else {
      window = window ?? UIWindow(frame: UIScreen.main.bounds)
      let controller = sharedFlutterController()
      window?.rootViewController = controller
      window?.makeKeyAndVisible()
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    guard Self.isIosFcmEnabled else {
      NSLog("AppDelegate: skip APNs token registration (iOS FCM disabled)")
      return
    }
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

}
