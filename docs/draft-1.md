## План Sentry для BizLevel (мобайл)

Цели:
- Полная наблюдаемость без регресса старта приложения.
- Единые окружения, релизы, символы, алерты.
- Полный набор breadcrumbs по ключевым сценариям.
- Защита от PII в событиях.

Ограничения:
- Не менять место и задержку инициализации Sentry.
- Фокус на iOS/Android, web не приоритет.

---

### Этап 0 — Инвентаризация и базовая гигиена

Чеклист:
- [x] Зафиксировать проект Sentry: `bizlevel/bizlevel-flutter`.
- [x] Зафиксировать окружение: в коде используется `prod`, все запросы/алерты строить на `prod`.
- [x] Проверить, что в Sentry отображаются релизы (должны быть `bizlevel@<version>+<build>`).
- [ ] Согласовать список шумных ошибок, которые не должны триггерить алерты
      (например, “GoogleSignIn canceled by user”). (нужно вручную)

Результат этапа:
- Единый baseline по окружению и релизам.
- Список “noise issues” для фильтрации.

---

### Этап 1 — Breadcrumbs для ключевых пользовательских потоков

Чеклист:
- [x] Auth: `auth_login_submit/success/fail`.
- [x] Auth: `auth_register_submit/success/fail`.
- [x] OAuth: `auth_google_start/success/fail`.
- [x] OAuth: `auth_apple_start/success/fail`.
- [x] Logout: `auth_logout_tap/success/fail`.
- [x] Mentors screen: `mentors_opened`.
- [x] Chat open: `chat_opened` (bot, chatId).
- [x] New chat: `chat_new_started` (bot).
- [x] Chat send: `chat_send_start/success/fail` (bot, chatId).
- [x] Profile: `profile_opened`.
- [x] Profile save: `profile_save_start/success/fail`.
- [x] Profile: `avatar_changed`.
- [x] Tab navigation: `tab_switch` (from, to).
- [x] Deep links: `deeplink_received`, `deeplink_mapped`, `deeplink_ignored`.
- [x] Library: `library_opened`, `library_section_opened`.
- [x] Library: `library_filter_applied`, `library_favorite_toggled`.
- [x] Library: `library_link_open` + error.

Результат этапа:
- Полный набор breadcrumbs для бета-аналитики.

---

### Этап 2 — User context при автосессии

Чеклист:
- [x] Устанавливать `Sentry.setUser` после восстановления `currentUserProvider`
      (не только в явном логине).
- [x] Оставить очистку пользователя при `signOut`.

Результат этапа:
- Все события привязаны к пользователю даже при auto-login.

---

### Этап 3 — PII и санитизация

Чеклист:
- [x] Добавить `beforeBreadcrumb` для удаления пользовательских текстов.
- [x] Удалять потенциальный PII из `NotificationCenter` и чатов (оставлять только тип/категорию).
- [x] Оставить удаление `Authorization` из `beforeSend`.
- [ ] Проверить настройки PII на проекте Sentry (принимать осознанно). (нужно вручную)

Результат этапа:
- Нет утечек пользовательских сообщений в breadcrumbs/событиях.

---

### Этап 4 — Release health и symbols

Чеклист:
- [x] Настроить загрузку символов:
      - iOS: dSYM
      - Android: mapping.txt
      - Flutter: Dart symbols
- [ ] Убедиться, что `release` совпадает с загрузкой символов
      (нужно выставить `SENTRY_RELEASE` в CI/скриптах).
- [x] Включить release health (sessions) без performance tracing.

Результат этапа:
- Символизированные крэши и метрика crash-free sessions.

---

### Этап 5 — Алерты и валидация

Чеклист:
- [ ] Алерт “New issue in prod”. (нужно вручную)
- [ ] Алерт “Error spike”. (нужно вручную)
- [ ] Алерт “High user impact”. (нужно вручную)
- [ ] Ручная валидация на iOS/Android: (нужно вручную)
      - login/logout
      - deep links
      - отправка сообщения в чатах
      - пуш-тап
- [ ] Проверить, что breadcrumbs приходят корректно. (нужно вручную)

Результат этапа:
- Оперативные алерты и проверенная телеметрия.

