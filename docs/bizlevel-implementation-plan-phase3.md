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
