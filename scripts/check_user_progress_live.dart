#!/usr/bin/env dart
/// Интерактивный скрипт для проверки данных user_progress в БД
/// 
/// Использование:
///   dart scripts/check_user_progress_live.dart
/// 
/// Требования:
///   - Переменные окружения SUPABASE_URL и SUPABASE_ANON_KEY
///   - Или запуск из Flutter приложения с инициализированным Supabase

import 'dart:io';

void main() async {
  print('🔍 Проверка данных user_progress в БД\n');
  print('⚠️  Этот скрипт требует подключения к Supabase.\n');
  print('📝 Рекомендуется использовать SQL-запросы из файла:');
  print('   scripts/check_user_progress.sql\n');
  print('📋 Или выполните запросы напрямую в Supabase Dashboard:\n');
  print('   1. Откройте https://app.supabase.com');
  print('   2. Выберите ваш проект');
  print('   3. Перейдите в SQL Editor');
  print('   4. Скопируйте запросы из check_user_progress.sql\n');
  
  print('💡 Быстрый SQL-запрос для проверки уровней 4 и 7:\n');
  print('''
SELECT 
  l.number as level_number,
  l.title,
  COALESCE(up.is_completed, false) as is_completed,
  CASE 
    WHEN up.is_completed = true THEN '✅ Завершен'
    WHEN up.is_completed = false THEN '⚠️  В БД, но не завершен'
    ELSE '❌ Нет записи в БД'
  END as status
FROM levels l
LEFT JOIN user_progress up ON up.level_id = l.id AND up.user_id = 'ВАШ_USER_ID'
WHERE l.number IN (4, 7)
ORDER BY l.number;
''');
  
  print('\n📌 Чтобы найти ваш user_id, выполните:\n');
  print('''
SELECT id, email, name, current_level 
FROM users 
WHERE email = 'ваш-email@example.com';
''');
  
  exit(0);
}
