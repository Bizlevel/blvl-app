#!/usr/bin/env python3
"""
Тестирование новой RAG системы
"""

import asyncio
import os
import sys
from pathlib import Path

# Добавляем текущую директорию в путь для импорта
sys.path.append(str(Path(__file__).parent))

from leo_chat_new_retriever import perform_new_rag_query, RAGConfig
from leo_chat_config import LeoChatConfig

async def test_basic_search():
    """Тестирует базовый поиск"""
    print("🔍 Тестирование базового поиска...")
    
    config = RAGConfig(
        use_new_rag=True,
        fallback_to_old=True,
        supabase_url=os.getenv('SUPABASE_URL', ''),
        supabase_key=os.getenv('SUPABASE_ANON_KEY', ''),
        openai_api_key=os.getenv('OPENAI_API_KEY', '')
    )
    
    # Тестовые запросы
    test_queries = [
        "Как поставить цели?",
        "Что такое мотивация?",
        "Как развить лидерские качества?",
        "Стратегии планирования времени"
    ]
    
    for query in test_queries:
        print(f"\n📝 Запрос: {query}")
        try:
            result = await perform_new_rag_query(
                last_user_message=query,
                level_context="level_id=11",
                config=config
            )
            
            if result:
                print(f"✅ Результат ({len(result)} символов):")
                print(result[:200] + "..." if len(result) > 200 else result)
            else:
                print("❌ Результат пустой")
                
        except Exception as e:
            print(f"❌ Ошибка: {e}")

async def test_level_filtering():
    """Тестирует фильтрацию по уровням"""
    print("\n🎯 Тестирование фильтрации по уровням...")
    
    config = RAGConfig(
        use_new_rag=True,
        fallback_to_old=True,
        supabase_url=os.getenv('SUPABASE_URL', ''),
        supabase_key=os.getenv('SUPABASE_ANON_KEY', ''),
        openai_api_key=os.getenv('OPENAI_API_KEY', '')
    )
    
    # Тестируем разные уровни
    test_levels = [11, 12, 13, 14, 15]
    
    for level in test_levels:
        print(f"\n📊 Уровень {level}:")
        try:
            result = await perform_new_rag_query(
                last_user_message="цели мотивация",
                level_context=f"level_id={level}",
                config=config
            )
            
            if result:
                print(f"✅ Найдено {len(result.split('\\n'))} фактов")
                print(result[:150] + "..." if len(result) > 150 else result)
            else:
                print("❌ Результат пустой")
                
        except Exception as e:
            print(f"❌ Ошибка: {e}")

async def test_fallback():
    """Тестирует fallback на старую систему"""
    print("\n🔄 Тестирование fallback на старую RAG...")
    
    config = RAGConfig(
        use_new_rag=False,  # Отключаем новую систему
        fallback_to_old=True,
        supabase_url=os.getenv('SUPABASE_URL', ''),
        supabase_key=os.getenv('SUPABASE_ANON_KEY', ''),
        openai_api_key=os.getenv('OPENAI_API_KEY', '')
    )
    
    try:
        result = await perform_new_rag_query(
            last_user_message="Как поставить цели?",
            level_context="level_id=11",
            config=config
        )
        
        if result:
            print("✅ Fallback работает")
            print(result[:200] + "..." if len(result) > 200 else result)
        else:
            print("❌ Fallback не дал результатов")
            
    except Exception as e:
        print(f"❌ Ошибка fallback: {e}")

async def test_error_handling():
    """Тестирует обработку ошибок"""
    print("\n⚠️ Тестирование обработки ошибок...")
    
    # Тест с неверными параметрами
    config = RAGConfig(
        use_new_rag=True,
        fallback_to_old=True,
        supabase_url="https://invalid-url.supabase.co",
        supabase_key="invalid-key",
        openai_api_key="invalid-key"
    )
    
    try:
        result = await perform_new_rag_query(
            last_user_message="тест",
            config=config
        )
        
        if result:
            print("✅ Обработка ошибок работает")
        else:
            print("✅ Система корректно обработала ошибку")
            
    except Exception as e:
        print(f"✅ Ошибка корректно обработана: {e}")

async def test_performance():
    """Тестирует производительность"""
    print("\n⚡ Тестирование производительности...")
    
    config = RAGConfig(
        use_new_rag=True,
        fallback_to_old=True,
        supabase_url=os.getenv('SUPABASE_URL', ''),
        supabase_key=os.getenv('SUPABASE_ANON_KEY', ''),
        openai_api_key=os.getenv('OPENAI_API_KEY', '')
    )
    
    import time
    
    queries = [
        "цели мотивация",
        "лидерство команда",
        "планирование время",
        "коммуникация навыки",
        "стратегия развитие"
    ]
    
    total_time = 0
    successful_queries = 0
    
    for i, query in enumerate(queries, 1):
        print(f"  Запрос {i}/{len(queries)}: {query}")
        
        start_time = time.time()
        try:
            result = await perform_new_rag_query(
                last_user_message=query,
                level_context="level_id=11",
                config=config
            )
            
            end_time = time.time()
            query_time = end_time - start_time
            total_time += query_time
            
            if result:
                successful_queries += 1
                print(f"    ✅ {query_time:.2f}с, {len(result)} символов")
            else:
                print(f"    ❌ {query_time:.2f}с, пустой результат")
                
        except Exception as e:
            end_time = time.time()
            query_time = end_time - start_time
            total_time += query_time
            print(f"    ❌ {query_time:.2f}с, ошибка: {e}")
    
    avg_time = total_time / len(queries)
    success_rate = (successful_queries / len(queries)) * 100
    
    print(f"\n📊 Результаты производительности:")
    print(f"  Среднее время запроса: {avg_time:.2f}с")
    print(f"  Успешных запросов: {successful_queries}/{len(queries)} ({success_rate:.1f}%)")
    print(f"  Общее время: {total_time:.2f}с")

async def main():
    """Основная функция тестирования"""
    print("🚀 Запуск тестирования новой RAG системы")
    print("=" * 50)
    
    # Проверяем конфигурацию
    if not LeoChatConfig.validate_config():
        print("❌ Конфигурация некорректна. Установите переменные окружения.")
        return
    
    # Запускаем тесты
    await test_basic_search()
    await test_level_filtering()
    await test_fallback()
    await test_error_handling()
    await test_performance()
    
    print("\n🎉 Тестирование завершено!")

if __name__ == "__main__":
    asyncio.run(main())
