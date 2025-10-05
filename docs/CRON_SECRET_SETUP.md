# 🔐 Инструкция: Добавление CRON_SECRET в Edge Function leo-chat

## Статус
✅ **Выполнено:** CRON_SECRET создан и добавлен в app_settings  
✅ **Выполнено:** Edge Function настроена на работу с XAI (x.ai) и OpenAI  
✅ **Выполнено:** Динамический выбор API endpoint по модели  
⚠️ **Требуется:** Добавить CRON_SECRET, XAI_API_KEY и OPENAI_API_KEY в переменные окружения Edge Function

---

## Шаги для завершения настройки

### 1. Получите значение CRON_SECRET

```sql
-- Выполните в SQL Editor Supabase Dashboard
SELECT value as cron_secret 
FROM public.app_settings 
WHERE key = 'CRON_SECRET';
```

**Результат:** `e928d3d590d23800960c41dfacbdade5a14965e46b1039b16266a89cb9155bfe`

### 2. Добавьте секреты в Edge Function

1. Откройте **Supabase Dashboard**
2. Перейдите в **Edge Functions** → **leo-chat**
3. Откройте вкладку **Settings**
4. В разделе **Secrets** добавьте:

   **A. CRON_SECRET (для webhook авторизации)**
   - **Name:** `CRON_SECRET`
   - **Value:** `e928d3d590d23800960c41dfacbdade5a14965e46b1039b16266a89cb9155bfe`

   **B. XAI API KEY (для бота Макс)** ⚠️ **ОБЯЗАТЕЛЬНО!**
   - **Name:** `XAI_API_KEY`
   - **Value:** `xai-...` (получите на https://console.x.ai)
   
   > Макс использует модель `grok-4-fast-non-reasoning` от X.AI
   
   **C. OPENAI API KEY (для бота Лео)** ⚠️ **ОБЯЗАТЕЛЬНО!**
   - **Name:** `OPENAI_API_KEY`
   - **Value:** `sk-...` (получите на https://platform.openai.com)
   
   > Лео использует модель `gpt-5-nano` от OpenAI
   
   > ✅ **Умный выбор:** Edge Function автоматически выбирает правильный endpoint в зависимости от модели:
   > - `grok-*` модели → `https://api.x.ai/v1`
   > - `gpt-*` модели → `https://api.openai.com`

5. Нажмите **Save**

### 3. Проверьте работу

После добавления секрета триггер `tg_notify_goal_comment` будет автоматически вызывать Edge Function leo-chat при сохранении версий цели (v2/v3/v4).

---

## Техническая информация

### Где используется CRON_SECRET

1. **Database Trigger:** `tg_notify_goal_comment`
   - Отправляет HTTP POST на Edge Function
   - Использует `Authorization: Bearer <CRON_SECRET>`

2. **Edge Function:** `leo-chat` (режим `goal_comment`)
   - Проверяет токен из заголовка Authorization
   - Блокирует доступ без правильного токена

### Настройки в app_settings

| Key | Value | Status |
|-----|-------|--------|
| `leo_chat_goal_comment_webhook` | `https://acevqbdpzgbtqznbpgzr.supabase.co/functions/v1/leo-chat` | ✅ Установлен |
| `CRON_SECRET` | `e928d3d5...` (64 символа) | ✅ Установлен |

---

## Что происходит после настройки

1. **Пользователь заполняет v2/v3/v4** в GoalCheckpointScreen
2. **Триггер срабатывает:** `tg_notify_goal_comment` 
3. **HTTP POST отправляется** на Edge Function с event=goal_field_saved
4. **Edge Function проверяет** CRON_SECRET в заголовке
5. **Макс генерирует комментарий:**
   - Edge Function вызывает `getOpenAIClient('grok-4-fast-non-reasoning')`
   - Функция определяет: это XAI модель → использует `XAI_API_KEY` + `https://api.x.ai/v1`
   - Генерируется ответ от Grok
6. **Комментарий сохраняется** в leo_messages
7. **Пользователь видит** реакцию Макса в чате

**Аналогично для Лео:**
- Пользователь пишет Лео → используется модель `gpt-5-nano`
- Edge Function определяет: это OpenAI модель → использует `OPENAI_API_KEY` + `https://api.openai.com`

---

## Troubleshooting

### Проблема: "Макс не отвечает после сохранения v2/v3/v4"

**Проверьте:**
1. CRON_SECRET добавлен в переменные окружения Edge Function
2. Значение совпадает с app_settings
3. Edge Function leo-chat активна (status: ACTIVE)

**Проверка через логи:**
```bash
# В Supabase Dashboard → Edge Functions → leo-chat → Logs
# Должны быть записи с goal_comment mode
```

### Проблема: "401 Unauthorized в логах Edge Function"

**Причина:** CRON_SECRET не совпадает или не установлен

**Решение:**
1. Проверьте значение в app_settings
2. Проверьте значение в Edge Function Secrets
3. Убедитесь, что нет лишних пробелов

### Проблема: "400 Incorrect API key provided" или "openai_error"

**Причина:** Отсутствует нужный API key для модели

**Решение:**
1. Проверьте, какую модель использует бот:
   - Макс → `grok-4-fast-non-reasoning` → нужен `XAI_API_KEY`
   - Лео → `gpt-5-nano` → нужен `OPENAI_API_KEY`
2. Добавьте оба ключа в **Edge Functions → leo-chat → Settings → Secrets**:
   - `XAI_API_KEY` от https://console.x.ai
   - `OPENAI_API_KEY` от https://platform.openai.com
3. Edge Function автоматически перезапустится

### Проблема: "Model gpt-5-nano does not exist" на XAI endpoint

**Причина:** Edge Function пытается использовать OpenAI модель на XAI endpoint

**Решение:**
1. Проверьте логи: должна быть запись `INFO openai_client_created`
2. Убедитесь, что для `gpt-*` моделей используется `OPENAI_API_KEY`
3. Убедитесь, что для `grok-*` моделей используется `XAI_API_KEY`
4. Если проблема сохраняется - перезадеплойте Edge Function

---

## Дата создания
3 октября 2025

## Связанные задачи
- Задача 56.1: ✅ Создание триггера для автоматических комментариев Макса
- Задача 56.2: ✅ Исправление XAI API интеграции
- Задача 56.3: ✅ Документация настройки
- Задача 56.4: ✅ Динамический выбор API endpoint по модели

