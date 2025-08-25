import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/providers/cases_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

class MiniCaseScreen extends ConsumerStatefulWidget {
  final int caseId;
  const MiniCaseScreen({super.key, required this.caseId});

  @override
  ConsumerState<MiniCaseScreen> createState() => _MiniCaseScreenState();
}

class _MiniCaseScreenState extends ConsumerState<MiniCaseScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _index = 0;
  Map<String, dynamic>? _caseMeta;
  bool _dialogOpened = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'case',
        level: SentryLevel.info,
        message: 'case_opened',
        data: {'caseId': widget.caseId},
      ));
      await ref.read(caseActionsProvider).start(widget.caseId);
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
    }

    try {
      final data = await Supabase.instance.client
          .from('mini_cases')
          .select('id, title, after_level, skill_name, estimated_minutes')
          .eq('id', widget.caseId)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _caseMeta = data == null ? {} : Map<String, dynamic>.from(data as Map);
        _loading = false;
      });
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить мини‑кейс')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _caseMeta?['title'] as String? ?? 'Мини‑кейс';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: _onSkip,
            child: const Text('Пропустить'),
          ),
        ],
        backgroundColor: AppColor.appBarColor,
      ),
      backgroundColor: AppColor.appBgColor,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _index = i),
                    children: [
                      _buildIntro(),
                      _buildDescriptionAndCTA(),
                    ],
                  ),
                ),
                _buildNavBarTwoBlocks(),
              ],
            ),
    );
  }

  Widget _buildIntro() {
    final skill = _caseMeta?['skill_name'] as String?;
    final eta = _caseMeta?['estimated_minutes'] as int? ?? 10;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          _buildCaseImage(slot: 1),
          const SizedBox(height: 16),
          Text(
            'Привет! Это мини‑кейс для тренировки навыка${skill != null ? ' «$skill»' : ''}.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text('Время прохождения ~ $eta мин.',
              style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildDescriptionAndCTA() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          _buildCaseImage(slot: 2),
          const SizedBox(height: 16),
          const Text(
            'Сначала прочитайте вводные данные кейса и подготовьтесь к короткому диалогу с Лео. Важно отвечать в 2–3 предложениях.',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 8,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Text(
              _firstTaskPrompt(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _openDialog,
            icon: const Icon(Icons.psychology_alt_outlined),
            label: const Text('Решить с Лео'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarTwoBlocks() {
    final bool canBack = _index > 0;
    final bool canNext = _index < 1;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: canBack ? _goBack : null,
                child: const Text('Назад'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: canNext
                  ? ElevatedButton(
                      onPressed: _goNext,
                      child: const Text('Далее'),
                    )
                  : ElevatedButton(
                      onPressed: _dialogOpened ? _complete : null,
                      child: const Text('Завершить кейс'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _goBack() {
    final target = (_index - 1).clamp(0, 1);
    _pageController.animateToPage(target,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    setState(() => _index = target);
  }

  void _goNext() {
    final target = (_index + 1).clamp(0, 1);
    _pageController.animateToPage(target,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    setState(() => _index = target);
  }

  Future<void> _openDialog() async {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'case',
        level: SentryLevel.info,
        message: 'case_dialog_started',
        data: {'caseId': widget.caseId},
      ));
      final systemPrompt = _buildCaseSystemPrompt();
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LeoDialogScreen(
          bot: 'leo',
          caseMode: true,
          systemPrompt: systemPrompt,
        ),
        fullscreenDialog: true,
      ));
      if (!mounted) return;
      setState(() => _dialogOpened = true);
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть диалог')));
    }
  }

  String _buildCaseSystemPrompt() {
    final title = _caseMeta?['title']?.toString() ?? '';
    final afterLevel = _caseMeta?['after_level']?.toString() ?? '';
    final skill = _caseMeta?['skill_name']?.toString() ?? '';
    return 'Режим: case_facilitатор. Ты — Лео, фасилитатор мини‑кейса. '
        'Кейс: "$title" (после уровня $afterLevel, навык: $skill). '
        'Задавай чёткие вопросы и оценивай ответы по 5‑уровневой шкале качества. '
        'Формат ответов короткий (2–3 предложения). Поддерживай мотивацию и давай мягкие подсказки.';
  }

  String _firstTaskPrompt() {
    switch (widget.caseId) {
      case 1:
        return 'Задание 1: Проанализируй ситуацию Даулета. Какая ГЛАВНАЯ проблема мешает ему эффективно управлять бизнесом? (2–3 предложения)';
      case 2:
        return 'Задание 1: В чём основная проблема презентации Гульнары? Почему клиенты не покупают, хотя работы качественные? (2–3 предложения)';
      case 3:
        return 'Задание 1: Определи самые критичные юридические риски в бизнесе Марата. Что могло привести к штрафу? (2–3 пункта)';
      default:
        return 'Задание 1: Дайте краткий анализ ситуации (2–3 предложения).';
    }
  }

  Widget _buildCaseImage({required int slot}) {
    final path = 'assets/images/cases/case_${widget.caseId}_$slot.png';
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 6)),
          ],
        ),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => const Center(
            child: Icon(Icons.broken_image_outlined,
                size: 56, color: Colors.black26),
          ),
        ),
      ),
    );
  }

  Future<void> _complete() async {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'case',
        level: SentryLevel.info,
        message: 'case_completed',
        data: {'caseId': widget.caseId},
      ));
      await ref.read(caseActionsProvider).complete(widget.caseId);
      final after = _caseMeta?['after_level'] as int?;
      final target = after != null ? after + 1 : null;
      if (!mounted) return;
      if (target != null) {
        context.go('/tower?scrollTo=$target');
      } else {
        context.go('/tower');
      }
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось завершить мини‑кейс')));
    }
  }

  Future<void> _onSkip() async {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'case',
        level: SentryLevel.info,
        message: 'case_skipped',
        data: {'caseId': widget.caseId},
      ));
      await ref.read(caseActionsProvider).skip(widget.caseId);
      final after = _caseMeta?['after_level'] as int?;
      final target = after != null ? after + 1 : null;
      if (!mounted) return;
      if (target != null) {
        context.go('/tower?scrollTo=$target');
      } else {
        context.go('/tower');
      }
    } catch (e, st) {
      await Sentry.captureException(e, stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Не удалось пропустить')));
    }
  }
}
