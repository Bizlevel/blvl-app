import UIKit
import Flutter
import Darwin

@objc class AppDelegate: FlutterAppDelegate {
  private var cachedFlutterController: FlutterViewController?
  private lazy var sharedEngineInstance: FlutterEngine = {
    FlutterEngine(name: "bizlevel_engine", project: nil, allowHeadlessExecution: false)
  }()
  private var didRunSharedEngine = false
  private var didRegisterPlugins = false

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
    return super.application(application, willFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
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
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

}
