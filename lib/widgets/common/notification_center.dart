import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

enum _BannerType { success, info, warn, error }

class NotificationCenter {
  NotificationCenter._();

  static void showSuccess(BuildContext context, String message,
      {int ms = 3500}) {
    _show(context, message, _BannerType.success, ms: ms);
  }

  static void showInfo(BuildContext context, String message, {int ms = 3500}) {
    _show(context, message, _BannerType.info, ms: ms);
  }

  static void showWarn(BuildContext context, String message,
      {int ms = 3500, VoidCallback? onAction, String? actionLabel}) {
    _show(context, message, _BannerType.warn,
        ms: ms, onAction: onAction, actionLabel: actionLabel);
  }

  static void showError(BuildContext context, String message, {int ms = 3500}) {
    _show(context, message, _BannerType.error, ms: ms);
  }

  static void _show(BuildContext context, String message, _BannerType type,
      {int ms = 3500, VoidCallback? onAction, String? actionLabel}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentMaterialBanner();

    final Color bg;
    final IconData icon;
    switch (type) {
      case _BannerType.success:
        bg = const Color(0xFFE6F6ED);
        icon = Icons.check_circle_outline;
        break;
      case _BannerType.info:
        bg = const Color(0xFFE8F0FE);
        icon = Icons.info_outline;
        break;
      case _BannerType.warn:
        bg = const Color(0xFFFFF4E5);
        icon = Icons.warning_amber_rounded;
        break;
      case _BannerType.error:
        bg = const Color(0xFFFFEBEE);
        icon = Icons.error_outline;
        break;
    }

    final action = onAction != null && (actionLabel?.isNotEmpty ?? false)
        ? MaterialBannerAction(label: actionLabel!, onPressed: onAction)
        : null;

    final banner = MaterialBanner(
      backgroundColor: bg,
      leading: Icon(icon),
      content: Text(message),
      actions: [
        if (action != null)
          TextButton(onPressed: action.onPressed, child: Text(action.label))
        else
          TextButton(
            onPressed: () => messenger.hideCurrentMaterialBanner(),
            child: const Text('ОК'),
          ),
      ],
    );

    messenger.showMaterialBanner(banner);
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        level: SentryLevel.info,
        category: 'notif',
        message: 'notif_banner_shown:${type.name}',
        data: {'message': message},
      ));
    } catch (_) {}
    // Автозакрытие баннера через ms
    Future<void>.delayed(Duration(milliseconds: ms)).then((_) {
      if (messenger.mounted) {
        messenger.hideCurrentMaterialBanner();
      }
    });
  }
}

class MaterialBannerAction {
  final String label;
  final VoidCallback onPressed;
  MaterialBannerAction({required this.label, required this.onPressed});
}
