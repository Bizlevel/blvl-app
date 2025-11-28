/// Дружелюбные сообщения для пользователя
///
/// Централизованное место для всех текстов, которые видит пользователь.
/// Вместо технических ошибок показываем понятные сообщения.
library;

class FriendlyMessages {
  // Успешные действия
  static const String goalSaved = '✅ Цель сохранена!';
  static const String goalVersionSaved = '✅ Этап завершен!';
  static const String sprintStarted =
      '🚀 Спринт начат! Первые задачи уже ждут тебя.';
  static const String dayCompleted = '✅ День завершен! Отличная работа!';
  static const String weekCompleted =
      '🎯 Неделя завершена! Продолжай в том же духе!';

  // Мотивационные сообщения при GP-бонусах
  static const String streak7Bonus = '🎉 Ты заработал +50 GP за 7 дней подряд!';
  static const String streak14Bonus =
      '🔥 Ты заработал +100 GP за 14 дней подряд!';
  static const String streak21Bonus =
      '💪 Ты заработал +200 GP за 21 день подряд!';
  static const String streak28Bonus =
      '🏆 Ты заработал +300 GP за полный спринт!';

  // Ошибки (дружелюбные)
  static const String networkError =
      'Не удалось подключиться к серверу. Проверь интернет и попробуй снова.';
  static const String unknownError =
      'Что-то пошло не так. Попробуй еще раз или напиши в поддержку.';
  static const String goalLoadError =
      'Не удалось загрузить цель. Обнови страницу или попробуй позже.';
  static const String saveError =
      'Не удалось сохранить. Проверь интернет и попробуй снова.';
  static const String authRequired =
      'Для этого действия нужно войти в аккаунт.';

  // Предупреждения
  static const String fillAllFields = 'Заполни все поля, чтобы продолжить';
  static const String confirmAction = 'Точно хочешь это сделать?';
  static const String unsavedChanges = 'У тебя есть несохраненные изменения';

  // Информационные
  static const String loading = 'Загружаем...';
  static const String saving = 'Сохраняем...';
  static const String noData = 'Пока здесь пусто';
  static const String comingSoon = 'Скоро здесь появится что-то интересное!';

  // Специфичные для Goal
  static const String goalNotReady =
      'Сначала нужно сформулировать цель в профиле';
  static const String levelRequired =
      'Пройди следующий уровень, чтобы открыть этот этап';
  static const String sprintAlreadyStarted = 'Спринт уже начат!';
  static const String sprintPaused =
      'Спринт приостановлен. Можешь возобновить в любой момент.';

  /// Получить сообщение об ошибке по коду
  static String getErrorMessage(String? errorCode) {
    if (errorCode == null) return unknownError;

    switch (errorCode) {
      case 'network_error':
      case 'timeout':
        return networkError;
      case 'unauthorized':
      case 'auth_required':
        return authRequired;
      case 'goal_load_error':
        return goalLoadError;
      case 'save_error':
        return saveError;
      default:
        return unknownError;
    }
  }

  /// Получить сообщение о бонусе по количеству дней
  static String getStreakBonusMessage(int days) {
    switch (days) {
      case 7:
        return streak7Bonus;
      case 14:
        return streak14Bonus;
      case 21:
        return streak21Bonus;
      case 28:
        return streak28Bonus;
      default:
        return '🎁 Ты заработал бонус!';
    }
  }
}
