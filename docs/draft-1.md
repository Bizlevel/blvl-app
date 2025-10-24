### План работ (fix6.x)

- fix6.1: Включить verify_jwt=true у Edge `leo-chat`; обновить CORS/headers; пройти smoke‑тесты (Web/iOS/Android).
- fix6.2: Сузить EXECUTE у RPC `gp_*` до `authenticated` (+ `service_role` по необходимости); убрать PUBLIC/anon там, где не нужно.
- fix6.3: Добавить `SET search_path=public` в функции без фиксированного search_path (например, `match_user_memories`).
- fix6.4: Перенести расширение `pg_net` из `public` в отдельную схему (org‑хардэнинг).
- fix6.5: Безопасность Auth — включить leaked password protection; уменьшить OTP expiry до рекомендованного.

- fix6.6: Переписать RLS‑политики с `auth.*()` на `(select auth.*())` для таблиц из advisors (users, levels, lessons, user_progress, leo_* , user_memories, gp_*, library_*, user_goal, practice_log и т.д.).
- fix6.7: Слить дубли permissive‑политик для `ai_message`, `app_settings`, `leo_chats` (оставить по одной политике на роль/действие).
- fix6.8: `leo_messages_processed` — либо добавить deny‑политику (явный запрет), либо снять RLS (если служебная).

- fix6.9: Добавить покрывающие индексы для отмеченных FK (например, `ai_message.leo_message_id`, `memory_archive.user_id`, `user_packages.package_id`).
- fix6.10: Пересмотреть и удалить неиспользуемые индексы после наблюдения в прод (по списку advisors).

- fix6.11: Деактивировать/удалить легаси `GoalsRepository.upsertGoalField` (fallback на `core_goals`), оставить новую плоскую модель `user_goal/practice_log`.
- fix6.12: Архивировать/удалить неиспользуемые Edge (`leo_context`, `leo-rag`) либо пометить как deprecated (если остаются для отладки).
- fix6.13: Регресс‑план: e2e‑smoke для чатов (Leo/Max, списание GP), GP‑магазина/покупок/бонусов, Башни/уровней; фиксация в `docs/status.md`.
- fix6.14: Синхронизировать каталог `supabase/functions` с прод‑набором: 
  - добавить недостающие каталоги `gp-balance/gp-spend/gp-purchase-init/gp-bonus-claim/gp-floor-unlock` (или документировать, что управляются отдельно),
  - удалить/архивировать локальные неиспользуемые (`push-dispatch`, `leo-test`, `storage-integrity-check`) или пометить deprecated,
  - выровнять конфиги verify_jwt и CORS.
