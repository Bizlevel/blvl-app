#!/usr/bin/env python3
"""
Конфигурация leo-chat для новой RAG системы
"""

import os
from typing import Optional

class LeoChatConfig:
    """Конфигурация leo-chat с поддержкой новой RAG системы"""
    
    # Основные настройки RAG
    USE_NEW_RAG: bool = os.getenv('USE_NEW_RAG', 'true').lower() == 'true'
    RAG_FALLBACK_TO_OLD: bool = os.getenv('RAG_FALLBACK_TO_OLD', 'true').lower() == 'true'
    
    # Supabase настройки
    SUPABASE_URL: str = os.getenv('SUPABASE_URL', '')
    SUPABASE_ANON_KEY: str = os.getenv('SUPABASE_ANON_KEY', '')
    SUPABASE_SERVICE_ROLE_KEY: str = os.getenv('SUPABASE_SERVICE_ROLE_KEY', '')
    
    # OpenAI настройки
    OPENAI_API_KEY: str = os.getenv('OPENAI_API_KEY', '')
    OPENAI_EMBEDDING_MODEL: str = os.getenv('OPENAI_EMBEDDING_MODEL', 'text-embedding-3-small')
    
    # RAG параметры
    RAG_MATCH_THRESHOLD: float = float(os.getenv('RAG_MATCH_THRESHOLD', '0.35'))
    RAG_MATCH_COUNT: int = int(os.getenv('RAG_MATCH_COUNT', '6'))
    RAG_MAX_TOKENS: int = int(os.getenv('RAG_MAX_TOKENS', '1200'))
    RAG_CACHE_TTL_SEC: int = int(os.getenv('RAG_CACHE_TTL_SEC', '180'))
    
    # Настройки новой RAG системы
    NEW_RAG_LEVEL_FILTER: bool = os.getenv('NEW_RAG_LEVEL_FILTER', 'true').lower() == 'true'
    NEW_RAG_SECTION_FILTER: bool = os.getenv('NEW_RAG_SECTION_FILTER', 'true').lower() == 'true'
    NEW_RAG_HYBRID_SEARCH: bool = os.getenv('NEW_RAG_HYBRID_SEARCH', 'true').lower() == 'true'
    
    # Настройки отладки
    RAG_DEBUG: bool = os.getenv('RAG_DEBUG', 'false').lower() == 'true'
    RAG_LOG_QUERIES: bool = os.getenv('RAG_LOG_QUERIES', 'false').lower() == 'true'
    
    @classmethod
    def validate_config(cls) -> bool:
        """Проверяет корректность конфигурации"""
        required_vars = [
            'SUPABASE_URL',
            'SUPABASE_ANON_KEY', 
            'OPENAI_API_KEY'
        ]
        
        missing_vars = []
        for var in required_vars:
            if not getattr(cls, var):
                missing_vars.append(var)
        
        if missing_vars:
            print(f"❌ Отсутствуют обязательные переменные окружения: {', '.join(missing_vars)}")
            return False
        
        return True
    
    @classmethod
    def get_rag_config(cls) -> dict:
        """Возвращает конфигурацию для RAG системы"""
        return {
            'use_new_rag': cls.USE_NEW_RAG,
            'fallback_to_old': cls.RAG_FALLBACK_TO_OLD,
            'supabase_url': cls.SUPABASE_URL,
            'supabase_key': cls.SUPABASE_ANON_KEY,
            'openai_api_key': cls.OPENAI_API_KEY,
            'embedding_model': cls.OPENAI_EMBEDDING_MODEL,
            'match_threshold': cls.RAG_MATCH_THRESHOLD,
            'match_count': cls.RAG_MATCH_COUNT,
            'max_tokens': cls.RAG_MAX_TOKENS,
            'level_filter': cls.NEW_RAG_LEVEL_FILTER,
            'section_filter': cls.NEW_RAG_SECTION_FILTER,
            'hybrid_search': cls.NEW_RAG_HYBRID_SEARCH,
            'debug': cls.RAG_DEBUG,
            'log_queries': cls.RAG_LOG_QUERIES
        }
    
    @classmethod
    def print_config(cls):
        """Выводит текущую конфигурацию"""
        print("🔧 Конфигурация leo-chat RAG:")
        print(f"  Новая RAG система: {'✅' if cls.USE_NEW_RAG else '❌'}")
        print(f"  Fallback на старую: {'✅' if cls.RAG_FALLBACK_TO_OLD else '❌'}")
        print(f"  Гибридный поиск: {'✅' if cls.NEW_RAG_HYBRID_SEARCH else '❌'}")
        print(f"  Фильтр по уровням: {'✅' if cls.NEW_RAG_LEVEL_FILTER else '❌'}")
        print(f"  Фильтр по секциям: {'✅' if cls.NEW_RAG_SECTION_FILTER else '❌'}")
        print(f"  Порог совпадения: {cls.RAG_MATCH_THRESHOLD}")
        print(f"  Количество результатов: {cls.RAG_MATCH_COUNT}")
        print(f"  Максимум токенов: {cls.RAG_MAX_TOKENS}")
        print(f"  Модель эмбеддингов: {cls.OPENAI_EMBEDDING_MODEL}")
        print(f"  Отладка: {'✅' if cls.RAG_DEBUG else '❌'}")

# Глобальный экземпляр конфигурации
config = LeoChatConfig()

# Функции для удобного доступа
def is_new_rag_enabled() -> bool:
    """Проверяет, включена ли новая RAG система"""
    return config.USE_NEW_RAG

def is_fallback_enabled() -> bool:
    """Проверяет, включен ли fallback на старую систему"""
    return config.RAG_FALLBACK_TO_OLD

def get_supabase_config() -> dict:
    """Возвращает конфигурацию Supabase"""
    return {
        'url': config.SUPABASE_URL,
        'anon_key': config.SUPABASE_ANON_KEY,
        'service_role_key': config.SUPABASE_SERVICE_ROLE_KEY
    }

def get_openai_config() -> dict:
    """Возвращает конфигурацию OpenAI"""
    return {
        'api_key': config.OPENAI_API_KEY,
        'embedding_model': config.OPENAI_EMBEDDING_MODEL
    }

def get_rag_params() -> dict:
    """Возвращает параметры RAG"""
    return {
        'match_threshold': config.RAG_MATCH_THRESHOLD,
        'match_count': config.RAG_MATCH_COUNT,
        'max_tokens': config.RAG_MAX_TOKENS,
        'cache_ttl_sec': config.RAG_CACHE_TTL_SEC
    }

# Пример использования
if __name__ == "__main__":
    # Проверяем конфигурацию
    if config.validate_config():
        print("✅ Конфигурация корректна")
        config.print_config()
    else:
        print("❌ Конфигурация некорректна")
        print("\nУстановите переменные окружения:")
        print("export SUPABASE_URL='https://your-project.supabase.co'")
        print("export SUPABASE_ANON_KEY='your-anon-key'")
        print("export OPENAI_API_KEY='sk-your-openai-key'")
