Лишние и устаревшие файлы, которые больше не используются в текущей версии проекта.

 Категории выявленных файлов

1. Архивная документация (docs/archive/)
Количество файлов: 24
Список файлов для удаления:
- `audit-after-23.md` - отчет аудита после этапа 23
- `bizlevel-cases-scenarios.md` - старые сценарии кейсов (дублируется актуальными данными в БД)
- `bizlevel-goal-feature-concept.md` - концепция системы целей v1
- `bizlevel-goal-feature-spec.md` - спецификация системы целей v1
- `bizlevel-gp-implementation-spec.md` - спецификация GP v1
- `bizlevel-level-content.md` - контент уровней v1
- `bizlevel-map-concept.md` - концепция карты уровней v1
- `bizlevel-minicases-concept.md` - концепция мини-кейсов v1
- `bizlevel-modification-plan-v2.md` - план модификации v2
- `bizlevel-supabase-schema-v2.md` - схема БД v2
- `bizlevel-tower-map-concept.md` - концепция башни v1
- `cost_tracking_implementation_plan.md` - план отслеживания стоимости
- `design-optimization(after_st44).md` - оптимизация дизайна после ст.44
- `library-concept.md` - концепция библиотеки v1
- `library-migration-sql.sql` - SQL миграция библиотеки
- `motivational-quotes-goals.md` - цитаты для целей
- `plan_case_rag_indexing.md` - план индексации RAG
- `project-structure-start.md` - начальная структура проекта
- `status (stages-1 to 29)).md` - статус этапов 1-29
- `vercel uploading.txt` - заметки о загрузке на Vercel
- `Вопросы для тестов.md` - вопросы для тестов v1
- `Навыки.md` - файл навыков v1
- `Создание долгосрочной памяти для Лео(этап 26).md` - концепция памяти Лео
- `Чистка supabase после эт.34.md` - план чистки БД

2. Устаревшие черновики
Количество файлов: 4
Расположение: docs/draft-.md
Список файлов для удаления:
- `docs/draft-1.md` - черновик концепции
- `docs/draft-2.md` - черновик концепции
- `docs/draft-3.md` - черновик концепции
- `docs/draft-4.md` - черновик концепции

3. Неактуальные скрипты
Количество файлов: 3
Расположение: scripts/
Список файлов для удаления:
- `scripts/debug_cases.py` - отладка кейсов (не используется в продакшене)
- `scripts/test_rag_search.py` - тест поиска RAG (дублируется основными тестами)
- `scripts/upload_from_drive.py` - загрузка из Google Drive (если не используется) - после переезда на RAG OpenAI

4. Устаревшие миграции Supabase
Количество файлов: 6 из 18
Расположение: supabase/migrations/
 Ранние миграции для проверки:
- `20250724_0001_add_missing_rls_policies.sql` - базовые политики RLS
- `20250724_0002_add_subscriptions.sql` - подписки (уже удалены из кода)
- `20250801_add_cover_path_to_levels.sql` - пути к обложкам
- `20250802_add_avatar_id_to_users.sql` - ID аватаров
- `20250806_fix_update_current_level.sql` - исправление обновления уровня
- `20250808_add_leo_messages_processed.sql` - обработанные сообщения Лео

Рекомендации по приоритетам
можно удалять сразу, если не актуально:
- Весь каталог `docs/archive/` (24 файла)
- `docs/draft-.md` файлы (4 файла)
- `scripts/debug_cases.py` и `scripts/test_rag_search.py` 

удалять после проверки:
- `scripts/upload_from_drive.py` (если Google Drive не используется)  - после переезда на RAG OpenAI

 Приоритет 3 (только после тестирования):
- Миграции после подтверждения работоспособности системы

Замечания
1. Резервное копирование: перед массовым удалением создать бэкап
2. Тестирование: после удаления провести полное тестирование системы
3. Git история: удаленные файлы останутся в истории git (можно очистить через git filter-branch при необходимости)
4. Этот отчет сохранить для истории
