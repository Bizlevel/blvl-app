#!/usr/bin/env python3
"""
Скрипт для загрузки документов из Google Drive в базу знаний Supabase
Оптимизирован для работы с большими файлами без зависания системы
"""

import os
import json
import time
import requests
from pathlib import Path
from typing import Optional, List, Dict, Any
import logging
from dataclasses import dataclass
import tempfile
import shutil

# Google Drive API
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
import io

# PDF processing
import PyPDF2
import fitz  # PyMuPDF

# DOCX processing
from docx import Document

# OpenAI
import openai

# Supabase
from supabase import create_client, Client

# Optional tokenizer (tiktoken). Falls back to naive tokenizer if not available
try:
    import tiktoken  # type: ignore
    _ENC = tiktoken.get_encoding("cl100k_base")
except Exception:
    _ENC = None

# Настройка логирования
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

with open('../credentials.json', 'r') as f:
    creds = json.load(f)
    print(f"Подключен к аккаунту: {creds.get('client_email', 'Не указан')}")
    print(f"Проект: {creds.get('project_id', 'Не указан')}")

@dataclass
class Config:
    """Конфигурация приложения"""
    supabase_url: str
    supabase_service_key: str
    openai_api_key: str
    google_drive_folder_id: str
    google_credentials_file: str
    
    # Ограничения для предотвращения зависания
    max_file_size_mb: int = 100  # 100MB
    delay_between_files: float = 3.0  # 3 секунды
    delay_between_chunks: float = 1.0  # 1 секунда
    # Целевой размер чанка в токенах и перекрытие
    token_chunk_size: int = 400
    token_chunk_overlap: int = 50
    # Путь к JSON-карте метаданных: { file_id | file_name: { level_id, skill_id, title, section, tags[] } }
    documents_map_json: Optional[str] = None

class DriveUploader:
    """Класс для загрузки документов из Google Drive в Supabase"""
    
    def __init__(self, config: Config):
        self.config = config
        self.supabase: Client = create_client(config.supabase_url, config.supabase_service_key)
        self.openai = openai.OpenAI(api_key=config.openai_api_key)
        self.drive_service = self._setup_google_drive()
        
    def _setup_google_drive(self):
        """Настройка Google Drive API"""
        try:
            credentials = service_account.Credentials.from_service_account_file(
                self.config.google_credentials_file,
                scopes=['https://www.googleapis.com/auth/drive.readonly']
            )
            return build('drive', 'v3', credentials=credentials)
        except Exception as e:
            logger.error(f"Ошибка настройки Google Drive: {e}")
            raise
    
    def _load_env_variables(self) -> Dict[str, str]:
        """Загрузка переменных окружения"""
        env_vars = {}
        env_files = ['.env', '../.env', '../../.env']
        
        for env_file in env_files:
            if os.path.exists(env_file):
                logger.info(f"Загружаю переменные из: {env_file}")
                with open(env_file, 'r', encoding='utf-8') as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith('#'):
                            if '=' in line:
                                key, value = line.split('=', 1)
                                env_vars[key.strip()] = value.strip()
                break
        
        return env_vars
    
    def _get_file_size_mb(self, file_id: str) -> float:
        """Получение размера файла в MB"""
        try:
            file_metadata = self.drive_service.files().get(fileId=file_id).execute()
            size_bytes = int(file_metadata.get('size', 0))
            return size_bytes / (1024 * 1024)
        except Exception as e:
            logger.warning(f"Не удалось получить размер файла {file_id}: {e}")
            return 0
    
    def _download_file(self, file_id: str, file_name: str) -> Optional[str]:
        """Скачивание файла из Google Drive"""
        try:
            # Проверяем размер файла
            file_size_mb = self._get_file_size_mb(file_id)
            if file_size_mb > self.config.max_file_size_mb:
                logger.warning(f"Файл {file_name} слишком большой ({file_size_mb:.1f}MB), пропускаем")
                return None
            
            # Создаем временный файл
            temp_dir = tempfile.mkdtemp()
            temp_file_path = os.path.join(temp_dir, file_name)
            
            # Скачиваем файл
            request = self.drive_service.files().get_media(fileId=file_id)
            with open(temp_file_path, 'wb') as f:
                downloader = MediaIoBaseDownload(f, request)
                done = False
                while not done:
                    status, done = downloader.next_chunk()
                    if status:
                        logger.info(f"Скачивание {file_name}: {int(status.progress() * 100)}%")
            
            logger.info(f"Файл {file_name} скачан успешно")
            return temp_file_path
            
        except Exception as e:
            logger.error(f"Ошибка скачивания файла {file_name}: {e}")
            return None
    
    def _extract_text_from_pdf(self, file_path: str) -> Optional[str]:
        """Извлечение текста из PDF"""
        try:
            # Пробуем PyMuPDF (более надежно)
            doc = fitz.open(file_path)
            text = ""
            for page in doc:
                text += page.get_text()
            doc.close()
            return text.strip()
        except Exception as e:
            logger.warning(f"PyMuPDF не удался, пробуем PyPDF2: {e}")
            try:
                with open(file_path, 'rb') as file:
                    reader = PyPDF2.PdfReader(file)
                    text = ""
                    for page in reader.pages:
                        text += page.extract_text() + "\n"
                return text.strip()
            except Exception as e2:
                logger.error(f"Ошибка извлечения текста из PDF: {e2}")
                return None
    
    def _extract_text_from_docx(self, file_path: str) -> Optional[str]:
        """Извлечение текста из DOCX"""
        try:
            doc = Document(file_path)
            text = ""
            for paragraph in doc.paragraphs:
                text += paragraph.text + "\n"
            return text.strip()
        except Exception as e:
            logger.error(f"Ошибка извлечения текста из DOCX: {e}")
            return None
    
    def _extract_text_from_txt(self, file_path: str) -> Optional[str]:
        """Извлечение текста из TXT"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return f.read().strip()
        except Exception as e:
            logger.error(f"Ошибка чтения TXT файла: {e}")
            return None
    
    def _extract_text(self, file_path: str, file_name: str) -> Optional[str]:
        """Извлечение текста из файла по расширению"""
        file_ext = Path(file_name).suffix.lower()
        
        if file_ext == '.pdf':
            return self._extract_text_from_pdf(file_path)
        elif file_ext == '.docx':
            return self._extract_text_from_docx(file_path)
        elif file_ext == '.txt':
            return self._extract_text_from_txt(file_path)
        else:
            logger.warning(f"Неподдерживаемый формат файла: {file_ext}")
            return None
    
    def _chunk_text(self, text: str) -> List[str]:
        """Разбиение текста на чанки по токенам (tiktoken с фолбэком)."""
        if not text:
            return []

        # Токенайзер: tiktoken → фолбэк (слова)
        def encode(s: str) -> List[int]:
            if _ENC:
                return _ENC.encode(s)
            # наивный фолбэк: разбиваем по пробелам, 1 слово = 1 "токен"
            return s.split()  # type: ignore

        def decode(tokens: List[int]) -> str:
            if _ENC:
                return _ENC.decode(tokens)  # type: ignore
            return " ".join(tokens)  # type: ignore

        tokens = encode(text)
        size = max(100, int(self.config.token_chunk_size))
        overlap = max(0, int(self.config.token_chunk_overlap))

        chunks: List[str] = []
        start = 0
        n = len(tokens)
        while start < n:
            end = min(n, start + size)
            chunk_tokens = tokens[start:end]
            chunk_text = decode(chunk_tokens).strip()
            if chunk_text:
                chunks.append(chunk_text)
            if end == n:
                break
            start = max(start + size - overlap, end) if overlap < size else end

        return chunks

    def _extract_headings_and_tags(self, text: str) -> Dict[str, Any]:
        """Грубая эвристика для заголовков/секций/тегов."""
        if not text:
            return {}
        lines = [l.strip() for l in text.splitlines() if l.strip()]
        title = lines[0][:120] if lines else None
        # Ищем строку, похожую на секцию (начинается с цифры/маркера)
        section = None
        for l in lines[1:6]:
            if l[:2].isdigit() or l.lower().startswith(("глава", "раздел", "section", "chapter")):
                section = l[:120]
                break
        # Простые теги: топ-5 часто встречающихся слов > 4 символов
        from collections import Counter
        words = [w.lower().strip('.,:;!()?"\'') for w in text.split()]
        words = [w for w in words if len(w) > 4 and w.isalpha()]
        common = [w for w, _ in Counter(words).most_common(5)]
        tags = list(dict.fromkeys(common))[:5]
        out: Dict[str, Any] = {}
        if title: out['title'] = title
        if section: out['section'] = section
        if tags: out['tags'] = tags
        return out
    
    def _create_embedding(self, text: str) -> Optional[List[float]]:
        """Создание эмбеддинга для текста"""
        try:
            response = self.openai.embeddings.create(
                input=text,
                model="text-embedding-3-small"
            )
            return response.data[0].embedding
        except Exception as e:
            logger.error(f"Ошибка создания эмбеддинга: {e}")
            return None
    
    def _upload_chunk_to_supabase(self, content: str, metadata: Dict[str, Any]) -> bool:
        """Загрузка чанка в Supabase"""
        try:
            embedding = self._create_embedding(content)
            if not embedding:
                return False
            
            # Вставляем в базу данных
            result = self.supabase.table('documents').insert({
                'content': content,
                'metadata': metadata,
                'embedding': embedding
            }).execute()
            
            if result.data:
                logger.info(f"Чанк загружен успешно")
                return True
            else:
                logger.error(f"Ошибка загрузки чанка: {result.error}")
                return False
                
        except Exception as e:
            logger.error(f"Ошибка загрузки в Supabase: {e}")
            return False
    
    def _process_file(self, file_id: str, file_name: str, mapping: Optional[Dict[str, Any]] = None) -> bool:
        """Обработка одного файла"""
        logger.info(f"Обрабатываю файл: {file_name}")
        
        # Скачиваем файл
        temp_file_path = self._download_file(file_id, file_name)
        if not temp_file_path:
            return False
        
        try:
            # Извлекаем текст
            text = self._extract_text(temp_file_path, file_name)
            if not text:
                logger.warning(f"Не удалось извлечь текст из {file_name}")
                return False
            
            logger.info(f"Извлечено {len(text)} символов из {file_name}")
            
            # Разбиваем на чанки по токенам и собираем базовые метаданные
            chunks = self._chunk_text(text)
            logger.info(f"Создано {len(chunks)} чанков для {file_name}")
            
            # Загружаем каждый чанк
            success_count = 0
            for i, chunk in enumerate(chunks):
                metadata: Dict[str, Any] = {
                    'file_name': file_name,
                    'file_id': file_id,
                    'chunk_index': i,
                    'total_chunks': len(chunks)
                }
                # Эвристики заголовков/секций/тегов из исходного текста (для первого чанка)
                if i == 0:
                    base_meta = self._extract_headings_and_tags(text)
                    metadata.update(base_meta)
                # Маппинг уровня/скилла и переопределение заголовков, если задан
                if mapping:
                    override = None
                    # по file_id или по file_name
                    if file_id in mapping:
                        override = mapping[file_id]
                    elif file_name in mapping:
                        override = mapping[file_name]
                    if isinstance(override, dict):
                        for k in ('level_id', 'skill_id', 'title', 'section', 'tags'):
                            if k in override and override[k] is not None:
                                metadata[k] = override[k]
                
                if self._upload_chunk_to_supabase(chunk, metadata):
                    success_count += 1
                
                # Задержка между чанками
                if i < len(chunks) - 1:
                    time.sleep(self.config.delay_between_chunks)
            
            logger.info(f"Файл {file_name} обработан: {success_count}/{len(chunks)} чанков загружено")
            return success_count > 0
            
        finally:
            # Удаляем временный файл
            try:
                os.remove(temp_file_path)
                os.rmdir(os.path.dirname(temp_file_path))
            except Exception as e:
                logger.warning(f"Не удалось удалить временный файл: {e}")
    
    def _get_files_from_folder(self) -> List[Dict[str, str]]:
        """Получение списка файлов из папки Google Drive"""
        try:
            results = self.drive_service.files().list(
                q=f"'{self.config.google_drive_folder_id}' in parents and trashed=false",
                fields="files(id,name,mimeType)",
                pageSize=1000
            ).execute()
            
            files = results.get('files', [])
            logger.info(f"Найдено {len(files)} файлов в папке")
            return files
            
        except Exception as e:
            logger.error(f"Ошибка получения файлов из Google Drive: {e}")
            return []
    
    def upload_all_files(self):
        """Загрузка всех файлов из папки Google Drive"""
        logger.info("🚀 Начинаю загрузку документов из Google Drive...")
        logger.info(f"⚙️ Ограничения:")
        logger.info(f"   📏 Максимальный размер файла: {self.config.max_file_size_mb}MB")
        logger.info(f"   ⏱️ Задержка между файлами: {self.config.delay_between_files}с")
        logger.info(f"   ⏱️ Задержка между чанками: {self.config.delay_between_chunks}с")
        
        # Получаем список файлов
        files = self._get_files_from_folder()
        if not files:
            logger.error("Не найдено файлов для загрузки")
            return
        
        # Загружаем карту метаданных, если задана
        mapping: Optional[Dict[str, Any]] = None
        if self.config.documents_map_json:
            try:
                with open(self.config.documents_map_json, 'r', encoding='utf-8') as mf:
                    mapping = json.load(mf)
                logger.info(f"📌 Загрузил карту метаданных: {self.config.documents_map_json}")
            except Exception as e:
                logger.warning(f"Не удалось загрузить карту метаданных: {e}")

        # Обрабатываем каждый файл
        success_count = 0
        total_count = len(files)
        
        for i, file_info in enumerate(files):
            file_id = file_info['id']
            file_name = file_info['name']
            
            logger.info(f"📄 [{i+1}/{total_count}] Обрабатываю: {file_name}")
            
            if self._process_file(file_id, file_name, mapping):
                success_count += 1
            
            # Задержка между файлами
            if i < total_count - 1:
                logger.info(f"⏳ Жду {self.config.delay_between_files} секунд...")
                time.sleep(self.config.delay_between_files)
        
        logger.info(f"✅ Загрузка завершена: {success_count}/{total_count} файлов обработано успешно")

def main():
    """Главная функция"""
    try:
        # Загружаем переменные окружения
        env_vars = {}
        env_files = ['.env', '../.env', '../../.env']
        
        for env_file in env_files:
            if os.path.exists(env_file):
                logger.info(f"📄 Загружаю переменные из: {env_file}")
                with open(env_file, 'r', encoding='utf-8') as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith('#'):
                            if '=' in line:
                                key, value = line.split('=', 1)
                                env_vars[key.strip()] = value.strip()
                break
        
        # Создаем конфигурацию
        config = Config(
            supabase_url=env_vars.get('SUPABASE_URL', 'http://127.0.0.1:54321'),
            supabase_service_key=env_vars.get('SUPABASE_SERVICE_ROLE_KEY', ''),
            openai_api_key=env_vars.get('OPENAI_API_KEY', ''),
            google_drive_folder_id=env_vars.get('GOOGLE_DRIVE_FOLDER_ID', ''),
            google_credentials_file=env_vars.get('GOOGLE_CREDENTIALS_FILE', '../credentials.json')
        )
        
        # Проверяем обязательные параметры
        if not config.openai_api_key:
            logger.error("❌ OPENAI_API_KEY не найден в .env")
            return
        
        if not config.google_drive_folder_id:
            logger.error("❌ GOOGLE_DRIVE_FOLDER_ID не найден в .env")
            return
        
        # Проверяем существование файла credentials
        credentials_path = config.google_credentials_file
        if not os.path.exists(credentials_path):
            # Пробуем найти файл в разных местах
            possible_paths = [
                credentials_path,
                f"../{credentials_path}",
                f"../../{credentials_path}",
                os.path.join(os.path.dirname(__file__), "..", credentials_path)
            ]
            
            for path in possible_paths:
                if os.path.exists(path):
                    config.google_credentials_file = path
                    logger.info(f"✅ Найден файл credentials: {path}")
                    break
            else:
                logger.error(f"❌ Файл credentials не найден в путях: {possible_paths}")
                return
        
        # Создаем загрузчик и запускаем
        uploader = DriveUploader(config)
        uploader.upload_all_files()
        
    except Exception as e:
        logger.error(f"❌ Критическая ошибка: {e}")
        raise

if __name__ == "__main__":
    main() 