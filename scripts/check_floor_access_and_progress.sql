-- Проверка доступа к этажам и прогресса по уровням
-- для пользователя: 575dc7cd-b315-411a-8aa5-472fc8859e67

-- 1. Проверка доступа к этажам (floor_access)
SELECT 
    fa.floor_number,
    fa.unlocked_at
FROM public.floor_access fa
WHERE fa.user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67'
ORDER BY fa.floor_number;

-- 2. Проверка завершенности уровней (user_progress)
SELECT 
    up.level_id,
    l.number as level_number,
    l.title as level_name,
    l.floor_number,
    up.is_completed,
    up.completed_at,
    up.updated_at
FROM public.user_progress up
JOIN public.levels l ON l.id = up.level_id
WHERE up.user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67'
ORDER BY l.number;

-- 3. Проверка конкретно уровня 5 (включая информацию об этаже и доступе)
SELECT 
    l.number as level_number,
    l.title as level_name,
    l.floor_number,
    COALESCE(up.is_completed, false) as is_completed,
    up.completed_at,
    CASE 
        WHEN l.floor_number = 1 AND l.number <= 3 THEN 'Бесплатный (этаж 1, уровни 0-3)'
        WHEN EXISTS (
            SELECT 1 FROM public.floor_access fa
            WHERE fa.user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67'
              AND fa.floor_number = l.floor_number
        ) THEN 'Доступ есть (этаж открыт)'
        ELSE 'Требуется покупка доступа к этажу'
    END as access_status
FROM public.levels l
LEFT JOIN public.user_progress up ON up.level_id = l.id 
    AND up.user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67'
WHERE l.number = 5;

-- 4. Проверка доступа к этажу 1
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM public.floor_access fa
            WHERE fa.user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67'
              AND fa.floor_number = 1
        ) THEN 'ДА - есть доступ к этажу 1'
        ELSE 'НЕТ - нет доступа к этажу 1'
    END as floor_1_access;

-- 5. Сводная информация: этажи и уровни
SELECT 
    'Этажи с доступом:' as info_type,
    COALESCE(
        string_agg(fa.floor_number::text, ', ' ORDER BY fa.floor_number),
        'Нет доступа ни к одному этажу'
    ) as value
FROM public.floor_access fa
WHERE fa.user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67'

UNION ALL

SELECT 
    'Завершенные уровни:' as info_type,
    COALESCE(
        string_agg(l.number::text, ', ' ORDER BY l.number),
        'Нет завершенных уровней'
    ) as value
FROM public.user_progress up
JOIN public.levels l ON l.id = up.level_id
WHERE up.user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67'
  AND up.is_completed = true;

-- 6. Проверка баланса GP (для контекста)
SELECT 
    balance,
    total_earned,
    total_spent,
    updated_at
FROM public.gp_wallets
WHERE user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67';

-- 7. Проверка пакетов (user_packages) - если используется
SELECT 
    up.package_id,
    p.code as package_code,
    p.kind as package_kind,
    up.gp_spent,
    up.source
FROM public.user_packages up
JOIN public.packages p ON p.id = up.package_id
WHERE up.user_id = '575dc7cd-b315-411a-8aa5-472fc8859e67'
ORDER BY up.package_id DESC;
