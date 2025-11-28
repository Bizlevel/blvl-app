// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Flutter
import ObjectiveC
import UIKit
import UniformTypeIdentifiers

/// Bridge between a UIDocumentPickerViewController and its Pigeon callback.
class PickerCompletionBridge: NSObject, UIDocumentPickerDelegate {
  let completion: (Result<[String], Error>) -> Void
  /// The plugin instance that owns this object, to ensure that it lives as long as the picker it
  /// serves as a delegate for. Instances are responsible for removing themselves from their owner
  /// on completion.
  let owner: FileSelectorPlugin

  init(completion: @escaping (Result<[String], Error>) -> Void, owner: FileSelectorPlugin) {
    self.completion = completion
    self.owner = owner
  }

  func documentPicker(
    _ controller: UIDocumentPickerViewController,
    didPickDocumentsAt urls: [URL]
  ) {
    sendResult(urls.map({ $0.path }))
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    sendResult([])
  }

  private func sendResult(_ result: [String]) {
    completion(.success(result))
    owner.pendingCompletions.remove(self)
  }
}

public class FileSelectorPlugin: NSObject, FlutterPlugin, FileSelectorApi {
  /// Owning references to pending completion callbacks.
  ///
  /// This is necessary since the objects need to live until a UIDocumentPickerDelegate method is
  /// called on the delegate, but the delegate is weak. Objects in this set are responsible for
  /// removing themselves from it.
  var pendingCompletions: Set<PickerCompletionBridge> = []
  /// Overridden document picker, for testing.
  var documentPickerViewControllerOverride: UIDocumentPickerViewController?
  /// Overridden view presenter, for testing.
  var viewPresenterOverride: ViewPresenter?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = FileSelectorPlugin()
    FileSelectorApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
  }

  func openFile(config: FileSelectorConfig, completion: @escaping (Result<[String], Error>) -> Void)
  {
    let completionBridge = PickerCompletionBridge(completion: completion, owner: self)
    let documentPicker: UIDocumentPickerViewController
    if let overridePicker = documentPickerViewControllerOverride {
      documentPicker = overridePicker
    } else if #available(iOS 14.0, *) {
      let contentTypes = config.utis.compactMap { UTType($0) }
      let safeContentTypes = contentTypes.isEmpty ? [UTType.data] : contentTypes
      documentPicker = UIDocumentPickerViewController(
        forOpeningContentTypes: safeContentTypes,
        asCopy: true)
    } else {
      documentPicker = UIDocumentPickerViewController(
        documentTypes: config.utis,
        in: .import)
    }
    documentPicker.allowsMultipleSelection = config.allowMultiSelection
    documentPicker.delegate = completionBridge

    if let presenter = resolvePresenter() {
      pendingCompletions.insert(completionBridge)
      presenter.present(documentPicker, animated: true, completion: nil)
    } else {
      completion(
        .failure(PigeonError(code: "error", message: "Missing root view controller.", details: nil))
      )
    }
  }

  private func resolvePresenter() -> ViewPresenter? {
    if let override = viewPresenterOverride {
      return override
    }
    return FileSelectorPlugin.topViewController()
  }

  private static func topViewController() -> UIViewController? {
    if #available(iOS 13.0, *) {
      let scenes = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
      for scene in scenes {
        if let window = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first,
          let controller = window.rootViewController
        {
          return visibleController(from: controller)
        }
      }
    }
    if let delegate = UIApplication.shared.delegate,
      let window = delegate.window ?? nil,
      let controller = window.rootViewController
    {
      return visibleController(from: controller)
    }
#if !targetEnvironment(macCatalyst)
    if #available(iOS 13.0, *) {
      // Scene-based apps must rely on UIWindowScene to determine presenters.
    } else if let legacyWindow = UIApplication.shared.keyWindow,
              let controller = legacyWindow.rootViewController
    {
      return visibleController(from: controller)
    }
#endif
    return nil
  }

  private static func visibleController(from controller: UIViewController?) -> UIViewController? {
    guard let controller = controller else { return nil }
    if let presented = controller.presentedViewController {
      return visibleController(from: presented)
    }
    if let navigation = controller as? UINavigationController {
      return visibleController(from: navigation.visibleViewController)
    }
    if let tab = controller as? UITabBarController {
      return visibleController(from: tab.selectedViewController)
    }
    return controller
  }
}
