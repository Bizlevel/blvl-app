import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/services/notification_log_service.dart';
import 'package:bizlevel/utils/app_scaffold_messenger.dart';

enum _BannerType { success, info, warn, error }

class NotificationCenter {
  NotificationCenter._();

  static void showSuccess(BuildContext context, String message,
      {int ms = 3500, String? route}) {
    _show(
      context,
      message,
      _BannerType.success,
      _BannerOptions(ms: ms, route: route),
    );
  }

  static void showInfo(BuildContext context, String message,
      {int ms = 3500, String? route}) {
    _show(
      context,
      message,
      _BannerType.info,
      _BannerOptions(ms: ms, route: route),
    );
  }

  static void showWarn(BuildContext context, String message,
      {int ms = 3500,
      VoidCallback? onAction,
      String? actionLabel,
      String? route}) {
    _show(
      context,
      message,
      _BannerType.warn,
      _BannerOptions(
        ms: ms,
        onAction: onAction,
        actionLabel: actionLabel,
        route: route,
      ),
    );
  }

  static void showError(BuildContext context, String message,
      {int ms = 3500, String? route}) {
    _show(
      context,
      message,
      _BannerType.error,
      _BannerOptions(ms: ms, route: route),
    );
  }

  static void _show(
    BuildContext context,
    String message,
    _BannerType type,
    _BannerOptions opts,
  ) {
    final messenger =
        rootScaffoldMessengerKey.currentState ?? ScaffoldMessenger.of(context);
    messenger.hideCurrentMaterialBanner();

    final _BannerStyle style = _resolveStyle(type);

    final action =
        opts.onAction != null && (opts.actionLabel?.isNotEmpty ?? false)
            ? MaterialBannerAction(
                label: opts.actionLabel!, onPressed: opts.onAction!)
            : null;

    final banner = MaterialBanner(
      backgroundColor: style.bg,
      leading: Icon(style.icon),
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
    // Лог в локальный журнал
    try {
      NotificationLogService.instance.record(
        kind: switch (type) {
          _BannerType.success => NotificationKind.success,
          _BannerType.info => NotificationKind.info,
          _BannerType.warn => NotificationKind.warn,
          _BannerType.error => NotificationKind.error,
        },
        message: message,
        category: 'banner',
        route: opts.route,
      );
    } catch (_) {}
    // Автозакрытие баннера через ms
    Future<void>.delayed(Duration(milliseconds: opts.ms)).then((_) {
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

class _BannerOptions {
  final int ms;
  final VoidCallback? onAction;
  final String? actionLabel;
  final String? route;
  const _BannerOptions({
    this.ms = 3500,
    this.onAction,
    this.actionLabel,
    this.route,
  });
}

class _BannerStyle {
  final Color bg;
  final IconData icon;
  const _BannerStyle(this.bg, this.icon);
}

_BannerStyle _resolveStyle(_BannerType type) {
  switch (type) {
    case _BannerType.success:
      return const _BannerStyle(
          AppColor.backgroundSuccess, Icons.check_circle_outline);
    case _BannerType.info:
      return const _BannerStyle(AppColor.backgroundInfo, Icons.info_outline);
    case _BannerType.warn:
      return const _BannerStyle(
          AppColor.backgroundWarning, Icons.warning_amber_rounded);
    case _BannerType.error:
      return const _BannerStyle(AppColor.backgroundError, Icons.error_outline);
  }
}
