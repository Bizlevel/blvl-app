// Функции для обработки deep-link схемы bizlevel://
/// Преобразует URI deep-link'ов в пути GoRouter:
/// - `bizlevel://levels/<id>` → `/levels/<id>`
/// - `bizlevel://auth/confirm` → `/login?registered=true`
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
    }
  } catch (_) {
    // ignore parse errors
  }
  return null;
}
