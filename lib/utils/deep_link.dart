// Функции для обработки deep-link схемы bizlevel://
/// Преобразует URI deep-link'ов в пути GoRouter:
/// - `bizlevel://levels/<id>` → `/levels/<id>`
/// - `bizlevel://auth/confirm` → `/login?registered=true`
/// - `bizlevel://ref/<code>` → `/profile` (код сохраняется локально)
/// - `bizlevel://promo/<code>` → `/profile` (код сохраняется локально)
/// Возвращает null, если ссылка не распознана.
String? mapBizLevelDeepLink(String link) {
  try {
    final uri = Uri.parse(link);
    if (uri.scheme == 'bizlevel') {
      // URI форм bizlevel://levels/42 => host=levels, pathSegments=["42"]
      final first = uri.host.isNotEmpty
          ? uri.host
          : (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null);
      final segments = uri.host.isNotEmpty
          ? uri.pathSegments
          : uri.pathSegments.skip(1).toList();

      // Обработка уровней: bizlevel://levels/42 → /levels/42
      if (first == 'levels' && segments.isNotEmpty) {
        final id = int.tryParse(segments.first);
        if (id != null) return '/levels/$id';
      }

      // Обработка auth-ссылок: bizlevel://auth/confirm → /login?registered=true
      if (first == 'auth' && segments.isNotEmpty) {
        if (segments.first == 'confirm') {
          return '/login?registered=true';
        }
      }

      // Реферальные и промо ссылки: если код есть — на регистрацию (для новых) или профиль (для авторизованных)
      // Фактический роутинг определяется в main.dart на основе авторизации
      if (first == 'ref' || first == 'referral' || first == 'promo') {
        // Возвращаем специальный путь, который обработается в main.dart
        return '/register?from_referral=true';
      }
    }
  } catch (_) {
    // ignore parse errors
  }
  return null;
}

String? extractReferralCodeFromDeepLink(Uri uri) {
  if (uri.scheme != 'bizlevel') return null;
  final first = uri.host.isNotEmpty
      ? uri.host
      : (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null);
  final segments = uri.host.isNotEmpty
      ? uri.pathSegments
      : uri.pathSegments.skip(1).toList();

  if (first == 'ref' || first == 'referral') {
    if (segments.isNotEmpty) return segments.first;
  }

  return uri.queryParameters['ref'] ?? uri.queryParameters['referral'];
}

String? extractPromoCodeFromDeepLink(Uri uri) {
  if (uri.scheme != 'bizlevel') return null;
  final first = uri.host.isNotEmpty
      ? uri.host
      : (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null);
  final segments = uri.host.isNotEmpty
      ? uri.pathSegments
      : uri.pathSegments.skip(1).toList();

  if (first == 'promo') {
    if (segments.isNotEmpty) return segments.first;
  }

  return uri.queryParameters['promo'];
}
