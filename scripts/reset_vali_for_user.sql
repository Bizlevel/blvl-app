-- Быстрый скрипт для сброса данных Валли для текущего пользователя
-- Использование: Замените USER_ID перед выполнением
-- 
-- Как найти USER_ID:
-- 1. В Supabase Dashboard → Authentication → Users
-- 2. Или выполните: SELECT id, email FROM auth.users WHERE email = 'your@email.com';

-- ==========================================
-- ВАРИАНТ 1: Только завершенные валидации
-- ==========================================
-- Удаляет только completed валидации, чтобы следующая считалась первой

DELETE FROM public.idea_validations
WHERE user_id = 'USER_ID_HERE'  -- ← ЗАМЕНИТЕ НА ВАШ USER_ID
  AND status = 'completed';

-- ==========================================
-- ВАРИАНТ 2: Все валидации (рекомендуется)
-- ==========================================
-- Удаляет все валидации, включая in_progress и abandoned

-- DELETE FROM public.idea_validations
-- WHERE user_id = 'USER_ID_HERE';  -- ← ЗАМЕНИТЕ НА ВАШ USER_ID

-- ==========================================
-- ВАРИАНТ 3: Полный сброс (валидации + чаты + сообщения)
-- ==========================================
-- Удаляет все данные Валли для пользователя

-- BEGIN;
-- 
-- -- Удаляем все валидации
-- DELETE FROM public.idea_validations
-- WHERE user_id = 'USER_ID_HERE';  -- ← ЗАМЕНИТЕ НА ВАШ USER_ID
-- 
-- -- Удаляем все чаты с Валли (сообщения удалятся через CASCADE)
-- DELETE FROM public.leo_chats
-- WHERE user_id = 'USER_ID_HERE'  -- ← ЗАМЕНИТЕ НА ВАШ USER_ID
--   AND bot = 'vali';
-- 
-- COMMIT;
