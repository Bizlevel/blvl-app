import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bizlevel/widgets/common/milestone_celebration.dart';

import 'package:bizlevel/providers/cases_provider.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/providers/user_skills_provider.dart';
import 'package:bizlevel/widgets/lesson_widget.dart'; // 🆕 Для видео
import 'package:bizlevel/models/lesson_model.dart'; // 🆕 Для создания mock урока

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
  // ignore: unused_field
  bool _dialogOpened = false;
  bool _loading = true;

  // 🆕 Для двухблоковой структуры
  late PageController _pageController;
  // ignore: unused_field
  int _currentPage = 0; // Готово для индикатора блоков (будущее улучшение)
  // ignore: unused_field
  bool _videoWatched =
      false; // Готово для блокировки кнопки до просмотра (будущее улучшение)

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
              'vimeo_id, video_url') // 🆕 Добавлены поля для видео
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
          : PageView(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // 🔒 Запретить свайпы
              onPageChanged: (index) {
                setState(() => _currentPage = index);
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
    );
  }

  /// 🆕 Блок 1: Intro (Картинка + короткое описание + кнопка "Далее")
  Widget _buildIntroBlock() {
    final introText = _script?['intro'] is Map
        ? ((_script?['intro'] as Map)['text']?.toString() ?? '')
        : '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          // Картинка
          _buildCaseImage(slot: 2),

          const SizedBox(height: 16),

          // Короткое описание (только intro, без context)
          if (introText.isNotEmpty)
            Text(
              introText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (introText.isEmpty)
            const Text(
              'Прочитайте описание кейса и приготовьтесь к решению.',
              style: TextStyle(fontSize: 16),
            ),

          const SizedBox(height: 24),

          // Кнопка "Далее" → переход на Блок 2
          ElevatedButton.icon(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Далее'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  /// 🆕 Блок 2: Видео + CTA "Решить с Лео"
  Widget _buildVideoBlock() {
    // Создаём фейковый LessonModel для переиспользования LessonWidget
    final vimeoId = _caseMeta?['vimeo_id'] as String?;
    final videoUrl = _caseMeta?['video_url'] as String?;

    final mockLesson = LessonModel(
      id: widget.caseId * 1000, // Уникальный ID для избежания конфликтов
      levelId: widget.caseId,
      order: 1,
      title: _caseMeta?['title'] as String? ?? 'Мини-кейс',
      description: 'Посмотрите видео перед решением кейса',
      videoUrl: videoUrl,
      vimeoId: vimeoId,
      durationMinutes: _caseMeta?['estimated_minutes'] as int? ?? 10,
      quizQuestions: [],
      correctAnswers: [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Видео (занимает большую часть экрана)
        Expanded(
          child: LessonWidget(
            lesson: mockLesson,
            onWatched: () {
              // Помечаем видео как просмотренное
              setState(() => _videoWatched = true);
            },
          ),
        ),

        // Нижняя панель с кнопками
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Кнопка "Решить с Лео"
                ElevatedButton.icon(
                  onPressed: _openDialog,
                  icon: const Icon(Icons.psychology_alt_outlined),
                  label: const Text('Решить с Лео'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),

                const SizedBox(height: 8),

                // Кнопка "Назад" (опционально, чтобы вернуться к описанию)
                TextButton.icon(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Назад к описанию'),
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
      final List<String> contexts = [
        '',
        (_script?['q2_context']?.toString() ?? ''),
        (_script?['q3_context']?.toString() ?? ''),
        (_script?['q4_context']?.toString() ?? ''),
      ];
      final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LeoDialogScreen(
          bot: 'leo',
          caseMode: true,
          systemPrompt: systemPrompt,
          firstPrompt: firstPrompt,
          casePrompts: prompts,
          caseContexts: contexts,
          casePreface: _buildChecklistPreface(),
          finalStory: _script?['final_story']?.toString(),
        ),
        fullscreenDialog: true,
      ));
      if (!mounted) return;
      if (result == 'case_final') {
        await _complete();
        return;
      }
      setState(() => _dialogOpened = true);
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
    final user = Supabase.instance.client.auth.currentUser;

    final hasProfile = user != null;
    if (!hasProfile) {
      return 'Режим: case_facilitатор. Ты — Лео, фасилитатор мини‑кейса. '
          'Кейс: "$title" (после уровня $afterLevel, навык: $skill). '
          '${contextText.isNotEmpty ? 'Текст кейса: $contextText ' : ''}'
          '⚠️ ВАЖНО: Профиль пользователя не заполнен или заполнен неполностью. '
          'Сначала помоги пользователю заполнить профиль (имя, сфера деятельности, цель, опыт), '
          'а затем переходи к кейсу. Объясни, что качество ответов зависит от полноты профиля. '
          'Правила: отвечай ТОЛЬКО на основе «Текста кейса», игнорируй внешние источники/память/RAG. '
          'Задавай чёткие вопросы и оценивай ответы по 5‑уровневой шкале качества. '
          'Формат ответов короткий (2–3 предложения). Поддерживай мотивацию и давай мягкие подсказки.';
    }

    return 'Режим: case_facilitатор. Ты — Лео, фасилитатор мини‑кейса. '
        'Кейс: "$title" (после уровня $afterLevel, навык: $skill). '
        '${contextText.isNotEmpty ? 'Текст кейса: $contextText ' : ''}'
        'Правила: отвечай ТОЛЬКО на основе «Текста кейса», игнорируй внешние источники/память/RAG. '
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
        final before = await client
            .from('gp_bonus_grants')
            .select('rule_key')
            .eq('rule_key', 'all_three_cases_completed')
            .maybeSingle();

        await client.rpc('gp_bonus_claim',
            params: {'p_rule_key': 'all_three_cases_completed'});

        final after = await client
            .from('gp_bonus_grants')
            .select('rule_key')
            .eq('rule_key', 'all_three_cases_completed')
            .maybeSingle();

        final newlyGranted = before == null && after != null;
        if (newlyGranted && mounted) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: MilestoneCelebration(
                gpGain: 200,
                onClose: () => Navigator.of(context).maybePop(),
              ),
            ),
          );
        }
      } catch (_) {}

      // Обновляем current_level пользователя после завершения кейса
      try {
        final after = _caseMeta?['after_level'] as int?;
        if (after != null) {
          // Находим level_id для следующего уровня (after + 1)
          final nextLevelNumber = after + 1;
          // Получаем level_id для следующего уровня
          final levelId =
              await SupabaseService.levelIdFromNumber(nextLevelNumber);
          // Guard: повышаем уровень только если текущий уровень пользователя
          // строго меньше целевого nextLevelNumber (число уровней уже пройденных + 1)
          try {
            final user = await ref.read(currentUserProvider.future);
            final currNum = await SupabaseService.resolveCurrentLevelNumber(
                user?.currentLevel);
            if (levelId != null && currNum < nextLevelNumber) {
              await SupabaseService.completeLevel(levelId);
            }
          } catch (_) {}
        }
      } catch (_) {
        // Игнорируем ошибки обновления уровня
      }

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
