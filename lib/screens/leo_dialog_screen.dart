import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/widgets/leo_message_bubble.dart';
import 'package:bizlevel/widgets/typing_indicator.dart';
import 'package:bizlevel/widgets/common/bizlevel_text_field.dart';
import 'package:bizlevel/widgets/custom_textfield.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/providers/cases_provider.dart';
import 'package:go_router/go_router.dart';

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
  final int? caseId; // id мини‑кейса для фиксации прогресса
  final bool
      embedded; // когда true — рендер без Scaffold/AppBar (встраиваемый вид)
  final ValueChanged<String>?
      onAssistantMessage; // колбэк для получения ответа ассистента
  final ValueChanged<String>?
      onUserMessage; // колбэк для отправленного сообщения пользователя
  final ValueChanged<String>?
      onChatIdChanged; // возвращает chatId после первого сообщения
  final List<String>?
      recommendedChips; // опц. серверные подсказки (fallback на клиенте)
  final String?
      autoUserMessage; // при передаче — автоматически отправить это сообщение
  final bool skipSpend; // пропуск списаний GP для тонкой реакции
  final String?
      initialAssistantMessage; // первое сообщение от ассистента (для приветствия)
  final List<String>?
      initialAssistantMessages; // несколько приветственных сообщений ассистента

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
    this.onUserMessage,
    this.onChatIdChanged,
    this.recommendedChips,
    this.casePreface,
    this.finalStory,
    this.autoUserMessage,
    this.skipSpend = false,
    this.initialAssistantMessage,
    this.initialAssistantMessages,
    this.caseId,
  });

  @override
  ConsumerState<LeoDialogScreen> createState() => _LeoDialogScreenState();
}

class _LeoDialogScreenState extends ConsumerState<LeoDialogScreen>
    with WidgetsBindingObserver {
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
  List<String> _serverRecommendedChips = [];
  final Set<String> _dismissedChips = {};
  bool _showScrollToBottom = false;
  bool _showSuggestions = true; // управляет показом inline-подсказок
  String? _lastFailedMessage;
  List<String> get _defaultGoalChips {
    if (widget.bot != 'max') return const [];
    return const [
      'Подскажи реалистичный темп',
      'Как выбрать финансовую метрику?',
      'Какие действия усилят прогресс за 7 дней?'
    ];
  }

  // Добавляем debounce для предотвращения дублей
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  // Debounce для обновления чипсов
  Timer? _chipsDebounceTimer;
  static const Duration _chipsDebounceDelay = Duration(milliseconds: 1000);

  double _lastViewInsetsBottom = 0.0;

  /// Защита от "случайного" закрытия экрана на iOS при попытке сфокусировать TextField
  /// (наблюдалось как резкий pop → возврат на /tower).
  /// Для mini-case запрещаем системный pop, оставляем только явную кнопку закрытия.
  bool _allowPop = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _leo = ref.read(leoServiceProvider);
    // Лимиты сообщений отключены (этап 39.1)
    _chatId = widget.chatId;
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'chat',
        level: SentryLevel.info,
        message: 'leo_dialog_opened',
        data: {
          'bot': widget.bot,
          'embedded': widget.embedded,
          'caseMode': widget.caseMode,
          'chatId': _chatId ?? '',
        },
      ));
    } catch (_) {}
    // если подсказок нет, скрываем ленту
    if (_serverRecommendedChips.isEmpty && _defaultGoalChips.isEmpty) {
      _showSuggestions = false;
    }
    _allowPop = !widget.caseMode;

    // Следим за позицией скролла для показа FAB «вниз»
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final metrics = _scrollController.position;
      final distFromBottom = (metrics.maxScrollExtent - metrics.pixels)
          .clamp(0.0, double.infinity);
      final show = distFromBottom > 200;
      if (show != _showScrollToBottom && mounted) {
        setState(() => _showScrollToBottom = show);
      }
    });
    // Загружаем персональные чипсы при инициализации
    _refreshChipsDebounced();
    // Автоприветствие: кейс → первый промпт задания; иначе Макс приветствие
    if (widget.caseMode && _chatId == null && _messages.isEmpty) {
      final String start = (widget.firstPrompt?.trim().isNotEmpty == true)
          ? widget.firstPrompt!.trim()
          : 'Задание 1: Ответьте в 2–3 предложениях.';
      final preface = widget.casePreface?.trim();
      if (preface != null && preface.isNotEmpty) {
        _messages.add({
          'role': 'assistant',
          'content': preface,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      _messages.add({
        'role': 'assistant',
        'content': start,
        'created_at': DateTime.now().toIso8601String(),
      });
      _caseStepIndex = 0;
    } else if (widget.bot == 'max' && _chatId == null && _messages.isEmpty) {
      // Приоритет: список приветствий → пользовательское приветствие → firstPrompt → дефолт
      final List<String> greetings = [];
      if (widget.initialAssistantMessages != null &&
          widget.initialAssistantMessages!.isNotEmpty) {
        greetings.addAll(widget.initialAssistantMessages!
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty));
      } else if (widget.initialAssistantMessage?.trim().isNotEmpty == true) {
        greetings.add(widget.initialAssistantMessage!.trim());
      } else if (widget.firstPrompt?.trim().isNotEmpty == true) {
        greetings.add(widget.firstPrompt!.trim());
      } else {
        greetings.add(
            'Я — Макс, трекер цели BizLevel. Помогаю формулировать и достигать цель. Напишите, чего хотите добиться — предложу ближайший шаг.');
      }
      for (final g in greetings) {
        _messages.add({
          'role': 'assistant',
          'content': g,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
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
        await _sendMessageInternal(
          widget.autoUserMessage!.trim(),
          isAuto: true,
        );
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _chipsDebounceTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    assert(() {
      debugPrint(
          'LEO_DIALOG dispose caseMode=${widget.caseMode} chatId=$_chatId');
      return true;
    }());

    _inputController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  double _currentViewInsetsBottom() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return 0.0;
    final view = views.first;
    final bottom = view.viewInsets.bottom;
    final dpr = view.devicePixelRatio;
    if (dpr == 0) return 0.0;
    return bottom / dpr;
  }

  @override
  void didChangeMetrics() {
    final nextBottom = _currentViewInsetsBottom();
    if (nextBottom != _lastViewInsetsBottom) {
      _lastViewInsetsBottom = nextBottom;
      if (nextBottom > 0) {
        _scrollToBottom();
      }
    }
    super.didChangeMetrics();
  }

  // Лимиты сообщений отключены — метод удалён

  Future<void> _loadMessages() async {
    if (_chatId == null) return;
    final rangeStart = _page * _pageSize;
    final rangeEnd = rangeStart + _pageSize - 1;

    final data = await Supabase.instance.client
        .from('leo_messages')
        .select('id, role, content, created_at')
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
          .map((e) => {
                'id': e['id'],
                'role': e['role'],
                'content': e['content'],
                'created_at': e['created_at'],
              })
          .toList();
      final existingKeys = _messages
          .map((m) => (m['id'] != null)
              ? 'id:${m['id']}'
              : 'msg:${m['role']}::${m['content']}::${m['created_at']}')
          .toSet();
      final toAdd = <Map<String, dynamic>>[];
      for (final m in chronological) {
        final key = (m['id'] != null)
            ? 'id:${m['id']}'
            : 'msg:${m['role']}::${m['content']}::${m['created_at']}';
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

  void _setCaseStepsCompleted(int stepsCompleted) {
    if (!widget.caseMode) return;
    final caseId = widget.caseId;
    if (caseId == null) return;
    try {
      ref.read(caseActionsProvider).setStepsCompleted(caseId, stepsCompleted);
    } catch (_) {}
  }

  /// Обновляет чипсы с сервера с дебаунсом
  void _refreshChipsDebounced() {
    _chipsDebounceTimer?.cancel();
    _chipsDebounceTimer = Timer(_chipsDebounceDelay, () async {
      try {
        final chips = await _leo.fetchRecommendedChips(
          bot: widget.bot,
          chatId: _chatId,
          userContext: widget.userContext,
          levelContext: widget.levelContext,
        );
        debugPrint('CHIPS server=$chips');
        if (mounted) {
          setState(() {
            _serverRecommendedChips = chips;
            // Показываем подсказки, если получили чипсы
            if (chips.isNotEmpty) {
              _showSuggestions = true;
            }
          });
          debugPrint('CHIPS merged=${_resolveRecommendedChips()}');
        }
      } catch (e) {
        // Тихо фейлимся — останется локальный фолбэк
        debugPrint('Failed to fetch recommended chips: $e');
      }
    });
  }

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

  Future<void> _sendMessageInternal(String text,
      {bool isAuto = false, bool isRetry = false}) async {
    // Дополнительная проверка на случай, если состояние изменилось
    if (_isSending || !mounted) return;
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'chat',
        level: SentryLevel.info,
        message: 'chat_send_start',
        data: {
          'bot': widget.bot,
          'chatId': _chatId ?? '',
          'caseMode': widget.caseMode,
        },
      ));
    } catch (_) {}

    setState(() {
      _isSending = true;
      if (!isRetry) {
        _messages.add({
          'role': 'user',
          'content': text,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    });
    try {
      widget.onUserMessage?.call(text);
    } catch (_) {}
    if (!isRetry) {
      _inputController.clear();
    }
    _scrollToBottom();

    try {
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
      // В режиме мини‑кейса ВСЕ сообщения должны быть бесплатными (без списания GP),
      // даже если вызывающий код забыл выставить skipSpend.
      final bool effectiveSkipSpend = widget.skipSpend || widget.caseMode;
      final response = await _leo.sendMessageWithRAG(
        messages: _buildChatContext(),
        userContext: cleanUserContext,
        levelContext: cleanLevelContext,
        bot: widget.bot,
        chatId: _chatId,
        // GP‑политика: в mentor-mode все сообщения бесплатные,
        // в обычном режиме только авто‑сообщения бесплатные
        skipSpend: effectiveSkipSpend,
        caseMode: widget.caseMode, // Add caseMode parameter
      );

      final String? responseChatId = response['chat_id']?.toString();
      if (responseChatId != null &&
          responseChatId.isNotEmpty &&
          responseChatId != _chatId) {
        if (mounted) {
          setState(() => _chatId = responseChatId);
        } else {
          _chatId = responseChatId;
        }
        try {
          widget.onChatIdChanged?.call(responseChatId);
        } catch (_) {}
      }

      final String effectiveChatId =
          (responseChatId != null && responseChatId.isNotEmpty)
              ? responseChatId
              : (_chatId ?? '');
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'chat',
          level: SentryLevel.info,
          message: 'chat_send_success',
          data: {
            'bot': widget.bot,
            'chatId': effectiveChatId,
            'caseMode': widget.caseMode,
          },
        ));
      } catch (_) {}

      assistantMsg = response['message']['content'] as String? ?? '';
      // Обновим серверные чипы, если пришли
      try {
        final chipsRaw = response['recommended_chips'];
        if (chipsRaw is List) {
          final next = chipsRaw
              .map((e) => e?.toString() ?? '')
              .where((s) => s.trim().isNotEmpty)
              .cast<String>()
              .toList();
          if (mounted) {
            setState(() {
              _serverRecommendedChips = next;
            });
          }
        }
      } catch (_) {}

      if (!mounted) return;
      // Скрываем служебные маркеры и префикс "Оценка:" для пользователя
      final String displayMsg = assistantMsg
          .replaceAll(RegExp(r"\[CASE:(NEXT|RETRY|FINAL)\]"), '')
          .replaceFirst(RegExp(r"^\s*Оценка\s*:\s*", caseSensitive: false), '')
          .replaceFirst(
              RegExp(
                  r"^(EXCELLENT|GOOD|ACCEPTABLE|WEAK|INVALID)\s*[\.|\-–:]?\s*"),
              '')
          .replaceFirst(
              RegExp(
                  r"^(Excellent|Good|Acceptable|Weak|Invalid)\s*[\.|\-–:]?\s*",
                  caseSensitive: false),
              '')
          .trim();
      if (displayMsg.isNotEmpty) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': displayMsg,
            'created_at': DateTime.now().toIso8601String(),
          });
        });
      }
      // Реакция на маркеры сценария (после отображения очищенного текста)
      if (widget.caseMode && widget.casePrompts != null) {
        final bool hasNext = assistantMsg.contains('[CASE:NEXT]');
        final bool hasFinal = assistantMsg.contains('[CASE:FINAL]');
        final int totalPrompts = widget.casePrompts!.length;
        final int lastIndex = totalPrompts > 0 ? totalPrompts - 1 : 0;
        final bool isLastStep = totalPrompts > 0 && _caseStepIndex >= lastIndex;

        // Иногда модель ошибочно возвращает [CASE:FINAL] уже на ранних шагах.
        // Это приводит к неожиданному завершению кейса и "вылету" в Башню.
        // Защита: финал разрешён только на последнем задании.
        final bool earlyFinal = hasFinal && !isLastStep;
        if (earlyFinal) {
          try {
            Sentry.addBreadcrumb(Breadcrumb(
              category: 'case',
              message: 'case_final_early_guard',
              level: SentryLevel.warning,
              data: {
                'stepIndex': _caseStepIndex,
                'totalPrompts': totalPrompts,
              },
            ));
          } catch (_) {}
        }

        if (hasNext || earlyFinal) {
          // Перейти к следующему заданию
          final nextIndex = (_caseStepIndex >= 0) ? _caseStepIndex + 1 : 1;
          if (nextIndex < (widget.casePrompts!.length)) {
            _caseStepIndex = nextIndex;
            _setCaseStepsCompleted(nextIndex);
            // Показать контекст следующего вопроса, если имеется
            final ctx = (widget.caseContexts != null &&
                    nextIndex < widget.caseContexts!.length)
                ? widget.caseContexts![nextIndex]
                : '';
            if (ctx.trim().isNotEmpty) {
              setState(() {
                _messages.add({
                  'role': 'assistant',
                  'content': ctx.trim(),
                  'hidden': true,
                });
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
        } else if (hasFinal && isLastStep) {
          _setCaseStepsCompleted(totalPrompts);
          // Показать финальную историю (если задана), затем предложить кнопку возврата
          final fs = widget.finalStory?.trim();
          if (fs != null && fs.isNotEmpty) {
            setState(() {
              _messages.add({'role': 'assistant', 'content': fs});
            });
            _scrollToBottom();
          }
          if (!mounted) return;
          // Кнопка в нижнем листе для явного возврата
          // ignore: use_build_context_synchronously
          await showModalBottomSheet(
            context: context,
            showDragHandle: true,
            builder: (ctx) => SafeArea(
              child: Padding(
                padding: AppSpacing.insetsAll(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Кейс завершён',
                      textAlign: TextAlign.center,
                      style: AppTypography.textTheme.titleMedium,
                    ),
                    AppSpacing.gapH(AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        if (mounted) {
                          setState(() => _allowPop = true);
                        }
                        Navigator.of(context, rootNavigator: true)
                            .pop('case_final');
                      },
                      child: const Text('Вернуться в Башню'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Остаться в диалоге'),
                    ),
                  ],
                ),
              ),
            ),
          );
          return;
        }
      }
      // В обычном режиме (не кейс) диалог не закрываем автоматически
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
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'chat',
          level: SentryLevel.warning,
          message: 'chat_send_fail',
          data: {
            'bot': widget.bot,
            'chatId': _chatId ?? '',
            'error_type': e.runtimeType.toString(),
            'caseMode': widget.caseMode,
          },
        ));
      } catch (_) {}
      if (!mounted) return;
      _lastFailedMessage = text;
      setState(() {
        _messages.add({
          'role': 'assistant',
          'type': 'error',
          'content':
              'Не удалось получить ответ. GP не списаны. Можно попробовать ещё раз.',
          'retryText': text,
          'created_at': DateTime.now().toIso8601String(),
        });
      });
      _scrollToBottom();
    } finally {
      if (mounted) setState(() => _isSending = false);
      // Обновляем чипсы после отправки сообщения
      _refreshChipsDebounced();
    }
  }

  List<Map<String, dynamic>> _buildChatContext() {
    final List<Map<String, dynamic>> ctx = _messages
        .where((m) => m['hidden'] != true && m['type'] != 'error')
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
      // ВАЖНО: Добавляем PopScope для контроля закрытия даже в embedded режиме
      return PopScope(
        canPop: _allowPop,
        onPopInvokedWithResult: (didPop, result) {
          // Логируем попытки закрытия для отладки
          assert(() {
            debugPrint(
                'LEO_DIALOG embedded popInvoked didPop=$didPop result=$result allowPop=$_allowPop');
            return true;
          }());

          // В embedded режиме разрешаем закрытие по умолчанию
          // (контроль закрытия осуществляется на уровне родительского Scaffold)
        },
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildInput(),
          ],
        ),
      );
    }
    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        // Важно: фиксируем, когда система пытается закрыть экран.
        // В кейс‑режиме это должно происходить только по явной кнопке.
        assert(() {
          debugPrint(
              'LEO_DIALOG popInvoked didPop=$didPop result=$result allowPop=$_allowPop caseMode=${widget.caseMode}');
          return true;
        }());

        try {
          Sentry.addBreadcrumb(Breadcrumb(
            category: 'nav',
            level: didPop ? SentryLevel.info : SentryLevel.warning,
            message: 'leo_dialog_pop_invoked',
            data: {
              'didPop': didPop,
              'result': result?.toString(),
              'allowPop': _allowPop,
              'caseMode': widget.caseMode,
              'chatId': _chatId,
            },
          ));
        } catch (_) {}
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          automaticallyImplyLeading: !widget.caseMode,
          leading: widget.caseMode
              ? IconButton(
                  tooltip: 'Закрыть',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() => _allowPop = true);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              : null,
          title: Row(
            children: [
              _FloatAvatar(
                radius: 14,
                asset: widget.bot == 'max'
                    ? 'assets/images/avatars/avatar_max.png'
                    : 'assets/images/avatars/avatar_leo.png',
              ),
              const SizedBox(width: 8),
              Text(widget.bot == 'max' ? 'Макс' : 'Лео'),
            ],
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: _buildMessageList()),
                  _buildInput(),
                ],
              ),
              // FAB «Вниз»
              if (_showScrollToBottom)
                Positioned(
                  right: 12,
                  bottom: 90,
                  child: FloatingActionButton.small(
                    heroTag: 'chat_scroll_down',
                    onPressed: _scrollToBottom,
                    child: const Icon(Icons.arrow_downward),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    final visibleMessages =
        _messages.where((m) => m['hidden'] != true).toList();
    return NotificationListener<ScrollNotification>(
      onNotification: (notif) {
        if (notif.metrics.pixels <= 50 && _hasMore) {
          _loadMore();
        }
        return false;
      },
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.s10),
        itemCount:
            visibleMessages.length + (_hasMore ? 1 : 0) + (_isSending ? 1 : 0),
        itemBuilder: (context, index) {
          // 1) Плашка загрузки предыдущих сообщений
          if (_hasMore && index == 0) {
            return Center(
              child: _isLoadingMore
                  ? Padding(
                      padding: AppSpacing.insetsAll(AppSpacing.sm),
                      child: const CircularProgressIndicator())
                  : TextButton(
                      onPressed: _loadMore,
                      child: Text(
                        'Загрузить ещё',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColor.primary),
                      ),
                    ),
            );
          }
          final offset = _hasMore ? 1 : 0;
          final msgIndex = index - offset;
          // 2) Последний элемент — индикатор набора, если ждём ответ
          if (_isSending && msgIndex == visibleMessages.length) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                decoration: BoxDecoration(
                  color: AppColor.appBarColor,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLg).copyWith(
                    topLeft: const Radius.circular(0),
                    topRight: const Radius.circular(AppDimensions.radiusLg),
                  ),
                ),
                child: const TypingIndicator.small(),
              ),
            );
          }
          // 3) Обычные сообщения
          final msg = visibleMessages[msgIndex];
          if (msg['type'] == 'error') {
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85),
                decoration: BoxDecoration(
                  color: AppColor.colorErrorLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg)
                      .copyWith(topLeft: const Radius.circular(0)),
                  border: Border.all(
                      color: AppColor.colorError.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg['content']?.toString() ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColor.colorTextPrimary,
                          ),
                    ),
                    AppSpacing.gapH(AppSpacing.s6),
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              msg['hidden'] = true;
                              setState(() {});
                              final retryText = msg['retryText']?.toString() ??
                                  _lastFailedMessage ??
                                  '';
                              if (retryText.isEmpty) return;
                              _sendMessageInternal(
                                retryText,
                                isRetry: true,
                              );
                            },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }
          final isUser = msg['role'] == 'user';
          final bubble = LeoMessageBubble(
            text: msg['content'] as String? ?? '',
            isUser: isUser,
          );
          // Метка времени (компактно)
          final ts = msg['created_at'] as String?;
          final timeWidget = (ts != null)
              ? Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: Text(
                    _formatTime(ts),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.black45),
                  ),
                )
              : const SizedBox.shrink();
          // Лёгкая анимация появления только для последних 6 элементов,
          // чтобы избежать нагрузки на длинные списки
          final bool animate = index >=
              ((_hasMore ? 1 : 0) + (_isSending ? 1 : 0) + _messages.length - 6)
                  .clamp(0, _messages.length + 2);
          if (!animate) {
            return Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [bubble, timeWidget],
            );
          }
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, (1 - v) * 20),
                child: child,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [bubble, timeWidget],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInput() {
    final bool isCaseMode = widget.caseMode;
    final String inputHint =
        isCaseMode ? 'Напиши своё решение...' : 'Введите сообщение...';
    // SafeArea(bottom: false) - Flutter сам обработает отступы снизу при adjustResize
    // Оставляем только боковые отступы для системных элементов (notch)
    // Когда embedded: true, родительский Scaffold управляет клавиатурой через resizeToAvoidBottomInset.
    // Не добавляем viewInsets.bottom здесь, чтобы избежать двойной компенсации и пустого пространства.
    return SafeArea(
      bottom: false,
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
                  child: Semantics(
                    label: 'Поле ввода сообщения',
                    child: BizLevelTextField(
                      controller: _inputController,
                      focusNode: _inputFocus,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      preset: TextFieldPreset.chat,
                      hint: inputHint,
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      // Отправка по Enter
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty && !_isSending) {
                          _sendMessage();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  label: 'Скрыть клавиатуру',
                  button: true,
                  child: IconButton(
                    tooltip: 'Скрыть клавиатуру',
                    icon: const Icon(Icons.keyboard_hide),
                    onPressed: () => FocusScope.of(context).unfocus(),
                  ),
                ),
                _isSending
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator())
                    : Semantics(
                        label: 'Отправить сообщение',
                        button: true,
                        child: IconButton(
                          key: const Key('chat_send_button'),
                          tooltip: 'Отправить',
                          icon: const Icon(Icons.send),
                          color: AppColor.primary,
                          onPressed: _sendMessage,
                        ),
                      ),
              ],
            ),
            if (isCaseMode) ...[
              const SizedBox(height: 6),
              Text(
                '2-3 предложения своими словами. Лео прокомментирует',
                style: AppTypography.captionSmall.copyWith(
                  color: AppColor.colorTextTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChipsRow() {
    if (widget.caseMode) return const SizedBox.shrink();
    // Скрываем при наборе текста или если пользователь свернул подсказки
    if ((_inputFocus.hasFocus && _inputController.text.trim().isNotEmpty) ||
        !_showSuggestions) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _showSuggestions = true),
          icon: const Icon(Icons.tips_and_updates_outlined, size: 18),
          label: const Text('Показать подсказки'),
        ),
      );
    }
    final chips = _resolveRecommendedChips();
    if (chips.isEmpty) return const SizedBox.shrink();
    final visible = chips.length > 4 ? chips.sublist(0, 4) : chips;
    final hidden = chips.length > 4 ? chips.sublist(4) : const <String>[];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            if (i < visible.length) {
              final text = visible[i];
              return _SuggestionCard(
                text: text,
                icon: text.contains('?')
                    ? Icons.help_outline
                    : Icons.lightbulb_outline,
                onTap: () {
                  _applySuggestion(text);
                },
              );
            }
            // Кнопка «Ещё…»
            return OutlinedButton.icon(
              onPressed: () => _showMoreSuggestions(hidden),
              icon: const Icon(Icons.more_horiz),
              label: const Text('Ещё…'),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: visible.length + (hidden.isNotEmpty ? 1 : 0),
        ),
      ),
    );
  }

  void _applySuggestion(String text) {
    // Эвристика: если подсказка предлагает открыть артефакт/материал — ведём на экран артефактов
    final lower = text.toLowerCase();
    if (lower.contains('артефакт') || lower.startsWith('открыть:')) {
      try {
        GoRouter.of(context).push('/artifacts');
        return;
      } catch (e) {
        // ignore: avoid_print
        print('Error navigating to artifacts: $e');
      }
    }
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        level: SentryLevel.info,
        category: widget.bot == 'max' ? 'goal' : 'leo',
        message: widget.bot == 'max'
            ? 'goal_checkpoint_max_suggestion_applied'
            : 'leo_suggestion_applied',
        data: {
          'suggestion_text':
              text.length > 50 ? '${text.substring(0, 50)}...' : text,
          'bot': widget.bot,
        },
      ));
    } catch (_) {}
    _inputController.text = text;
    _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.text.length));
    _inputFocus.requestFocus();
    setState(() {
      _dismissedChips.add(text);
      _showSuggestions = false;
    });
  }

  Future<void> _showMoreSuggestions(List<String> hidden) async {
    if (hidden.isEmpty) return;
    // ignore: use_build_context_synchronously
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (ctx, i) {
            final text = hidden[i];
            return ListTile(
              leading: Icon(
                text.contains('?')
                    ? Icons.help_outline
                    : Icons.lightbulb_outline,
              ),
              title: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
              onTap: () {
                Navigator.of(ctx).pop();
                _applySuggestion(text);
              },
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: hidden.length,
        ),
      ),
    );
  }

  String _formatTime(String ts) {
    try {
      final dt = DateTime.tryParse(ts);
      if (dt == null) return '';
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    } catch (_) {
      return '';
    }
  }

  List<String> _resolveRecommendedChips() {
    // Временно показываем ТОЛЬКО серверные чипсы (без мерджа и без фильтра dismissed)
    if (_serverRecommendedChips.isNotEmpty) {
      final clean =
          _serverRecommendedChips.where((e) => e.trim().isNotEmpty).toList();
      return clean.length > 6 ? clean.sublist(0, 6) : clean;
    }
    final fromWidget = widget.recommendedChips ?? const [];
    final local = _localChipsFallback();
    final fallback = <String>{...fromWidget, ...local}
        .where((e) => e.trim().isNotEmpty)
        .where((e) => !_dismissedChips.contains(e))
        .toList();
    return fallback.length > 6 ? fallback.sublist(0, 6) : fallback;
  }

  List<String> _localChipsFallback() {
    // Клиентский фолбэк
    if (widget.bot == 'max') {
      // По версии цели в userContext
      final ctx = widget.userContext ?? '';
      final match = RegExp(r'goal_version:\s*(\d+)').firstMatch(ctx);
      final v = match != null ? int.tryParse(match.group(1) ?? '') : null;
      switch (v) {
        case 1:
          return const [
            '💰 Выручка',
            '👥 Кол-во клиентов',
            '⏱ Время на задачи',
            '📊 Конверсия %',
            '✏️ Другое',
          ];
        case 2:
          return const [
            'Текущее значение метрики',
            'Целевое значение',
            'Реалистична ли цель?',
          ];
        case 3:
          return const [
            'Неделя 1: фокус',
            'Неделя 2: фокус',
            'Неделя 3: фокус',
            'Неделя 4: фокус',
          ];
        case 4:
          return const [
            'Готовность 7/10',
            'Назначить дату старта',
            'Первый шаг завтра',
          ];
        default:
          // Общий старт без контекста
          return const [
            'Уточнить цель',
            'Поставить метрику',
            'Определить дату старта',
            'Сформулировать ближайший шаг',
          ];
      }
    } else {
      // Leo: базовый фолбэк по уровню
      int lvl = 0;
      try {
        final lc = widget.levelContext ?? '';
        final m1 = RegExp(r'level[_ ]?id\s*[:=]\s*(\d+)', caseSensitive: false)
            .firstMatch(lc);
        final m2 = RegExp(r'current_level\s*[:=]\s*(\d+)', caseSensitive: false)
            .firstMatch(lc);
        lvl = int.tryParse((m1?.group(1) ?? m2?.group(1) ?? '0')) ?? 0;
      } catch (_) {}
      if (lvl <= 0) {
        return const [
          'С чего начать (ур.1)',
          'Объясни SMART просто',
          'Пример из моей сферы',
          'Дай микро‑шаг',
        ];
      }
      return [
        'Как применить на практике',
        'Пример из моей сферы',
        'Разобрать мою задачу',
        'Дай микро‑шаг',
        'Объясни тему ур.$lvl',
      ];
    }
  }
}

class _FloatAvatar extends StatefulWidget {
  final double radius;
  final String asset;
  const _FloatAvatar({required this.radius, required this.asset});

  @override
  State<_FloatAvatar> createState() => _FloatAvatarState();
}

class _FloatAvatarState extends State<_FloatAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  bool get _isLowEndDevice {
    final mq = MediaQuery.maybeOf(context);
    if (mq == null) return true;
    final disableAnimations = View.of(context)
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return mq.devicePixelRatio < 2.0 || disableAnimations;
  }

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _t = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLowEndDevice) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundImage: AssetImage(widget.asset),
        backgroundColor: Colors.transparent,
      );
    }
    return AnimatedBuilder(
      animation: _t,
      builder: (context, child) {
        final dy = (1 - _t.value) * 1.5; // лёгкое «плавание»
        return Transform.translate(
          offset: Offset(0, dy),
          child: child,
        );
      },
      child: CircleAvatar(
        radius: widget.radius,
        backgroundImage: AssetImage(widget.asset),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius10),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.06),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
          border: Border.all(color: AppColor.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColor.labelColor),
            const SizedBox(width: 8),
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
