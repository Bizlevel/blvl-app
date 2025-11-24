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
    final jsonMap = jsonDecode(depsFile.readAsStringSync()) as Map<String, dynamic>;
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

