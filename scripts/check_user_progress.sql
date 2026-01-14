-- SQL-запросы для проверки данных user_progress в Supabase Dashboard
-- 
-- Инструкция:
-- 1. Откройте Supabase Dashboard (https://app.supabase.com)
-- 2. Перейдите в SQL Editor
-- 3. Скопируйте и выполните нужный запрос
-- 4. Замените 'YOUR_USER_ID' на реальный user_id

-- ============================================
-- 1. Полная информация о прогрессе пользователя
-- ============================================
SELECT 
  up.id,
  up.user_id,
  up.level_id,
  l.number as level_number,
  l.title as level_title,
  up.is_completed,
  up.created_at,
  up.updated_at,
  u.current_level as user_current_level
FROM user_progress up
LEFT JOIN levels l ON l.id = up.level_id
LEFT JOIN users u ON u.id = up.user_id
WHERE up.user_id = 'YOUR_USER_ID'  -- ⚠️ ЗАМЕНИТЕ НА РЕАЛЬНЫЙ USER_ID
ORDER BY l.number ASC;

-- ============================================
-- 2. Проверка конкретных уровней (4 и 7)
-- ============================================
SELECT 
  up.level_id,
  l.number as level_number,
  l.title,
  up.is_completed,
  CASE 
    WHEN up.is_completed = true THEN '✅ Завершен'
    ELSE '❌ Не завершен'
  END as status
FROM user_progress up
LEFT JOIN levels l ON l.id = up.level_id
WHERE up.user_id = 'YOUR_USER_ID'  -- ⚠️ ЗАМЕНИТЕ НА РЕАЛЬНЫЙ USER_ID
  AND l.number IN (4, 7)
ORDER BY l.number;

-- ============================================
-- 3. Проверка всех уровней с их статусом
-- ============================================
SELECT 
  l.number as level_number,
  l.title,
  COALESCE(up.is_completed, false) as is_completed,
  CASE 
    WHEN up.is_completed = true THEN '✅ Завершен'
    WHEN up.is_completed = false THEN '⚠️  В БД, но не завершен'
    ELSE '❌ Нет записи в БД'
  END as status
FROM levels l
LEFT JOIN user_progress up ON up.level_id = l.id AND up.user_id = 'YOUR_USER_ID'  -- ⚠️ ЗАМЕНИТЕ НА РЕАЛЬНЫЙ USER_ID
WHERE l.number BETWEEN 0 AND 10
ORDER BY l.number;

-- ============================================
-- 4. Поиск проблемных записей (is_completed = true, но уровень не должен быть завершен)
-- ============================================
-- Этот запрос найдет уровни, которые помечены как завершенные,
-- но у которых есть незавершенные предыдущие уровни
WITH level_status AS (
  SELECT 
    l.number as level_number,
    l.id as level_id,
    COALESCE(up.is_completed, false) as is_completed
  FROM levels l
  LEFT JOIN user_progress up ON up.level_id = l.id AND up.user_id = 'YOUR_USER_ID'  -- ⚠️ ЗАМЕНИТЕ НА РЕАЛЬНЫЙ USER_ID
  WHERE l.number BETWEEN 0 AND 10
)
SELECT 
  ls1.level_number,
  ls1.is_completed,
  CASE 
    WHEN ls1.is_completed = true AND EXISTS (
      SELECT 1 FROM level_status ls2 
      WHERE ls2.level_number < ls1.level_number 
        AND ls2.is_completed = false
    ) THEN '⚠️  ПРОБЛЕМА: Завершен, но есть незавершенные предыдущие уровни'
    WHEN ls1.is_completed = true THEN '✅ Завершен корректно'
    ELSE '❌ Не завершен'
  END as status_check
FROM level_status ls1
WHERE ls1.is_completed = true
ORDER BY ls1.level_number;

-- ============================================
-- 5. Получить user_id текущего пользователя (если нужно)
-- ============================================
-- Выполните этот запрос, чтобы найти user_id по email:
SELECT 
  id as user_id,
  email,
  name,
  current_level
FROM users
WHERE email = 'your-email@example.com';  -- ⚠️ ЗАМЕНИТЕ НА РЕАЛЬНЫЙ EMAIL
