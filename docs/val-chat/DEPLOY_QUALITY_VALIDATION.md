# Инструкция по деплою валидации качества ответов

**Дата:** 15 декабря 2024  
**Функция:** val-chat (Edge Function)  
**Цель:** Deploy двухпроходной валидации ответов Валли

## Что было изменено

- ✅ Добавлена структура `VALIDATION_STEPS` с критериями для 7 вопросов
- ✅ Реализована двухпроходная валидация (generator → validator)
- ✅ Step gating: шаг увеличивается только при достаточном ответе
- ✅ Мягкое добивание при недостаточных ответах
- ✅ Fail-safe: при ошибке валидатора блокируем продвижение

## Шаги деплоя

### 1. Проверка кода (опционально)

```bash
cd /home/nail/Documents/Projects/BizLevel/blvl-app-main/supabase/functions/val-chat
deno check index.ts
```

Если Deno не установлен — пропустить, код будет проверен при деплое.

### 2. Деплой Edge Function

```bash
cd /home/nail/Documents/Projects/BizLevel/blvl-app-main
supabase functions deploy val-chat
```

**Ожидаемый вывод:**

```
Deploying val-chat...
✓ Function deployed successfully
Function URL: https://[project-id].supabase.co/functions/v1/val-chat
```

### 3. Проверка логов (real-time)

```bash
supabase functions logs val-chat --tail
```

Оставить эту команду запущенной в отдельном терминале для мониторинга.

### 4. Ручное тестирование (обязательно)

#### Тест 1: Нерелевантный ответ блокирует

1. Открыть приложение
2. Перейти в Base Trainers → Vali AI
3. Начать новую валидацию
4. На первый вопрос написать: **"Идея топ"**
5. **Ожидаемое поведение:**
   - Валли возвращает уточнение с критериями
   - Не переходит к следующему вопросу
6. Написать снова: **"Хорошая идея"**
7. **Ожидаемое поведение:**
   - Снова уточнение
8. Написать развёрнуто (см. примеры в `ANSWER_QUALITY_VALIDATION.md`)
9. **Ожидаемое поведение:**
   - Валли принимает ответ
   - Переходит к вопросу 2

**Проверить в логах:**

```
INFO step_blocked { validationId, currentStep: 1, isValid: false }
INFO step_advanced { validationId, from: 1, to: 2 }
```

#### Тест 2: Прохождение всех 7 вопросов

1. Пройти все 7 вопросов с качественными ответами
2. **Ожидаемое поведение:**
   - Каждый ответ проверяется
   - Шаг увеличивается только при достаточных ответах
   - После шага 7 → переход к скорингу

**Проверить в БД:**

```sql
SELECT id, current_step, status, created_at 
FROM idea_validations 
WHERE user_id = '[your-user-id]' 
ORDER BY created_at DESC 
LIMIT 1;
```

Должно быть: `current_step = 7`, `status = 'completed'`.

### 5. Проверка метрик (через 1-2 дня)

**Запрос в Supabase Logs (Dashboard):**

1. Перейти в Supabase Dashboard → Edge Functions → val-chat → Logs
2. Найти события:
   - `INFO step_blocked` — сколько раз блокировалось
   - `INFO step_advanced` — сколько раз продвигалось
   - `ERR validator_failed` — ошибки валидатора

**Целевые метрики:**

- **Блокировки:** 20-40% от всех сообщений (нормально)
- **Ошибки валидатора:** < 10%
- **Средняя длительность ответа:** +1-2 секунды (из-за второго вызова)

### 6. Rollback (если нужно)

Если тесты провалились или есть критические проблемы:

```bash
# 1. Откатить функцию на предыдущую версию
supabase functions deploy val-chat --version [previous-version]

# 2. Или откатить через Git
git revert [commit-hash]
git push origin [branch]
supabase functions deploy val-chat
```

## Checklist перед релизом

- [ ] Код задеплоен: `supabase functions deploy val-chat`
- [ ] Логи работают: `supabase functions logs val-chat --tail`
- [ ] Тест 1 пройден: нерелевантный ответ блокируется
- [ ] Тест 2 пройден: релевантный ответ пропускается
- [ ] Тест 3 пройден: полный флоу 7 вопросов работает
- [ ] БД проверена: `current_step` изменяется корректно
- [ ] Метрики мониторятся: логи `step_blocked`, `step_advanced`
- [ ] Документация обновлена: `CHANGELOG.md`, `ANSWER_QUALITY_VALIDATION.md`

## Известные ограничения

1. **Латентность +1-2 сек** на каждое сообщение (двойной вызов модели)
2. **Субъективность:** Модель-валидатор может ошибаться
3. **Fail-safe блокирует:** При ошибке валидатора шаг не продвигается

## Контакты и поддержка

- **Логи:** Supabase Dashboard → Edge Functions → val-chat → Logs
- **Документация:** `docs/val-chat/ANSWER_QUALITY_VALIDATION.md`
- **Changelog:** `docs/val-chat/CHANGELOG.md`

---

**Статус:** ✅ Готов к деплою  
**Дата:** 15 декабря 2024  
**Автор:** AI Code Agent
