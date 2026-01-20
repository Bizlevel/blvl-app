import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/providers/gp_providers.dart';
import 'package:bizlevel/widgets/common/milestone_celebration.dart';

import 'package:bizlevel/providers/cases_provider.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/providers/user_skills_provider.dart';
import 'package:bizlevel/widgets/lesson_widget.dart'; // 🆕 Для видео
import 'package:bizlevel/models/lesson_model.dart'; // 🆕 Для создания mock урока
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';

class MiniCaseScreen extends ConsumerStatefulWidget {
  final int caseId;
  const MiniCaseScreen({super.key, required this.caseId});

  @override
  ConsumerState<MiniCaseScreen> createState() => _MiniCaseScreenState();
}

class _MiniCaseScreenState extends ConsumerState<MiniCaseScreen> {
  Map<String, dynamic>? _caseMeta;
  Map<String, dynamic>?
      _script; // intro/context/questions/final from mini_cases.script
  bool _loading = true;

  // 🆕 Для двухблоковой структуры
  late PageController _pageController;
  // Индикаторы текущей страницы/просмотра видео не используются — удалены

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _bootstrap();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'case',
          level: SentryLevel.info,
          message: 'case_opened',
          data: {'caseId': widget.caseId},
        ));
      } catch (_) {
        // Sentry не настроен, игнорируем
      }
      await ref.read(caseActionsProvider).start(widget.caseId);
    } catch (e, st) {
      try {
        await Sentry.captureException(e, stackTrace: st);
      } catch (_) {
        // Sentry не настроен, просто логируем в консоль
        debugPrint('DEBUG: Exception (Sentry not configured): $e');
      }
    }

    try {
      final data = await Supabase.instance.client
          .from('mini_cases')
          .select(
              'id, title, after_level, skill_name, estimated_minutes, script, '
              'video_url') // видео: Bunny/Supabase через video_url
          .eq('id', widget.caseId)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _caseMeta = data == null ? {} : Map<String, dynamic>.from(data);
        final s = (_caseMeta?['script']);
        if (s is Map) {
          _script = Map<String, dynamic>.from(s);
        }
        _loading = false;
      });
    } catch (e, st) {
      try {
        await Sentry.captureException(e, stackTrace: st);
      } catch (_) {
        // Sentry не настроен, просто логируем в консоль
        debugPrint('DEBUG: Exception (Sentry not configured): $e');
      }
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить мини‑кейс')));
    }
  }

  /// Нормализует значения из mini_cases.script в читаемый многострочный текст.
  /// В данных встречаются строки, списки строк (List) и Map с полем `text`.
  String _asMultilineText(dynamic value) {
    if (value == null) return '';
    if (value is String) return value.trim();
    if (value is List) {
      return value
          .map((e) => e?.toString() ?? '')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .join('\n');
    }
    if (value is Map) {
      final t = value['text']?.toString();
      if (t != null && t.trim().isNotEmpty) return t.trim();
    }
    return value.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final title = _caseMeta?['title'] as String? ?? 'Мини‑кейс';
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: _onSkip, child: const Text('Пропустить')),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColor.bgGradient),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // 🔒 Запретить свайпы
                onPageChanged: (index) {
                  // Breadcrumb для аналитики
                  try {
                    Sentry.addBreadcrumb(Breadcrumb(
                      category: 'case',
                      message: index == 0
                          ? 'case_intro_block_opened'
                          : 'case_video_block_opened',
                      data: {'caseId': widget.caseId, 'blockIndex': index},
                    ));
                  } catch (_) {}
                },
                children: [
                  _buildIntroBlock(), // Блок 1: Картинка + Описание + "Далее"
                  _buildVideoBlock(), // Блок 2: Видео + "Решить с Лео"
                ],
              ),
      ),
    );
  }

  /// 🆕 Блок 1: Intro (Картинка + короткое описание + кнопка "Далее")
  Widget _buildIntroBlock() {
    final introText = _script?['intro'] is Map
        ? ((_script?['intro'] as Map)['text']?.toString() ?? '')
        : '';

    return SingleChildScrollView(
      padding: AppSpacing.insetsAll(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.gapH(AppSpacing.md),

          BizLevelCard(
            padding: AppSpacing.insetsAll(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCaseImage(slot: 2),
                AppSpacing.gapH(AppSpacing.lg),
                if (introText.isNotEmpty)
                  Text(
                    introText,
                    style: AppTypography.textTheme.titleMedium,
                  ),
                if (introText.isEmpty)
                  Text(
                    'Прочитайте описание кейса и приготовьтесь к решению.',
                    style: AppTypography.textTheme.bodyLarge,
                  ),
              ],
            ),
          ),

          AppSpacing.gapH(AppSpacing.xl),

          BizLevelButton(
            label: 'Далее',
            icon: const Icon(Icons.arrow_forward, size: 20),
            fullWidth: true,
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          AppSpacing.gapH(AppSpacing.sm),
          Text(
            'Если пропустить кейс, бонусы за него не начисляются.',
            textAlign: TextAlign.center,
            style: AppTypography.textTheme.bodySmall
                ?.copyWith(color: AppColor.labelColor),
          ),
        ],
      ),
    );
  }

  /// 🆕 Блок 2: Видео + CTA "Решить с Лео"
  Widget _buildVideoBlock() {
    // Создаём фейковый LessonModel для переиспользования LessonWidget
    final videoUrl = _caseMeta?['video_url'] as String?;

    final mockLesson = LessonModel(
      id: widget.caseId * 1000, // Уникальный ID для избежания конфликтов
      levelId: widget.caseId,
      order: 1,
      title: _caseMeta?['title'] as String? ?? 'Мини-кейс',
      description: 'Посмотрите видео перед решением кейса',
      videoUrl: videoUrl,
      durationMinutes: _caseMeta?['estimated_minutes'] as int? ?? 10,
      quizQuestions: [],
      correctAnswers: [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Видео (занимает большую часть экрана)
        Expanded(
          child: Padding(
            padding: AppSpacing.insetsSymmetric(
              h: AppSpacing.lg,
              v: AppSpacing.md,
            ),
            child: BizLevelCard(
              padding: EdgeInsets.zero,
              child: LessonWidget(
                lesson: mockLesson,
                onWatched: () {},
                // В mini-case избегаем автоперехода в fullscreen на iOS:
                // это уменьшает шанс hang/gesture-timeout и Impeller "no drawable".
                autoFullscreenOnPlay: false,
              ),
            ),
          ),
        ),

        // Нижняя панель с кнопками
        SafeArea(
          child: Padding(
            padding: AppSpacing.insetsAll(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Кнопка "Решить с Лео"
                BizLevelButton(
                  label: 'Решить с Лео',
                  icon: const Icon(Icons.psychology_alt_outlined, size: 20),
                  fullWidth: true,
                  onPressed: _openDialog,
                ),

                AppSpacing.gapH(AppSpacing.sm),

                // Кнопка "Назад" (опционально, чтобы вернуться к описанию)
                BizLevelButton(
                  label: 'Назад к описанию',
                  icon: const Icon(Icons.arrow_back, size: 20),
                  variant: BizLevelButtonVariant.text,
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                AppSpacing.gapH(AppSpacing.xs),
                Text(
                  'Если пропустить кейс, бонусы за него не начисляются.',
                  textAlign: TextAlign.center,
                  style: AppTypography.textTheme.bodySmall
                      ?.copyWith(color: AppColor.labelColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openDialog() async {
    try {
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'case',
          level: SentryLevel.info,
          message: 'case_dialog_started',
          data: {'caseId': widget.caseId},
        ));
      } catch (_) {
        // Sentry не настроен, игнорируем
      }
      final systemPrompt = _buildCaseSystemPrompt();
      final firstPrompt = _firstTaskPromptFromScript();
      // Собираем список всех промптов и контекстов (для автопереходов)
      final List<String> prompts = [];
      try {
        final qs = _script?['questions'];
        if (qs is List) {
          for (final q in qs) {
            if (q is Map && q['prompt'] is String) {
              prompts.add((q['prompt'] as String).trim());
            }
          }
        }
      } catch (_) {}
      final List<String> contexts = _buildCaseContexts(prompts.length);
      final String finalStory = _asMultilineText(_script?['final_story']);
      // Важно: открываем диалог через rootNavigator, чтобы он был поверх ShellRoute
      // (и не конфликтовал с таб-навбаром/вложенным навигатором).
      final result =
          await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) => LeoDialogScreen(
          caseMode: true,
          caseId: widget.caseId,
          // Мини‑кейс должен быть бесплатным: не списываем GP за сообщения.
          skipSpend: true,
          systemPrompt: systemPrompt,
          firstPrompt: firstPrompt,
          casePrompts: prompts,
          caseContexts: contexts,
          casePreface: _buildChecklistPreface(),
          finalStory: finalStory.isEmpty ? null : finalStory,
        ),
        fullscreenDialog: true,
      ));
      if (!mounted) return;
      if (result == 'case_final') {
        await _complete();
        return;
      }
    } catch (e, st) {
      try {
        await Sentry.captureException(e, stackTrace: st);
      } catch (_) {
        // Sentry не настроен, просто логируем в консоль
        debugPrint('DEBUG: Exception (Sentry not configured): $e');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть диалог')));
    }
  }

  // String? _buildChecklistPreface() {
  //   try {
  //     final list = _script?['checklist'];
  //     if (list is List && list.isNotEmpty) {
  //       final b = StringBuffer('Презентация Гульнары:\n');
  //       for (final item in list) {
  //         b.writeln(item.toString());
  //       }
  //       return b.toString().trim();
  //     }
  //   } catch (_) {}
  //   return null;
  // }
  String? _buildChecklistPreface() {
    try {
      final list = _script?['checklist'];
      if (list is List && list.isNotEmpty) {
        // Определяем имя персонажа и тип списка по номеру кейса
        String characterName;
        String listType;
        switch (widget.caseId) {
          case 1:
            characterName = 'Даулета';
            listType = 'Список дел';
            break;
          case 2:
            characterName = 'Гульнары';
            listType = 'Презентация';
            break;
          case 3:
            characterName = 'Руслана';
            listType = 'План';
            break;
          default:
            characterName = 'персонажа';
            listType = 'Список';
        }

        final b = StringBuffer('$listType $characterName:\n');
        for (final item in list) {
          b.writeln(item.toString());
        }
        return b.toString().trim();
      }
    } catch (_) {}
    return null;
  }

  String _buildCaseSystemPrompt() {
    final title = _caseMeta?['title']?.toString() ?? '';
    final afterLevel = _caseMeta?['after_level']?.toString() ?? '';
    final skill = _caseMeta?['skill_name']?.toString() ?? '';
    final contextText = _script?['context'] is Map
        ? ((_script?['context'] as Map)['text']?.toString() ?? '')
        : '';
    final int totalTasks = (() {
      try {
        final qs = _script?['questions'];
        if (qs is List) return qs.length;
      } catch (_) {}
      return 0;
    })();

    return 'Режим: case_facilitатор. Ты — Лео, фасилитатор мини‑кейса. '
        'Кейс: "$title" (после уровня $afterLevel, навык: $skill). '
        '${contextText.isNotEmpty ? 'Текст кейса: $contextText ' : ''}'
        'Правила: отвечай ТОЛЬКО на основе «Текста кейса», игнорируй внешние источники/память/RAG. '
        '${totalTasks > 0 ? 'В кейсе $totalTasks задания(й). ' : ''}'
        'ВАЖНО: не завершай кейс раньше времени. '
        'Используй маркеры в конце ответа отдельной строкой: '
        '[CASE:NEXT] — перейти к следующему заданию; '
        '[CASE:RETRY] — попросить доработать; '
        '[CASE:FINAL] — только после последнего задания. '
        'Не вставляй текст следующего задания — его покажет приложение. '
        'Алгоритм: дай «Задание 1» как ассистент; оцени ответ (EXCELLENT/GOOD/ACCEPTABLE/WEAK/INVALID). '
        'При EXCELLENT/GOOD — переход к следующему заданию (верни маркер [CASE:NEXT]); '
        'при ACCEPTABLE — мягкая подсказка и переход (верни [CASE:NEXT]); '
        'при WEAK/INVALID — короткая наводящая подсказка и запрос доработки (верни [CASE:RETRY]). '
        'В финале выдай краткий итог и верни маркер [CASE:FINAL]. '
        'Формат ответов краткий (2–3 предложения), без таблиц/эмодзи.';
  }

  String _firstTaskPromptFromScript() {
    try {
      final qs = _script?['questions'];
      if (qs is List && qs.isNotEmpty) {
        final first = qs.first;
        if (first is Map && first['prompt'] is String) {
          return (first['prompt'] as String).trim();
        }
      }
    } catch (_) {}
    return _fallbackFirstTaskPrompt();
  }

  String _fallbackFirstTaskPrompt() {
    switch (widget.caseId) {
      case 1:
        return 'Задание 1: Проанализируй ситуацию Даулета. Какая ГЛАВНАЯ проблема мешает ему эффективно управлять бизнесом? (2–3 предложения)';
      case 2:
        return 'Задание 1: В чём основная проблема презентации Гульнары? Почему клиенты не покупают, хотя работы качественные? (2–3 предложения)';
      case 3:
        return 'Задание 1: В чем СТРАТЕГИЧЕСКАЯ ошибка Руслана при открытии второй точки? Что он не учел? (2-3 предложения)';
      default:
        return 'Задание 1: Дайте краткий анализ ситуации (2–3 предложения).';
    }
  }

  List<String> _buildCaseContexts(int promptCount) {
    if (promptCount <= 0) return const <String>[];
    final List<String> contexts = [];
    final qs = _script?['questions'];
    if (qs is List) {
      for (int i = 0; i < qs.length; i++) {
        final q = qs[i];
        String ctx = '';
        if (q is Map && q['context'] != null) {
          ctx = _asMultilineText(q['context']);
        }
        if (ctx.trim().isEmpty) {
          final legacyKey = 'q${i + 1}_context';
          ctx = _asMultilineText(_script?[legacyKey]);
        }
        contexts.add(ctx);
      }
    }
    if (contexts.isEmpty) {
      contexts.addAll([
        '',
        _asMultilineText(_script?['q2_context']),
        _asMultilineText(_script?['q3_context']),
        _asMultilineText(_script?['q4_context']),
      ]);
    }
    while (contexts.length < promptCount) {
      contexts.add('');
    }
    if (contexts.length > promptCount) {
      return contexts.sublist(0, promptCount);
    }
    return contexts;
  }

  Widget _buildCaseImage({required int slot}) {
    final path = 'assets/images/cases/case_${widget.caseId}_$slot.png';
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      child: SizedBox(
        height: 180,
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => const Center(
            child: Icon(Icons.broken_image_outlined,
                size: 56, color: AppColor.onSurfaceSubtle),
          ),
        ),
      ),
    );
  }

  Future<void> _complete() async {
    try {
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'case',
          level: SentryLevel.info,
          message: 'case_completed',
          data: {'caseId': widget.caseId},
        ));
      } catch (_) {
        // Sentry не настроен, игнорируем
      }
      await ref.read(caseActionsProvider).complete(widget.caseId);

      // Попытка начислить бонус за 3 завершённых кейса (идемпотентно)
      try {
        final client = Supabase.instance.client;
        final uid = client.auth.currentUser?.id;

        Map<String, dynamic>? before;
        if (uid != null && uid.isNotEmpty) {
          before = await client
              .from('gp_bonus_grants')
              .select('rule_key')
              .eq('user_id', uid)
              .eq('rule_key', 'all_three_cases_completed')
              .maybeSingle();
        }

        await client.rpc('gp_bonus_claim',
            params: {'p_rule_key': 'all_three_cases_completed'});

        Map<String, dynamic>? after;
        if (uid != null && uid.isNotEmpty) {
          after = await client
              .from('gp_bonus_grants')
              .select('rule_key')
              .eq('user_id', uid)
              .eq('rule_key', 'all_three_cases_completed')
              .maybeSingle();
        }

        final newlyGranted = before == null && after != null;
        if (newlyGranted && mounted) {
          try {
            // Инвалидация баланса после начисления бонуса
            // ignore: unused_result
            ProviderScope.containerOf(context).invalidate(gpBalanceProvider);
          } catch (_) {}
          showDialog(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: AppSpacing.insetsAll(AppSpacing.lg),
              child: MilestoneCelebration(
                gpGain: 200,
                onClose: () => Navigator.of(context).maybePop(),
              ),
            ),
          );
        }
      } catch (_) {}

      // СНАЧАЛА обновляем данные башни и уровней, ПОТОМ переходим
      try {
        // ignore: unused_result
        ref.invalidate(towerNodesProvider);
        // ignore: unused_result
        ref.invalidate(levelsProvider);
        // ignore: unused_result
        ref.invalidate(nextLevelToContinueProvider);
        // ignore: unused_result
        ref.invalidate(currentUserProvider);
        // ignore: unused_result
        ref.invalidate(userSkillsProvider);
        // ignore: unused_result
        ref.invalidate(caseStatusProvider(widget.caseId));
      } catch (_) {}

      // Небольшая задержка для обновления UI
      await Future.delayed(const Duration(milliseconds: 100));

      final after = _caseMeta?['after_level'] as int?;
      final target = after != null ? after + 1 : null;
      if (!mounted) return;
      if (target != null) {
        context.go('/tower?scrollTo=$target');
      } else {
        context.go('/tower');
      }
    } catch (e, st) {
      try {
        await Sentry.captureException(e, stackTrace: st);
      } catch (_) {
        // Sentry не настроен, просто логируем в консоль
        debugPrint('DEBUG: Exception (Sentry not configured): $e');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось завершить мини‑кейс')));
    }
  }

  Future<void> _onSkip() async {
    try {
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'case',
          level: SentryLevel.info,
          message: 'case_skipped',
          data: {'caseId': widget.caseId},
        ));
      } catch (_) {
        // Sentry не настроен, игнорируем
      }
      await ref.read(caseActionsProvider).skip(widget.caseId);

      // СНАЧАЛА обновляем данные башни и уровней, ПОТОМ переходим
      try {
        // ignore: unused_result
        ref.invalidate(towerNodesProvider);
        // ignore: unused_result
        ref.invalidate(levelsProvider);
        // ignore: unused_result
        ref.invalidate(nextLevelToContinueProvider);
        // ignore: unused_result
        ref.invalidate(currentUserProvider);
        // ignore: unused_result
        ref.invalidate(userSkillsProvider);
        // ignore: unused_result
        ref.invalidate(caseStatusProvider(widget.caseId));
      } catch (_) {}

      // Небольшая задержка для обновления UI
      await Future.delayed(const Duration(milliseconds: 100));

      final after = _caseMeta?['after_level'] as int?;
      final target = after != null ? after + 1 : null;
      if (!mounted) return;
      if (target != null) {
        context.go('/tower?scrollTo=$target');
      } else {
        context.go('/tower');
      }
    } catch (e, st) {
      try {
        await Sentry.captureException(e, stackTrace: st);
      } catch (_) {
        // Sentry не настроен, просто логируем в консоль
        debugPrint('DEBUG: Exception (Sentry not configured): $e');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Не удалось пропустить')));
    }
  }
}
