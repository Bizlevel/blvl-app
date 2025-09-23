#!/usr/bin/env python3
"""
Скрипт для обработки экспортированных уроков и создания JSON файлов
"""

import json
import os
from pathlib import Path
from datetime import datetime
import hashlib

def process_lessons():
    """Обрабатывает экспортированные уроки и создает JSON файлы"""
    
    # Загружаем экспортированные данные
    with open('lessons_export.json', 'r', encoding='utf-8') as f:
        lessons = json.load(f)
    
    # Создаем директории для каждого уровня
    for lesson in lessons:
        level_id = lesson['level_id']
        lesson_id = lesson['lesson_id']
        
        # Создаем директорию для урока
        lesson_dir = Path(f'../levels/{level_id}/lesson_{lesson_id}')
        lesson_dir.mkdir(parents=True, exist_ok=True)
        
        # Создаем lesson.json
        lesson_data = {
            "lesson_id": lesson_id,
            "level_id": level_id,
            "title": lesson['title'],
            "description": lesson['description'],
            "content": lesson['quiz_questions'],
            "video_url": f"https://vimeo.com/{lesson['vimeo_id']}" if lesson['vimeo_id'] else None,
            "duration_minutes": lesson['duration_minutes'],
            "language": lesson['language'],
            "version": lesson['version'],
            "created_at": lesson['created_at'],
            "updated_at": lesson['updated_at'],
            "checksum_sha256": lesson['checksum_sha256']
        }
        
        with open(lesson_dir / 'lesson.json', 'w', encoding='utf-8') as f:
            json.dump(lesson_data, f, ensure_ascii=False, indent=2)
        
        # Создаем facts.jsonl (пока пустой, будет заполнен позже)
        with open(lesson_dir / 'facts.jsonl', 'w', encoding='utf-8') as f:
            pass
        
        # Создаем README.md
        readme_content = f"""# Урок {lesson_id}: {lesson['title']}

**Уровень:** {level_id}  
**Длительность:** {lesson['duration_minutes']} минут  
**Язык:** {lesson['language']}  
**Версия:** {lesson['version']}  

## Описание
{lesson['description']}

## Контент урока
Урок содержит интерактивные вопросы и объяснения в формате quiz_questions.

## Видео
{f"https://vimeo.com/{lesson['vimeo_id']}" if lesson['vimeo_id'] else "Видео не доступно"}

## Метаданные
- **Создан:** {lesson['created_at']}
- **Обновлен:** {lesson['updated_at']}
- **Checksum:** {lesson['checksum_sha256']}
"""
        
        with open(lesson_dir / 'README.md', 'w', encoding='utf-8') as f:
            f.write(readme_content)
        
        print(f"Обработан урок {lesson_id} (уровень {level_id}): {lesson['title']}")

if __name__ == "__main__":
    process_lessons()
    print("Обработка завершена!")
