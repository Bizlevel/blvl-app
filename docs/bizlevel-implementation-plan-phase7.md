# Этап 25 — План реализации

Ниже перечислены **атомарные** задачи, сформированные на основе `docs/audit-after-23.md`. Каждая задача = **один pull-request**. В описании PR дублируем текст задачи и указываем затронутые файлы.

> ☑️ После мержа любой задачи обновляем `docs/status.md` и ставим «✅ выполнено».

---

## 25.1 Функции Postgres: фиксированный `search_path`
• Миграции Supabase (`supabase/migrations/`), функции: `handle_leo_unread_after_insert`, `reset_leo_unread`, `decrement_leo_message`, `match_documents`, `update_updated_at_column`  
• Пересоздать функции с `SECURITY DEFINER SET search_path = public, extensions`  
• После применения выполнить `mcp_supabase_get_logs` — ошибок быть не должно

---

## 25.2 Переместить расширение `vector`
• Миграция `202508XX_move_vector_to_extensions.sql`  
• SQL: `CREATE SCHEMA IF NOT EXISTS extensions; ALTER EXTENSION vector SET SCHEMA extensions;`  
• Убедиться, что функции используют `extensions.vector`

---

## 25.3 Android-release: разрешения `INTERNET` и `READ_MEDIA_VIDEO`
• Файл `android/app/src/main/AndroidManifest.xml`  
• Добавить `<uses-permission android:name="android.permission.INTERNET"/>` и `<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" android:required="false"/>` (API ≥ 33) либо `READ_EXTERNAL_STORAGE` для API ≤ 32  
• Не дублировать в `debug/` и `profile/` манифестах

---

## 25.4 Создать `PrivacyInfo.xcprivacy`
• Путь `ios/Runner/PrivacyInfo.xcprivacy`  
• Описать категории данных: Email, Usage Data, Diagnostics (Sentry)  
• Проверить валидность `xcodebuild -resolvePackageDependencies`

---

## 25.5 Политика конфиденциальности (RU / EN)
• Файлы `docs/privacy_policy_ru.md` и `docs/privacy_policy_en.md`, ссылки в `lib/screens/auth/login_screen.dart` и `lib/screens/profile_screen.dart`  
• На Web ссылка открывается новой вкладкой, на мобилках — через `url_launcher`

---

## 25.6 Edge Function `delete-account`
• Путь `supabase/functions/delete-account/index.ts`  
• Удаляет данные пользователя + Storage, `auth`-protected, тайм-аут ≤ 15 с  
• Возвращает `{success:true}`

---

## 25.7 Semantics для LevelCard и навигационных кнопок
• Файлы `lib/widgets/level_card.dart`, `lib/screens/level_detail_screen.dart`  
• Добавить `Semantics(label: …, button: true)` и/или `semanticLabel` для изображений  
• Не ломаем hover-эффекты и тесты `levels_map_screen_test.dart`

---

## 25.8 `index.html`: lang и description
• Файл `web/index.html`  
• Добавить `<html lang="ru">` и `<meta name="description" content="BizLevel – образовательная платформа…">`  
• Lighthouse A11y ≥ 90

---

## 25.9 CI: порог покрытия ≥ 70 %
• Workflow `.github/workflows/ci.yaml`  
• Добавить `flutter test --coverage`, объединить lcov, падать при `< 70 %`  
• Сохранять отчёт как artefact

---

## 25.10 CI: `LHCI Autorun`
• В том же workflow после `flutter build web`  
• Запустить `lhci autorun` (npm-кеш)  
• Пороги: A11y ≥ 90, Perf ≥ 80

---

## 25.11 Индексы FK
• Миграция `202508XX_add_fks_idx.sql`  
• `CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_leo_messages_user_id ON leo_messages(user_id);` и аналогично для `user_progress(level_id)`  
• В `infrastructure_test.dart` убедиться, что план использует индекс

---

## 25.12 Удалить дублирующий индекс `payments_status_idx`
• Миграция `202508XX_drop_duplicate_idx.sql`  
• `DROP INDEX IF EXISTS payments_status_idx;`  
• Проверить зависимости внешних ключей

---

## 25.13 Upgrade `responsive_framework` → 1.5.1
• Файл `pubspec.yaml`  
• Обновить версию, `flutter pub upgrade`  
• Переписать использование API (`ResponsiveBreakpointsData`, `ResponsiveWrapper.builder`), обновить `LevelsMapScreen`, `RootApp`, тесты

---

## 25.14 Подготовка к `go_router` 16.x
• Ветка `feat/upgrade-go-router-16`, зависимость `go_router: ^16.0.0`, сборка с `continue-on-error`  
• Создать CI-job `go_router_16_experimental`  
• Итог: отчёт `docs/experiment/go_router_16_migration.md`

---

## 25.15 Общий helper `_withRetry`
• Новый файл `lib/utils/retry.dart`; вынести логику ретрая из `SupabaseService` и `LeoService`  
• Обновить юнит-тесты сервисов

---

## 25.16 Устранить `prefer_const_*` предупреждения
• Запустить `dart fix --apply`, вручную добавить `const` в горячих виджетах (`LevelCard`, `LessonWidget`)  
• Проверить FPS в DevTools

---

## 25.17 npm-кеш в CI
• Добавить cache step для `~/.npm` (ключ по `package-lock.json`) в `.github/workflows/ci.yaml`

---

## 25.18 Отключить hover-эффект `ChatItem` на мобилках
• Файл `lib/widgets/chat_item.dart`  
• При ширине < 600 px не использовать `MouseRegion`  
• Обновить тесты `leo_chat_screen_test.dart`

---

## 25.19 Улучшения схемы Supabase
**Миграция:** `202508XX_schema_refinements.sql`

1. **Уникальный индекс уроков внутри уровня**  
   • SQL: `CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS uniq_lessons_level_order ON lessons(level_id, "order");`  
   • Почему: предотвращает случайные дубли уроков при массовом импорте.

2. **Пометить `levels.image_url` как устаревший**  
   • SQL: `COMMENT ON COLUMN levels.image_url IS 'deprecated – use cover_path';`  
   • Дальнейший план: удалить колонку после релиза v2 клиента.

3. **(Опционально) Индекс сортировки по дате обновления чатов**  
   • SQL: `CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_leo_chats_updated_at ON leo_chats(updated_at DESC);`  
   • Почему: ускоряет выборку списка диалогов по последней активности.

После применения миграции запустить `supabase_advisor_check.sh` — предупреждений CRITICAL/WARN быть не должно.


