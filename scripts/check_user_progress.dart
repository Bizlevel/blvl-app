#!/usr/bin/env dart
/// Скрипт для проверки данных user_progress в БД
/// 
/// Использование:
///   dart scripts/check_user_progress.dart [user_id]
/// 
/// Если user_id не указан, будет использован текущий авторизованный пользователь

import 'dart:io';

void main(List<String> args) async {
  print('🔍 Проверка данных user_progress в БД\n');
  
  // Получаем user_id из аргументов или используем текущего пользователя
  String? userId;
  if (args.isNotEmpty) {
    userId = args[0];
    print('📋 Проверяем данные для пользователя: $userId\n');
  } else {
    print('⚠️  Укажите user_id как аргумент:');
    print('   dart scripts/check_user_progress.dart <user_id>\n');
    print('   Или используйте SQL-запрос из check_user_progress.sql\n');
    exit(1);
  }

  print('''
📝 SQL-запрос для выполнения в Supabase Dashboard:

SELECT 
  up.id,
  up.user_id,
  up.level_id,
  l.number as level_number,
  l.title as level_title,
  up.is_completed,
  up.created_at,
  up.updated_at,
  u.current_level as user_current_level
FROM user_progress up
LEFT JOIN levels l ON l.id = up.level_id
LEFT JOIN users u ON u.id = up.user_id
WHERE up.user_id = '$userId'
ORDER BY l.number ASC;

-- Проверка конкретных уровней (4 и 7):
SELECT 
  up.level_id,
  l.number as level_number,
  l.title,
  up.is_completed,
  CASE 
    WHEN up.is_completed = true THEN '✅ Завершен'
    ELSE '❌ Не завершен'
  END as status
FROM user_progress up
LEFT JOIN levels l ON l.id = up.level_id
WHERE up.user_id = '$userId' 
  AND l.number IN (4, 7)
ORDER BY l.number;

-- Проверка всех уровней с их статусом:
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
LEFT JOIN user_progress up ON up.level_id = l.id AND up.user_id = '$userId'
WHERE l.number BETWEEN 0 AND 10
ORDER BY l.number;
''');
}
