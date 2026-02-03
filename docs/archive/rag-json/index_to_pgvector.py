#!/usr/bin/env python3
"""
Скрипт для индексации фактов в pgvector
"""

import json
import os
import asyncio
import aiohttp
from pathlib import Path
from typing import List, Dict, Any
import hashlib
from datetime import datetime

class PgVectorIndexer:
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
    
    async def index_facts(self):
        """Индексирует все факты в pgvector"""
        print("🚀 Начинаем индексацию фактов в pgvector...")
        
        fact_files = []
        for root, dirs, files in os.walk('levels'):
            for file in files:
                if file == 'facts.jsonl':
                    fact_files.append(os.path.join(root, file))
        
        total_facts = 0
        processed_files = 0
        
        for fact_file in fact_files:
            try:
                print(f"📁 Обрабатываем файл: {fact_file}")
                
                with open(fact_file, 'r', encoding='utf-8') as f:
                    for line_num, line in enumerate(f, 1):
                        if line.strip():
                            fact = json.loads(line)
                            
                            # Получаем эмбеддинг
                            print(f"  🔍 Генерируем эмбеддинг для факта {fact['id']}...")
                            embedding = await self.get_embedding(fact['content'])
                            fact['embedding'] = embedding
                            
                            # Вставляем в базу
                            await self.insert_fact(fact)
                            total_facts += 1
                            
                            if total_facts % 5 == 0:
                                print(f"  ✅ Обработано {total_facts} фактов...")
                
                processed_files += 1
                print(f"✅ Файл {processed_files}/{len(fact_files)} обработан")
                
            except Exception as e:
                print(f"❌ Ошибка обработки {fact_file}: {e}")
        
        print(f"🎉 Индексация завершена! Обработано {total_facts} фактов из {processed_files} файлов")
    
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
    
    async def verify_indexing(self):
        """Проверяет результаты индексации"""
        print("🔍 Проверяем результаты индексации...")
        
        # Проверяем количество фактов по уровням
        url = f"{self.supabase_url}/rest/v1/lesson_facts"
        params = {
            "select": "level_number",
            "group": "level_number"
        }
        headers = {
            "apikey": self.supabase_key,
            "Authorization": f"Bearer {self.supabase_key}"
        }
        
        async with self.session.get(url, params=params, headers=headers) as response:
            if response.status == 200:
                data = await response.json()
                print("📊 Факты по уровням:")
                for item in data:
                    print(f"  Уровень {item['level_number']}: {item['count']} фактов")
            else:
                print(f"❌ Ошибка проверки: {response.status}")
        
        # Проверяем эмбеддинги
        url = f"{self.supabase_url}/rest/v1/lesson_facts"
        params = {
            "select": "id,array_length(embedding,1) as embedding_size",
            "limit": "5"
        }
        
        async with self.session.get(url, params=params, headers=headers) as response:
            if response.status == 200:
                data = await response.json()
                print("🔍 Проверка эмбеддингов:")
                for item in data:
                    print(f"  {item['id']}: {item['embedding_size']} измерений")
            else:
                print(f"❌ Ошибка проверки эмбеддингов: {response.status}")

async def main():
    """Основная функция индексации"""
    
    # Загружаем переменные окружения
    supabase_url = os.getenv('SUPABASE_URL')
    supabase_key = os.getenv('SUPABASE_ANON_KEY')
    openai_api_key = os.getenv('OPENAI_API_KEY')
    
    if not all([supabase_url, supabase_key, openai_api_key]):
        print("❌ Необходимо установить переменные окружения:")
        print("SUPABASE_URL, SUPABASE_ANON_KEY, OPENAI_API_KEY")
        return
    
    async with PgVectorIndexer(supabase_url, supabase_key, openai_api_key) as indexer:
        try:
            # Индексируем факты
            await indexer.index_facts()
            
            # Проверяем результаты
            await indexer.verify_indexing()
            
            print("🎉 Индексация в pgvector завершена успешно!")
            
        except Exception as e:
            print(f"❌ Ошибка индексации: {e}")

if __name__ == "__main__":
    asyncio.run(main())
