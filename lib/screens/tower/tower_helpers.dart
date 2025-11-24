part of '../biz_tower_screen.dart';

// Хелперы: SnackBar, breadcrumbs, ошибки, лейблы
void _showBlockedSnackBar(BuildContext context, {bool premium = false}) {
  final String text =
      premium ? 'Доступно в Премиум' : 'Завершите предыдущий уровень';
  NotificationCenter.showWarn(context, text);
}

void _logBreadcrumb(String message, {String category = 'tower'}) {
  try {
    Sentry.addBreadcrumb(
      Breadcrumb(level: SentryLevel.info, category: category, message: message),
    );
  } catch (_) {}
}

void _captureError(Object error, StackTrace stackTrace) {
  try {
    Sentry.captureException(error, stackTrace: stackTrace);
  } catch (_) {}
}

Widget _buildNodeLabel(String label, {TextAlign textAlign = TextAlign.center}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      textAlign: textAlign,
      maxLines: 3,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: kNodeLabelStyle,
    ),
  );
}

Alignment _alignmentForColumn(int col) {
  switch (col) {
    case 0:
      return Alignment.centerLeft;
    case 1:
      return Alignment.center;
    default:
      return Alignment.centerRight;
  }
}

// Утилита затемнения цвета (используется в плитке уровня)
Color _darker(Color c, double t) {
  final lerped = Color.lerp(c, AppColor.textColor, t);
  return lerped ?? c;
}
