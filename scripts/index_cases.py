#!/usr/bin/env python3
"""
Скрипт для индексации кейсов BizLevel в RAG-систему
Парсит кейсы из Markdown файлов и загружает в базу Supabase с эмбеддингами
"""

import os
import re
import json
import time
import logging
from typing import List, Dict, Any, Optional
from pathlib import Path
from dataclasses import dataclass
import hashlib
import uuid

# Supabase и OpenAI
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

@dataclass
class CaseChunk:
    """Структура чанка кейса для индексации"""
    case_id: int
    chunk_type: str  # metadata, situation, question, solution, insight
    title: str
    content: str
    after_level: int
    skill_name: str
    tags: List[str]
    business_areas: List[str]
    difficulty: str

class CaseIndexer:
    """Класс для индексации кейсов в RAG-систему"""
    
    def __init__(self):
        self.openai_client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        self.supabase: Client = create_client(
            os.getenv("SUPABASE_URL"),
            os.getenv("SUPABASE_SERVICE_ROLE_KEY")
        )
        self.embedding_model = os.getenv("OPENAI_EMBEDDING_MODEL", "text-embedding-3-small")
        
    def parse_cases_from_markdown(self, file_path: str) -> List[Dict[str, Any]]:
        """Парсит кейсы из Markdown файла"""
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        cases = []
        # Разделяем по кейсам (заголовки ## Кейс №X:)
        case_sections = re.split(r'\n## Кейс №(\d+):', content)
        
        for i in range(1, len(case_sections), 2):
            case_id = int(case_sections[i])
            case_content = case_sections[i + 1]
            
            case_data = self._parse_single_case(case_id, case_content)
            if case_data:
                cases.append(case_data)
                logger.info(f"Парсинг кейса №{case_id}: {case_data['title']}")
        
        return cases
    
    def _parse_single_case(self, case_id: int, content: str) -> Optional[Dict[str, Any]]:
        """Парсит отдельный кейс"""
        lines = content.strip().split('\n')
        
        # Извлекаем название кейса
        title_match = re.search(r'^"([^"]+)"', lines[0])
        title = title_match.group(1) if title_match else f"Кейс №{case_id}"
        
        # Извлекаем метаданные
        metadata = self._extract_metadata(content)
        if not metadata:
            logger.warning(f"Не удалось извлечь метаданные для кейса №{case_id}")
            return None
            
        # Разделяем на секции
        sections = self._split_into_sections(content)
        
        return {
            'case_id': case_id,
            'title': title,
            'metadata': metadata,
            'sections': sections
        }
    
    def _extract_metadata(self, content: str) -> Optional[Dict[str, Any]]:
        """Извлекает метаданные кейса"""
        metadata = {}
        
        # После уровня
        level_match = re.search(r'После уровня:\*\* (\d+)', content)
        if level_match:
            metadata['after_level'] = int(level_match.group(1))
        else:
            return None
            
        # Навыки
        skill_match = re.search(r'Навыки:\*\* (.+?)(?:\n|$)', content)
        if skill_match:
            skill_text = skill_match.group(1).strip()
            # Убираем эмодзи и извлекаем название навыка
            skill_clean = re.sub(r'[🧠💰⚡]+\s*', '', skill_text).strip()
            metadata['skill_name'] = skill_clean
        
        # Затрагиваемые уроки (теги)
        lessons_section = re.search(r'Затрагиваемые уроки:(.*?)(?=\n###|\n##|$)', content, re.DOTALL)
        tags = []
        if lessons_section:
            lessons_text = lessons_section.group(1)
            # Извлекаем названия уроков
            lesson_matches = re.findall(r'Уровень \d+: ([^(]+)', lessons_text)
            tags = [lesson.strip() for lesson in lesson_matches]
        
        metadata['tags'] = tags
        
        # Определяем сферы бизнеса по контенту
        business_areas = self._detect_business_areas(content)
        metadata['business_areas'] = business_areas
        
        # Определяем сложность по уровню
        level = metadata.get('after_level', 1)
        if level <= 3:
            difficulty = 'beginner'
        elif level <= 7:
            difficulty = 'intermediate'
        else:
            difficulty = 'advanced'
        metadata['difficulty'] = difficulty
        
        return metadata
    
    def _detect_business_areas(self, content: str) -> List[str]:
        """Определяет сферы бизнеса по ключевым словам в контенте"""
        business_patterns = {
            'Торговля': ['магазин', 'мини-маркет', 'торговля', 'покупатель', 'товар', 'продажа'],
            'Услуги': ['автомойка', 'сервис', 'клиент', 'услуга', 'обслуживание'],
            'IT': ['программист', 'разработка', 'сайт', 'приложение', 'код'],
            'Производство': ['производство', 'завод', 'изготовление', 'продукция'],
            'Общепит': ['кафе', 'ресторан', 'кулинария', 'еда', 'повар'],
            'Образование': ['обучение', 'курс', 'студент', 'преподаватель']
        }
        
        detected_areas = []
        content_lower = content.lower()
        
        for area, keywords in business_patterns.items():
            if any(keyword in content_lower for keyword in keywords):
                detected_areas.append(area)
        
        return detected_areas if detected_areas else ['Общий']
    
    def _split_into_sections(self, content: str) -> Dict[str, str]:
        """Разделяет кейс на семантические секции"""
        sections = {}
        
        # Метаданные
        metadata_match = re.search(r'### Метаданные(.*?)(?=\n###|\n##|$)', content, re.DOTALL)
        if metadata_match:
            sections['metadata'] = metadata_match.group(1).strip()
        
        # Сценарий кейса
        scenario_match = re.search(r'### Сценарий кейса\s*\n(.*?)(?=\n##|$)', content, re.DOTALL)
        if scenario_match:
            scenario_content = scenario_match.group(1).strip()
            logger.info(f"Найден сценарий длиной {len(scenario_content)} символов")
            
            # Создаем основные секции
            sections['scenario'] = scenario_content
            
            # Дополнительно выделяем ключевые части
            if "Погружение" in scenario_content:
                immersion_match = re.search(r'#### Этап 1: Погружение(.*?)(?=\n####|\n##|$)', scenario_content, re.DOTALL)
                if immersion_match:
                    sections['situation'] = immersion_match.group(1).strip()
            
            # Ищем задания и вопросы
            assignments = re.findall(r'Задание \d+:(.*?)(?=Задание \d+:|Ответ Лео|\n##|$)', scenario_content, re.DOTALL)
            if assignments:
                sections['questions'] = '\n\n'.join([f"Задание {i+1}:{assignment.strip()}" for i, assignment in enumerate(assignments)])
            
            # Ищем ответы Лео
            leo_responses = re.findall(r'Ответ Лео и продолжение:(.*?)(?=Задание \d+:|Ответ Лео|\n##|$)', scenario_content, re.DOTALL)
            if leo_responses:
                sections['solutions'] = '\n\n'.join([f"Ответ Лео:{response.strip()}" for response in leo_responses])
        else:
            logger.warning(f"Сценарий кейса не найден для кейса {case_id}")
            
            # Дополнительно выделяем ключевые части
            if "Погружение" in full_scenario:
                immersion_match = re.search(r'#### Этап 1: Погружение(.*?)(?=\n####|\n##|$)', full_scenario, re.DOTALL)
                if immersion_match:
                    sections['situation'] = immersion_match.group(1).strip()
            
            # Ищем задания и вопросы
            assignments = re.findall(r'Задание \d+:(.*?)(?=Задание \d+:|Ответ Лео|\n##|$)', full_scenario, re.DOTALL)
            if assignments:
                sections['questions'] = '\n\n'.join([f"Задание {i+1}:{assignment.strip()}" for i, assignment in enumerate(assignments)])
            
            # Ищем ответы Лео
            leo_responses = re.findall(r'Ответ Лео и продолжение:(.*?)(?=Задание \d+:|Ответ Лео|\n##|$)', full_scenario, re.DOTALL)
            if leo_responses:
                sections['solutions'] = '\n\n'.join([f"Ответ Лео:{response.strip()}" for response in leo_responses])
        
        return sections
    
    def create_chunks(self, case_data: Dict[str, Any]) -> List[CaseChunk]:
        """Создает чанки из данных кейса"""
        chunks = []
        
        case_id = case_data['case_id']
        title = case_data['title']
        metadata = case_data['metadata']
        sections = case_data['sections']
        
        # Создаем чанки для каждой секции
        for section_type, content in sections.items():
            if content and len(content.strip()) > 100:  # Увеличиваем минимальную длину
                # Разбиваем длинный контент на более мелкие чанки
                if len(content) > 2000:
                    # Разбиваем по абзацам или предложениям
                    paragraphs = re.split(r'\n\n+', content)
                    for i, paragraph in enumerate(paragraphs):
                        if len(paragraph.strip()) > 100:
                            chunk = CaseChunk(
                                case_id=case_id,
                                chunk_type=f"{section_type}_part_{i+1}",
                                title=title,
                                content=paragraph.strip(),
                                after_level=metadata['after_level'],
                                skill_name=metadata['skill_name'],
                                tags=metadata['tags'],
                                business_areas=metadata['business_areas'],
                                difficulty=metadata['difficulty']
                            )
                            chunks.append(chunk)
                else:
                    chunk = CaseChunk(
                        case_id=case_id,
                        chunk_type=section_type,
                        title=title,
                        content=content.strip(),
                        after_level=metadata['after_level'],
                        skill_name=metadata['skill_name'],
                        tags=metadata['tags'],
                        business_areas=metadata['business_areas'],
                        difficulty=metadata['difficulty']
                    )
                    chunks.append(chunk)
        
        return chunks
    
    def generate_embeddings(self, chunks: List[CaseChunk]) -> List[Dict[str, Any]]:
        """Генерирует эмбеддинги для чанков"""
        documents = []
        
        logger.info(f"Генерация эмбеддингов для {len(chunks)} чанков...")
        
        for i, chunk in enumerate(chunks):
            try:
                # Формируем текст для эмбеддинга
                embedding_text = f"{chunk.title}\n\n{chunk.content}"
                
                # Генерируем эмбеддинг
                response = self.openai_client.embeddings.create(
                    input=embedding_text,
                    model=self.embedding_model
                )
                
                embedding = response.data[0].embedding
                
                # Создаем уникальный идентификатор
                doc_id = str(uuid.uuid4())
                
                # Формируем документ для загрузки
                document = {
                    'id': doc_id,
                    'content': chunk.content,
                    'embedding': embedding,
                    'metadata': {
                        'source': 'bizlevel_case',
                        'case_id': chunk.case_id,
                        'case_title': chunk.title,
                        'chunk_type': chunk.chunk_type,
                        'level_id': chunk.after_level,
                        'skill_name': chunk.skill_name,
                        'tags': chunk.tags,
                        'business_areas': chunk.business_areas,
                        'difficulty': chunk.difficulty
                    }
                }
                
                documents.append(document)
                
                if (i + 1) % 10 == 0:
                    logger.info(f"Обработано {i + 1}/{len(chunks)} чанков")
                
                # Пауза для избежания rate limit
                time.sleep(0.1)
                
            except Exception as e:
                logger.error(f"Ошибка при генерации эмбеддинга для чанка {i}: {e}")
                continue
        
        logger.info(f"Успешно создано {len(documents)} документов с эмбеддингами")
        return documents
    
    def save_to_database(self, documents: List[Dict[str, Any]]) -> bool:
        """Сохраняет документы в базу данных Supabase"""
        try:
            logger.info(f"Сохранение {len(documents)} документов в базу данных...")
            
            # Удаляем существующие кейсы из базы
            delete_result = self.supabase.table('documents').delete().eq('metadata->>source', 'bizlevel_case').execute()
            logger.info(f"Удалено существующих документов кейсов: {len(delete_result.data) if delete_result.data else 0}")
            
            # Вставляем новые документы батчами
            batch_size = 50
            for i in range(0, len(documents), batch_size):
                batch = documents[i:i + batch_size]
                
                result = self.supabase.table('documents').insert(batch).execute()
                
                if result.data:
                    logger.info(f"Загружен батч {i//batch_size + 1}: {len(result.data)} документов")
                else:
                    logger.error(f"Ошибка при загрузке батча {i//batch_size + 1}")
                    return False
                
                # Пауза между батчами
                time.sleep(0.5)
            
            logger.info("✅ Все документы успешно загружены в базу данных")
            return True
            
        except Exception as e:
            logger.error(f"Ошибка при сохранении в базу данных: {e}")
            return False
    
    def index_cases(self, markdown_file: str) -> bool:
        """Главный метод для индексации кейсов"""
        try:
            logger.info("🚀 Начинаем индексацию кейсов BizLevel")
            
            # 1. Парсинг кейсов
            logger.info(f"📖 Парсинг кейсов из файла: {markdown_file}")
            cases = self.parse_cases_from_markdown(markdown_file)
            logger.info(f"Найдено кейсов: {len(cases)}")
            
            if not cases:
                logger.error("Не найдено ни одного кейса для индексации")
                return False
            
            # 2. Создание чанков
            logger.info("✂️ Создание чанков...")
            all_chunks = []
            for case in cases:
                logger.info(f"Обработка кейса {case['case_id']}: {case['title']}")
                logger.info(f"Секции: {list(case['sections'].keys())}")
                for section_type, content in case['sections'].items():
                    logger.info(f"  {section_type}: {len(content)} символов")
                
                chunks = self.create_chunks(case)
                logger.info(f"  Создано чанков: {len(chunks)}")
                all_chunks.extend(chunks)
            
            logger.info(f"Создано чанков: {len(all_chunks)}")
            
            if not all_chunks:
                logger.error("Не создано ни одного чанка")
                return False
            
            # 3. Генерация эмбеддингов
            documents = self.generate_embeddings(all_chunks)
            
            if not documents:
                logger.error("Не создано ни одного документа с эмбеддингом")
                return False
            
            # 4. Сохранение в базу
            success = self.save_to_database(documents)
            
            if success:
                logger.info("🎉 Индексация кейсов завершена успешно!")
                logger.info(f"📊 Статистика:")
                logger.info(f"  - Кейсов: {len(cases)}")
                logger.info(f"  - Чанков: {len(all_chunks)}")
                logger.info(f"  - Документов в базе: {len(documents)}")
                return True
            else:
                logger.error("❌ Ошибка при сохранении в базу данных")
                return False
                
        except Exception as e:
            logger.error(f"Критическая ошибка при индексации: {e}")
            return False

def main():
    """Главная функция скрипта"""
    # Проверяем переменные окружения
    required_vars = ['OPENAI_API_KEY', 'SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY']
    missing_vars = [var for var in required_vars if not os.getenv(var)]
    
    if missing_vars:
        logger.error(f"Отсутствуют переменные окружения: {', '.join(missing_vars)}")
        return False
    
    # Путь к файлу с кейсами
    script_dir = Path(__file__).parent
    cases_file = script_dir.parent / 'docs' / 'bizlevel-cases-scenarios.md'
    
    if not cases_file.exists():
        logger.error(f"Файл с кейсами не найден: {cases_file}")
        return False
    
    # Запуск индексации
    indexer = CaseIndexer()
    success = indexer.index_cases(str(cases_file))
    
    return success

if __name__ == '__main__':
    success = main()
    exit(0 if success else 1)
