/// Утилиты для получения человеческих названий версий цели
///
/// Централизованное место для маппинга технических версий (v1, v2, v3, v4)
/// на понятные пользователю названия.
library;

/// Возвращает человеческое название версии цели
String getGoalVersionName(int version) {
  switch (version) {
    case 1:
      return 'Семя цели';
    case 2:
      return 'Метрики';
    case 3:
      return 'План на 4 недели';
    case 4:
      return 'Готовность к старту';
    default:
      return 'v$version';
  }
}

/// Возвращает короткое название версии (для компактных UI)
String getGoalVersionShortName(int version) {
  switch (version) {
    case 1:
      return 'Семя';
    case 2:
      return 'Метрики';
    case 3:
      return 'План';
    case 4:
      return 'Старт';
    default:
      return 'v$version';
  }
}

/// Возвращает эмодзи для версии (опционально)
String getGoalVersionEmoji(int version) {
  switch (version) {
    case 1:
      return '🌱';
    case 2:
      return '📊';
    case 3:
      return '📋';
    case 4:
      return '🚀';
    default:
      return '🎯';
  }
}
