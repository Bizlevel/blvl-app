import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Copies patched plugin files from [tool/plugin_patches] into the actual
/// plugin directories resolved via `.flutter-plugins`.
Future<void> main() async {
  final projectRoot = Directory.current;
  final flutterPlugins = <String, String>{};
  final pluginsFile = File(p.join(projectRoot.path, '.flutter-plugins'));
  if (pluginsFile.existsSync()) {
    for (final line in pluginsFile.readAsLinesSync()) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final idx = trimmed.indexOf('=');
      if (idx <= 0) continue;
      final name = trimmed.substring(0, idx);
      final path = trimmed.substring(idx + 1);
      flutterPlugins[name] = path;
    }
  } else {
    final depsFile =
        File(p.join(projectRoot.path, '.flutter-plugins-dependencies'));
    if (!depsFile.existsSync()) {
      stdout.writeln(
          '[plugin_patches] No plugin dependency file found, skipping patch application.');
      return;
    }
    final jsonMap =
        jsonDecode(depsFile.readAsStringSync()) as Map<String, dynamic>;
    final pluginsSection = jsonMap['plugins'] as Map<String, dynamic>? ?? {};
    for (final platformEntry in pluginsSection.values) {
      if (platformEntry is List) {
        for (final plugin in platformEntry) {
          if (plugin is Map<String, dynamic>) {
            final name = plugin['name'] as String?;
            final path = plugin['path'] as String?;
            if (name != null && path != null) {
              flutterPlugins.putIfAbsent(name, () => path);
            }
          }
        }
      }
    }
  }

  final patchesRoot =
      Directory(p.join(projectRoot.path, 'tool', 'plugin_patches'));
  if (!patchesRoot.existsSync()) {
    stdout
        .writeln('[plugin_patches] No patches directory found, nothing to do.');
    return;
  }

  var patchedSomething = false;
  patchedSomething = _patchOneSignalPlugin(flutterPlugins) || patchedSomething;
  for (final entity in patchesRoot.listSync()) {
    if (entity is! Directory) continue;
    final pluginName = p.basename(entity.path);
    final pluginPath = flutterPlugins[pluginName];
    if (pluginPath == null) {
      stdout.writeln(
          '[plugin_patches] Warning: plugin "$pluginName" not found in .flutter-plugins, skipping.');
      continue;
    }

    final pluginDir = Directory(pluginPath);
    if (!pluginDir.existsSync()) {
      stdout.writeln(
          '[plugin_patches] Warning: directory for "$pluginName" not found ($pluginPath), skipping.');
      continue;
    }

    _copyDirectory(entity, pluginDir);
    patchedSomething = true;
  }

  await _patchHostFiles(projectRoot);

  if (patchedSomething) {
    stdout.writeln('[plugin_patches] Patch application complete.');
  } else {
    stdout.writeln('[plugin_patches] No matching plugins to patch.');
  }
}

void _copyDirectory(Directory source, Directory destinationRoot) {
  for (final entity in source.listSync(recursive: true)) {
    if (entity is! File) continue;
    final relativePath = p.relative(entity.path, from: source.path);
    final destinationPath = p.join(destinationRoot.path, relativePath);
    final destinationFile = File(destinationPath);
    destinationFile.parent.createSync(recursive: true);
    destinationFile.writeAsBytesSync(entity.readAsBytesSync());
    stdout.writeln(
        '[plugin_patches] -> ${p.basename(source.path)} / $relativePath');
  }
}

/// Applies in-place patches to the iOS host project that are not tied to a
/// specific plugin (Firebase gating, Sign in with Apple exhaustive switch).
Future<void> _patchHostFiles(Directory projectRoot) async {
  _patchGeneratedPluginRegistrant(projectRoot);
  _patchSignInWithApple(projectRoot);
  // Стратегия A (декабрь 2025): НЕ патчим Sentry внутри ios/Pods.
  // Причина: Pods перегенерируются при pod install, а строковые патчи могут давать
  // самоповреждение и нестабильность старта. Sentry фиксируем конфигурацией/порядком init.
  _pruneStoreKit1Dependencies(projectRoot);
}

bool _patchOneSignalPlugin(Map<String, String> flutterPlugins) {
  final candidates = <Directory>{};
  final pluginPath = flutterPlugins['onesignal_flutter'];
  if (pluginPath != null) {
    candidates.add(Directory(pluginPath));
  }
  final home = Platform.environment['HOME'];
  if (home != null) {
    final cacheRoot =
        Directory(p.join(home, '.pub-cache', 'hosted', 'pub.dev'));
    if (cacheRoot.existsSync()) {
      for (final entity in cacheRoot.listSync()) {
        if (entity is Directory &&
            p.basename(entity.path).startsWith('onesignal_flutter-')) {
          candidates.add(entity);
        }
      }
    }
  }

  if (candidates.isEmpty) {
    stdout.writeln(
        '[plugin_patches] onesignal_flutter not found in plugin map or .pub-cache');
    return false;
  }

  var patched = false;
  for (final dir in candidates) {
    final iosClasses = Directory(p.join(dir.path, 'ios', 'Classes'));
    if (!iosClasses.existsSync()) continue;

    // OneSignalPlugin.m: disable auto-init on plugin registration.
    // BizLevel requirement: initialize OneSignal only after login/registration.
    final pluginFile = File(p.join(iosClasses.path, 'OneSignalPlugin.m'));
    if (pluginFile.existsSync()) {
      var contents = pluginFile.readAsStringSync();
      const marker =
          'BizLevel: OneSignal auto-init disabled; init after auth in Dart.';
      const markerLine = '    // $marker';
      final markerLineRegex =
          RegExp('^.*${RegExp.escape(marker)}.*\\n?', multiLine: true);

      final nilInitLineRegex = RegExp(
        r'^[ \t]*(?:\/\/\s*)?\[OneSignal initialize:nil withLaunchOptions:nil\];\s*$',
        multiLine: true,
      );
      final infoPlistInitLineRegex = RegExp(
        r'^[ \t]*(?:\/\/\s*)?\[OneSignal initialize:\[\[NSBundle mainBundle\] objectForInfoDictionaryKey:@"OneSignalAppID"\] withLaunchOptions:nil\];\s*$',
        multiLine: true,
      );

      final hadAnyInitLine = nilInitLineRegex.hasMatch(contents) ||
          infoPlistInitLineRegex.hasMatch(contents);

      var changed = false;
      if (hadAnyInitLine) {
        // Remove any previous marker lines to keep the patch idempotent.
        contents = contents.replaceAll(markerLineRegex, '');
        contents = contents.replaceAll(nilInitLineRegex, markerLine);
        contents = contents.replaceAll(infoPlistInitLineRegex, markerLine);
        changed = true;
      }

      if (changed) {
        pluginFile.writeAsStringSync(contents);
        stdout.writeln(
            '[plugin_patches] -> onesignal_flutter / OneSignalPlugin.m patched');
        patched = true;
      }
    }

    // OSFlutterUser.m: fix types and NSNull returns
    final userFile = File(p.join(iosClasses.path, 'OSFlutterUser.m'));
    if (userFile.existsSync()) {
      var contents = userFile.readAsStringSync();
      var changed = false;
      if (contents.contains('[OneSignal.User removeAliases:aliases];')) {
        contents = contents.replaceAll(
            '[OneSignal.User removeAliases:aliases];',
            '[OneSignal.User removeAliases:[aliases allValues]];');
        changed = true;
      }
      if (contents.contains('[OneSignal.User removeTags:tags];')) {
        contents = contents.replaceAll('[OneSignal.User removeTags:tags];',
            '[OneSignal.User removeTags:[tags allKeys]];');
        changed = true;
      }
      if (contents.contains('[OneSignal.User addObserver:self];')) {
        contents = contents.replaceAll(
            '[OneSignal.User addObserver:self];',
            'if ([self conformsToProtocol:@protocol(OSUserStateObserver)]) { '
                '[OneSignal.User addObserver:(id<OSUserStateObserver>)self]; '
                '}');
        changed = true;
      }
      if (contents.contains('return [NSNull null];')) {
        contents =
            contents.replaceAll('return [NSNull null];', 'return @\"\";');
        changed = true;
      }
      if (changed) {
        userFile.writeAsStringSync(contents);
        stdout.writeln(
            '[plugin_patches] -> onesignal_flutter / OSFlutterUser.m patched');
        patched = true;
      }
    }

    // OSFlutterPushSubscription.m: add sharedInstance if missing
    final subFile =
        File(p.join(iosClasses.path, 'OSFlutterPushSubscription.m'));
    if (subFile.existsSync()) {
      var contents = subFile.readAsStringSync();
      if (!contents.contains('+ (instancetype)sharedInstance')) {
        contents = contents.replaceFirst(
          '@implementation OSFlutterPushSubscription',
          '@implementation OSFlutterPushSubscription\n\n'
              '+ (instancetype)sharedInstance {\n'
              '  static OSFlutterPushSubscription *instance;\n'
              '  static dispatch_once_t onceToken;\n'
              '  dispatch_once(&onceToken, ^{ instance = [[self alloc] init]; });\n'
              '  return instance;\n'
              '}\n',
        );
        subFile.writeAsStringSync(contents);
        stdout.writeln(
            '[plugin_patches] -> onesignal_flutter / OSFlutterPushSubscription.m patched');
        patched = true;
      }
    }

    // OSFlutterLiveActivities.m: fix pointer-type compare with NSNull
    // (warning: comparison of distinct pointer types).
    final liveActivitiesFile =
        File(p.join(iosClasses.path, 'OSFlutterLiveActivities.m'));
    if (liveActivitiesFile.existsSync()) {
      var contents = liveActivitiesFile.readAsStringSync();
      const needle = 'if (options != [NSNull null]) {';
      const replacement = 'if ([options isKindOfClass:[NSDictionary class]]) {';
      if (contents.contains(needle)) {
        contents = contents.replaceAll(needle, replacement);
        liveActivitiesFile.writeAsStringSync(contents);
        stdout.writeln(
            '[plugin_patches] -> onesignal_flutter / OSFlutterLiveActivities.m patched');
        patched = true;
      }
    }

    // OSFlutterInAppMessages.h: declare click listener conformance
    // (warning: incompatible pointer types for addClickListener:).
    final inAppHeader =
        File(p.join(iosClasses.path, 'OSFlutterInAppMessages.h'));
    if (inAppHeader.existsSync()) {
      var contents = inAppHeader.readAsStringSync();
      const needle =
          '@interface OSFlutterInAppMessages : NSObject<FlutterPlugin, OSInAppMessageLifecycleListener>';
      const replacement =
          '@interface OSFlutterInAppMessages : NSObject<FlutterPlugin, OSInAppMessageLifecycleListener, OSInAppMessageClickListener>';
      if (contents.contains(needle)) {
        contents = contents.replaceAll(needle, replacement);
        inAppHeader.writeAsStringSync(contents);
        stdout.writeln(
            '[plugin_patches] -> onesignal_flutter / OSFlutterInAppMessages.h patched');
        patched = true;
      }
    }
  }

  return patched;
}

void _patchGeneratedPluginRegistrant(Directory projectRoot) {
  final file = File(
      p.join(projectRoot.path, 'ios', 'Runner', 'GeneratedPluginRegistrant.m'));
  if (!file.existsSync()) return;

  var contents = file.readAsStringSync();
  final changedImports = contents.contains('@import firebase_core;') ||
      contents.contains('@import firebase_messaging;');
  final hasDirectRegistration = contents
          .contains('[FLTFirebaseCorePlugin registerWithRegistrar:') ||
      contents.contains('[FLTFirebaseMessagingPlugin registerWithRegistrar:');

  // Remove direct @import firebase_*; we rely on dynamic lookup.
  contents = contents.replaceAll(RegExp(r'@import firebase_core;\s*'), '');
  contents = contents.replaceAll(RegExp(r'@import firebase_messaging;\s*'), '');

  // Replace direct registration with NSClassFromString guards.
  const registrationNeedleCore =
      '[FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];';
  const registrationNeedleMessaging =
      '[FLTFirebaseMessagingPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseMessagingPlugin"]];';

  if (contents.contains(registrationNeedleCore)) {
    contents = contents.replaceFirst(
      registrationNeedleCore,
      '  Class firebaseCoreClass = NSClassFromString(@"FLTFirebaseCorePlugin");\n'
      '  if (firebaseCoreClass) {\n'
      '    [firebaseCoreClass performSelector:@selector(registerWithRegistrar:)\n'
      '                            withObject:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];\n'
      '  }',
    );
  }

  if (contents.contains(registrationNeedleMessaging)) {
    contents = contents.replaceFirst(
      registrationNeedleMessaging,
      '  Class firebaseMessagingClass = NSClassFromString(@"FLTFirebaseMessagingPlugin");\n'
      '  if (firebaseMessagingClass) {\n'
      '    [firebaseMessagingClass performSelector:@selector(registerWithRegistrar:)\n'
      '                                  withObject:[registry registrarForPlugin:@"FLTFirebaseMessagingPlugin"]];\n'
      '  }',
    );
  }

  // Wrap registration with DisableIosFirebase flag from Info.plist.
  if (!contents.contains('DisableIosFirebase')) {
    final insertNeedle =
        '[FileSelectorPlugin registerWithRegistrar:[registry registrarForPlugin:@"FileSelectorPlugin"]];';
    if (contents.contains(insertNeedle)) {
      contents = contents.replaceFirst(
        insertNeedle,
        '$insertNeedle\n\n  NSNumber *firebaseDisabled = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"DisableIosFirebase"];\n'
        '  const BOOL isFirebaseDisabled = firebaseDisabled ? firebaseDisabled.boolValue : NO;\n\n'
        '  if (!isFirebaseDisabled) {\n'
        '    Class firebaseCoreClass = NSClassFromString(@"FLTFirebaseCorePlugin");\n'
        '    if (firebaseCoreClass) {\n'
        '      [firebaseCoreClass performSelector:@selector(registerWithRegistrar:)\n'
        '                              withObject:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];\n'
        '    }\n\n'
        '    Class firebaseMessagingClass = NSClassFromString(@"FLTFirebaseMessagingPlugin");\n'
        '    if (firebaseMessagingClass) {\n'
        '      [firebaseMessagingClass performSelector:@selector(registerWithRegistrar:)\n'
        '                                    withObject:[registry registrarForPlugin:@"FLTFirebaseMessagingPlugin"]];\n'
        '    }\n'
        '  }',
      );
    }
  }

  if (changedImports || hasDirectRegistration) {
    file.writeAsStringSync(contents);
    stdout.writeln(
        '[plugin_patches] Patched GeneratedPluginRegistrant for Firebase gating.');
  }
}

void _patchSignInWithApple(Directory projectRoot) {
  final symlinkPath = p.join(projectRoot.path, 'ios', '.symlinks', 'plugins',
      'sign_in_with_apple', 'ios', 'Classes', 'SignInWithAppleError.swift');
  final podPath = p.join(projectRoot.path, 'ios', 'Pods', 'sign_in_with_apple',
      'ios', 'Classes', 'SignInWithAppleError.swift');

  for (final path in [symlinkPath, podPath]) {
    final file = File(path);
    if (!file.existsSync()) continue;
    var contents = file.readAsStringSync();
    if (!contents.contains('case .credentialImport') ||
        !contents.contains('@unknown default')) {
      contents = contents.replaceFirst(
        'switch code {',
        '''
switch code {
        case .credentialImport:
            errorCode = "authorization-error/credential-import"
        case .credentialExport:
            errorCode = "authorization-error/credential-export"
        case .preferSignInWithApple:
            errorCode = "authorization-error/prefer-sign-in-with-apple"
        case .deviceNotConfiguredForPasskeyCreation:
            errorCode = "authorization-error/device-not-configured-for-passkey-creation"''',
      );
      if (!contents.contains('@unknown default')) {
        contents = contents.replaceFirst(
          RegExp(r'(default:\s*errorCode = "[^"]+"\s*)}', multiLine: true),
          r'$1'
          "\n        @unknown default:\n            errorCode = \"authorization-error/unknown\" \n        }",
        );
      }
      file.writeAsStringSync(contents);
      stdout.writeln(
          '[plugin_patches] Patched SignInWithAppleError.swift (exhaustive switch).');
    }
  }
}

void _pruneStoreKit1Dependencies(Directory projectRoot) {
  final depsFile =
      File(p.join(projectRoot.path, '.flutter-plugins-dependencies'));
  if (!depsFile.existsSync()) return;
  try {
    final json =
        jsonDecode(depsFile.readAsStringSync()) as Map<String, dynamic>;
    final plugins = json['plugins'] as Map<String, dynamic>?;
    if (plugins == null) return;
    var changed = false;

    bool pruneList(List<dynamic>? list) {
      if (list == null) return false;
      final initial = list.length;
      list.removeWhere(
          (p) => p is Map && p['name'] == 'in_app_purchase_storekit');
      return list.length != initial;
    }

    for (final entry in plugins.entries) {
      if (entry.value is List) {
        if (pruneList(entry.value as List)) changed = true;
      }
    }

    if (changed) {
      depsFile
          .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(json));
      stdout.writeln(
          '[plugin_patches] Pruned in_app_purchase_storekit from .flutter-plugins-dependencies');
    }
  } catch (e) {
    stdout.writeln('[plugin_patches] Failed to prune storekit1: $e');
  }
}
