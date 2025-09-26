const int ANIMATED_BODY_MS = 500;
const bool kUseLeoQuiz =
    true; // фича-флаг для включения LeoQuizWidget вместо старого QuizWidget
// Фича-флаг аварийного отключения списаний GP в чате (rollback режим)
// При true: отправка сообщений не списывает GP, показываем «Временно бесплатно»
const bool kDisableGpSpendInChat = false;
// Фича-флаг реакций Макса на weekly check-in (server-side webhook)
const bool kEnableWeeklyReaction = true;
// Фича-флаг показа recommended chips в чатах Макса
const bool kEnableGoalChips = true;
// Фича-флаги клиентских реакций (тонкий режим)
const bool kEnableClientGoalReactions = true;
const bool kEnableClientWeeklyReaction = true;

// Фича-флаг: использовать реальный этаж уровня (floor_number) в клиентской логике
// При false — сохраняется поведение «все уровни 1..10 на этаже 1»
const bool kUseFloorMapping =
    true; // включено для dev-проверки FNN/гейтинга по этажу
