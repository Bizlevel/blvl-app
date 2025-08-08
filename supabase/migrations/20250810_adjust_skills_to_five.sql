-- Adjust skills to 5 and map existing levels accordingly

-- Upsert canonical skills list (id, name)
INSERT INTO public.skills (id, name)
VALUES
  (1, 'Фокус лидера'),
  (2, 'Денежный контроль'),
  (3, 'Магнит клиентов'),
  (4, 'Система действий'),
  (5, 'Скорость роста')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- Remove obsolete skills beyond 5
DELETE FROM public.skills WHERE id > 5;

-- Map current levels to skills (based on bizlevel-concept)
UPDATE public.levels SET skill_id = 1 WHERE number IN (1,2,3);
UPDATE public.levels SET skill_id = 2 WHERE number IN (4,9);
UPDATE public.levels SET skill_id = 3 WHERE number IN (5,6,8);
UPDATE public.levels SET skill_id = 4 WHERE number IN (7,10);
-- Skill 5 will be linked to future levels

