#!/usr/bin/env python3
"""
Скрипт миграции JSON данных в Supabase
"""

import json
import os
import asyncio
import aiohttp
from pathlib import Path
from typing import List, Dict, Any
import hashlib
from datetime import datetime

# Загружаем переменные окружения из .env
from dotenv import load_dotenv
# Ищем .env в корне проекта (на 2 уровня выше)
env_path = Path(__file__).parent.parent.parent / '.env'
load_dotenv(env_path)

class SupabaseMigrator:
    def __init__(self, supabase_url: str, supabase_key: str, openai_api_key: str):
        self.supabase_url = supabase_url
        self.supabase_key = supabase_key
        self.openai_api_key = openai_api_key
        self.session = None
        
    async def __aenter__(self):
        self.session = aiohttp.ClientSession()
        return self
        
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        if self.session:
            await self.session.close()
    
    async def create_tables(self):
        """Создает необходимые таблицы в Supabase"""
        
        # DDL для создания таблиц
        ddl_queries = [
            """
            -- Создание таблицы для фактов уроков
            CREATE TABLE IF NOT EXISTS lesson_facts (
                id TEXT PRIMARY KEY,
                content TEXT NOT NULL,
                lesson_id INTEGER NOT NULL,
                level_number INTEGER NOT NULL,
                section TEXT NOT NULL,
                title TEXT NOT NULL,
                file_name TEXT NOT NULL,
                doc_id TEXT NOT NULL,
                chunk_index INTEGER NOT NULL,
                tags TEXT[] DEFAULT '{}',
                topics TEXT[] DEFAULT '{}',
                keywords TEXT[] DEFAULT '{}',
                embedding VECTOR(1536), -- OpenAI text-embedding-3-small
                created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
                updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
            );
            """,
            """
            -- Создание индексов для быстрого поиска
            CREATE INDEX IF NOT EXISTS idx_lesson_facts_level_number ON lesson_facts(level_number);
            CREATE INDEX IF NOT EXISTS idx_lesson_facts_section ON lesson_facts(section);
            CREATE INDEX IF NOT EXISTS idx_lesson_facts_lesson_id ON lesson_facts(lesson_id);
            CREATE INDEX IF NOT EXISTS idx_lesson_facts_tags ON lesson_facts USING GIN(tags);
            CREATE INDEX IF NOT EXISTS idx_lesson_facts_topics ON lesson_facts USING GIN(topics);
            CREATE INDEX IF NOT EXISTS idx_lesson_facts_keywords ON lesson_facts USING GIN(keywords);
            """,
            """
            -- Создание векторного индекса для поиска по сходству
            CREATE INDEX IF NOT EXISTS idx_lesson_facts_embedding ON lesson_facts 
            USING ivfflat (embedding vector_cosine_ops) 
            WITH (lists = 100);
            """,
            """
            -- Создание таблицы для метаданных уроков
            CREATE TABLE IF NOT EXISTS lesson_metadata (
                lesson_id INTEGER PRIMARY KEY,
                level_id INTEGER NOT NULL,
                title TEXT NOT NULL,
                description TEXT NOT NULL,
                video_url TEXT,
                duration_minutes INTEGER,
                language TEXT NOT NULL,
                version TEXT NOT NULL,
                created_at TIMESTAMP WITH TIME ZONE NOT NULL,
                updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
                checksum_sha256 TEXT NOT NULL,
                content JSONB NOT NULL
            );
            """,
            """
            -- Создание индексов для метаданных
            CREATE INDEX IF NOT EXISTS idx_lesson_metadata_level_id ON lesson_metadata(level_id);
            CREATE INDEX IF NOT EXISTS idx_lesson_metadata_language ON lesson_metadata(language);
            CREATE INDEX IF NOT EXISTS idx_lesson_metadata_version ON lesson_metadata(version);
            """
        ]
        
        print("Создание таблиц в Supabase...")
        for i, query in enumerate(ddl_queries, 1):
            try:
                await self.execute_sql(query)
                print(f"✅ Запрос {i}/{len(ddl_queries)} выполнен")
            except Exception as e:
                print(f"❌ Ошибка в запросе {i}: {e}")
                raise
    
    async def execute_sql(self, query: str):
        """Выполняет SQL запрос в Supabase"""
        url = f"{self.supabase_url}/rest/v1/rpc/exec_sql"
        headers = {
            "apikey": self.supabase_key,
            "Authorization": f"Bearer {self.supabase_key}",
            "Content-Type": "application/json"
        }
        
        async with self.session.post(url, json={"query": query}, headers=headers) as response:
            if response.status != 200:
                error_text = await response.text()
                raise Exception(f"SQL execution failed: {response.status} - {error_text}")
            return await response.json()
    
    async def get_embedding(self, text: str) -> List[float]:
        """Получает эмбеддинг от OpenAI"""
        url = "https://api.openai.com/v1/embeddings"
        headers = {
            "Authorization": f"Bearer {self.openai_api_key}",
            "Content-Type": "application/json"
        }
        
        data = {
            "input": text,
            "model": "text-embedding-3-small"
        }
        
        async with self.session.post(url, json=data, headers=headers) as response:
            if response.status != 200:
                error_text = await response.text()
                raise Exception(f"OpenAI API error: {response.status} - {error_text}")
            
            result = await response.json()
            return result["data"][0]["embedding"]
    
    async def load_lesson_metadata(self):
        """Загружает метаданные уроков"""
        print("Загрузка метаданных уроков...")
        
        lesson_files = []
        for root, dirs, files in os.walk('levels'):
            for file in files:
                if file == 'lesson.json':
                    lesson_files.append(os.path.join(root, file))
        
        for lesson_file in lesson_files:
            try:
                with open(lesson_file, 'r', encoding='utf-8') as f:
                    lesson_data = json.load(f)
                
                # Подготавливаем данные для вставки
                metadata = {
                    "lesson_id": lesson_data['lesson_id'],
                    "level_id": lesson_data['level_id'],
                    "title": lesson_data['title'],
                    "description": lesson_data['description'],
                    "video_url": lesson_data.get('video_url'),
                    "duration_minutes": lesson_data.get('duration_minutes'),
                    "language": lesson_data['language'],
                    "version": lesson_data['version'],
                    "created_at": lesson_data['created_at'],
                    "updated_at": lesson_data['updated_at'],
                    "checksum_sha256": lesson_data['checksum_sha256'],
                    "content": lesson_data['content']
                }
                
                # Вставляем в базу
                await self.insert_lesson_metadata(metadata)
                print(f"✅ Метаданные урока {lesson_data['lesson_id']} загружены")
                
            except Exception as e:
                print(f"❌ Ошибка загрузки {lesson_file}: {e}")
    
    async def insert_lesson_metadata(self, metadata: Dict[str, Any]):
        """Вставляет метаданные урока в базу"""
        url = f"{self.supabase_url}/rest/v1/lesson_metadata"
        headers = {
            "apikey": self.supabase_key,
            "Authorization": f"Bearer {self.supabase_key}",
            "Content-Type": "application/json",
            "Prefer": "resolution=merge-duplicates"
        }
        
        async with self.session.post(url, json=metadata, headers=headers) as response:
            if response.status not in [200, 201]:
                error_text = await response.text()
                raise Exception(f"Failed to insert lesson metadata: {response.status} - {error_text}")
    
    async def load_facts(self):
        """Загружает факты с эмбеддингами"""
        print("Загрузка фактов с эмбеддингами...")
        
        fact_files = []
        for root, dirs, files in os.walk('levels'):
            for file in files:
                if file == 'facts.jsonl':
                    fact_files.append(os.path.join(root, file))
        
        total_facts = 0
        for fact_file in fact_files:
            try:
                with open(fact_file, 'r', encoding='utf-8') as f:
                    for line in f:
                        if line.strip():
                            fact = json.loads(line)
                            
                            # Получаем эмбеддинг
                            embedding = await self.get_embedding(fact['content'])
                            fact['embedding'] = embedding
                            
                            # Вставляем в базу
                            await self.insert_fact(fact)
                            total_facts += 1
                            
                            if total_facts % 10 == 0:
                                print(f"✅ Загружено {total_facts} фактов...")
                
                print(f"✅ Файл {fact_file} обработан")
                
            except Exception as e:
                print(f"❌ Ошибка обработки {fact_file}: {e}")
        
        print(f"🎉 Всего загружено {total_facts} фактов")
    
    async def insert_fact(self, fact: Dict[str, Any]):
        """Вставляет факт в базу"""
        url = f"{self.supabase_url}/rest/v1/lesson_facts"
        headers = {
            "apikey": self.supabase_key,
            "Authorization": f"Bearer {self.supabase_key}",
            "Content-Type": "application/json",
            "Prefer": "resolution=merge-duplicates"
        }
        
        async with self.session.post(url, json=fact, headers=headers) as response:
            if response.status not in [200, 201]:
                error_text = await response.text()
                raise Exception(f"Failed to insert fact: {response.status} - {error_text}")
    
    async def create_search_functions(self):
        """Создает функции для поиска"""
        search_functions = [
            """
            -- Функция для гибридного поиска
            CREATE OR REPLACE FUNCTION search_lesson_facts(
                query_text TEXT,
                query_embedding VECTOR(1536),
                level_filter INTEGER DEFAULT NULL,
                section_filter TEXT DEFAULT NULL,
                limit_count INTEGER DEFAULT 10
            )
            RETURNS TABLE (
                id TEXT,
                content TEXT,
                lesson_id INTEGER,
                level_number INTEGER,
                section TEXT,
                title TEXT,
                similarity_score FLOAT,
                bm25_score FLOAT,
                combined_score FLOAT
            )
            LANGUAGE plpgsql
            AS $$
            BEGIN
                RETURN QUERY
                SELECT 
                    lf.id,
                    lf.content,
                    lf.lesson_id,
                    lf.level_number,
                    lf.section,
                    lf.title,
                    (1 - (lf.embedding <=> query_embedding)) as similarity_score,
                    ts_rank(to_tsvector('russian', lf.content), plainto_tsquery('russian', query_text)) as bm25_score,
                    (0.7 * (1 - (lf.embedding <=> query_embedding)) + 0.3 * ts_rank(to_tsvector('russian', lf.content), plainto_tsquery('russian', query_text))) as combined_score
                FROM lesson_facts lf
                WHERE 
                    (level_filter IS NULL OR lf.level_number = level_filter)
                    AND (section_filter IS NULL OR lf.section = section_filter)
                ORDER BY combined_score DESC
                LIMIT limit_count;
            END;
            $$
            """,
            """
            -- Функция для поиска по уровням
            CREATE OR REPLACE FUNCTION search_by_level(
                level_number INTEGER,
                query_text TEXT DEFAULT '',
                limit_count INTEGER DEFAULT 20
            )
            RETURNS TABLE (
                id TEXT,
                content TEXT,
                lesson_id INTEGER,
                section TEXT,
                title TEXT
            )
            LANGUAGE plpgsql
            AS $$
            BEGIN
                IF query_text = '' THEN
                    RETURN QUERY
                    SELECT lf.id, lf.content, lf.lesson_id, lf.section, lf.title
                    FROM lesson_facts lf
                    WHERE lf.level_number = level_number
                    ORDER BY lf.lesson_id, lf.chunk_index
                    LIMIT limit_count;
                ELSE
                    RETURN QUERY
                    SELECT lf.id, lf.content, lf.lesson_id, lf.section, lf.title
                    FROM lesson_facts lf
                    WHERE lf.level_number = level_number
                        AND to_tsvector('russian', lf.content) @@ plainto_tsquery('russian', query_text)
                    ORDER BY ts_rank(to_tsvector('russian', lf.content), plainto_tsquery('russian', query_text)) DESC
                    LIMIT limit_count;
                END IF;
            END;
            $$
            """
        ]
        
        print("Создание функций поиска...")
        for i, func in enumerate(search_functions, 1):
            try:
                await self.execute_sql(func)
                print(f"✅ Функция {i}/{len(search_functions)} создана")
            except Exception as e:
                print(f"❌ Ошибка создания функции {i}: {e}")

async def main():
    """Основная функция миграции"""
    
    # Загружаем переменные окружения
    supabase_url = os.getenv('SUPABASE_URL')
    # Используем SERVICE_ROLE_KEY для создания таблиц (требуются админские права)
    supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY') or os.getenv('SUPABASE_ANON_KEY')
    openai_api_key = os.getenv('OPENAI_API_KEY')
    
    if not all([supabase_url, supabase_key, openai_api_key]):
        print("❌ Необходимо установить переменные окружения:")
        print("SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY (или SUPABASE_ANON_KEY), OPENAI_API_KEY")
        return
    
    async with SupabaseMigrator(supabase_url, supabase_key, openai_api_key) as migrator:
        try:
            print("🚀 Начинаем миграцию данных...")
            print("⚠️ Убедитесь, что таблицы lesson_facts и lesson_metadata уже созданы в Supabase!\n")
            
            # Таблицы уже созданы вручную через SQL Editor
            # 1. Создаем таблицы - ПРОПУСКАЕМ
            # await migrator.create_tables()
            
            # 2. Загружаем метаданные уроков
            await migrator.load_lesson_metadata()
            
            # 3. Загружаем факты с эмбеддингами
            await migrator.load_facts()
            
            # 4. Создаем функции поиска - делаем вручную через SQL
            print("\n⚠️ Не забудьте создать функции поиска через SQL Editor:")
            print("   - search_lesson_facts()")
            print("   - search_by_level()")
            
            print("\n🎉 Миграция данных завершена успешно!")
            print(f"📊 Проверьте таблицы lesson_facts и lesson_metadata в Supabase")
            
        except Exception as e:
            print(f"❌ Ошибка миграции: {e}")
            import traceback
            traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
