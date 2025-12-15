-- Migration: Создание таблицы idea_validations для бота Валли
-- Цель: хранение метаданных валидаций идей (скоринг, отчёты, рекомендации)
-- Safe to run multiple times (idempotent)

BEGIN;

-- Создание таблицы idea_validations
CREATE TABLE IF NOT EXISTS public.idea_validations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  chat_id UUID REFERENCES public.leo_chats(id) ON DELETE CASCADE,
  
  -- Статус сессии
  status TEXT NOT NULL DEFAULT 'in_progress' 
    CHECK (status IN ('in_progress', 'completed', 'abandoned')),
  
  -- Прогресс диалога (1-7 вопросов)
  current_step INT DEFAULT 1 CHECK (current_step >= 1 AND current_step <= 7),
  
  -- Результаты скоринга
  scores JSONB, -- Формат: {"problem": 15, "customer": 12, "validation": 8, "unique": 14, "action": 10}
  total_score INT CHECK (total_score >= 0 AND total_score <= 100),
  archetype TEXT CHECK (archetype IN ('МЕЧТАТЕЛЬ', 'ИССЛЕДОВАТЕЛЬ', 'СТРОИТЕЛЬ', 'ГОТОВ К ЗАПУСКУ', 'VALIDATED')),
  
  -- Отчёт
  report_markdown TEXT,
  
  -- Рекомендации BizLevel
  recommended_levels JSONB DEFAULT '[]'::jsonb,
  -- Формат: [{"level_id": 8, "level_number": 8, "reason": "Низкий балл по валидации"}]
  
  -- Конкретное действие (ONE THING)
  one_thing TEXT,
  
  -- Метаданные
  idea_summary TEXT, -- Краткое описание идеи пользователя
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  gp_spent INT DEFAULT 0
);

-- Индексы для производительности
CREATE INDEX IF NOT EXISTS idx_idea_validations_user_id 
  ON public.idea_validations(user_id);

CREATE INDEX IF NOT EXISTS idx_idea_validations_chat_id 
  ON public.idea_validations(chat_id);

CREATE INDEX IF NOT EXISTS idx_idea_validations_status 
  ON public.idea_validations(status);

CREATE INDEX IF NOT EXISTS idx_idea_validations_created_at 
  ON public.idea_validations(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_idea_validations_user_status 
  ON public.idea_validations(user_id, status);

-- Включение RLS
ALTER TABLE public.idea_validations ENABLE ROW LEVEL SECURITY;

-- RLS политики: пользователи видят/модифицируют только свои валидации
DO $$
BEGIN
  -- Политика SELECT
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
      AND tablename = 'idea_validations' 
      AND policyname = 'Users can view own validations'
  ) THEN
    CREATE POLICY "Users can view own validations" 
      ON public.idea_validations FOR SELECT 
      TO authenticated
      USING (auth.uid() = user_id);
  END IF;

  -- Политика INSERT
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
      AND tablename = 'idea_validations' 
      AND policyname = 'Users can insert own validations'
  ) THEN
    CREATE POLICY "Users can insert own validations" 
      ON public.idea_validations FOR INSERT 
      TO authenticated
      WITH CHECK (auth.uid() = user_id);
  END IF;

  -- Политика UPDATE
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
      AND tablename = 'idea_validations' 
      AND policyname = 'Users can update own validations'
  ) THEN
    CREATE POLICY "Users can update own validations" 
      ON public.idea_validations FOR UPDATE 
      TO authenticated
      USING (auth.uid() = user_id)
      WITH CHECK (auth.uid() = user_id);
  END IF;
END$$;

COMMIT;
