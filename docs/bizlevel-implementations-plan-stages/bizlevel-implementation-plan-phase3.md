# Этап 11: Веб-стабилизация и финальная полировка (07/2025)

### Задача 11.1: Исправить `Zone mismatch` при запуске Web
Файлы: `lib/main.dart`, `lib/services/supabase_service.dart`
Зависимости: —
Компоненты: `main`, `SupabaseService.initialize`
Что делать:
1. Переместить все вызовы `WidgetsFlutterBinding.ensureInitialized`, `dotenv.load`, `SupabaseService.initialize` и `SentryFlutter.init` в одну синхронную зону — см. пример в черновом плане.
2. Удалить лишние `async`/`await`-обёртки внутри `initialize`.
3. Добавить `BindingBase.debugZoneErrorsAreFatal = true` в тестовой сборке.
Почему это важно:
Ошибка ломает запуск приложения в Chrome и порождает каскад багов auth/video.
Проверка результата:
`flutter run -d chrome` стартует без исключений «Zone mismatch».
### Задача 11.2: Корректное воспроизведение Vimeo-видео в Web и iOS
Файлы: `lib/widgets/lesson_widget.dart`, `web/index.html`
Зависимости: 11.1
Компоненты: `_LessonWidgetState`, `HtmlElementView`
Что делать:
1. Для `kIsWeb` заменить `VideoPlayerController.network` на `iframe`-обёртку (`HtmlElementView`) с ссылкой вида `https://player.vimeo.com/video/<id>?…`.
2. Зарегистрировать view-factory через `ui.platformViewRegistry`.
3. Сохранить текущий `video_player`-код для mobile.
4. Видео также недоступно при запуске на ios - исправить. 
Почему это важно:
Web-плеер не поддерживает HTML-страницы, что приводит к `MEDIA_ERR_SRC_NOT_SUPPORTED`.
Проверка результата:
Урок с `vimeoId` воспроизводится в Chrome/Edge без ошибок.
### Задача 11.3: Сохранять диалог только после отправки сообщения от пользователя
Файлы: `lib/screens/leo_dialog_screen.dart`, `lib/providers/leo_provider.dart`, Supabase RPC
Зависимости: 11.1
Компоненты: `LeoDialogScreen`, `LeoProvider`, `leo_chats`
Что делать:
1. Переместить логику `createDialog` из `initState` в обработчик «Send».  
2. При открытии чата запрашивать только диалоги, где `messages.count > 0`. (только те чаты, где есть хотя бы одно сообщение от пользователя)
3. Добавить в RPC/таблицу `CHECK (array_length(messages,1) > 0 OR is_system)`.
Почему это важно:
Устраняет рост пустых диалогов и минимизирует шум данных.
Проверка результата:
Открытие чата без отправки сообщения не создаёт запись в `leo_chats`.
### Задача 11.4: Ошибка «Пользователь не авторизован» в профиле в web
Файлы: `lib/providers/auth_provider.dart`, `lib/screens/profile_screen.dart`
Зависимости: 11.1
Компоненты: `authStateProvider`, `currentUserProvider`
Что делать:
1. После фикса зон убедиться, что `Supabase.initialize` завершён до чтения `currentUser`.
2. В `ProfileScreen` показывать индикатор загрузки, пока `authAsync` в `AsyncLoading`.
Почему это важно:
Неверный UX, пользователь пугается и перезаходит.
Проверка результата:
Профиль открывается корректно сразу после логина на Web и Mobile.
### Задача 11.5: Автоматический мониторинг Sentry
Файлы: `.github/workflows/ci.yaml`, `scripts/sentry_check.sh`
Зависимости: 11.1
Компоненты: GitHub Actions, Sentry CLI
Что делать:
1. В CI после тестов запускать `sentry-cli issues list --statsPeriod=24h --json` и падать, если есть новые `unresolved` критические баги.
2. Добавить ссылку на дашборд в Slack-нотификации.
Почему это важно:
Предотвращает регрессию — ошибки находятся до релиза.
Проверка результата:
При наличии новых критических ошибок workflow завершается `failed`.
### Задача 11.6: Web-тесты в CI
Файлы: `test/`, `.github/workflows/ci.yaml`
Зависимости: 11.1
Компоненты: `flutter_test`, `integration_test`
Что делать:
1. Добавить `flutter test --platform chrome` в CI.
2. Написать smoke-тест: старт приложения, открытие урока с видео.
Почему это важно:
Гарантирует, что правки не ломают веб-сборку.
Проверка результата:
Workflow проходит, тесты зелёные, зона/видео-ошибок нет.

## Этап 12: Устойчивый маршрут уровня и UX-полировка (08/2025)
### Задача 12.1: Вертикальная прокрутка PageView на всех платформах
Файлы: `lib/screens/level_detail_screen.dart`
Зависимости: 11.2
Компоненты: `_buildPageView`, `PageController`
Что делать:
1. Переместить `PageView` из-под `Column` в `LayoutBuilder` или задать явную высоту через `Expanded(child: SizedBox.expand(...))`, чтобы гарантировать корректные `constraints` на iOS.
2. Удалить внутренние горизонтальные `Viewport`, убедиться, что `scrollDirection: Axis.vertical` отрабатывает.
Проверка результата: свайп работает только вертикально, горизонтальный жест не меняет страницу.
### Задача 12.2: Устранить "прыжки" между блоками
Файлы: `level_detail_screen.dart`
Компоненты: метод `build()` (`jumpToPage`)
Что делать:
1. Инициализировать `PageController(initialPage: unlockedPage)` в `initState`.
2. Удалить вызов `jumpToPage()` в `build`, оставить его только при ручном восстановлении позиции после hot-reload.
Проверка результата: после просмотра видео пользователь остаётся на текущем блоке, переход вручную.
### Задача 12.3: Стабильная работа кнопки «Назад»
Файлы: `level_detail_screen.dart`
Компоненты: `_currentIndex`, `_goBack`, `_NavBar`
Что делать:
1. Заменить расчёт `_currentIndex` на `(_pageController.page ?? _pageController.initialPage).round()` c `Listener` на `PageController` для setState.
2. Убрать блокировку кнопки до завершения анимации: всегда разрешать `onBack` если `pageController.page > 0`.
Проверка результата: кнопка «Назад» всегда переводит к предыдущему блоку.
### Задача 12.4: Добавить блок «Артефакт» в маршрут уровня
Файлы: `level_detail_screen.dart`, `widgets/artifact_card.dart`
Зависимости: 12.1
Компоненты: `_buildBlocks`, новый `_ArtifactBlock`
Что делать:
1. Расширить модель `LevelModel` полем `artifact_*` уже присутствующим в БД.
2. В `_buildBlocks()` после всех уроков вставить `_ArtifactBlock`, который показывает описание и кнопку «Скачать» (использовать `SupabaseService.getArtifactSignedUrl`).
3. В `LessonProgressProvider` добавить событие `markArtifactViewed`, которое автоматически разблокирует кнопку «Завершить уровень» после посещения блока.
Проверка результата: блок отображается, файл скачивается, прогресс сохраняется.
### Задача 12.5: Исправить ошибку `updated_at` при завершении уровня
Файлы: миграция Supabase `add_updated_at_to_user_progress.sql`, `supabase_service.dart`
Компоненты: таблица `user_progress`
Что делать:
1. Создать миграцию: `ALTER TABLE user_progress ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT now();`.
2. Перегенерировать RLS-политику, если требуется.
3. Проверить `upsert` в `completeLevel` — поле остаётся.
Проверка результата: кнопка «Завершить уровень» выполняет RPC без ошибок.
### Задача 12.6: Корректная активация кнопки «Далее»
Файлы: `level_detail_screen.dart`, `lesson_progress_provider.dart`
Что делать:
1. Изменить условие `canNext` на `_currentIndex < _progress.unlockedPage` **или** `_currentIndex + 1 == _progress.unlockedPage`.
2. В `unlockNext()` проверять, что `current + 1 < _blocks.length`.
Проверка результата: «Далее» активна сразу после разблокировки, нет ложных неактивных состояний.
### Задача 12.7: Безопасный fallback, если у урока нет видео
Файлы: `lesson_widget.dart`
Компоненты: `_initPlayer`
Что делать:
1. При отсутствии `videoUrl`/`vimeoId` показывать текст «Видео недоступно» + кнопку «Пропустить» → вызывает `widget.onWatched()`.
2. Удалить хардкод `DRAFT_1.2 (1).mp4`.
Проверка результата: приложение не падает, урок считается просмотренным.
### Задача 12.8: Оптимизировать записи SharedPreferences
Файлы: `lesson_progress_provider.dart`
Что делать:
1. Добавить debounce (200 мс) перед `_save()` через `Timer`.
2. Сохранять только при реальных изменениях state (использовать `identical` проверку).
Проверка результата: число операций записи сокращается, пропали лаги при быстром листании.
### Задача 12.9: Корректная проверка завершения уровня
Файлы: `level_detail_screen.dart`
Компоненты: `_isLevelCompleted`
Что делать:
1. Для каждого урока проверять: если есть квиз → требовать `passedQuizzes.contains(quizPage)`, иначе достаточно `watchedVideos.contains(videoPage)`.
2. Кнопка «Завершить уровень» активна, когда условия выполнены для всех уроков.
Проверка результата: уровень завершается корректно для уроков без квиза.
### Задача 12.10: Финальное тестирование уровня
Файлы: `test/level_flow_test.dart`, CI
Зависимости: 12.1-12.9
Что делать:
1. Написать интеграционный тест (Flutter driver): регистрация, вход, открытие уровня, прохождение видео+квизы, скачивание артефакта, завершение уровня.
2. Запустить на iOS-симуляторе, Android-эмуляторе и Chrome в CI.
3. Включить тест в GitHub Actions.
Проверка результата: тест проходит на трёх платформах, UX соответствует концепции (стр. 100-106).

## Этап 13: Стабильность 2.0 
### Задача 13.1: Автоматическое обновление Карты уровней
Файлы: `lib/screens/level_detail_screen.dart`, `lib/providers/levels_provider.dart`
Что делать:
1. После `completeLevel` вызывать `ref.invalidate(levelsProvider)` и возвращать пользователя на Карту уровней (`Navigator.pop`).
2. LevelCard показывает открытый уровень, если его номер `<= current_level`.
Проверка: после завершения 2-го уровня пользователь попадает на карту, где разблокирован уровень 3.
### Задача 13.2: Персистентность пройденных квизов
Файлы: `lesson_progress_provider.dart`, `widgets/quiz_widget.dart`
Что делать:
1. При правильном ответе сохранять `passedQuizzes` в SharedPreferences.
2. При повторном входе в уровень — если квиз пройден, показывать «Верно!» и скрывать кнопку «Проверить».
Проверка: после перезапуска приложения ответы остаются сохранёнными.
### Задача 13.3: Жёсткая блокировка свайпов
Файлы: `lib/screens/level_detail_screen.dart`
Что делать:
1. Заменить `PageView.physics` на `NeverScrollableScrollPhysics`.
2. Переход выполняется только через кнопку «Далее» после `_unlockNext`.
Проверка: невозможно пролистать вниз, пока не выполнены условия блока.
### Задача 13.4: Онбординг только при первом входе
Файлы: `lib/main.dart`, `lib/providers/auth_provider.dart`, `lib/screens/onboarding_video_screen.dart`
Что делать:
1. После окончания онбординга записывать `onboarding_done=true` в SharedPreferences.
2. При старте приложения проверять флаг; если `true` – сразу открывать `RootApp`.
Проверка: повторные запуски обходят онбординг.
### Задача 13.5: Адаптивный Web-лейаут и устранение RenderFlex overflow
Файлы: `lib/main.dart` (ResponsiveWrapper), `widgets/progress_dots.dart`, `widgets/lesson_widget.dart`
Что делать:
1. Для Web задать `maxWidth:480`, `minWidth:320`, `breakpoints` ⇒ мобильный layout.
2. Обернуть вертикальные точки в `SafeArea` + `SingleChildScrollView`, чтобы устранить overflow (ошибки BIZLEVEL-FLUTTER-A/K/5/6/D).
Проверка: Chrome DevTools, ширины 300-1400 px без overflow.
### Задача 13.6: Устранить ошибку «modify provider while building»
Файлы: `level_detail_screen.dart`, `LessonWidget`
Что делать:
1. Перенести `_unlockNext` / `mark…` вызовы в `addPostFrameCallback`.
2. Проверить, что ошибка BIZLEVEL-FLUTTER-G исчезает в Sentry.
Проверка: повторное прохождение уровня не генерирует новую issue.
### Задача 13.7: Обработка Storage 404 без Sentry-error
Файлы: `SupabaseService.getVideoSignedUrl`, `getArtifactSignedUrl`
Что делать:
1. При 404 возвращать `null`, логировать breadcrumb, но не бросать исключение.
2. В UI показывать placeholder и кнопку «Пропустить»/«Скачать позже».
Проверка: отсутствуют новые StorageException issues.
### Задача 13.8: Расширение CI
Файлы: `.github/workflows/ci.yaml`
Что делать:
1. Запуск `flutter test` (unit), `integration_test` (Android/iOS simulators, Web) в параллели.
2. Добавить шаг Sentry-CLI проверки новых `unresolved` + Slack-нотификация.
Проверка: PR падает, если тесты или Sentry-check не прошли.

