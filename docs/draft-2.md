# Текущее состояние: Цель, Журнал, Макс, Чекпоинты и БД

## База данных (Supabase)
- Таблицы (owner-only RLS):
  - `user_goal(user_id PK, goal_text, metric_type, metric_start, metric_current, metric_target, start_date, target_date, financial_focus, action_plan_note, updated_at)`
  - `practice_log(id PK, user_id, applied_at, applied_tools text[], note, created_at, updated_at)`
- Индексы: `ix_practice_log_user_applied_at(user_id, applied_at desc)` — ускоряет списки и агрегаты журнала.
- Политики RLS: для `user_goal` и `practice_log` — "Allow owner read/insert/update/delete" (доступ только к своим данным по `auth.uid() = user_id`).
- Функции GP-экономики:
  - `gp_claim_daily_application()` — разовый бонус за дневную запись в журнал (idempotent). Используется после `practice_log.insert`.
  - `gp_claim_goal_progress(p_key)` — бонусы за достижения прогресса цели (используется из клиента при переходе порогов 50%/100%).
- Public-политики на учебный контент: `lesson_metadata`, `lesson_facts`, `package_items` имеют SELECT-политику для безопасной выдачи данных в приложении.
- Примечания:
  - Колонка `metric_start` используется для стабильного расчёта прогресса (не зависит от колебаний текущего значения).

## Репозиторий (`lib/repositories/goals_repository.dart`)
- Методы цели:
  - `fetchUserGoal()` — читает одну запись из `user_goal` по текущему пользователю; на Web добавляет `apikey` в заголовок; кеширует в Hive `user_goal/self`.
  - `upsertUserGoal({... metric_start, metric_current, metric_target, financial_focus?, action_plan_note? ...})` — upsert по `user_id`, обновляет кеш.
- Журнал применений:
  - `fetchPracticeLog(limit)` — читает список записей, кеширует в Hive `practice_log/list_<limit>`.
  - `addPracticeEntry({appliedTools, note, appliedAt})` — вставка, затем idempotent RPC для GP‑бонуса, инвалидация кеша.
  - `aggregatePracticeLog(items)` — агрегаты: дни с применениями, топ‑инструменты.
- Утилиты:
  - Z/W: `computeRecentPace`, `computeRequiredPace`.
  - Прогресс: `computeGoalProgressPercent(goal)` — безопасный расчёт 0..1 с гвардом `target != start`.
 - Заголовки/кеширование: на Web репозиторий добавляет `apikey` для Supabase REST; данные складываются в Hive и используются по принципу SWR (быстро из кеша, затем фоновое обновление).

## Провайдеры (`lib/providers/goals_providers.dart`)
- `userGoalProvider` — `fetchUserGoal`.
- `practiceLogProvider` / `practiceLogWithLimitProvider` — список записей журнала.
- `practiceLogAggregatesProvider` — агрегаты журнала.
- `usedToolsOptionsProvider` — список навыков из `levels.artifact_title` (дедуплицировано).
- `goalStateProvider` — флаги L1/L4/L7 для NextActionBanner и статусов:
  - `l1Done` = есть `goal_text` и `metric_type` (старта/таргета может не быть).
  - `l4Done` = заполнен `financial_focus`.
  - `l7Done` = заполнен `action_plan_note` (решение по Z/W).

## Экран «Цель» (`lib/screens/goal_screen.dart`)
- Блок «Моя цель»:
  - Поля: описание цели, метрика, дедлайн, три показателя: Стартовое (readonly), Текущее (редактируемо в режиме редактирования), Целевое (readonly).
  - Кнопки: «Редактировать» (TextButton, включает режим), «Сохранить/Отмена» в режиме редактирования, «Обсудить с Максом» (синяя Elevated).
  - Прогресс‑полоса: рассчитывается как (Текущее − Стартовое)/(Целевое − Стартовое), с индикацией дней до дедлайна и GP‑кнопками на 50%/100%.
  - Z/W под прогрессом (флаг `kShowZWOnGoal`): короткая строка «Z: x/день • W: y/день • Осталось: N дней» + тап раскрывает пояснение.
- Баннер «Что дальше?» (`NextActionBanner`): ведёт по маршруту L1 → L4 → L7 → Журнал, основывается на `goalStateProvider`.
- Блок «Журнал применений»:
  - Выбор навыка: выпадающий список «Выбрать навык» (один выбор) из `usedToolsOptionsProvider`; поле «Что конкретно сделал сегодня»; кнопка «Сохранить запись».
  - После сохранения открывается диалог с Максом; в контекст передаётся реальный `practice_note` и `applied_tools` (значения берём до очистки полей). Авто‑сообщение после записи — без списания GP.
  - Статистика (Всего/Дней/Часто) — в `Wrap`; переполнение предотвращается ограничением ширины для длинных надписей.
  - «Вся история»: под списком показываются только 3 последние записи, кнопка «Вся история →» ведёт на `/goal/history`. Формат даты в элементах: `dd-аббр‑YYYY` (например, `19-окт-2025`).
 - Sticky-CTA (флаг `kGoalStickyCta`): снизу две кнопки «Добавить запись» и «Обсудить с Максом» для быстрого действия.
 - Prefill-навигация с L7 (флаг `kL7PrefillToJournal`): поддержка `?prefill=intensive&scroll=journal` для прокрутки к журналу и префилла.
 - Наблюдаемость: breadcrumbs `goal_edit_saved`, `zw_info_opened`, `chat_opened_from_goal`, `journal_prefill_opened`.

## Макс (чат)
- Экран чата `LeoDialogScreen` используется для диалогов. Для журнала контекст включает реальные данные записи.
- Edge Function `leo-chat` использует `user_goal`/`practice_log` контекст и сценарии для чекпоинтов.
- GP‑политика: обычные сообщения списывают 1 GP; авто‑комментарии (после записи в журнал, после решений L1/L4/L7, где предусмотрено) — бесплатно. `sendMessageWithRAG` передаёт `chatId` для идемпотентности списаний.
- Рекомендованные чипы в чате Макса (fallback): быстрые подсказки по L1/L4, если сервер не прислал собственные.
- Breadcrumbs: `chat_max_auto_commented` и другие события диалогов логируются в Sentry.

## Чекпоинты
- L1 (`checkpoint_l1_screen.dart`): мастер из 4 шагов, сохраняет `user_goal` с `metric_start`, `metric_current`, `metric_target`, `target_date`; затем показывает мини‑квиз‑блок с ответом Макса и кнопками «Сохранить/Редактировать».
- L4 (`checkpoint_l4_screen.dart`): предложение добавить финансовый фокус (`financial_focus`).
  - «Добавить метрику»: обновляет `user_goal`, делает `ref.invalidate(userGoalProvider)` и возвращает на `/goal`.
  - «Оставить как есть»: возвращает на `/goal` и даёт мотивацию (без изменения данных).
- L7: расчёт Z/W и варианты действий; выбранное решение сохраняется в `user_goal.action_plan_note` и добавляется системная запись в `practice_log`.
  - CTA: «Усилить применение» → `/goal?prefill=intensive&scroll=journal`; «Скорректировать цель» → `/goal`; «Продолжить темп» — триггерит бесплатный совет Макса и возвращает на `/goal`.

## Навигация
- Маршруты `/checkpoint/l1|l4|l7`, `/goal`, `/goal/history`; башня (`tower_tiles`) ведёт на мастера чекпоинтов.
- Переходы выполняются через `GoRouter.of(context).push(...)` (а не `Navigator.pushNamed`), чтобы исключить ошибки `onGenerateRoute`.

## Известные замечания
- Предупреждения анализатора по `use_build_context_synchronously` в нескольких местах — не критично для функционала.
- Депрекейт `GoRouter.location` — постепенно переводим на `uri`.

## Путь пользователя (User Journey)
1) Онбординг и вход
   - Роут: `/login` → `/home`
   - Таблицы: `auth.users`, `users`
   - Цель: пользователь попадает в приложение, видит навигацию и башню уровней `/tower`.

2) Обучение и артефакты
   - Роуты: `/tower`, `/levels/:id`, `/artifacts`
   - Пользователь проходит уроки уровня 1, знакомится с артефактом «Ядро целей» (из `levels.artifact_title`).
   - По завершении блока L1 — доступен чекпоинт «Первая цель».

3) Чекпоинт L1 — Постановка цели
   - Роут: `/checkpoint/l1`
   - Экран‑мастер (4 шага): текущее значение → ключевой показатель → целевое → срок.
   - Сохранение: `user_goal` (поля: `goal_text`, `metric_type`, `metric_start`, `metric_current`, `metric_target`, `target_date`).
   - После сохранения: компактный «квиз‑блок» с комментарием Макса и кнопки «Сохранить/Редактировать»; переход на `/goal`.

4) Страница «Цель» — обзор и редактирование
   - Роут: `/goal`
   - Блок «Моя цель»:
     - Режим «Просмотр»: поля статичны, доступна кнопка «Редактировать».
     - Режим «Редактирование»: можно менять «Текущее»; сохранение обновляет `user_goal` (RLS owner‑only).
     - Прогресс‑полоса: расчет от `metric_start` → `metric_target`; кнопки GP на 50% и 100%.
   - Z/W: краткая строка под прогрессом (тап — пояснение).
   - Блок «Журнал применений»:
     - Навык: выбирается из выпадающего списка (один).
     - Сохранение записи: `practice_log.insert` + автокомментарий Макса с фактической заметкой и инструментами (бесплатно).
     - Под списком: 3 последних записи, формат даты `dd-аббр‑YYYY`; «Вся история →» ведёт на `/goal/history`.

5) Журнал истории
   - Роут: `/goal/history`
   - Таблица: `practice_log` (фильтр текущего пользователя, лимит/пагинация по провайдеру).

6) Чекпоинт L4 — Финансовый фокус
   - Роут: `/checkpoint/l4`
   - Сценарий: предложение добавить финансовую метрику; «Добавить метрику» — апдейт `user_goal` + возврат на `/goal` с обновлением; «Оставить как есть» — возврат на `/goal`.

7) Чекпоинт L7 — Проверка реальности (Z/W)
   - Роут: `/checkpoint/l7`
   - Сценарий: расчет Z (темп из `practice_log`) и W (требуемый до дедлайна из `user_goal`); CTA: «Усилить применение» (prefill журнала на Цели), «Скорректировать цель» (на `/goal`), «Продолжить темп» (автокомментарий Макса и переход на `/goal`).

8) Диалоги с Максом
   - Роут: `/chat` (или встроенные вызовы диалога с авто‑контекстом).
   - Контекст: цель/журнал (фактический `practice_note`, `applied_tools`) и сценарии чекпоинтов.

9) Награды и мотивация
   - GP‑бонусы: RPC `gp_claim_daily_application`, `gp_claim_goal_progress`.
   - Отображение достижений через уведомления/тосты.

