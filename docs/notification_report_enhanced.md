# Расширенный отчёт по уведомлениям BizLevel

## 1. Текущее состояние (по коду и статус-докам)

### Локальные уведомления (OS-level)
- **Подключён** `flutter_local_notifications` (^17.2.1). Инициализация и расписание выполняются в рантайме.
- **В `main.dart`** выполняется подготовка таймзон (`timezone`), затем:
  - `NotificationsService.initialize()` — базовая инициализация плагина; на iOS запрашиваются разрешения (`alert/badge/sound`).
  - `NotificationsService.scheduleWeeklyPlan()` — планируются еженедельные напоминания: Пн 09:00 (план недели), Ср 14:00 (середина недели), Пт 16:00 (напоминание), Вс 10:00/13:00/18:00 (чек-ин).
- **Сообщения/каналы**: Android-канал `goal_weekly_channel` (importance/priority high).
- **Обработчик тапа** по уведомлению не задан (нет deeplink-навигации).

### Внутренние уведомления (UI в приложении)
- Повсеместно используются `SnackBar` (навигация, ошибки/успехи сохранений, магазин GP и пр.).
- `NotificationBox` (иконка «колокол» с бейджем) — декоративный индикатор в AppBar некоторых экранов (не связан с системными уведомлениями).

### Покрытие платформ
- **iOS**: разрешения запрашиваются корректно; локальные уведомления работают.
- **Android (<13)**: планирование уведомлений работает; канал создаётся.
- **Android (13+)**: разрешение `POST_NOTIFICATIONS` в манифесте отсутствует (см. раздел «Проблемы»).
- **Web**: плагин не работает; инициализация обёрнута в `try/catch` — падений нет, уведомлений нет (по плану).

## 2. Что работает стабильно / Где есть проблемы

### ✅ Работает
- iOS локальные уведомления
- Android до версии 13
- UI-`SnackBar`
- Визуальный `NotificationBox`

### ⚠️ Проблемы/риски
1. **Android 13+** требует явного разрешения: нет `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>` и нет runtime-запроса разрешения ⇒ уведомления не показываются.
2. **Таймзона**: используется `DateTime.now().timeZoneName` для `tz.getLocation(...)`, что не всегда IANA-идентификатор ⇒ возможный фолбэк на UTC и сдвиг времени уведомлений.
3. **Перезагрузка устройства**: нет `RECEIVE_BOOT_COMPLETED` и логики восстановления расписания ⇒ уведомления могут «теряться» до повторного планирования.
4. **Тап по уведомлению** ничего не делает (нет `onDidReceiveNotificationResponse`) ⇒ отсутствует переход на нужный экран (`/goal`, `/goal-checkpoint/:v` и т.д.).
5. **Small icon Android**: используется `ic_launcher`, что может давать залитую квадратную иконку вместо монохромной status-иконки.
6. **Remote push (FCM)** отсутствует по MVP — ограничение по замыслу (не баг).
7. **Персонализация времени** — не реализована возможность пользователю выбирать время уведомлений.
8. **Аналитика** — отсутствует отслеживание CTR и эффективности уведомлений.

### 2.5 Проверка реализуемости и потенциальные конфликты (по коду и Supabase)
- Локальные еженедельные уведомления уже реализованы в `NotificationsService.scheduleWeeklyPlan()` и вызываются из `main.dart` — совместимо с разделом «Недельный цикл целей» (нужны лишь фиксы Android 13+/таймзоны/deeplink).
- Deeplink при тапе по уведомлению отсутствует — необходимо добавить `onDidReceiveNotificationResponse` и маршрутизацию через GoRouter (совместимо с текущей навигацией).
- Восстановление расписания после перезагрузки не настроено — для постоянных weekly‑уведомлений рекомендуется добавить `RECEIVE_BOOT_COMPLETED` (опционально).
- Предложенные OS‑сценарии «чат‑ответ» конфликтуют с чисто локальной реализацией (без фоновых задач) — для надёжной доставки требуется FCM или серверный пуш; оставить как будущий этап (M2).
- Точки данных для триггеров присутствуют на клиенте:
  - GP: `GpService`, `gpBalanceProvider` (Hive+SWR) — можно инициировать баннер «низкий баланс», успех/ошибку покупок/разблокировок.
  - Цели: `GoalsRepository` (`upsertGoalField`, `upsertWeek/updateWeek`), провайдеры `goalLatest/goalVersions/goalProgressProvider` — можно инициировать баннеры «шаг сохранён», «версия готова/что дальше».
  - Башня: `tower_tiles.dart` (`_unlockFloor`, обработка ошибок/успеха) — баннеры «этаж открыт»/ошибки.
  - Библиотека: `LibraryRepository` + провайдеры — баннер о новых материалах после обновления кеша.
- Supabase: отдельной серверной логики для push сейчас нет — конфликтов нет; всё, что отмечено как FCM/сервер, помечено как будущие этапы.

Дополнительно по текущему коду и навигации:
- Навигация через `AppShell` (PageView) требует глобального доступа к роутеру (или `navigatorKey`), чтобы обрабатывать deeplink из обработчика уведомлений вне контекста виджета; также при переходе может понадобиться переключить активный таб перед `go()` на вложенный маршрут.
- Планирование сейчас использует стабильные ID (1001/1002/1003/11xx) — это безопасно для повторного планирования на старте (идемпотентность по ID). Рекомендуется придерживаться стабильных ID или явно отменять только «свои» уведомления перед пере‑планированием.
- `NotificationBox` — чисто визуальный индикатор и не связан с системными уведомлениями; центр уведомлений в приложении планируется отдельно (M1).

## 3. Стратегия уведомлений (продукт + маркетинг)

### 3.1 Внешние уведомления (OS-level push)

#### Приоритет 1: Retention & Engagement

**Недельный цикл целей** (улучшенная версия):
- **Пн 9:00** → "🎯 Новая неделя! {Name}, какой главный результат хотите получить на этой неделе?"
- **Ср 14:00** → "⚡ Середина недели. Ты прошел {N}% пути к цели"
- **Пт 16:00** → "📊 Выходные близко! Самое время подготовиться к чекину"
- **Вс 18:00** → "✍️ {Name}, заполни итоги недели за 5 минут"

**Прогресс башни** (новое):
- После 24ч неактивности: "🏗️ Твои цели ждут! Уровень {N} почти пройден"
- Разблокировка этажа: "🎉 Поздравляем! Этаж {N} открыт. Новые навыки ждут!"
- Завершение мини-кейса: "💼 Кейс завершен! Следующий уровень разблокирован"

**GP-экономика** (критично):
- Баланс < 10 GP: "⚠️ Остался последние GP для чата с тренером"
- Баланс = 0: "🔴 GP закончились. Пополни баланс для продолжения"
- Бонус доступен: "🎁 +50 GP за заполнение профиля доступны!"
- Покупка подтверждена: "✅ +{N} GP успешно начислены"

#### Приоритет 2: Education & Motivation

**Мотивационные** (1 раз в день, персонализированное время):
- Утренние (7-9): Цитаты из `motivational_quotes` + "Начни день с урока"
- Вечерние (19-21): "Завершил ли ты {daily_action} сегодня?"

**Образовательные**:
- Новый артефакт: "📄 Шаблон {artifact_name} готов к скачиванию"
- Завершение квиза: "🧠 Отличная работа! Навык {skill} +1"
- Новый уровень доступен: "🎓 Уровень {N}: {title} ждет тебя"


### 3.2 Внутренние уведомления (in-app)

#### Компоненты уведомлений

**Toast/Banner система**:
```
- Успех: Зеленый баннер сверху с анимацией slideDown + fadeIn
- Информация: Синий баннер с иконкой ℹ️
- Предупреждение: Оранжевый с легкой вибрацией
- Ошибка: Красный со звуком alert.mp3
```

**Приоритетные события для in-app**:

**Башня BizLevel**:
- "🎯 Версия цели v{N} сохранена" + CTA "Перейти к башне"
- "🏆 Уровень {N} завершен! Навык {skill} +1"
- "🔓 Чекпоинт цели v{N} доступен" + CTA "Начать"
- "⚠️ Завершите уровень {N-1} для продолжения"

**Уровни и обучение**:
- "📹 Видео недоступно — включен резервный режим"
- "💾 Артефакт {name} сохранен в загрузки"
- "📚 Новые материалы добавлены в библиотеку"

**GP и магазин**:
- "💎 +{N} GP начислено на баланс"
- "⚠️ Недостаточно GP. Баланс: {current}, требуется: {needed}"
- "🛒 Покупка обрабатывается..."
- "✅ Этаж {N} успешно разблокирован"

#### Центр уведомлений (новая функция)

**Структура**:
- Иконка колокольчика в AppBar с счетчиком непрочитанных
- История последних 20 событий с группировкой по дням
- Фильтры: Все / Цели / GP / Обучение / Чаты
- Свайп для удаления, тап для перехода
- Пагинация для истории >20 событий

### 3.3 Условия срабатывания (binding к событиям в коде и БД)

#### In-app баннеры (всплывающие, небольшая анимация)
- Башня / этажи:
  - "✅ Этаж {N} разблокирован" — после успешного `GpService.unlockFloor(...)` (см. `tower_tiles.dart` → `_unlockFloor` ветка успеха).
  - "⚠️ Недостаточно GP" — когда `GpService.unlockFloor` вернул ошибку `gp_insufficient` или `gpBalanceProvider.value < threshold` при открытии диалога.
  - "⚠️ Завершите предыдущий уровень" — при попытке открыть заблокированный узел (есть Snackbar; заменить на баннер) — `tower_tiles.dart` → `_handleLevelTap/_handleCheckpointTap`.

- Цель / чекпоинты:
  - "✔ Шаг сохранён. Открылось следующее поле" — успешный `GoalsRepository.upsertGoalField` (уже есть Snackbar в `GoalCheckpointScreen`; заменяем на баннер).
  - "🎯 Версия v{N} сохранена" — успешное сохранение версии (в `GoalVersionForm`/`GoalCheckpointScreen`).
  - "💡 Что дальше" — при наличии `hasGoalVersionProvider(version-1)=true` и `hasGoalVersionProvider(version)=false` на экране `/goal`.

- Недельный чек-ин:
  - "📈 Итоги недели сохранены" — успешный `GoalsRepository.updateWeek/upsertWeek` (заменяем Snackbar на баннер на `GoalScreen`).
  - "ℹ️ Укажите метрику/число" — валидационные ошибки форм (уже есть Snackbar; заменить на баннер).

- Чаты (Лео/Макс):
  - "💬 Новый ответ от Макса/Лео" — когда пришёл ответ ассистента, а текущая активная вкладка shell ≠ `/chat` (проверка активного таба в `AppShell`). Источник события — коллбек в `LeoDialogScreen`/`LeoService` после получения сообщения.

- GP и покупки:
  - "+{N} GP начислено" — успешная верификация покупки (`GpService.verifyPurchase`) на `GpStoreScreen`.
  - "🛒 Покупка обрабатывается..." → "✅ Покупка подтверждена/Ошибка" — состояние процесса init→verify в `GpStoreScreen`.

- Библиотека:
  - "📚 Новые материалы в библиотеке" — после успешного обновления данных в `LibraryRepository` (сравнение timestamp/количества; не чаще 1 раза в сутки).

Условия показа баннеров:
- Не перекрывать критические модальные окна; автоисчезновение через 3–5 секунд; стек не более 2 одновременно.
- Дедупликация по ключу события (например, `goal_step_saved` с таймаутом 5 минут).

#### OS‑level (локальные/FCM)
- Недельный цикл целей (локальные):
  - Пн 09:00, Ср 14:00, Пт 16:00, Вс 10/13/18 — как в `NotificationsService.scheduleWeeklyPlan()`; скорректировать через IANA таймзону.
- Баланс GP низкий (локальные или FCM):
  - При изменении `gpBalanceProvider` → если `balance < threshold` и прошло ≥24ч с последнего уведомления.
- Разблокировка этажа (локальные):
  - Сразу после успешного `unlockFloor` (однократно), с deeplink в `/tower`.
- Чат‑ответ (FCM, будущий этап):
  - Триггер на сервере при новом ассистентском сообщении; отправка пуша с deeplink `/chat?sessionId=...` только если приложение в фоне и пользователь opt‑in.
- Библиотека дайджест (FCM):
  - Раз в неделю при наличии новых материалов > N за период; deeplink `/library`.

## 4. Архитектура для гибкой настройки

### 4.1 Конфигурационный слой

```dart
// Загружается из Supabase Remote Config
class NotificationConfig {
  // Шаблоны уведомлений
  Map<String, NotificationTemplate> templates;
  
  // Расписание по умолчанию
  Map<String, TimeSlot> defaultSchedule;
  
  // Feature flags для A/B тестов
  Map<String, bool> featureFlags;
  
  // Пользовательские настройки (Hive)
  UserNotificationPreferences userPrefs;
}

class NotificationTemplate {
  String id;
  String titleTemplate; // {name}, {progress}, {level}
  String bodyTemplate;
  String? soundFile;
  bool vibrate;
  int priority;
  String? imageUrl;
  Map<String, dynamic> deepLinkPayload;
  Map<String, String> localizations; // ru, en, kz
}
```

### 4.2 Rules Engine

```dart
abstract class NotificationRule {
  bool shouldTrigger(UserContext context);
  NotificationPayload build(UserContext context);
  DateTime? nextTriggerTime();
  int priority; // для разрешения конфликтов
}

// Примеры правил
class InactivityRule extends NotificationRule {
  final Duration threshold = Duration(hours: 24);
  // Проверка последней активности
}

class LowBalanceRule extends NotificationRule {
  final int threshold = 10;
  // Проверка баланса GP
}

class StreakRule extends NotificationRule {
  final int minStreak = 3;
  // Проверка серии дней
}

class GoalProgressRule extends NotificationRule {
  final double minProgress = 0.5;
  // Проверка прогресса недели
}
```

### 4.3 Персонализация

```dart
class NotificationPersonalizer {
  // A/B тестирование
  String getVariant(String testId, String userId) {
    // Распределение по когортам
  }
  
  // Оптимальное время отправки
  DateTime getBestTimeToSend(String userId, String type) {
    // Анализ активности пользователя
    // Учет часового пояса
    // DND режим (22:00-8:00)
  }
  
  // Динамический контент
  String personalizeMessage(String template, UserData data) {
    // Замена плейсхолдеров
    // Локализация
    // Эмодзи based on user preferences
  }
  
  // Батчинг уведомлений
  List<Notification> batchNotifications(List<Notification> pending) {
    // Максимум 3 в день
    // Приоритизация по важности
    // Группировка похожих
  }
}
```

## 5. Визуальное оформление и UX

### 5.1 iOS (нативный стиль)

- **Звуки**:
  - Custom звук `goal_achieved.caf` для важных (цель, GP)
  - Системный `default` для информационных
  - Без звука для low-priority
- **Вибрация**: только критические (баланс < 5 GP, дедлайн цели)
- **Badge**: количество незавершенных действий недели
- **Группировка**: по категориям через Notification Groups
- **Rich notifications**: с изображениями для достижений

### 5.2 Android

**Каналы уведомлений**:
```xml
- goal_critical: MAX importance, звук + вибрация + heads-up
- goal_reminder: HIGH importance, звук без вибрации
- education: DEFAULT importance, тихие
- gp_economy: HIGH importance, custom звук coin.mp3
- chat_messages: HIGH importance, звук message.mp3
```

**Визуальные элементы**:
- **Small icon**: монохромная иконка башни `ic_stat_tower`
- **Large icon**: аватар пользователя или иконка категории
- **Accent color**: `#4B6BFB` (AppColor.primary)
- **Стили**: BigTextStyle для длинных, InboxStyle для группировки
- **Actions**: "Открыть", "Отложить", "Отметить выполненным"

### 5.3 In-App анимации

```dart
// Появление баннера
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeOutBack,
  transform: Matrix4.translationValues(0, offset, 0),
  child: NotificationBanner(),
)

// Haptic feedback
HapticFeedback.lightImpact(); // iOS success
HapticFeedback.mediumImpact(); // iOS warning
Vibration.vibrate(duration: 50); // Android all

// Звуковые эффекты
AudioPlayer.play('sounds/success.mp3'); // Завершение уровня
AudioPlayer.play('sounds/coin.mp3'); // Начисление GP
AudioPlayer.play('sounds/notification.mp3'); // Общее уведомление
```

## 6. Рекомендации и план внедрения

### 6.1 M0 — Критические исправления (1 неделя)

1. **Android 13+ permissions**:
   ```xml
   <!-- AndroidManifest.xml -->
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   ```
   ```dart
   // Runtime request (через API плагина, без дополнительных зависимостей)
   final androidPlugin = FlutterLocalNotificationsPlugin()
     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
   await androidPlugin?.requestNotificationsPermission();
   ```

2. **Таймзоны**:
   ```dart
   // Добавить flutter_native_timezone
   final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
   tz.setLocalLocation(tz.getLocation(timeZoneName));
   ```

3. **DeepLink навигация**:
   ```dart
   // Инициализация с обработчиком тапа (без использования BuildContext)
   await _plugin.initialize(
     initSettings,
     onDidReceiveNotificationResponse: (details) {
       final payload = details.payload;
       if (payload == null) return;
       final data = json.decode(payload);
       // Вызов глобального роутера/навигационного сервиса
       AppRouter.instance.go(data['route']); // например: "/goal", "/tower"
     },
   );
   // При планировании добавлять payload с маршрутом
   await _plugin.zonedSchedule(
     1001,
     '…',
     '…',
     when,
     details,
     payload: json.encode({ 'route': '/goal' }),
     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
     matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
     androidAllowWhileIdle: true,
   );
   ```

4. **Small icon Android**:
   ```bash
   # Создать монохромную иконку
   res/drawable/ic_stat_tower.xml
   res/drawable-hdpi/ic_stat_tower.png
   res/drawable-xhdpi/ic_stat_tower.png
   ```

5. **Boot receiver** (опционально):
   ```xml
   <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
   <receiver android:name=".BootReceiver">
     <intent-filter>
       <action android:name="android.intent.action.BOOT_COMPLETED"/>
     </intent-filter>
   </receiver>
   ```

6. **Идемпотентное расписание**:
   - Использовать стабильные идентификаторы уведомлений (как сейчас) и безопасно вызывать планирование на старте — дубликаты не появятся.
   - При необходимости — перед планированием отменять только свои ID.

### 6.2 M1 — Улучшения и персонализация (2-3 недели)

**Функциональность**:
- Каналы/категории для детального контроля
- Идемпотентное планирование с версионированием
- Локализация текстов (ru/en/kz)
- Центр уведомлений в приложении
- A11y: Semantics, min hit-targets ≥44px
- Пользовательские настройки времени и категорий

**Smart Scheduling**:
- Анализ активности пользователя
- DND режим (22:00-8:00)
- Батчинг (максимум 3 уведомления в день)
- Учет часовых поясов

**Gamification**:
- Достижения ("🏆 Первый этаж пройден!")

### 6.3 M2 — FCM и серверная логика (4-6 недель)

**Инфраструктура**:
- Подключение `firebase_messaging`
- Серверная отправка через Supabase Edge Functions
- Token management и segmentation
- Silent push для фоновых обновлений

**Продвинутые сценарии**:
- Triggered campaigns на основе событий
- Персонализация через ML
- Cross-device синхронизация
- Rich media (изображения, видео превью)

## 7. Метрики успеха и KPI

### Основные метрики
- **CTR уведомлений** > 15% (цель: 20%)
- **Opt-out rate** < 5% (цель: 3%)
- **DAU увеличение** на 20% после внедрения
- **Retention D7** увеличение на 15%
- **Session length** увеличение на 10%

### Метрики по категориям
- **Недельные цели**: completion rate +25%
- **GP-экономика**: конверсия в покупку +30%
- **Башня**: прогресс по уровням +20%
- **Чаты**: среднее количество сообщений +15%

### A/B тесты
1. **Время отправки**: утро (7-9) vs день (12-14) vs вечер (18-21)
2. **Тон сообщений**: формальный vs дружеский vs мотивационный
3. **Эмодзи**: с эмодзи vs без эмодзи
4. **Частота**: 1 vs 3 vs 5 уведомлений в день
5. **Персонализация**: {name} vs без имени
6. **Urgency**: с дедлайнами vs без

## 8. Тест-чеклист

### Базовая функциональность
- [ ] iOS: первый запуск → запрос разрешений → получение в нужное время
- [ ] Android 13+: запрос POST_NOTIFICATIONS через API плагина → расписание только после grant; отказ — без крэшей
- [ ] Перезагрузка: сохранение расписания
- [ ] Web: отсутствие падений
- [ ] Таймзоны: корректное локальное время (тест 3+ поясов)

### Deeplinks и навигация
- [ ] Тап по уведомлению → нужный экран (в том числе при закрытом приложении)
- [ ] Payload корректно парсится и передаётся в глобальный роутер
- [ ] Навигация из фона/убитого процесса корректна
- [ ] При AppShell/PageView корректно переключается активная вкладка перед переходом на вложенный маршрут
- [ ] Идемпотентное перепланирование при повторных стартах не создаёт дубликаты

### UX и доступность
- [ ] Баннеры читаемы screen reader
- [ ] Hit targets ≥ 44px
- [ ] Анимации плавные (<16ms frame time)
- [ ] Звуки/вибрация работают корректно
- [ ] На Android отображается монохромная small‑icon `ic_stat_tower` в статус‑баре

### Персонализация
- [ ] Пользовательские настройки сохраняются
- [ ] DND режим соблюдается
- [ ] Батчинг работает (≤3 в день)
- [ ] Локализация корректна

## 9. Риски и митигация

| Риск | Вероятность | Влияние | Митигация |
|------|------------|---------|-----------|
| Спам-жалобы | Средняя | Высокое | Строгий батчинг, настройки частоты |
| Технические сбои | Низкая | Высокое | Graceful degradation, мониторинг |
| Низкий CTR | Средняя | Среднее | A/B тесты, персонализация |
| Battery drain | Низкая | Высокое | Оптимизация, exact → inexact alarms |
| Privacy concerns | Низкая | Среднее | Прозрачность, явный opt-in |

## 10. Заключение

Система уведомлений BizLevel требует комплексного подхода: от технических исправлений до продуктовой стратегии. Приоритет — быстрые исправления (M0) для Android 13+ и deeplinks, затем постепенное наращивание функциональности с фокусом на персонализацию и вовлечение.

Ключевые принципы:
- **Ценность > Частота**: каждое уведомление должно быть полезным
- **Персонализация**: учет предпочтений и поведения пользователя
- **Измеримость**: все решения based on data
- **Модульность**: возможность быстрой настройки без релиза

При правильной реализации система уведомлений станет мощным инструментом retention и engagement, увеличивая ключевые метрики продукта на 15-30%.