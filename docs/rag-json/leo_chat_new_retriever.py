#!/usr/bin/env python3
"""
Новый ретривер для leo-chat с поддержкой JSON-основанной RAG системы
"""

import os
import json
import asyncio
import aiohttp
from typing import List, Dict, Any, Optional
from dataclasses import dataclass

@dataclass
class RAGConfig:
    """Конфигурация RAG системы"""
    use_new_rag: bool = True
    fallback_to_old: bool = True
    supabase_url: str = ""
    supabase_key: str = ""
    openai_api_key: str = ""
    embedding_model: str = "text-embedding-3-small"
    match_threshold: float = 0.35
    match_count: int = 6
    max_tokens: int = 1200

class NewRAGRetriever:
    """Новый ретривер с гибридным поиском"""
    
    def __init__(self, config: RAGConfig):
        self.config = config
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
            "Authorization": f"Bearer {self.config.openai_api_key}",
            "Content-Type": "application/json"
        }
        
        data = {
            "input": text,
            "model": self.config.embedding_model
        }
        
        async with self.session.post(url, json=data, headers=headers) as response:
            if response.status != 200:
                error_text = await response.text()
                raise Exception(f"OpenAI API error: {response.status} - {error_text}")
            
            result = await response.json()
            return result["data"][0]["embedding"]
    
    async def search_lesson_facts(
        self, 
        query: str, 
        level_filter: Optional[int] = None,
        section_filter: Optional[str] = None,
        limit: int = 10
    ) -> List[Dict[str, Any]]:
        """Гибридный поиск по фактам уроков"""
        
        try:
            # Получаем эмбеддинг запроса
            query_embedding = await self.get_embedding(query)
            
            # Вызываем функцию поиска в Supabase
            url = f"{self.config.supabase_url}/rest/v1/rpc/search_lesson_facts"
            headers = {
                "apikey": self.config.supabase_key,
                "Authorization": f"Bearer {self.config.supabase_key}",
                "Content-Type": "application/json"
            }
            
            params = {
                "query_text": query,
                "query_embedding": query_embedding,
                "level_filter": level_filter,
                "section_filter": section_filter,
                "limit_count": limit
            }
            
            async with self.session.post(url, json=params, headers=headers) as response:
                if response.status != 200:
                    error_text = await response.text()
                    raise Exception(f"Search error: {response.status} - {error_text}")
                
                results = await response.json()
                return results or []
                
        except Exception as e:
            print(f"❌ Ошибка поиска в новой RAG: {e}")
            return []
    
    async def search_by_level(
        self, 
        level_number: int, 
        query: str = "", 
        limit: int = 20
    ) -> List[Dict[str, Any]]:
        """Поиск по уровню"""
        
        try:
            url = f"{self.config.supabase_url}/rest/v1/rpc/search_by_level"
            headers = {
                "apikey": self.config.supabase_key,
                "Authorization": f"Bearer {self.config.supabase_key}",
                "Content-Type": "application/json"
            }
            
            params = {
                "level_number": level_number,
                "query_text": query,
                "limit_count": limit
            }
            
            async with self.session.post(url, json=params, headers=headers) as response:
                if response.status != 200:
                    error_text = await response.text()
                    raise Exception(f"Level search error: {response.status} - {error_text}")
                
                results = await response.json()
                return results or []
                
        except Exception as e:
            print(f"❌ Ошибка поиска по уровню: {e}")
            return []
    
    async def old_rag_fallback(
        self, 
        query: str, 
        level_context: Optional[str] = None
    ) -> str:
        """Fallback на старую RAG систему"""
        
        try:
            # Вызываем старую функцию match_documents
            query_embedding = await self.get_embedding(query)
            
            url = f"{self.config.supabase_url}/rest/v1/rpc/match_documents"
            headers = {
                "apikey": self.config.supabase_key,
                "Authorization": f"Bearer {self.config.supabase_key}",
                "Content-Type": "application/json"
            }
            
            # Парсим level_context для фильтрации
            metadata_filter = {}
            if level_context:
                if isinstance(level_context, str):
                    import re
                    m = re.match(r'level[_ ]?id\s*[:=]\s*(\d+)', level_context, re.IGNORECASE)
                    if m:
                        metadata_filter['level_id'] = int(m.group(1))
                elif isinstance(level_context, dict):
                    level_id = level_context.get('level_id') or level_context.get('levelId')
                    if level_id:
                        metadata_filter['level_id'] = int(level_id)
            
            params = {
                "query_embedding": query_embedding,
                "match_threshold": self.config.match_threshold,
                "match_count": self.config.match_count,
                "metadata_filter": metadata_filter if metadata_filter else None
            }
            
            async with self.session.post(url, json=params, headers=headers) as response:
                if response.status != 200:
                    error_text = await response.text()
                    raise Exception(f"Old RAG error: {response.status} - {error_text}")
                
                results = await response.json()
                
                # Обрабатываем результаты как в старой системе
                if results:
                    compressed_bullets = []
                    for r in results:
                        content = r.get('content', '')
                        if content:
                            # Простое сжатие (можно улучшить)
                            summary = content[:200] + "..." if len(content) > 200 else content
                            compressed_bullets.append(f"- {summary}")
                    
                    joined = '\n'.join(compressed_bullets)
                    
                    # Ограничение по токенам (простая реализация)
                    if len(joined) > self.config.max_tokens * 4:  # Примерная оценка
                        joined = joined[:self.config.max_tokens * 4] + "..."
                    
                    return joined
                
                return ""
                
        except Exception as e:
            print(f"❌ Ошибка fallback RAG: {e}")
            return ""
    
    def summarize_chunk(self, content: str) -> str:
        """Сжимает чанк контента (как в старой системе)"""
        if not content:
            return ""
        
        # Простая реализация сжатия
        if len(content) <= 200:
            return content
        
        # Ищем первое предложение или обрезаем
        sentences = content.split('. ')
        if len(sentences) > 1:
            return sentences[0] + '.'
        
        return content[:200] + "..."
    
    async def retrieve_context(
        self, 
        query: str, 
        level_context: Optional[str] = None,
        user_id: Optional[str] = None
    ) -> str:
        """Основная функция получения контекста с fallback"""
        
        if not self.config.use_new_rag:
            # Используем только старую систему
            return await self.old_rag_fallback(query, level_context)
        
        try:
            # Парсим level_context для фильтрации
            level_filter = None
            if level_context:
                if isinstance(level_context, str):
                    import re
                    m = re.match(r'level[_ ]?id\s*[:=]\s*(\d+)', level_context, re.IGNORECASE)
                    if m:
                        level_filter = int(m.group(1))
                elif isinstance(level_context, dict):
                    level_id = level_context.get('level_id') or level_context.get('levelId')
                    if level_id:
                        level_filter = int(level_id)
            
            # Пытаемся использовать новую RAG систему
            results = await self.search_lesson_facts(
                query=query,
                level_filter=level_filter,
                limit=self.config.match_count
            )
            
            if results:
                # Обрабатываем результаты новой системы
                compressed_bullets = []
                for r in results:
                    content = r.get('content', '')
                    if content:
                        summary = self.summarize_chunk(content)
                        compressed_bullets.append(f"- {summary}")
                
                joined = '\n'.join(compressed_bullets)
                
                # Ограничение по токенам
                if len(joined) > self.config.max_tokens * 4:
                    joined = joined[:self.config.max_tokens * 4] + "..."
                
                return joined
            
            # Если новая система не дала результатов, используем fallback
            if self.config.fallback_to_old:
                print("🔄 Fallback на старую RAG систему")
                return await self.old_rag_fallback(query, level_context)
            
            return ""
            
        except Exception as e:
            print(f"❌ Ошибка в новой RAG системе: {e}")
            
            # Fallback на старую систему
            if self.config.fallback_to_old:
                print("🔄 Fallback на старую RAG систему")
                return await self.old_rag_fallback(query, level_context)
            
            return ""

# Функция для интеграции с leo-chat
async def perform_new_rag_query(
    last_user_message: str,
    level_context: Optional[str] = None,
    user_id: Optional[str] = None,
    config: Optional[RAGConfig] = None
) -> str:
    """Функция для замены performRAGQuery в leo-chat"""
    
    if not config:
        # Загружаем конфигурацию из переменных окружения
        config = RAGConfig(
            use_new_rag=os.getenv('USE_NEW_RAG', 'true').lower() == 'true',
            fallback_to_old=os.getenv('RAG_FALLBACK_TO_OLD', 'true').lower() == 'true',
            supabase_url=os.getenv('SUPABASE_URL', ''),
            supabase_key=os.getenv('SUPABASE_ANON_KEY', ''),
            openai_api_key=os.getenv('OPENAI_API_KEY', ''),
            embedding_model=os.getenv('OPENAI_EMBEDDING_MODEL', 'text-embedding-3-small'),
            match_threshold=float(os.getenv('RAG_MATCH_THRESHOLD', '0.35')),
            match_count=int(os.getenv('RAG_MATCH_COUNT', '6')),
            max_tokens=int(os.getenv('RAG_MAX_TOKENS', '1200'))
        )
    
    async with NewRAGRetriever(config) as retriever:
        return await retriever.retrieve_context(
            query=last_user_message,
            level_context=level_context,
            user_id=user_id
        )

# Пример использования
if __name__ == "__main__":
    async def test_retriever():
        config = RAGConfig(
            use_new_rag=True,
            fallback_to_old=True,
            supabase_url="https://your-project.supabase.co",
            supabase_key="your-anon-key",
            openai_api_key="sk-your-openai-key"
        )
        
        result = await perform_new_rag_query(
            last_user_message="Как поставить цели?",
            level_context="level_id=11",
            config=config
        )
        
        print("Результат RAG:", result)
    
    # asyncio.run(test_retriever())
