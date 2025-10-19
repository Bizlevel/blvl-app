# Текущее состояние: Цель, Журнал, Макс, Чекпоинты и БД

## База данных (Supabase)
- Таблицы:
  - `user_goal(user_id PK, goal_text, metric_type, metric_start, metric_current, metric_target, start_date, target_date, financial_focus, action_plan_note, updated_at)`
  - `practice_log(id, user_id, applied_at, applied_tools text[], note, created_at, updated_at)`
- Индексы: `ix_practice_log_user_applied_at(user_id, applied_at desc)` для быстрых агрегатов журнала.
- RLS: политики owner-only на `user_goal` и `practice_log` включены.
- Примечания:
  - Добавлена колонка `metric_start` для расчёта прогресса от стартового значения.

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

## Провайдеры (`lib/providers/goals_providers.dart`)
- `userGoalProvider` — `fetchUserGoal`.
- `practiceLogProvider` / `practiceLogWithLimitProvider` — список записей журнала.
- `practiceLogAggregatesProvider` — агрегаты журнала.
- `usedToolsOptionsProvider` — список навыков из `levels.artifact_title` (дедуплицировано).
- `goalStateProvider` — флаги L1/L4/L7 для NextActionBanner и статусов.

## Экран «Цель» (`lib/screens/goal_screen.dart`)
- Блок «Моя цель»:
  - Поля: описание цели, метрика, дедлайн, три показателя: Стартовое (readonly), Текущее (редактируемо в режиме редактирования), Целевое (readonly).
  - Кнопки: «Редактировать» (TextButton, включает режим), «Сохранить/Отмена» в режиме редактирования, «Обсудить с Максом» (синяя Elevated).
  - Прогресс‑полоса: рассчитывается как (Текущее − Стартовое)/(Целевое − Стартовое), с индикацией дней до дедлайна и GP‑кнопками на 50%/100%.
- Баннер «Что дальше?» (`NextActionBanner`): ведёт по маршруту L1 → L4 → L7 → Журнал, основывается на `goalStateProvider`.
- Блок «Журнал применений»:
  - Выбор инструментов из `usedToolsOptionsProvider` (артефакты уровней), заметка, кнопка «Сохранить запись».
  - После сохранения открывается диалог с Максом; в контекст передаётся реальный `practice_note` и выбранные `applied_tools` (перед очисткой полей сохраняем значения). Авто‑сообщение после записи — без списания GP.
  - Статистика (Всего/Дней/Часто) в адаптивном Wrap для избежания переполнения.

## Макс (чат)
- Экран чата `LeoDialogScreen` используется для диалогов. Для журнала контекст включает реальные данные записи.
- Edge Function `leo-chat` использует `user_goal`/`practice_log` контекст и сценарии для чекпоинтов.
- GP‑политика: обычные сообщения списывают 1 GP; авто‑комментарии после записи — бесплатно. Вызовы `sendMessageWithRAG` передают `chatId` для идемпотентности списаний.

## Чекпоинты
- L1 (`checkpoint_l1_screen.dart`): мастер из 4 шагов, сохраняет `user_goal` с `metric_start`, `metric_current`, `metric_target`, `target_date`; затем показывает мини‑квиз‑блок с ответом Макса и кнопками «Сохранить/Редактировать».
- L4 (`checkpoint_l4_screen.dart`): предложение добавить финансовый фокус (`financial_focus`), кнопки «Добавить фокус» (апдейт цели + переход на «Цель») и «Оставить как есть» (мотивация).
- L7: расчёт Z/W и варианты действий; выбранное решение сохраняется в `user_goal.action_plan_note` и добавляется системная запись в `practice_log`.

## Навигация
- Маршруты `/checkpoint/l1|l4|l7`, `/goal`, `/goal/history`; башня (`tower_tiles`) ведёт на мастера чекпоинтов.

## Известные замечания
- Предупреждения анализатора по use_build_context_synchronously в нескольких местах — не критично для функционала.

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
   - Блок «Журнал применений»:
     - Инструменты: из `levels.artifact_title`.
     - Сохранение записи: `practice_log.insert` + автокомментарий Макса с фактической заметкой и инструментами.
     - «Вся история →»: переход на `/goal/history`.

5) Журнал истории
   - Роут: `/goal/history`
   - Таблица: `practice_log` (фильтр текущего пользователя, лимит/пагинация по провайдеру).

6) Чекпоинт L4 — Финансовый фокус
   - Роут: `/checkpoint/l4`
   - Сценарий: предложение добавить финансовую метрику; кнопки «Добавить метрику» (апдейт `user_goal` и переход на `/goal`) или «Оставить как есть» (мотивация Макса).

7) Чекпоинт L7 — Проверка реальности (Z/W)
   - Роут: `/checkpoint/l7`
   - Сценарий: расчет Z (темп из `practice_log`) и W (требуемый до дедлайна из `user_goal`); варианты: «Усилить применение», «Скорректировать цель» (переход на `/goal`), «Продолжить темп».

8) Диалоги с Максом
   - Роут: `/chat` (или встроенные вызовы диалога с авто‑контекстом).
   - Контекст: цель/журнал (фактический `practice_note`, `applied_tools`) и сценарии чекпоинтов.

9) Награды и мотивация
   - GP‑бонусы: RPC `gp_claim_daily_application`, `gp_claim_goal_progress`.
   - Отображение достижений через уведомления/тосты.

