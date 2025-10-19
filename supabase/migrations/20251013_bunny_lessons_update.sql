-- Migration: Switch Level 1, Lesson 1 to Bunny HLS, remove Vimeo
-- Date: 2025-10-13
-- Notes:
--  - This migration updates public.lessons.video_url to point to Bunny HLS for Level 1, Lesson 1.
--  - It also nulls out vimeo_id for that lesson.
--  - Repeat similar UPDATEs for other lessons as Bunny videos are uploaded.

begin;

-- Level 1, Lesson order = 1 → set Bunny HLS URL
update public.lessons l
set video_url = 'https://vz-1d42f250-27d.b-cdn.net/ec865a2f-be0d-4910-819a-68c397d42478/playlist.m3u8',
    vimeo_id = null,
    updated_at = now()
where l.level_id in (select id from public.levels where number = 1)
  and l."order" = 1;

-- Template for future lessons (uncomment and replace <number>/<order>/<HLS_URL>):
-- update public.lessons l
-- set video_url = '<HLS_URL>',
--     vimeo_id = null,
--     updated_at = now()
-- where l.level_id in (select id from public.levels where number = <number>)
--   and l."order" = <order>;

commit;




