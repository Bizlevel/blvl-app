// Функции для обработки deep-link схемы bizlevel://
/// Преобразует URI вида `bizlevel://levels/<id>` в путь GoRouter
/// `/levels/<id>`. Возвращает null, если ссылка не распознана.
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
      if (first == 'levels' && segments.isNotEmpty) {
        final id = int.tryParse(segments.first);
        if (id != null) return '/levels/$id';
      }
    }
  } catch (_) {
    // ignore parse errors
  }
  return null;
}
