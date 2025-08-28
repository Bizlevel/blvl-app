#!/usr/bin/env python3
"""
Тестовый скрипт для проверки RAG-поиска кейсов BizLevel
Проверяет, что кейсы загружены в базу и поиск работает корректно
"""

import os
import logging
from pathlib import Path
import openai
from supabase import create_client, Client

# Загрузка переменных окружения
from dotenv import load_dotenv
script_dir = Path(__file__).parent
env_file = script_dir.parent / '.env'
load_dotenv(env_file)

# Настройка логирования
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class RAGTester:
    """Класс для тестирования RAG-поиска"""
    
    def __init__(self):
        self.openai_client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        self.supabase: Client = create_client(
            os.getenv("SUPABASE_URL"),
            os.getenv("SUPABASE_SERVICE_ROLE_KEY")
        )
        self.embedding_model = os.getenv("OPENAI_EMBEDDING_MODEL", "text-embedding-3-small")
    
    def check_cases_in_database(self):
        """Проверяет, что кейсы загружены в базу данных"""
        try:
            # Проверяем количество документов кейсов
            result = self.supabase.table('documents').select('id, metadata').eq('metadata->>source', 'bizlevel_case').execute()
            
            if result.data:
                logger.info(f"✅ Найдено {len(result.data)} документов кейсов в базе")
                
                # Показываем статистику по типам чанков
                chunk_types = {}
                case_ids = set()
                
                for doc in result.data:
                    metadata = doc.get('metadata', {})
                    chunk_type = metadata.get('chunk_type', 'unknown')
                    case_id = metadata.get('case_id', 'unknown')
                    
                    chunk_types[chunk_type] = chunk_types.get(chunk_type, 0) + 1
                    case_ids.add(case_id)
                
                logger.info(f"📊 Статистика:")
                logger.info(f"  - Уникальных кейсов: {len(case_ids)}")
                logger.info(f"  - Типы чанков: {chunk_types}")
                
                return True
            else:
                logger.error("❌ Документы кейсов не найдены в базе данных")
                return False
                
        except Exception as e:
            logger.error(f"Ошибка при проверке базы данных: {e}")
            return False
    
    def test_rag_search(self, query: str, expected_keywords: list = None):
        """Тестирует RAG-поиск с заданным запросом"""
        try:
            logger.info(f"🔍 Тестируем поиск: '{query}'")
            
            # Генерируем эмбеддинг для запроса
            response = self.openai_client.embeddings.create(
                input=query,
                model=self.embedding_model
            )
            
            embedding = response.data[0].embedding
            
            # Ищем похожие документы
            result = self.supabase.rpc('match_documents', {
                'query_embedding': embedding,
                'match_threshold': 0.3,
                'match_count': 5
            }).execute()
            
            if result.data:
                logger.info(f"✅ Найдено {len(result.data)} релевантных документов")
                
                for i, doc in enumerate(result.data, 1):
                    metadata = doc.get('metadata', {})
                    similarity = doc.get('similarity', 0)
                    
                    logger.info(f"  {i}. Схожесть: {similarity:.3f}")
                    logger.info(f"     Кейс: {metadata.get('case_title', 'N/A')}")
                    logger.info(f"     Тип: {metadata.get('chunk_type', 'N/A')}")
                    logger.info(f"     Уровень: {metadata.get('level_id', 'N/A')}")
                    logger.info(f"     Навык: {metadata.get('skill_name', 'N/A')}")
                    
                    # Проверяем наличие ожидаемых ключевых слов
                    if expected_keywords:
                        content = doc.get('content', '').lower()
                        found_keywords = [kw for kw in expected_keywords if kw.lower() in content]
                        if found_keywords:
                            logger.info(f"     ✅ Найдены ключевые слова: {found_keywords}")
                        else:
                            logger.info(f"     ⚠️ Ключевые слова не найдены")
                    
                    logger.info(f"     Контент: {doc.get('content', '')[:100]}...")
                    logger.info("")
                
                return True
            else:
                logger.warning("⚠️ Поиск не вернул результатов")
                return False
                
        except Exception as e:
            logger.error(f"Ошибка при тестировании поиска: {e}")
            return False
    
    def run_comprehensive_test(self):
        """Запускает комплексный тест RAG-системы"""
        logger.info("🚀 Запуск комплексного теста RAG-системы")
        
        # 1. Проверяем наличие кейсов в базе
        if not self.check_cases_in_database():
            return False
        
        # 2. Тестируем различные типы поиска
        test_queries = [
            {
                'query': 'автомойка',
                'keywords': ['автомойка', 'Даулет'],
                'description': 'Поиск по конкретному кейсу'
            },
            {
                'query': 'стресс менеджмент',
                'keywords': ['стресс', 'менеджмент'],
                'description': 'Поиск по навыку'
            },
            {
                'query': 'приоритизация задач',
                'keywords': ['приоритизация', 'задачи'],
                'description': 'Поиск по теме'
            },
            {
                'query': 'торговля и услуги',
                'keywords': ['торговля', 'услуги'],
                'description': 'Поиск по сфере бизнеса'
            }
        ]
        
        success_count = 0
        for test in test_queries:
            logger.info(f"\n📝 {test['description']}")
            if self.test_rag_search(test['query'], test['keywords']):
                success_count += 1
        
        logger.info(f"\n📊 Результаты тестирования:")
        logger.info(f"  - Успешных тестов: {success_count}/{len(test_queries)}")
        
        if success_count == len(test_queries):
            logger.info("🎉 Все тесты прошли успешно!")
            return True
        else:
            logger.warning("⚠️ Некоторые тесты не прошли")
            return False

def main():
    """Главная функция тестирования"""
    # Проверяем переменные окружения
    required_vars = ['OPENAI_API_KEY', 'SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY']
    missing_vars = [var for var in required_vars if not os.getenv(var)]
    
    if missing_vars:
        logger.error(f"Отсутствуют переменные окружения: {', '.join(missing_vars)}")
        return False
    
    # Запуск тестирования
    tester = RAGTester()
    success = tester.run_comprehensive_test()
    
    return success

if __name__ == '__main__':
    success = main()
    exit(0 if success else 1)
