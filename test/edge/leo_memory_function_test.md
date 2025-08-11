# Док-тест: Edge Function `leo-memory`

## Сценарии

1) Ручной вызов (per-user):
- Запрос: POST /functions/v1/leo-memory с headers: Authorization: Bearer <user_jwt>
- Тело: { "messages": [ {"role":"user","content":"Я владелец кофейни, цель — увеличить LTV"}, {"role":"assistant","content":"..."} ], "maxMemories": 5 }
- Ожидаем: 200 OK, JSON { user_id, saved>=1 }
- Проверка в БД: таблица user_memories содержит строки с content без PII и embedding != null

2) Cron-режим:
- Запрос: POST /functions/v1/leo-memory с headers: x-cron-secret: <CRON_SECRET>
- Тело: {}
- Предусловия: в leo_messages есть свежие записи; leo_chats привязаны к пользователям
- Ожидаем: 200 OK, JSON { usersProcessed>=0, messagesProcessed>=0, factsSaved>=0 }
- Проверка в БД: появились строки в user_memories; в leo_messages_processed помечены обработанные message_id; в leo_chats заполнены summary и last_topics (до 5 тем)


