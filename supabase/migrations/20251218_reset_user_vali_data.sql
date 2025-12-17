-- SQL скрипт для сброса данных пользователя для тестирования первой валидации
-- ВАЖНО: Выполнять только в dev/test окружении!
-- Замените 'YOUR_USER_ID_HERE' на реальный user_id перед выполнением

-- Вариант 1: Удалить только завершенные валидации (для сброса статуса "первой валидации")
-- Это минимальное изменение - удалит только completed валидации

-- DELETE FROM public.idea_validations
-- WHERE user_id = 'YOUR_USER_ID_HERE'
--   AND status = 'completed';

-- Вариант 2: Удалить ВСЕ валидации пользователя (полный сброс)
-- DELETE FROM public.idea_validations
-- WHERE user_id = 'YOUR_USER_ID_HERE';

-- Вариант 3: Удалить все данные Валли (валидации + чаты + сообщения)
-- Это самый полный сброс

-- BEGIN;
-- 
-- -- 1. Удаляем все валидации пользователя
-- DELETE FROM public.idea_validations
-- WHERE user_id = 'YOUR_USER_ID_HERE';
-- 
-- -- 2. Находим и удаляем все чаты с Валли
-- DELETE FROM public.leo_chats
-- WHERE user_id = 'YOUR_USER_ID_HERE'
--   AND bot = 'vali';
-- 
-- -- 3. Сообщения из этих чатов удалятся автоматически через CASCADE,
-- -- но можно и явно удалить (если CASCADE не настроен)
-- -- DELETE FROM public.leo_messages
-- -- WHERE user_id = 'YOUR_USER_ID_HERE'
-- --   AND chat_id IN (
-- --     SELECT id FROM public.leo_chats WHERE bot = 'vali' AND user_id = 'YOUR_USER_ID_HERE'
-- --   );
-- 
-- COMMIT;

-- ==========================================
-- ИНСТРУКЦИЯ ПО ИСПОЛЬЗОВАНИЮ:
-- ==========================================
-- 
-- 1. Найдите ваш user_id:
--    SELECT id, email FROM auth.users WHERE email = 'your-email@example.com';
--
-- 2. Выберите нужный вариант (1, 2 или 3) и раскомментируйте его
--
-- 3. Замените 'YOUR_USER_ID_HERE' на ваш user_id
--
-- 4. Выполните через Supabase SQL Editor или psql
--
-- 5. После этого следующая валидация будет считаться первой (бесплатной)
