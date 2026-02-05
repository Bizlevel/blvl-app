import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/providers/ray_service_provider.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/screens/gp_store_screen.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/services/ray_service.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/bizlevel_text_field.dart';
import 'package:bizlevel/widgets/custom_textfield.dart';
import 'package:bizlevel/widgets/leo_message_bubble.dart';
import 'package:bizlevel/widgets/typing_indicator.dart';

class RayDialogScreen extends ConsumerStatefulWidget {
  const RayDialogScreen({super.key, this.chatId});

  final String? chatId;

  @override
  ConsumerState<RayDialogScreen> createState() => _RayDialogScreenState();
}

class _RayDialogScreenState extends ConsumerState<RayDialogScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
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

  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _inputFocus = FocusNode();

  bool _loading = true;
  bool _starting = false;
  bool _sending = false;
  bool _scoring = false;
  final bool _isAnalyzing = false;
  bool _showScrollToBottom = false;
  double _lastViewInsetsBottom = 0.0;

  String? _chatId;
  String? _validationId;
  Map<String, dynamic>? _validationData;
  Map<String, dynamic>? _slotsState;
  Map<String, dynamic>? _onboardingMetadata;

  int _currentStep = 0;
  bool _isComplete = false;

  RayPricing? _pricing;
  String? _reportMarkdown;

  final List<_RayMessage> _messages = [];

  late final AnimationController _focusPulseController;
  late final Animation<double> _focusPulse;

  // Debounce timer
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

    _chatId = widget.chatId;

    // Следим за позицией скролла для показа FAB «вниз»
    _scroll.addListener(() {
      if (!_scroll.hasClients) return;
      final metrics = _scroll.position;
      final distFromBottom = (metrics.maxScrollExtent - metrics.pixels)
          .clamp(0.0, double.infinity);
      final show = distFromBottom > 200;
      if (show != _showScrollToBottom && mounted) {
        setState(() => _showScrollToBottom = show);
      }
    });

    _bootstrap();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _focusPulseController.dispose();
    _controller.dispose();
    _scroll.dispose();
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

  Future<void> _bootstrap() async {
    final ray = ref.read(rayServiceProvider);

    try {
      // Load pricing for the start button label (server is still source of truth).
      final pricing = await ray.getValidationPrice();
      _pricing = pricing;

      if (_chatId != null) {
        // Existing chat: load history and validation.
        final msgs = await ray.loadChatMessages(_chatId!);
        _messages
          ..clear()
          ..addAll(msgs.map((m) {
            final role = (m['role'] as String?) ?? 'assistant';
            final content = (m['content'] as String?) ?? '';
            final createdAt = m['created_at'] as String?;
            return _RayMessage(
              role: role,
              content: content,
              createdAt: createdAt,
            );
          }));

        _validationId = await ray.getValidationIdByChatId(_chatId!);

        if (_validationId != null) {
          final v = await ray.getValidation(_validationId!);
          if (v != null) {
            _validationData = v;
            _currentStep = (v['current_step'] as int?) ?? 0;
            final status = (v['status'] as String?) ?? 'in_progress';
            final report = v['report_markdown'] as String?;
            final slots = v['slots_state'];
            if (slots != null) {
              _applySlotsState(slots);
            }
            if (status == 'completed' && report != null && report.isNotEmpty) {
              _reportMarkdown = report;
              _isComplete = true;
            }
          }
        }
      }
    } catch (_) {
      // ignore, fallback to simple onboarding UI
    }

    // If no chat exists yet, show static onboarding (no LLM call until start).
    if (_chatId == null && _messages.isEmpty) {
      final isFirst = _pricing?.isFree ?? false;
      _messages.add(const _RayMessage(
        role: 'assistant',
        includeInApi: false,
        content: 'Привет! Я Ray — валидатор бизнес‑идей в BizLevel.\n\n'
            'Я задам 7 вопросов по твоей идее и после этого сделаю краткий отчёт: '
            'оценка, сильные стороны, красные флаги и следующий шаг.',
      ));

      // Устанавливаем метаданные онбординга
      setState(() {
        _onboardingMetadata = {
          'price': isFirst ? 0 : RayService.kValidationCostGp,
          'is_free': isFirst,
          'actions': [
            {
              'id': 'start_validation',
              'label': isFirst
                  ? 'Начать проверку (Бесплатно)'
                  : 'Начать проверку (${RayService.kValidationCostGp} GP)',
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
    }

    if (mounted) {
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
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

  List<Map<String, dynamic>> _edgeMessages() {
    // `ray-chat` expects chat completion format.
    return _messages
        .where((m) => m.includeInApi && m.content.trim().isNotEmpty)
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();
  }

  Future<void> _showRayAbout() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Что умеет Ray'),
        content: const Text(
          'Ray помогает проверить бизнес‑идею на прочность:\n'
          '- уточняет продукт, проблему и аудиторию\n'
          '- ищет слепые зоны и риски\n'
          '- предлагает простой следующий шаг\n'
          '- формирует итоговый отчёт.\n\n'
          'Чтобы не тратить ресурсы впустую, Ray начинает работу только после старта проверки.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Ок'),
          ),
        ],
      ),
    );
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
          'Первая валидация бесплатно, повторные — ${RayService.kValidationCostGp} GP.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _goToGpStore();
            },
            child: const Text('Пополнить GP'),
          ),
        ],
      ),
    );
  }

  Future<void> _goToGpStore() async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GpStoreScreen()),
    );
  }

  Widget _buildOnboardingActions() {
    final onboardingMeta = _onboardingMetadata;
    if (onboardingMeta == null) return const SizedBox.shrink();

    final price =
        onboardingMeta['price'] as int? ?? RayService.kValidationCostGp;
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _sending
                    ? null
                    : () => _handleStartValidation(price, isFree),
              ),
            ),

          const SizedBox(height: 12),

          // Вторичная кнопка "А что ты умеешь?"
          if (actions.length > 1)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _sending
                    ? null
                    : () {
                        _controller.text =
                            'Расскажи подробнее, как ты работаешь и зачем ты нужен?';
                        _send();
                      },
                child: const Text('А что ты умеешь?'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleStartValidation(int price, bool isFree) async {
    if (_sending) return;

    // Проверяем баланс для платной валидации (опционально на фронтенде)
    // Финальная проверка будет на бэкенде при списании GP
    if (!isFree) {
      try {
        // Обновляем баланс перед проверкой
        final balanceMap = await ref.read(gpBalanceProvider.future);
        final balance = balanceMap['balance'] ?? 0;
        if (balance < price) {
          if (mounted) {
            _showInsufficientGpDialog(price);
          }
          return;
        }
      } catch (e) {
        // Если не удалось проверить баланс на фронтенде, продолжаем
        // Финальная проверка будет на бэкенде при списании GP
        debugPrint(
            'Failed to check GP balance on frontend, will check on backend: $e');
      }
    }

    await _startValidation();
  }

  Future<void> _startValidation() async {
    if (_starting) return;
    final ray = ref.read(rayServiceProvider);

    setState(() => _starting = true);
    try {
      // Ensure chat + validation exist before calling `ray-chat` so we keep history and logging.
      _chatId ??= await ray.createChat();
      _validationId ??= await ray.createValidation(chatId: _chatId!);

      // Start validation. Important: no user message here -> server returns the first question without LLM cost.
      final res = await ray.dialog(
        validationId: _validationId!,
        messages: const [
          {'role': 'assistant', 'content': 'start'}
        ],
        action: 'start_validation',
      );

      final msg = res['message'];
      final content = (msg is Map ? (msg['content'] as String?) : null) ?? '';
      final meta = res['metadata'] as Map<String, dynamic>?;

      if (meta != null) {
        _currentStep = (meta['current_step'] as int?) ?? 1;
        _isComplete = (meta['is_complete'] as bool?) ?? false;

        // Применяем slots_state если он есть
        final slotsState = meta['slots_state'];
        if (slotsState != null) {
          _applySlotsState(slotsState);
        }

        // Обновляем onboarding metadata
        setState(() {
          _onboardingMetadata = null; // Скрываем кнопки онбординга
        });
      }

      if (content.trim().isNotEmpty) {
        final now = DateTime.now().toIso8601String();
        _messages.add(_RayMessage(
          role: 'assistant',
          content: content,
          createdAt: now,
        ));
        await ray.saveConversationMessage(
          chatId: _chatId!,
          role: 'assistant',
          content: content,
        );
      }

      // Refresh cached GP balance in background (server might have spent 20 GP).
      ray.refreshGpBalanceCache();
      _scrollToBottom();

      // После старта показываем ввод и мягко фокусируем его (без дёрганий iOS input-session).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _inputFocus.requestFocus();
      });
    } on RayFailure catch (e) {
      if (!mounted) return;
      if (e.statusCode == 402 || e.code == 'insufficient_gp') {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Недостаточно GP'),
            content: const Text(
              'Для повторной проверки идеи нужно 20 GP. Пополните баланс и попробуйте снова.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Позже'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await _goToGpStore();
                },
                child: const Text('Пополнить GP'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    // Отменяем предыдущий таймер debounce
    _debounceTimer?.cancel();

    // Устанавливаем новый таймер debounce
    _debounceTimer = Timer(_debounceDelay, () async {
      await _sendInternal(text);
    });
  }

  Future<void> _sendInternal(String text) async {
    if (_sending || !mounted) return;
    if (_validationId == null || _chatId == null) {
      await _startValidation();
      if (_validationId == null || _chatId == null) return;
    }

    _controller.clear();

    final ray = ref.read(rayServiceProvider);

    setState(() => _sending = true);
    try {
      final now = DateTime.now().toIso8601String();
      _messages.add(_RayMessage(role: 'user', content: text, createdAt: now));
      await ray.saveConversationMessage(
        chatId: _chatId!,
        role: 'user',
        content: text,
      );
      _scrollToBottom();

      final res = await ray.dialog(
        validationId: _validationId!,
        messages: _edgeMessages(),
      );

      final msg = res['message'];
      final content = (msg is Map ? (msg['content'] as String?) : null) ?? '';
      final meta = res['metadata'] as Map<String, dynamic>?;

      if (meta != null) {
        _currentStep = (meta['current_step'] as int?) ?? _currentStep;
        _isComplete = (meta['is_complete'] as bool?) ?? _isComplete;

        // Применяем slots_state если он есть
        final slotsState = meta['slots_state'];
        if (slotsState != null) {
          _applySlotsState(slotsState);
        }
      }

      if (content.trim().isNotEmpty) {
        _messages.add(_RayMessage(role: 'assistant', content: content));
        await ray.saveConversationMessage(
          chatId: _chatId!,
          role: 'assistant',
          content: content,
        );
      }

      _scrollToBottom();
    } on RayFailure catch (e) {
      if (!mounted) return;
      if (e.statusCode == 402) {
        // Недостаточно GP
        final required = e.code == 'insufficient_gp'
            ? RayService.kValidationCostGp
            : RayService.kValidationCostGp;
        _showInsufficientGpDialog(required);
      } else {
        _showError(e.message);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _score() async {
    if (_scoring) return;
    if (_validationId == null) return;

    // Когда показываем отчёт, удобнее скрыть клавиатуру.
    FocusScope.of(context).unfocus();

    final ray = ref.read(rayServiceProvider);
    setState(() => _scoring = true);
    try {
      final res = await ray.score(
        validationId: _validationId!,
        messages: _edgeMessages(),
      );
      final report = (res['report'] as String?) ?? '';
      if (mounted) {
        setState(() {
          _reportMarkdown = report.isEmpty ? null : report;
        });
      }
      _scrollToBottom();
    } on RayFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _scoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricing = _pricing;
    final startLabel = (pricing == null)
        ? 'Начать проверку'
        : (pricing.isFree
            ? 'Начать проверку (Бесплатно)'
            : 'Начать проверку (${pricing.priceGp} GP)');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage:
                  AssetImage('assets/images/avatars/avatar_12.png'),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 8),
            Text('Ray AI'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Что умеет Ray',
            onPressed: _showRayAbout,
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildProgressBar(),
                  _buildSlotChecklist(),
                  Expanded(
                    child: _reportMarkdown != null
                        ? _buildReportView(_reportMarkdown!)
                        : _buildChatView(startLabel: startLabel),
                  ),
                  if (_reportMarkdown == null) _buildComposer(startLabel),
                ],
              ),
            ),
      floatingActionButton: _showScrollToBottom
          ? FloatingActionButton.small(
              heroTag: 'ray_scroll_down',
              onPressed: _scrollToBottom,
              child: const Icon(Icons.arrow_downward),
            )
          : null,
    );
  }

  Widget _buildProgressBar() {
    // На Step 0 не показываем прогресс-бар
    if (_currentStep == 0) return const SizedBox.shrink();
    final progress = _currentStep / maxSteps;
    return Container(
      height: 4,
      decoration: const BoxDecoration(
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

  Widget _buildHeader() {
    final progress = (_currentStep <= 0) ? 0.0 : (_currentStep / 7.0);
    return Padding(
      padding: AppSpacing.insetsSymmetric(h: AppSpacing.lg, v: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColor.surface.withValues(alpha: 0.0),
                // Placeholder avatar (replace with a dedicated asset later)
                backgroundImage:
                    const AssetImage('assets/images/avatars/avatar_12.png'),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  _isComplete ? 'Готово к анализу' : 'Шаг $_currentStep из 7',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView({required String startLabel}) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _scroll,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.s10,
      ),
      itemCount: _messages.length + (_sending ? 1 : 0),
      itemBuilder: (context, index) {
        // Индикатор набора
        if (_sending && index == _messages.length) {
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

        final m = _messages[index];
        final isUser = m.role == 'user';
        final bubble = LeoMessageBubble(text: m.content, isUser: isUser);

        // Метка времени (если есть в данных)
        final timeWidget = m.createdAt != null
            ? Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 4),
                child: Text(
                  _formatTime(m.createdAt!),
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

  Widget _buildComposer(String startLabel) {
    final hasStarted = _validationId != null && _currentStep > 0;
    final showOnboardingActions =
        _currentStep == 0 && _onboardingMetadata != null;

    return SafeArea(
      bottom: false,
      // Приводим нижнюю панель к паттерну Leo/Max:
      // SafeArea + Padding, без принудительного белого фона, чтобы совпадать с общим градиентом.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showOnboardingActions) _buildOnboardingActions(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Важно: не выключаем TextField во время отправки.
                // На iOS это часто приводит к пересозданию input-session и "подвисанию" клавиатуры.
                if (hasStarted)
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          label: 'Поле ввода ответа',
                          child: BizLevelTextField(
                            controller: _controller,
                            focusNode: _inputFocus,
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.send,
                            preset: TextFieldPreset.chat,
                            hint: 'Ваш ответ…',
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            onSubmitted: (_) {
                              if (_controller.text.trim().isNotEmpty &&
                                  !_sending &&
                                  !_starting) {
                                _send();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Semantics(
                        label: 'Скрыть клавиатуру',
                        button: true,
                        child: IconButton(
                          tooltip: 'Скрыть клавиатуру',
                          icon: const Icon(Icons.keyboard_hide),
                          onPressed: () => FocusScope.of(context).unfocus(),
                        ),
                      ),
                      _sending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Semantics(
                              label: 'Отправить ответ',
                              button: true,
                              child: IconButton(
                                onPressed:
                                    (hasStarted && !_sending && !_starting)
                                        ? _send
                                        : null,
                                icon: const Icon(Icons.send),
                                color: AppColor.primary,
                              ),
                            ),
                    ],
                  ),
                if (_isComplete && !_scoring && _reportMarkdown == null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _score,
                      child: const Text('Показать отчёт'),
                    ),
                  ),
                ],
                if (_scoring) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportView(String markdown) {
    final styleSheet = _buildReportMarkdownStyleSheet(context);
    final recommendedLevels =
        _validationData?['recommended_levels'] as List? ?? [];

    return ListView(
      padding: AppSpacing.insetsAll(AppSpacing.lg),
      children: [
        BizLevelCard(
          tonal: true,
          outlined: true,
          padding: AppSpacing.insetsAll(AppSpacing.lg),
          child: MarkdownBody(
            data: markdown,
            styleSheet: styleSheet,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _reportMarkdown = null);
                },
                child: const Text('Вернуться в чат'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: _goToGpStore,
              child: const Text('Магазин GP'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: markdown));
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Отчёт скопирован')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Скопировать отчёт'),
          ),
        ),
        if (recommendedLevels.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _buildCTAButtons(recommendedLevels),
        ],
      ],
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
                builder: (_) => const LeoDialogScreen(
                  bot: 'max',
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
                builder: (context) => const RayDialogScreen(),
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

  MarkdownStyleSheet _buildReportMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final base = MarkdownStyleSheet.fromTheme(theme);

    final body = AppTypography.textTheme.bodyMedium?.copyWith(
      color: AppColor.textColor,
      height: 1.5,
    );

    final title = AppTypography.textTheme.titleLarge?.copyWith(
      color: AppColor.textColor,
      fontWeight: FontWeight.w700,
    );

    final subtitle = AppTypography.textTheme.titleMedium?.copyWith(
      color: AppColor.textColor,
      fontWeight: FontWeight.w700,
    );

    final codeText = AppTypography.textTheme.bodySmall?.copyWith(
      color: AppColor.textColor,
      fontFamily: 'monospace',
    );

    return base.copyWith(
      p: body,
      strong: body?.copyWith(fontWeight: FontWeight.w700),
      em: body?.copyWith(fontStyle: FontStyle.italic),
      h1: title,
      h2: title?.copyWith(fontSize: (title.fontSize ?? 18) - 2),
      h3: subtitle,
      h4: subtitle?.copyWith(fontSize: (subtitle.fontSize ?? 16) - 1),
      h5: AppTypography.textTheme.titleSmall?.copyWith(
        color: AppColor.textColor,
        fontWeight: FontWeight.w700,
      ),
      h6: AppTypography.textTheme.labelLarge?.copyWith(
        color: AppColor.labelColor,
        fontWeight: FontWeight.w700,
      ),
      listBullet: body?.copyWith(color: AppColor.labelColor),
      a: body?.copyWith(
        color: AppColor.primary,
        decoration: TextDecoration.underline,
      ),
      blockquote: body?.copyWith(color: cs.onSurface),
      blockquotePadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      blockquoteDecoration: BoxDecoration(
        color: AppColor.backgroundInfo,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      code: codeText,
      codeblockPadding: const EdgeInsets.all(12),
      codeblockDecoration: BoxDecoration(
        color: AppColor.appBarColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColor.borderStrong),
        ),
      ),
    );
  }
}

class _RayMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  final bool includeInApi;
  final String? createdAt;

  const _RayMessage({
    required this.role,
    required this.content,
    this.includeInApi = true,
    this.createdAt,
  });
}
