-- Migration: Add Slot Filling support to idea_validations
-- Date: 2024-12-17
-- Description: Adds slots_state JSONB column and retry_count for Slot Filling architecture

ALTER TABLE idea_validations 
ADD COLUMN IF NOT EXISTS slots_state JSONB DEFAULT '{}'::jsonb;

-- Add retry_count to track soft validation attempts
ALTER TABLE idea_validations 
ADD COLUMN IF NOT EXISTS retry_count INT DEFAULT 0;

-- NOTE: GIN-индекс на slots_state закомментирован, чтобы не создавать лишнюю нагрузку на запись.
-- Включать ТОЛЬКО если будут активные аналитические запросы по содержимому JSON.
-- Add index for querying slots_state (optional, for analytics)
-- CREATE INDEX IF NOT EXISTS idx_validations_slots_state 
-- ON idea_validations USING gin(slots_state);

-- Add comment explaining the structure
COMMENT ON COLUMN idea_validations.slots_state IS 
'Slot Filling state: {
  "slots": {
    "product": {"content": "...", "status": "filled|partial|empty", "confidence": 0.0-1.0, "feedback": "...", "updated_at": "ISO"},
    "problem": {...},
    "audience": {...},
    "competitors": {...},
    "utp": {...},
    "next_steps": {...},
    "risks": {...}
  },
  "metadata": {
    "last_updated": "ISO timestamp",
    "forced_slots": ["product"]
  }
}';

COMMENT ON COLUMN idea_validations.retry_count IS 
'Number of retry attempts for current step (soft validation). Resets on step advance.';
