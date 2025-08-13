# Схема БД BizLevel (public)

В таблице приведены все сущности Supabase, используемые приложением, и назначение их колонок. Названия приведены как в базе, описания — на русском.

---

## users
| Колонка | Тип | Назначение |
|---------|-----|------------|
| id | uuid (PK) | ID пользователя = `auth.uid()`. Используется во всех FK |
| email | text | Подтверждённый e-mail пользователя |
| name | text | Имя, введённое при онбординге |
| about | text | Коротко «О себе» для персонализации подсказок Leo |
| goal | text | Цель обучения — также попадает в системный prompt Leo |
| is_premium | bool | Есть активная подписка Premium |
| current_level | int | Номер текущего (открытого) уровня |
| leo_messages_total | int | Сколько сообщений осталось у Free-пользователя (разовый лимит) |
| leo_messages_today | int | Сколько сообщений осталось сегодня у Premium-пользователя |
| leo_reset_at | timestamptz | Время последнего дневного сброса лимита Leo |
| onboarding_completed | bool | Пройден ли онбординг |
| avatar_id | int | Выбранный аватар (ссылка на assets) |
| created_at | timestamptz | Дата создания строки |
| updated_at | timestamptz | Обновляется триггером при каждом изменении |

## levels
| Колонка | Тип | Назначение |
|---------|-----|------------|
| id | int (PK) | Идентификатор уровня |
| number | int | Числовой порядок отображения (1…N) |
| title | text | Название уровня |
| description | text | Короткое описание для карточки |
| image_url | text | Иконка (устарела, теперь cover_path) |
| is_free | bool | Бесплатный ли уровень (true для 1-3) |
| artifact_title | text | Заголовок бизнес-артефакта |
| artifact_description | text | Описание артефакта |
| artifact_url | text | Путь в Supabase Storage к PDF/ZIP |
| cover_path | text | Путь в bucket `level-covers` для обложки |
| created_at | timestamptz | Время добавления |

## lessons
| Колонка | Тип | Назначение |
|---------|-----|------------|
| id | int (PK) | ID урока |
| level_id | int (FK → levels.id) | К какому уровню принадлежит |
| order | int | Порядковый номер внутри уровня |
| title | text | Название урока |
| description | text | Краткое описание |
| video_url | text (nullable) | Прямая ссылка на mp4 в Storage (fallback) |
| vimeo_id | text (nullable) | ID ролика на Vimeo (Web / iOS) |
| duration_minutes | int | Продолжительность видео |
| quiz_questions | jsonb | Массив вопросов (текст/варианты) |
| correct_answers | jsonb | Массив индексов правильных ответов |
| created_at | timestamptz | Дата создания |

## user_progress
| Колонка | Тип | Назначение |
|---------|-----|------------|
| user_id | uuid (PK, FK → users.id) | Пользователь |
| level_id | int  (PK, FK → levels.id) | Уровень |
| current_lesson | int | Последний открытый внутри уровня |
| is_completed | bool | Завершён ли уровень |
| started_at | timestamptz | Когда пользователь начал уровень |
| completed_at | timestamptz (nullable) | Дата завершения |
| updated_at | timestamptz | Обновляется при каждом прогрессе |

## leo_chats
| Колонка | Тип | Назначение |
|---------|-----|------------|
| id | uuid (PK) | ID диалога |
| user_id | uuid (FK → users.id) | Владелец чата |
| title | text | Первые 40 символов первого сообщения пользователя |
| message_count | int | Сколько сообщений всего в чате |
| unread_count | int | Непрочитанные ответы Leo (подсчёт триггером) |
| created_at | timestamptz | Дата создания чата |
| updated_at | timestamptz | Обновляется при каждом новом сообщении |

## leo_messages
| Колонка | Тип | Назначение |
|---------|-----|------------|
| id | uuid (PK) | ID сообщения |
| chat_id | uuid (FK → leo_chats.id) | К какому чату принадлежит |
| user_id | uuid (FK → users.id) | Кто отправил (user или system) |
| role | text | 'user' / 'assistant' / 'system' |
| content | text | Текст сообщения |
| token_count | int | Сколько токенов OpenAI списано (usage.total_tokens) |
| created_at | timestamptz | Время отправки |

## payments
| Колонка | Тип | Назначение |
|---------|-----|------------|
| id | int (PK) | ID платежа |
| user_id | uuid (FK → users.id) | Плательщик |
| amount | numeric | Сумма в тенге |
| status | text | 'pending' / 'succeeded' / 'failed'… |
| payment_method | text | 'kaspi', 'freedompay'… |
| bill_id | text | ID счета в провайдере |
| bill_url | text | Ссылка на оплату |
| confirmed_by | uuid | Модератор, подтвердивший вручную |
| created_at | timestamptz | Когда выставлен счёт |
| confirmed_at | timestamptz | Когда оплачен |

## subscriptions
| Колонка | Тип | Назначение |
|---------|-----|------------|
| id | uuid (PK) | ID подписки |
| user_id | uuid (FK → users.id) | Подписчик |
| status | text | 'trialing' / 'active' / 'past_due' / 'canceled' |
| current_period_end | timestamptz | Дата окончания оплаченного периода |
| created_at | timestamptz | Дата начала подписки |

---

## Использование таблиц и колонок в коде
Ниже перечислены компоненты/файлы, которые прямо обращаются к таблицам или колонкам. Колонки, не встречающиеся в исходниках, помечены *не используется*.

### users
| Колонка | Где используется | Примечание |
|---------|------------------|------------|
| id | auth → FK всех сервисов | |
| email | `AuthService.updateProfile`, регистрация | |
| name / about / goal | Edge Function `leo-chat`, `OnboardingProfileScreen` | влияют на prompt Leo |
| is_premium | `LevelsRepository`, `subscriptionProvider` | |
| current_level | providers, RPC `update_current_level` | |
| leo_messages_total / leo_messages_today / leo_reset_at | `LeoService.checkMessageLimit` | лимиты сообщений |
| onboarding_completed | GoRouter redirect | |
| avatar_id | `ProfileScreen` | |
| created_at / updated_at | *не используется* |

### levels
| Колонка | Используется |
|---------|-------------|
| id, number, title, description | репозитории, UI |
| image_url | `LevelsRepository` (legacy) |
| cover_path | `LevelsRepository.getCoverSignedUrl` |
| is_free | `levels_provider` (блокировка) |
| artifact_title / artifact_description / artifact_url | `_ArtifactBlock`, ProfileScreen |
| created_at | *не используется* |

### lessons
| Колонка | Используется |
|---------|-------------|
| id, level_id, order, title, description | репо + UI |
| video_url / vimeo_id | `LessonWidget` |
| duration_minutes | отображение длительности |
| quiz_questions / correct_answers | `QuizWidget` |
| created_at | *не используется* |

### user_progress
| Колонка | Используется |
|---------|-------------|
| user_id, level_id, current_lesson, is_completed | прогресс |
| started_at / completed_at / updated_at | *не используется* |

### leo_chats
| Колонка | Используется |
|---------|-------------|
| id, user_id, title, message_count, updated_at | списки чатов |
| unread_count | `leo_unread_provider` |
| created_at | *не используется* |

### leo_messages
| Колонка | Используется |
|---------|-------------|
| id, chat_id, user_id, role, content, created_at | история сообщений |
| token_count | *не используется* |

### payments
| Колонка | Используется |
|---------|-------------|
| id, user_id, amount, status, payment_method | Edge Function `create-checkout-session` |
| bill_id, bill_url, confirmed_by, confirmed_at | *не используется* |
| created_at | *не используется* |

### subscriptions
| Колонка | Используется |
|---------|-------------|
| id, user_id, status | `subscriptionProvider` |
| current_period_end, created_at | *не используется* |

### Итог — столбцы/таблицы без использования
`users.created_at`, `users.updated_at`, `levels.created_at`, `lessons.created_at`, `user_progress.started_at`, `user_progress.completed_at`, `user_progress.updated_at`, `leo_chats.created_at`, `leo_messages.token_count`, `payments.bill_id`, `payments.bill_url`, `payments.confirmed_by`, `payments.confirmed_at`, `subscriptions.current_period_end`, `subscriptions.created_at`

> **Примечание:** во всех таблицах включён Row Level Security; политики разрешают чтение / изменение только собственных записей пользователя. RPC-процедуры `decrement_leo_message`, `reset_leo_unread` и триггеры управляют лимитами и счётчиками Leo.
