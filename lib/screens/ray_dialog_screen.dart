import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/providers/ray_service_provider.dart';
import 'package:bizlevel/screens/gp_store_screen.dart';
import 'package:bizlevel/services/ray_service.dart';
import 'package:bizlevel/theme/color.dart' show AppColor;
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/leo_message_bubble.dart';
import 'package:bizlevel/widgets/typing_indicator.dart';

class RayDialogScreen extends ConsumerStatefulWidget {
  const RayDialogScreen({super.key, this.chatId});

  final String? chatId;

  @override
  ConsumerState<RayDialogScreen> createState() => _RayDialogScreenState();
}

class _RayDialogScreenState extends ConsumerState<RayDialogScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _inputFocus = FocusNode();

  bool _loading = true;
  bool _starting = false;
  bool _sending = false;
  bool _scoring = false;

  String? _chatId;
  String? _validationId;

  int _currentStep = 0;
  bool _isComplete = false;

  RayPricing? _pricing;
  String? _reportMarkdown;

  final List<_RayMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _chatId = widget.chatId;
    _bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _inputFocus.dispose();
    super.dispose();
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
            return _RayMessage(role: role, content: content);
          }));

        _validationId = await ray.getValidationIdByChatId(_chatId!);

        if (_validationId != null) {
          final v = await ray.getValidation(_validationId!);
          if (v != null) {
            _currentStep = (v['current_step'] as int?) ?? 0;
            final status = (v['status'] as String?) ?? 'in_progress';
            final report = v['report_markdown'] as String?;
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
      _messages.add(const _RayMessage(
        role: 'assistant',
        includeInApi: false,
        content:
            'Привет! Я Ray — валидатор бизнес‑идей в BizLevel.\n\n'
            'Я задам 7 вопросов по твоей идее и после этого сделаю краткий отчёт: '
            'оценка, сильные стороны, красные флаги и следующий шаг.',
      ));
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

  Future<void> _goToGpStore() async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GpStoreScreen()),
    );
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
      final meta = res['metadata'];
      _currentStep = (meta is Map ? (meta['current_step'] as int?) : null) ?? 1;
      _isComplete =
          (meta is Map ? (meta['is_complete'] as bool?) : null) ?? false;

      if (content.trim().isNotEmpty) {
        _messages.add(_RayMessage(role: 'assistant', content: content));
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
    if (_sending) return;
    if (_validationId == null || _chatId == null) {
      await _startValidation();
      if (_validationId == null || _chatId == null) return;
    }

    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    final ray = ref.read(rayServiceProvider);

    setState(() => _sending = true);
    try {
      _messages.add(_RayMessage(role: 'user', content: text));
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
      final meta = res['metadata'];
      _currentStep =
          (meta is Map ? (meta['current_step'] as int?) : null) ?? _currentStep;
      _isComplete =
          (meta is Map ? (meta['is_complete'] as bool?) : null) ?? _isComplete;

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
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
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage('assets/images/avatars/avatar_12.png'),
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
                  Expanded(
                    child: _reportMarkdown != null
                        ? _buildReportView(_reportMarkdown!)
                        : _buildChatView(startLabel: startLabel),
                  ),
                  if (_reportMarkdown == null) _buildComposer(startLabel),
                ],
              ),
            ),
    );
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
        if (_sending && index == _messages.length) {
          return const Padding(
            padding: EdgeInsets.only(top: 8),
            child: TypingIndicator(),
          );
        }
        final m = _messages[index];
        final isUser = m.role == 'user';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: LeoMessageBubble(text: m.content, isUser: isUser),
        );
      },
    );
  }

  Widget _buildComposer(String startLabel) {
    final hasStarted = _validationId != null && _currentStep > 0;
    return SafeArea(
      top: false,
      // Приводим нижнюю панель к паттерну Leo/Max:
      // SafeArea + Padding, без принудительного белого фона, чтобы совпадать с общим градиентом.
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!hasStarted) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _starting ? null : _startValidation,
                      child: _starting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(startLabel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: _showRayAbout,
                    child: const Text('А что ты умеешь?'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            // Важно: не выключаем TextField во время отправки.
            // На iOS это часто приводит к пересозданию input-session и "подвисанию" клавиатуры.
            if (hasStarted)
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: 'Поле ввода ответа',
                      child: TextField(
                        controller: _controller,
                        focusNode: _inputFocus,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        onSubmitted: (_) {
                          if (_controller.text.trim().isNotEmpty &&
                              !_sending &&
                              !_starting) {
                            _send();
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Ваш ответ…',
                          border: OutlineInputBorder(),
                        ),
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
                            onPressed: (hasStarted && !_sending && !_starting)
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
    );
  }

  Widget _buildReportView(String markdown) {
    final styleSheet = _buildReportMarkdownStyleSheet(context);
    return ListView(
      padding: AppSpacing.insetsAll(AppSpacing.lg),
      children: [
        BizLevelCard(
          tonal: true,
          outlined: true,
          elevation: 1,
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

  const _RayMessage({
    required this.role,
    required this.content,
    this.includeInApi = true,
  });
}


