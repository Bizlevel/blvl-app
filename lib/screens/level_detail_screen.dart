import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/models/lesson_model.dart';
import 'package:online_course/providers/lessons_provider.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/services/supabase_service.dart';
import 'package:online_course/providers/lesson_progress_provider.dart';
import 'package:online_course/widgets/lesson_widget.dart';
import 'package:online_course/widgets/floating_chat_bubble.dart';
import 'package:online_course/services/leo_service.dart';
import 'package:online_course/widgets/quiz_widget.dart';

/// Shows a level as full-screen blocks (Intro → Lesson → Quiz → …).
class LevelDetailScreen extends ConsumerStatefulWidget {
  final int levelId;
  const LevelDetailScreen({Key? key, required this.levelId}) : super(key: key);

  @override
  ConsumerState<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends ConsumerState<LevelDetailScreen> {
  late final PageController _pageController;

  late List<_PageBlock> _blocks;
  LessonProgressState get _progress =>
      ref.watch(lessonProgressProvider(widget.levelId));

  // Leo chat (создаётся при первом сообщении пользователя)
  String? _chatId;

  @override
  void initState() {
    super.initState();
    // Берём последнюю разблокированную страницу, чтобы открывать уровень там, где пользователь остановился.
    final initialUnlockedPage =
        ref.read(lessonProgressProvider(widget.levelId)).unlockedPage;
    _pageController = PageController(initialPage: initialUnlockedPage);
    // Listen for page changes to rebuild so that chat bubble visibility updates
    _pageController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helpers to interact with progress provider
  LessonProgressNotifier get _progressNotifier =>
      ref.read(lessonProgressProvider(widget.levelId).notifier);

  void _unlockNext(int current) {
    _progressNotifier.unlockPage(current + 1);
  }

  void _videoWatched(int page) {
    // Отложим обновление, чтобы избежать модификации провайдера во время билда
    Future(() {
      _progressNotifier.markVideoWatched(page);
      _unlockNext(page);
    });
  }

  void _quizPassed(int page) {
    Future(() {
      _progressNotifier.markQuizPassed(page);
      _unlockNext(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(lessonsProvider(widget.levelId));

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: lessonsAsync.when(
        data: (lessons) {
          _buildBlocks(lessons);

          final mainContent = SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildPageView()),
                _ProgressDots(current: _currentIndex, total: _blocks.length),
                _NavBar(
                  canBack: _currentIndex > 0,
                  canNext: _currentIndex < _progress.unlockedPage,
                  onBack: _goBack,
                  onNext: _goNext,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isLevelCompleted(lessons)
                      ? () async {
                          try {
                            await SupabaseService.completeLevel(widget.levelId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Уровень завершён!')),
                              );
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Ошибка: $e')),
                              );
                            }
                          }
                        }
                      : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Завершить уровень'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary),
                ),
              ],
            ),
          );

          // Wrap with Stack to overlay chat bubble
          final stack = Stack(
            children: [
              mainContent,
              if (_blocks[_currentIndex] is _LessonBlock ||
                  _blocks[_currentIndex] is _QuizBlock)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingChatBubble(
                    chatId: _chatId,
                    systemPrompt: _buildSystemPrompt(),
                    unreadCount: 0,
                  ),
                ),
            ],
          );
          return stack;
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: ${e.toString()}')),
      ),
    );
  }

  // Helpers ---------------------------------------------------------

  int get _currentIndex =>
      _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;

  // --- Leo chat helpers --------------------------------------------
  void _ensureChatCreated(String prompt) async {
    try {
      final id =
          await LeoService.saveConversation(role: 'system', content: prompt);
      if (mounted) setState(() => _chatId = id);
    } catch (_) {
      // Silently ignore chat creation errors – chat bubble will not show
    }
  }

  String _buildSystemPrompt() {
    if (_currentIndex == 0) {
      return 'Пользователь читает вводный блок уровня ${widget.levelId}. Помогите разобраться со структурой уровня.';
    }
    final block = _blocks[_currentIndex];
    if (block is _LessonBlock) {
      return 'Пользователь сейчас просматривает урок "${block.lesson.title}". Дайте совет или пояснение по содержанию урока.';
    } else if (block is _QuizBlock) {
      return 'Пользователь проходит тест по уроку "${block.lesson.title}". Помогите объяснить правильные ответы, не раскрывая их напрямую.';
    } else {
      return 'Пользователь работает с уровнем ${widget.levelId}. Помогите при необходимости.';
    }
  }

  void _goBack() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goNext() {
    if (_currentIndex + 1 < _blocks.length &&
        _currentIndex < _progress.unlockedPage) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Widget _buildPageView() {
    // SizedBox.expand гарантирует, что PageView получает валидные вертикальные constraints
    // даже на раннем этапе компоновки (особенно в iOS debug-сборке), исключая создание
    // горизонтального Viewport и неправильную ориентацию свайпа.
    return SizedBox.expand(
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        physics: const PageScrollPhysics(),
        itemCount: _blocks.length,
        itemBuilder: (context, index) {
          final locked = index > _progress.unlockedPage;
          return AbsorbPointer(
            absorbing: locked,
            child: Opacity(
              opacity: locked ? 0.3 : 1,
              child: _blocks[index].build(context, index),
            ),
          );
        },
      ),
    );
  }

  bool _isLevelCompleted(List<LessonModel> lessons) {
    final lessonCount = lessons.length;
    return _progress.watchedVideos.length >= lessonCount &&
        _progress.passedQuizzes.length >= lessonCount;
  }

  void _buildBlocks(List<LessonModel> lessons) {
    _blocks = [
      _IntroBlock(levelId: widget.levelId),
      for (final lesson in lessons) ...[
        _LessonBlock(lesson: lesson, onWatched: _videoWatched),
        _QuizBlock(lesson: lesson, onCorrect: _quizPassed),
      ],
    ];
  }
}

// Abstract block ----------------------------------------------------
abstract class _PageBlock {
  Widget build(BuildContext context, int index);
}

// Intro -------------------------------------------------------------
class _IntroBlock extends _PageBlock {
  final int levelId;
  _IntroBlock({required this.levelId});
  @override
  Widget build(BuildContext context, int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Уровень $levelId',
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(
                'Проходите уроки по порядку и выполняйте тесты, чтобы продвигаться дальше.',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// Lesson ------------------------------------------------------------
class _LessonBlock extends _PageBlock {
  final LessonModel lesson;
  final void Function(int) onWatched;
  _LessonBlock({required this.lesson, required this.onWatched});
  @override
  Widget build(BuildContext context, int index) {
    return LessonWidget(
      lesson: lesson,
      onWatched: () => onWatched(index),
    );
  }
}

// Quiz --------------------------------------------------------------
class _QuizBlock extends _PageBlock {
  final LessonModel lesson;
  final void Function(int) onCorrect;
  _QuizBlock({required this.lesson, required this.onCorrect});
  @override
  Widget build(BuildContext context, int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: QuizWidget(
          questionData: {
            'question': lesson.quizQuestions.first['question'],
            'options': List<String>.from(lesson.quizQuestions.first['options']),
            'correct': lesson.correctAnswers.first,
          },
          onCorrect: () => onCorrect(index),
        ),
      ),
    );
  }
}

// Progress dots -----------------------------------------------------
class _ProgressDots extends StatelessWidget {
  final int current;
  final int total;
  const _ProgressDots({Key? key, required this.current, required this.total})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          total,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: i <= current ? AppColor.primary : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// Navigation bar ----------------------------------------------------
class _NavBar extends StatelessWidget {
  final bool canBack;
  final bool canNext;
  final VoidCallback onBack;
  final VoidCallback onNext;
  const _NavBar(
      {Key? key,
      required this.canBack,
      required this.canNext,
      required this.onBack,
      required this.onNext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: canBack ? onBack : null,
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            child: const Text('Назад'),
          ),
          ElevatedButton(
            onPressed: canNext ? onNext : null,
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            child: const Text('Далее'),
          ),
        ],
      ),
    );
  }
}
