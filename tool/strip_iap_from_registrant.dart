import 'dart:io';

/// Удаляет импорт и регистрацию `InAppPurchasePlugin` из
/// `ios/Runner/GeneratedPluginRegistrant.m`.
void main() {
  const registrantPath = 'ios/Runner/GeneratedPluginRegistrant.m';
  final file = File(registrantPath);
  if (!file.existsSync()) {
    stderr.writeln(
        '[strip_iap_from_registrant] File not found: $registrantPath. Skipping.');
    exit(0);
  }

  final original = file.readAsStringSync();
  final importBlockPattern = RegExp(
    r'#if __has_include\(<in_app_purchase_storekit/InAppPurchasePlugin\.h>\)'
    r'[\s\S]*?'
    r'#endif\s*',
    multiLine: true,
  );
  final registrationPattern = RegExp(
    r'^\s*\[InAppPurchasePlugin registerWithRegistrar:[^\n]+\n',
    multiLine: true,
  );

  final hasForbiddenBlock = importBlockPattern.hasMatch(original) ||
      registrationPattern.hasMatch(original);

  final updated = _stripPluginBlock(
    original,
    importBlockPattern: importBlockPattern,
    registrationPattern: registrationPattern,
  );

  if (!hasForbiddenBlock) {
    stdout.writeln(
        '[strip_iap_from_registrant] No in_app_purchase_storekit block to remove.');
    return;
  }

  file.writeAsStringSync(updated);
  stderr.writeln(
      '[strip_iap_from_registrant] InAppPurchasePlugin удалён из GeneratedPluginRegistrant.m. Продолжаем сборку (проверьте, что StoreKit1 не используется).');
}

String _stripPluginBlock(
  String input, {
  required RegExp importBlockPattern,
  required RegExp registrationPattern,
}) {
  final cleanedImports = input.replaceFirst(importBlockPattern, '');
  final cleanedRegistration =
      cleanedImports.replaceFirst(registrationPattern, '\n');

  final normalized = cleanedRegistration.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return '${normalized.trimRight()}\n';
}
