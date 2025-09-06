import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/leo_message_bubble.dart';
import 'package:bizlevel/widgets/typing_indicator.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:bizlevel/providers/gp_providers.dart';

/// Dialog screen for chatting with Leo assistant.
/// Supports pagination (30 messages per page), unread counter reset,
/// message limit enforcement and auto-scroll to bottom.
class LeoDialogScreen extends ConsumerStatefulWidget {
  final String? chatId;
  final String? userContext;
  final String? levelContext;
  final String bot; // 'leo' | 'max'
  final bool caseMode; // режим мини‑кейса: не тратим лимиты, не сохраняем чаты
  final String? systemPrompt; // опц. системный промпт (для кейса)
  final String? firstPrompt; // опц. первый ассистентский промпт (для кейса)
  final List<String>? casePrompts; // весь список промптов кейса (Q1..Qn)
  final List<String>? caseContexts; // контексты для Q2..Qn (по индексам)
  final String?
      casePreface; // вступление перед первым заданием (например, список дел)
  final String? finalStory; // развёрнутый финальный текст кейса
  final bool
      embedded; // когда true — рендер без Scaffold/AppBar (встраиваемый вид)
  final ValueChanged<String>?
      onAssistantMessage; // колбэк для получения ответа ассистента
  final List<String>?
      recommendedChips; // опц. серверные подсказки (fallback на клиенте)
  final String?
      autoUserMessage; // при передаче — автоматически отправить это сообщение
  final bool skipSpend; // пропуск списаний GP для тонкой реакции

  const LeoDialogScreen({
    super.key,
    this.chatId,
    this.userContext,
    this.levelContext,
    this.bot = 'leo',
    this.caseMode = false,
    this.systemPrompt,
    this.firstPrompt,
    this.casePrompts,
    this.caseContexts,
    this.embedded = false,
    this.onAssistantMessage,
    this.recommendedChips,
    this.casePreface,
    this.finalStory,
    this.autoUserMessage,
    this.skipSpend = false,
  });

  @override
  ConsumerState<LeoDialogScreen> createState() => _LeoDialogScreenState();
}

class _LeoDialogScreenState extends ConsumerState<LeoDialogScreen> {
  static const _pageSize = 30;

  String? _chatId;

  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final _inputFocus = FocusNode();
  final List<Map<String, dynamic>> _messages = [];

  bool _isSending = false;
  bool _isLoadingMore = false;
  bool _hasMore =
      false; // включаем пагинацию только после реальной загрузки из БД
  int _page = 0; // 0-based page counter
  // int _remaining = -1; // −1 unknown (лимиты отключены)

  late final LeoService _leo;
  int _caseStepIndex = -1; // -1 когда не в сценарии или не начато

  // Добавляем debounce для предотвращения дублей
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _leo = ref.read(leoServiceProvider);
    // Лимиты сообщений отключены (этап 39.1)
    _chatId = widget.chatId;
    // Автоприветствие: кейс → первый промпт задания; иначе Макс приветствие
    if (widget.caseMode && _chatId == null && _messages.isEmpty) {
      final String start = (widget.firstPrompt?.trim().isNotEmpty == true)
          ? widget.firstPrompt!.trim()
          : 'Задание 1: Ответьте в 2–3 предложениях.';
      final preface = widget.casePreface?.trim();
      if (preface != null && preface.isNotEmpty) {
        _messages.add({'role': 'assistant', 'content': preface});
      }
      _messages.add({'role': 'assistant', 'content': start});
      _caseStepIndex = 0;
    } else if (widget.bot == 'max' && _chatId == null && _messages.isEmpty) {
      final String greeting = (widget.firstPrompt?.trim().isNotEmpty == true)
          ? widget.firstPrompt!.trim()
          : 'Я — Макс, трекер цели BizLevel. Помогаю кристаллизовать цель и держать темп 28 дней. Напишите, чего хотите добиться — предложу ближайший шаг.';
      _messages.add({'role': 'assistant', 'content': greeting});
    }
    if (_chatId != null) {
      _loadMessages();
    }

    // Автоматическая отправка пользовательского сообщения (тонкая реакция)
    if (widget.autoUserMessage != null &&
        widget.autoUserMessage!.trim().isNotEmpty) {
      // Отправляем асинхронно после первого кадра, чтобы не мешать построению
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await _sendMessageInternal(widget.autoUserMessage!.trim());
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _inputFocus.dispose();
    super.dispose();
  }

  // Лимиты сообщений отключены — метод удалён

  Future<void> _loadMessages() async {
    if (_chatId == null) return;
    final rangeStart = _page * _pageSize;
    final rangeEnd = rangeStart + _pageSize - 1;

    final data = await Supabase.instance.client
        .from('leo_messages')
        .select('role, content, created_at')
        .eq('chat_id', _chatId!)
        .order('created_at', ascending: false)
        .range(rangeStart, rangeEnd);

    final fetched = List<Map<String, dynamic>>.from(
        data.map((e) => Map<String, dynamic>.from(e as Map)));

    if (!mounted) return;
    setState(() {
      _hasMore = fetched.length == _pageSize;
      _page += 1;
      // Reverse to chronological order и добавить только новые (по роли+контенту), чтобы не дублировать
      final chronological = fetched.reversed
          .map((e) => {'role': e['role'], 'content': e['content']})
          .toList();
      final existingKeys =
          _messages.map((m) => '${m['role']}::${m['content']}').toSet();
      final toAdd = <Map<String, dynamic>>[];
      for (final m in chronological) {
        final key = '${m['role']}::${m['content']}';
        if (!existingKeys.contains(key)) {
          toAdd.add(m);
          existingKeys.add(key);
        }
      }
      if (toAdd.isNotEmpty) {
        _messages.insertAll(0, toAdd);
      }
    });

    // Auto-scroll only after first page load
    if (_page == 1) _scrollToBottom();
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await _loadMessages();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  void _scrollToBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

  Future<void> _sendMessage() async {
    // debug prints removed

    // Лимиты отключены — не блокируем отправку

    final text = _inputController.text.trim();
    if (text.isEmpty || _isSending) return;

    // Отменяем предыдущий таймер debounce
    _debounceTimer?.cancel();

    // Устанавливаем новый таймер debounce
    _debounceTimer = Timer(_debounceDelay, () async {
      await _sendMessageInternal(text);
    });
  }

  Future<void> _sendMessageInternal(String text) async {
    // Дополнительная проверка на случай, если состояние изменилось
    if (_isSending || !mounted) return;

    setState(() {
      _isSending = true;
      _messages.add({'role': 'user', 'content': text});
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      // В режиме кейса не создаём чат
      if (!widget.caseMode) {
        if (_chatId == null) {
          _chatId = await _leo.saveConversation(
              role: 'user', content: text, bot: widget.bot);
        } else {
          await _leo.saveConversation(
              chatId: _chatId, role: 'user', content: text);
        }
      }

      // Get assistant response with RAG if context is available
      String assistantMsg;

      // Фильтруем строки "null" и пустые значения
      final cleanUserContext =
          (widget.userContext == 'null' || widget.userContext?.isEmpty == true)
              ? ''
              : (widget.userContext ?? '');
      final cleanLevelContext = (widget.levelContext == 'null' ||
              widget.levelContext?.isEmpty == true)
          ? ''
          : (widget.levelContext ?? '');

      // Единый вызов: сервер выполнит RAG + персонализацию при необходимости
      final response = await _leo.sendMessageWithRAG(
        messages: _buildChatContext(),
        userContext: cleanUserContext,
        levelContext: cleanLevelContext,
        bot: widget.bot,
        // Тонкая реакция: можно пропустить списания GP
        skipSpend: widget.skipSpend,
      );

      assistantMsg = response['message']['content'] as String? ?? '';

      if (!widget.caseMode) {
        await _leo.saveConversation(
            chatId: _chatId, role: 'assistant', content: assistantMsg);
      }

      if (!mounted) return;
      // Скрываем служебные маркеры и префикс "Оценка:" для пользователя
      String displayMsg = assistantMsg
          .replaceAll(RegExp(r"\[CASE:(NEXT|RETRY|FINAL)\]"), '')
          .replaceFirst(RegExp(r"^\s*Оценка\s*:\s*", caseSensitive: false), '')
          .replaceFirst(
              RegExp(
                  r"^(EXCELLENT|GOOD|ACCEPTABLE|WEAK|INVALID)\s*[\.|\-–:]?\s*",
                  caseSensitive: true),
              '')
          .replaceFirst(
              RegExp(
                  r"^(Excellent|Good|Acceptable|Weak|Invalid)\s*[\.|\-–:]?\s*",
                  caseSensitive: false),
              '')
          .trim();
      setState(() {
        _messages.add({'role': 'assistant', 'content': displayMsg});
      });
      // Реакция на маркеры сценария (после отображения очищенного текста)
      if (widget.caseMode && widget.casePrompts != null) {
        if (assistantMsg.contains('[CASE:NEXT]')) {
          // Перейти к следующему заданию
          final nextIndex = (_caseStepIndex >= 0) ? _caseStepIndex + 1 : 1;
          if (nextIndex < (widget.casePrompts!.length)) {
            _caseStepIndex = nextIndex;
            // Показать контекст следующего вопроса, если имеется
            final ctx = (widget.caseContexts != null &&
                    nextIndex < widget.caseContexts!.length)
                ? widget.caseContexts![nextIndex]
                : '';
            if (ctx.trim().isNotEmpty) {
              setState(() {
                _messages.add({'role': 'assistant', 'content': ctx.trim()});
              });
            }
            // Показать следующий вопрос как ассистентское сообщение
            final q = widget.casePrompts![nextIndex].trim();
            if (q.isNotEmpty) {
              setState(() {
                _messages.add({'role': 'assistant', 'content': q});
              });
              _scrollToBottom();
            }
          }
        } else if (assistantMsg.contains('[CASE:FINAL]')) {
          // Показать финальную историю (если задана), затем CTA на возврат
          final fs = widget.finalStory?.trim();
          if (fs != null && fs.isNotEmpty) {
            setState(() {
              _messages.add({'role': 'assistant', 'content': fs});
            });
            _scrollToBottom();
          }
          if (!mounted) return;
          // Кнопка в нижнем листе
          // ignore: use_build_context_synchronously
          await showModalBottomSheet(
            context: context,
            showDragHandle: true,
            builder: (ctx) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop('case_final');
                    },
                    child: const Text('Вернуться в Башню'),
                  ),
                ),
              ),
            ),
          );
          return;
        }
      }
      // Если ассистент сообщил о финале кейса — предложим вернуться в башню
      if (assistantMsg.contains('[CASE:FINAL]')) {
        if (!mounted) return;
        final goBack = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Кейс завершён'),
            content: const Text('Отличная работа! Перейти обратно на Башню?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Остаться'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Вернуться в Башню'),
              ),
            ],
          ),
        );
        if (goBack == true && mounted) {
          Navigator.of(context).pop('case_final');
          return;
        }
      }
      // После успешного ответа обновим баланс GP в фоне
      try {
        // ignore: unused_result
        ref.invalidate(gpBalanceProvider);
      } catch (_) {}
      // Сообщаем родителю об ответе ассистента (для префилла форм)
      try {
        widget.onAssistantMessage?.call(assistantMsg);
      } catch (_) {}
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  List<Map<String, dynamic>> _buildChatContext() {
    final List<Map<String, dynamic>> ctx = _messages
        .map((m) => {'role': m['role'], 'content': m['content']})
        .toList();
    // В режиме мини‑кейса добавляем системный промпт фасилитатора как первое сообщение
    if (widget.caseMode) {
      final sp = widget.systemPrompt?.trim();
      if (sp != null && sp.isNotEmpty) {
        ctx.insert(0, {'role': 'system', 'content': sp});
      }
    }
    return ctx;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      // Встраиваемый режим: без Scaffold/AppBar, только тело
      return Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInput(),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage(widget.bot == 'max'
                  ? 'assets/images/avatars/avatar_max.png'
                  : 'assets/images/avatars/avatar_leo.png'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 8),
            Text(widget.bot == 'max' ? 'Макс' : 'Лео'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notif) {
        if (notif.metrics.pixels <= 50 && _hasMore) {
          _loadMore();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _messages.length + (_hasMore ? 1 : 0) + (_isSending ? 1 : 0),
        itemBuilder: (context, index) {
          // 1) Плашка загрузки предыдущих сообщений
          if (_hasMore && index == 0) {
            return Center(
              child: _isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: _loadMore, child: const Text('Загрузить ещё')),
            );
          }
          final offset = _hasMore ? 1 : 0;
          final msgIndex = index - offset;
          // 2) Последний элемент — индикатор набора, если ждём ответ
          if (_isSending && msgIndex == _messages.length) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12).copyWith(
                    topLeft: const Radius.circular(0),
                    topRight: const Radius.circular(12),
                  ),
                ),
                child: const TypingIndicator.small(),
              ),
            );
          }
          // 3) Обычные сообщения
          final msg = _messages[msgIndex];
          final isUser = msg['role'] == 'user';
          return LeoMessageBubble(
              text: msg['content'] as String? ?? '', isUser: isUser);
        },
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChipsRow(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    focusNode: _inputFocus,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: OutlineInputBorder(),
                    ),
                    // Отправка по Enter
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty && !_isSending) {
                        _sendMessage();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                _isSending
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator())
                    : IconButton(
                        icon: const Icon(Icons.send),
                        color: AppColor.primary,
                        onPressed: _sendMessage,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsRow() {
    final chips = _resolveRecommendedChips();
    if (chips.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final text in chips)
            ActionChip(
              label: Text(text, overflow: TextOverflow.ellipsis),
              onPressed: () {
                _inputController.text = text;
                _inputController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _inputController.text.length));
                _inputFocus.requestFocus();
              },
            ),
        ],
      ),
    );
  }

  List<String> _resolveRecommendedChips() {
    if (widget.recommendedChips != null &&
        widget.recommendedChips!.isNotEmpty) {
      return widget.recommendedChips!;
    }
    // Клиентский фолбэк: подбираем подсказки по версии цели в userContext
    if (widget.bot == 'max') {
      final ctx = widget.userContext ?? '';
      final match = RegExp(r'goal_version:\s*(\d+)').firstMatch(ctx);
      final v = match != null ? int.tryParse(match.group(1) ?? '') : null;
      switch (v) {
        case 2:
          return const [
            '💰 Выручка',
            '👥 Кол-во клиентов',
            '⏱ Время на задачи',
            '📊 Конверсия %',
            '✏️ Другое',
          ];
        case 3:
          return const [
            'Неделя 1: Подготовка',
            'Неделя 2: Запуск',
            'Неделя 3: Масштабирование',
            'Неделя 4: Оптимизация',
          ];
        case 4:
          return const [
            'Готовность 7/10',
            'Начать завтра',
            'Старт в понедельник',
          ];
        default:
          return const [];
      }
    }
    return const [];
  }
}
