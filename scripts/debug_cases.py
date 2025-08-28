#!/usr/bin/env python3
"""
Скрипт для детального анализа загруженных кейсов в базе данных
"""

import os
import json
from pathlib import Path
from supabase import create_client, Client

# Загрузка переменных окружения
from dotenv import load_dotenv
script_dir = Path(__file__).parent
env_file = script_dir.parent / '.env'
load_dotenv(env_file)

def main():
    """Анализ загруженных кейсов"""
    supabase: Client = create_client(
        os.getenv("SUPABASE_URL"),
        os.getenv("SUPABASE_SERVICE_ROLE_KEY")
    )
    
    # Получаем все документы кейсов
    result = supabase.table('documents').select('*').eq('metadata->>source', 'bizlevel_case').execute()
    
    if not result.data:
        print("❌ Документы кейсов не найдены")
        return
    
    print(f"📊 Найдено {len(result.data)} документов кейсов")
    print("=" * 80)
    
    for i, doc in enumerate(result.data, 1):
        print(f"\n📄 Документ {i}:")
        print(f"ID: {doc.get('id')}")
        
        metadata = doc.get('metadata', {})
        print(f"Кейс ID: {metadata.get('case_id')}")
        print(f"Название: {metadata.get('case_title')}")
        print(f"Тип чанка: {metadata.get('chunk_type')}")
        print(f"Уровень: {metadata.get('level_id')}")
        print(f"Навык: {metadata.get('skill_name')}")
        print(f"Теги: {metadata.get('tags')}")
        print(f"Сферы бизнеса: {metadata.get('business_areas')}")
        print(f"Сложность: {metadata.get('difficulty')}")
        
        content = doc.get('content', '')
        print(f"Длина контента: {len(content)} символов")
        print(f"Контент (первые 200 символов):")
        print(f"'{content[:200]}...'")
        print("-" * 40)

if __name__ == '__main__':
    main()
