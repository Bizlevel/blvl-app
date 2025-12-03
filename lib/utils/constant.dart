const int animatedBodyMs = 500;
const bool kUseLeoQuiz =
    true; // фича-флаг для включения LeoQuizWidget вместо старого QuizWidget
// Фича-флаг аварийного отключения списаний GP в чате (rollback режим)
// При true: отправка сообщений не списывает GP, показываем «Временно бесплатно»
const bool kDisableGpSpendInChat = false;
// Удалены фиче‑флаги weekly/daily/chips — концепция упрощена до единой цели и журнала

// Фичефлаги страницы Цель/чекпоинтов
const bool kShowZWOnGoal = true; // строка «Z/W/Осталось N» и подсказка
const bool kL7PrefillToJournal =
    true; // префилл записи при выборе «Усилить применение»
const bool kGoalStickyCta = true; // нижняя панель CTA на мобайле

// Фича-флаг: использовать реальный этаж уровня (floor_number) в клиентской логике
// При false — сохраняется поведение «все уровни 1..10 на этаже 1»
const bool kUseFloorMapping =
    true; // включено для dev-проверки FNN/гейтинга по этажу

// Фича-флаг: показывать кнопки входа/регистрации через Google
const bool kEnableGoogleAuth = true;

// Фича-флаг: показывать кнопки входа/регистрации через Apple (iOS/Web)
const bool kEnableAppleAuth = true;

// Фича‑флаг нормализации current_level (поэтапное включение/rollback)
const bool kNormalizeCurrentLevel = true;
