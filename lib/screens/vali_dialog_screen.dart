import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:bizlevel/services/vali_service.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/widgets/leo_message_bubble.dart';
import 'package:bizlevel/widgets/typing_indicator.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

/// Dialog screen for chatting with Vali AI (idea validator).
/// Supports 7-question validation flow, scoring, and report display.
class ValiDialogScreen extends ConsumerStatefulWidget {
  final String? chatId;
  final String? validationId;
  final String? ideaSummary;

  const ValiDialogScreen({
    super.key,
    this.chatId,
    this.validationId,
    this.ideaSummary,
  });

  @override
  ConsumerState<ValiDialogScreen> createState() => _ValiDialogScreenState();
}

class _ValiDialogScreenState extends ConsumerState<ValiDialogScreen>
    with SingleTickerProviderStateMixin {
  static const int maxSteps = 7;
  static const List<String> _slotOrder = [
    'product',
    'problem',
    'audience',
    'validation',
    'competitors',
    'utp',
    'risks',
  ];

  static const Map<String, String> _slotTitles = {
    'product': 'Суть идеи',
    'problem': 'Проблема',
    'audience': 'Целевая аудитория',
    'validation': 'Валидация',
    'competitors': 'Конкуренты',
    'utp': 'Уникальное преимущество',
    'risks': 'Риски',
  };

  static const Map<String, IconData> _slotIcons = {
    'product': Icons.lightbulb_outline,
    'problem': Icons.warning_amber_outlined,
    'audience': Icons.group_outlined,
    'validation': Icons.check_circle_outline,
    'competitors': Icons.track_changes_outlined,
    'utp': Icons.star_outline,
    'risks': Icons.shield_outlined,
  };

  String? _chatId;
  String? _validationId;
  Map<String, dynamic>? _validationData;
  Map<String, dynamic>? _slotsState;

  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final _inputFocus = FocusNode();
  final List<Map<String, dynamic>> _messages = [];

  bool _isSending = false;
  bool _isScoring = false;
  bool _isAnalyzing = false;
  bool _showScrollToBottom = false;
  int _currentStep = 0; // Начинаем с Step 0 (онбординг)
  Map<String, dynamic>? _onboardingMetadata; // Метаданные для кнопок онбординга

  late final ValiService _vali;
  late final AnimationController _focusPulseController;
  late final Animation<double> _focusPulse;

  // Debounce timer
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _focusPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _focusPulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(
        parent: _focusPulseController,
        curve: Curves.easeInOut,
      ),
    );
    _vali = ValiService(Supabase.instance.client);
    _chatId = widget.chatId;
    _validationId = widget.validationId;

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

    // Загружаем валидацию или создаём новую
    _initializeValidation();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusPulseController.dispose();
    _scrollController.dispose();
    _inputController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  Future<void> _initializeValidation() async {
    try {
      // Если передан chatId, но нет validationId, ищем валидацию по chatId
      if (_validationId == null && _chatId != null) {
        _validationData = await _vali.getValidationByChatId(_chatId!);
        if (_validationData != null) {
          _validationId = _validationData!['id'] as String?;
        }
      }

      if (_validationId != null) {
        // Загружаем существующую валидацию
        final validation = await _vali.getValidation(_validationId!);

        if (validation == null) {
          throw ValiFailure('Валидация не найдена');
        }

        final nextStep = validation['current_step'] ?? 0;
        final normalizedSlots = _normalizeSlotsState(validation['slots_state']);
        final status = (validation['status'] as String?) ?? 'in_progress';

        if (!mounted) return;
        setState(() {
          _validationData = validation;
          _slotsState = normalizedSlots;
          _currentStep = nextStep is int ? nextStep : 0;
          _chatId = validation['chat_id'] ?? _chatId;
        });

        if (status == 'completed') {
          return;
        }

        // Загружаем историю сообщений
        if (_chatId != null) {
          await _loadMessages();
        }
      } else {
        // Создаём новую валидацию
        _validationId = await _vali.createValidation(
          chatId: _chatId,
          ideaSummary: widget.ideaSummary,
        );

        // Добавляем приветственное сообщение от Валли
        if (mounted) {
          // Проверяем, первая ли это валидация (для определения цены)
          final isFirst = await _vali.isFirstValidation();
          
          setState(() {
            _currentStep = 0; // Устанавливаем Step 0 для онбординга
            _messages.add({
              'role': 'assistant',
              'content': 'Привет! Я Валли 🤖 Я здесь, чтобы сэкономить тебе время и деньги. '
                  'Вместо того чтобы пилить продукт полгода, давай проверим твою идею за 10 минут. '
                  'Я задам вопросы, найду слабые места и дам отчет.\n\n'
                  'Готов начать или хочешь узнать обо мне больше?',
              'created_at': DateTime.now().toIso8601String(),
            });
            
            // Устанавливаем метаданные онбординга локально (кнопки появятся сразу)
            _onboardingMetadata = {
              'price': isFirst ? 0 : ValiService.kValidationCostGp,
              'is_free': isFirst,
              'actions': [
                {
                  'id': 'start_validation',
                  'label': isFirst 
                      ? 'Начать проверку (Бесплатно)' 
                      : 'Начать проверку (${ValiService.kValidationCostGp} GP)',
                  'is_primary': true,
                },
                {
                  'id': 'ask_about',
                  'label': 'А что ты умеешь?',
                  'is_primary': false,
                },
              ],
            };
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Не удалось загрузить валидацию: $e');
    }
  }

  Future<void> _loadMessages() async {
    if (_chatId == null) return;

    try {
      final data = await Supabase.instance.client
          .from('leo_messages')
          .select('role, content, created_at')
          .eq('chat_id', _chatId!)
          .order('created_at', ascending: true);

      final fetched = List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e as Map)));

      if (!mounted) return;
      setState(() {
        _messages.clear();
        _messages.addAll(fetched);
      });

      _scrollToBottom();
    } catch (e) {
      debugPrint('Failed to load messages: $e');
    }
  }

  Map<String, dynamic>? _normalizeSlotsState(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return Map<String, dynamic>.from(raw);
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(
        raw.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    return null;
  }

  void _applySlotsState(dynamic raw) {
    final normalized = _normalizeSlotsState(raw);
    if (normalized == null) return;
    if (!mounted) return;
    setState(() {
      _slotsState = normalized;
    });
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
    if (_isSending || !mounted) return;

    setState(() {
      _isSending = true;
      _messages.add({'role': 'user', 'content': text});
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      // Сохраняем сообщение пользователя в БД
      _chatId = await _vali.saveConversation(
        role: 'user',
        content: text,
        chatId: _chatId,
        validationId: _validationId,
      );

      // Отправляем в Edge Function (режим dialog)
      final response = await _vali.sendMessage(
        messages: _buildChatContext(),
        validationId: _validationId,
      );

      final assistantMessage = response['message']['content'] as String? ?? '';
      final meta = response['metadata'] as Map<String, dynamic>?;

      // Сохраняем метаданные онбординга если они есть
      if (meta?['onboarding'] != null) {
        setState(() {
          _onboardingMetadata = meta!['onboarding'] as Map<String, dynamic>?;
        });
      } else {
        setState(() {
          _onboardingMetadata = null; // Скрываем кнопки онбординга когда перешли на Step 1+
        });
      }

      // Проверяем флаг завершения валидации от backend
      final bool isComplete = meta?['is_complete'] == true;

      // Текущий шаг на backend
      final int backendStep = meta != null && meta['current_step'] is int
          ? meta['current_step'] as int
          : _currentStep;

      // Сохраняем ответ Валли в БД
      await _vali.saveConversation(
        role: 'assistant',
        content: assistantMessage,
        chatId: _chatId,
        validationId: _validationId,
      );

      if (!mounted) return;
      setState(() {
        _messages.add({'role': 'assistant', 'content': assistantMessage});
        _currentStep = backendStep;
      });

      _applySlotsState(meta?['slots_state']);

      // Обновляем прогресс в БД
      if (_validationId != null) {
        await _vali.updateValidationProgress(
          validationId: _validationId!,
          currentStep: backendStep,
        );
      }

      // Обновляем баланс GP в фоне
      try {
        ref.invalidate(gpBalanceProvider);
      } catch (_) {}

      _scrollToBottom();

      // Если валидация завершена (backend вернул is_complete), показываем диалог
      if (isComplete && mounted) {
        setState(() => _isAnalyzing = true);
        await _showCompletionDialog();
      }
    } on ValiFailure catch (e) {
      if (!mounted) return;

      if (e.statusCode == 402) {
        // Недостаточно GP
        _showInsufficientGpDialog(e.data?['required'] ?? ValiService.kValidationCostGp);
      } else {
        _showError(e.message);
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Ошибка: $e');

      try {
        await Sentry.captureException(e);
      } catch (_) {}
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _showCompletionDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Готов узнать результат?'),
        content: const Text(
          'Ты ответил на все 7 вопросов. Давай проанализирую твою идею '
          'и покажу, что уже хорошо, а где есть слепые зоны.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Ещё подумаю'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Показать результат'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _requestScoring();
    } else if (confirmed == false && mounted) {
      // Пользователь отказался — снимаем флаг анализа
      setState(() => _isAnalyzing = false);
    }
  }

  Future<void> _requestScoring() async {
    if (_validationId == null || _isScoring) return;

    setState(() => _isScoring = true);

    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'vali',
        message: 'validation_scoring_start',
        data: {'validationId': _validationId},
      ));

      // Показываем индикатор анализа
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Анализирую твою идею...'),
              ],
            ),
            duration: Duration(hours: 1), // Закроем вручную
          ),
        );
      }

      // Запрашиваем скоринг
      final result = await _vali.scoreValidation(
        messages: _buildChatContext(),
        validationId: _validationId!,
      );

      // Закрываем snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Обновляем данные валидации
      _validationData = await _vali.getValidation(_validationId!);

      if (!mounted) return;
      setState(() {});

      Sentry.addBreadcrumb(Breadcrumb(
        category: 'vali',
        message: 'validation_scoring_complete',
        data: {
          'validationId': _validationId,
          'totalScore': result['scores']?['total'],
        },
      ));
    } on ValiFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showError('Ошибка анализа: ${e.message}');
      setState(() => _isAnalyzing = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showError('Не удалось проанализировать идею: $e');
      setState(() => _isAnalyzing = false);

      try {
        await Sentry.captureException(e);
      } catch (_) {}
    } finally {
      if (mounted) setState(() => _isScoring = false);
    }
  }

  List<Map<String, dynamic>> _buildChatContext() {
    return _messages
        .map((m) => {'role': m['role'], 'content': m['content']})
        .toList();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showInsufficientGpDialog(int required) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Недостаточно GP'),
        content: Text(
          'Для валидации идеи нужно $required GP.\n\n'
          'Первая валидация бесплатно, повторные — ${ValiService.kValidationCostGp} GP.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push('/gp-store');
            },
            child: const Text('Пополнить GP'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Если валидация завершена, показываем отчёт
    if (_validationData?['status'] == 'completed') {
      return _buildReportView();
    }

    // Обычный диалоговый режим
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 14,
              backgroundImage:
                  AssetImage('assets/images/avatars/avatar_vali.png'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 8),
            const Text('Валли'),
            const Spacer(),
            // Индикатор прогресса
            Text(
              '$_currentStep/$maxSteps',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
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
                // Динамический чек-лист (скрыт на Step 0)
                _buildSlotChecklist(),
                // Прогресс-бар (скрыт на Step 0)
                _buildProgressBar(),
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
                  heroTag: 'vali_scroll_down',
                  onPressed: _scrollToBottom,
                  child: const Icon(Icons.arrow_downward),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildProgressBar() {
    // На Step 0 не показываем прогресс-бар
    if (_currentStep == 0) return const SizedBox.shrink();
    final progress = _currentStep / maxSteps;
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: AppColor.borderColor,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotChecklist() {
    // На Step 0 не показываем чек-лист
    if (_currentStep == 0) return const SizedBox.shrink();
    final slots = (_slotsState?['slots'] as Map<String, dynamic>?) ?? {};
    final currentIndex = (_currentStep - 1).clamp(0, _slotOrder.length - 1);
    final currentSlotKey = _slotOrder[currentIndex];
    final activeLabel = _slotTitles[currentSlotKey];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColor.glassSurfaceStrong,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                _slotOrder.length,
                (index) => _buildSlotIndicator(
                  _slotOrder[index],
                  index,
                  slots,
                ),
              ),
            ),
          ),
          if (activeLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              activeLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColor.labelColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSlotIndicator(
    String slotKey,
    int index,
    Map<String, dynamic> slots,
  ) {
    final slotData = slots[slotKey];
    final status = slotData is Map ? slotData['status'] as String? : null;
    final normalizedStatus = status ?? 'empty';
    final isCurrent = _currentStep == index + 1;
    final baseColor = _colorForStatus(normalizedStatus);
    final backgroundColor =
        isCurrent ? AppColor.info : baseColor.withOpacity(0.95);
    final icon = _slotIcons[slotKey] ?? Icons.circle_outlined;

    final circle = CircleAvatar(
      radius: 20,
      backgroundColor: backgroundColor,
      child: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: _slotTitles[slotKey] ?? 'Этап ${index + 1}',
        child: isCurrent && !_isAnalyzing
            ? ScaleTransition(
                scale: _focusPulse,
                child: circle,
              )
            : circle,
      ),
    );
  }

  Color _colorForStatus(String status) {
    switch (status) {
      case 'filled':
        return AppColor.success;
      case 'partial':
      case 'skipped_by_retry':
        return AppColor.warning;
      default:
        return AppColor.inActiveColor;
    }
  }

  Widget _buildMessageList() {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.s10),
      itemCount: _messages.length + (_isSending ? 1 : 0),
      itemBuilder: (context, index) {
        // Индикатор набора
        if (_isSending && index == _messages.length) {
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

        final msg = _messages[index];
        final isUser = msg['role'] == 'user';
        final bubble = LeoMessageBubble(
          text: msg['content'] as String? ?? '',
          isUser: isUser,
        );

        // Метка времени
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

        // Анимация для последних 6 сообщений
        final bool animate =
            index >= (_messages.length - 6).clamp(0, _messages.length);
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
    );
  }

  Widget _buildInput() {
    // Показываем кнопки онбординга когда currentStep === 0
    final showOnboardingActions = _currentStep == 0 && _onboardingMetadata != null;
    
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Кнопки онбординга (над полем ввода)
          if (showOnboardingActions) _buildOnboardingActions(),
          
          // Поле ввода
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    focusNode: _inputFocus,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: _currentStep == 0 
                          ? 'Задай вопрос о валидации...' 
                          : 'Введите ответ...',
                      border: const OutlineInputBorder(),
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty && !_isSending) {
                        _sendMessage();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Скрыть клавиатуру',
                  icon: const Icon(Icons.keyboard_hide),
                  onPressed: () => FocusScope.of(context).unfocus(),
                ),
                _isSending
                    ? const SizedBox(
                        width: 24, height: 24, child: CircularProgressIndicator())
                    : IconButton(
                        tooltip: 'Отправить',
                        icon: const Icon(Icons.send),
                        color: AppColor.primary,
                        onPressed: _sendMessage,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingActions() {
    final onboardingMeta = _onboardingMetadata;
    if (onboardingMeta == null) return const SizedBox.shrink();

    final price = onboardingMeta['price'] as int? ?? ValiService.kValidationCostGp;
    final isFree = onboardingMeta['is_free'] as bool? ?? false;
    final actions = onboardingMeta['actions'] as List? ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Главная кнопка "Начать проверку"
          if (actions.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.rocket_launch),
                label: Text(
                  isFree 
                      ? 'Начать проверку (Бесплатно)' 
                      : 'Начать проверку ($price GP)',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFree ? AppColor.success : AppColor.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _isSending ? null : () => _handleStartValidation(price, isFree),
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Вторичная кнопка "А что ты умеешь?"
          if (actions.length > 1)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                child: const Text('А что ты умеешь?'),
                onPressed: _isSending ? null : () {
                  _inputController.text = 'Расскажи подробнее, как ты работаешь и зачем ты нужен?';
                  _sendMessage();
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleStartValidation(int price, bool isFree) async {
    if (_isSending) return;

    // Проверяем баланс для платной валидации (опционально на фронтенде)
    // Финальная проверка будет на бэкенде при списании GP
    if (!isFree) {
      try {
        // Обновляем баланс перед проверкой
        ref.invalidate(gpBalanceProvider);
        final balanceMap = await ref.read(gpBalanceProvider.future);
        final balance = (balanceMap['balance'] ?? 0) as int;
        if (balance < price) {
          if (mounted) {
            _showInsufficientGpDialog(price);
          }
          return;
        }
      } catch (e) {
        // Если не удалось проверить баланс на фронтенде, продолжаем
        // Финальная проверка будет на бэкенде при списании GP
        debugPrint('Failed to check GP balance on frontend, will check on backend: $e');
      }
    }

    // Отправляем action: 'start_validation' для перехода на Step 1
    setState(() {
      _isSending = true;
    });

    try {
      final response = await _vali.sendMessage(
        messages: _buildChatContext(),
        validationId: _validationId,
        action: 'start_validation',
      );

      final assistantMessage = response['message']['content'] as String? ?? '';
      final meta = response['metadata'] as Map<String, dynamic>?;
      final int backendStep = meta != null && meta['current_step'] is int
          ? meta['current_step'] as int
          : 1;

      // Сохраняем ответ Валли в БД
      await _vali.saveConversation(
        role: 'assistant',
        content: assistantMessage,
        chatId: _chatId,
        validationId: _validationId,
      );

      if (!mounted) return;
      setState(() {
        _messages.add({'role': 'assistant', 'content': assistantMessage});
        _currentStep = backendStep;
        _onboardingMetadata = null; // Скрываем кнопки онбординга
        _isSending = false;
      });

      _applySlotsState(meta?['slots_state']);

      // Обновляем прогресс в БД
      if (_validationId != null) {
        await _vali.updateValidationProgress(
          validationId: _validationId!,
          currentStep: backendStep,
        );
      }

      // Обновляем баланс GP
      try {
        ref.invalidate(gpBalanceProvider);
      } catch (_) {}

      _scrollToBottom();
    } on ValiFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
      });

      if (e.statusCode == 402) {
        _showInsufficientGpDialog(e.data?['required'] ?? ValiService.kValidationCostGp);
      } else {
        _showError(e.message);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
      });
      _showError('Ошибка: $e');
    }
  }


  Widget _buildReportView() {
    final reportRaw = _validationData?['report_markdown'] as String? ?? '';

    // Нормализуем markdown-отчёт:
    // - убираем текстовые разделители "----" и "━━━"
    // - конвертируем HTML-переносы <br> в обычные переводы строк
    // - схлопываем тройные переводы строк
    final report = reportRaw
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'^----+$', multiLine: true), '')
        .replaceAll(RegExp(r'^━━━+$', multiLine: true), '')
        .replaceAll(RegExp(r'\n{3,}', multiLine: true), '\n\n')
        .trim();
    final totalScore = _validationData?['total_score'] as int? ?? 0;
    final archetype = _validationData?['archetype'] as String? ?? 'МЕЧТАТЕЛЬ';
    final recommendedLevels =
        _validationData?['recommended_levels'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Text('Результат валидации'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Карточка с баллом
            Card(
              color: AppColor.surface,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      '$totalScore/100',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      archetype,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Markdown отчёт
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: MarkdownBody(
                  data: report,
                  styleSheet: MarkdownStyleSheet(
                    p: Theme.of(context).textTheme.bodyMedium,
                    h1: Theme.of(context).textTheme.titleLarge,
                    h2: Theme.of(context).textTheme.titleMedium,
                    strong: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // CTA кнопки
            _buildCTAButtons(recommendedLevels),
          ],
        ),
      ),
    );
  }

  Widget _buildCTAButtons(List recommendedLevels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Кнопка "Пройти рекомендованный уровень"
        if (recommendedLevels.isNotEmpty)
          Builder(
            builder: (context) {
              final firstLevel = recommendedLevels.first;
              // Обрабатываем разные форматы данных
              Map<String, dynamic> levelData;
              if (firstLevel is Map) {
                levelData = Map<String, dynamic>.from(firstLevel);
              } else {
                levelData = {'level_number': 1, 'name': 'урок'};
              }

              final levelNumber = levelData['level_number'] as int? ??
                  (levelData['level_id'] as int?);
              final levelName = levelData['name'] as String? ??
                  (levelData['title'] as String?);

              // Если levelNumber не найден, не показываем кнопку
              if (levelNumber == null) {
                return const SizedBox.shrink();
              }

              return ElevatedButton.icon(
                onPressed: () async {
                  // Проверяем текущий уровень пользователя
                  try {
                    final currentLevel =
                        await ref.read(currentLevelNumberProvider.future);

                    if (currentLevel < levelNumber) {
                      // Пользователь ещё не достиг этого уровня
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Вы ещё не достигли этого уровня. Сначала пройдите предыдущие уровни.'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                      return;
                    }

                    // Уровень доступен — переходим
                    if (mounted) {
                      context.push('/levels/$levelNumber');
                    }
                  } catch (e) {
                    // В случае ошибки логируем и всё равно переходим
                    debugPrint('Failed to check user level: $e');
                    if (mounted) {
                      context.push('/levels/$levelNumber');
                    }
                  }
                },
                icon: const Icon(Icons.school),
                label: Text(
                  levelName != null
                      ? 'Пройти $levelName'
                      : 'Пройти урок $levelNumber',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              );
            },
          ),
        const SizedBox(height: AppSpacing.md),

        // Кнопка "Поставить цель с Максом"
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LeoDialogScreen(
                  bot: 'max',
                  userContext: null,
                  levelContext: null,
                ),
              ),
            );
          },
          icon: const Icon(Icons.flag),
          label: const Text('Поставить цель с Максом'),
        ),
        const SizedBox(height: AppSpacing.md),

        // Кнопка "Проверить другую идею"
        OutlinedButton.icon(
          onPressed: () {
            // Создаём новую валидацию
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ValiDialogScreen(),
              ),
            );
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Проверить другую идею'),
        ),
        const SizedBox(height: AppSpacing.md),

        // Кнопка "Назад"
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Вернуться в Башню'),
        ),
      ],
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
}
