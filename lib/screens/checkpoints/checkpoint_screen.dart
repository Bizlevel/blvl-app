import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/models/goal_update.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/theme/animations.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/glass_utils.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/utils/custom_modal_route.dart';
import 'package:bizlevel/utils/goal_checkpoint_helper.dart';
import 'package:bizlevel/utils/max_context_helper.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/widgets/common/bizlevel_card.dart';
import 'package:bizlevel/widgets/common/discuss_bubble.dart';
import 'package:bizlevel/widgets/common/gp_balance_widget.dart';
import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:bizlevel/widgets/reminders_settings_sheet.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

enum CheckpointType { l1, l4, l7 }

class CheckpointScreen extends ConsumerStatefulWidget {
  final CheckpointType type;
  const CheckpointScreen({super.key, required this.type});

  @override
  ConsumerState<CheckpointScreen> createState() => _CheckpointScreenState();
}

class _CheckpointScreenState extends ConsumerState<CheckpointScreen> {
  bool _busy = false;
  String? _chatId;

  CheckpointConfig get _config => CheckpointConfig.fromType(widget.type);

  Future<void> _completeCheckpoint({bool navigateToTower = false}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(goalsRepositoryProvider);
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      if (userId.isEmpty) return;
      final goal = ref.read(userGoalProvider).asData?.value;
      final String goalText = (goal?['goal_text'] ?? '').toString();

      GoalUpsertRequest request;
      if (widget.type == CheckpointType.l1) {
        final String nextText = goalText.trim().isNotEmpty
            ? goalText.trim()
            : kCheckpointGoalPlaceholder;
        request = GoalUpsertRequest(
          userId: userId,
          goalText: nextText,
        );
      } else if (widget.type == CheckpointType.l4) {
        request = GoalUpsertRequest(
          userId: userId,
          goalText: goalText.trim(),
          financialFocus: 'Регулярность подтверждена',
        );
      } else {
        request = GoalUpsertRequest(
          userId: userId,
          goalText: goalText.trim(),
          actionPlanNote: 'Система поддержки подтверждена',
        );
      }

      await repo.upsertUserGoalRequest(request);
      ref.invalidate(userGoalProvider);
      ref.invalidate(towerNodesProvider);
      ref.invalidate(levelsProvider);
      if (!mounted) return;
      try {
        Sentry.addBreadcrumb(Breadcrumb(
          category: 'checkpoint',
          message: 'checkpoint_completed_${widget.type.name}',
          level: SentryLevel.info,
        ));
      } catch (_) {}
      NotificationCenter.showSuccess(context, _config.successMessage);
      if (navigateToTower) {
        context.go('/tower');
      }
    } catch (e) {
      if (!mounted) return;
      NotificationCenter.showError(context, 'Ошибка: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openMaxChatSheet() async {
    final container = ProviderScope.containerOf(context);
    final goal = ref.read(userGoalProvider).asData?.value;
    final router = GoRouter.of(context);
    final origin = router.routeInformationProvider.value.uri.toString();

    try {
      Sentry.addBreadcrumb(Breadcrumb(
        category: 'chat',
        level: SentryLevel.info,
        message: 'leo_dialog_open_requested',
        data: {'origin': origin, 'bot': 'max'},
      ));
    } catch (_) {}

    final result = await Navigator.of(context, rootNavigator: true).push(
      CustomModalBottomSheetRoute(
        barrierDismissible: false,
        child: UncontrolledProviderScope(
          container: container,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      final navigator = Navigator.of(
                        context,
                        rootNavigator: true,
                      );
                      if (navigator.canPop()) {
                        navigator.pop();
                      }
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.9,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColor.surface,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          children: [
                            Container(
                              color: AppColor.primary,
                              child: SafeArea(
                                bottom: false,
                                child: AppBar(
                                  backgroundColor: AppColor.primary,
                                  automaticallyImplyLeading: false,
                                  leading: Builder(
                                    builder: (context) => IconButton(
                                      tooltip: 'Закрыть',
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        final navigator = Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        );
                                        if (navigator.canPop()) {
                                          navigator.pop();
                                        }
                                      },
                                    ),
                                  ),
                                  title: const Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundImage: AssetImage(
                                          'assets/images/avatars/avatar_max.png',
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Макс'),
                                    ],
                                  ),
                                  actions: const [
                                    Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: Center(child: GpBalanceWidget()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: LeoDialogScreen(
                                chatId: _chatId,
                                bot: 'max',
                                userContext: buildMaxUserContext(goal: goal),
                                levelContext: '',
                                embedded: true,
                                onChatIdChanged: (id) {
                                  if (mounted && id.isNotEmpty) {
                                    setState(() => _chatId = id);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!mounted) return;
    final current = router.routeInformationProvider.value.uri.toString();
    if (origin.startsWith('/tower') && current != origin) {
      router.go(origin);
    }
    assert(() {
      debugPrint(
          'leo_dialog_closed origin=$origin current=$current result=$result');
      return true;
    }());
  }

  Future<void> _handlePrimaryAction() async {
    if (widget.type == CheckpointType.l1) {
      await _completeCheckpoint();
      if (!mounted) return;
      context.go('/goal?scroll=goal&edit=1&from=checkpoint');
      return;
    }
    if (widget.type == CheckpointType.l4) {
      await _completeCheckpoint();
      if (!mounted) return;
      context.go('/goal?scroll=journal');
      return;
    }
    if (widget.type == CheckpointType.l7) {
      await showRemindersSettingsSheet(
        context,
        onLater: () async {
          await _completeCheckpoint(navigateToTower: true);
        },
        onSaved: () async {
          await _completeCheckpoint(navigateToTower: true);
        },
      );
    }
  }

  Future<void> _handleSecondaryAction() async {
    if (widget.type == CheckpointType.l7) {
      await _completeCheckpoint(navigateToTower: true);
      return;
    }
    await _completeCheckpoint(navigateToTower: true);
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    // Pulse-анимация для L1 — первый чекпоинт, привлекаем внимание
    final bool shouldPulse = widget.type == CheckpointType.l1;

    return Scaffold(
      appBar: AppBar(
        title: Text(config.title),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: AppSpacing.insetsAll(AppSpacing.lg),
              child: BizLevelCard(
                variant: GlassVariant.hero,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.colorPrimaryLight,
                    AppColor.colorSurface,
                  ],
                ),
                semanticsLabel: '${config.header}. ${config.description}',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header — action-oriented заголовок
                    Text(
                      config.header,
                      style: AppTypography.headingSection.copyWith(
                        color: AppColor.colorTextPrimary,
                      ),
                    ),
                    AppSpacing.gapH(AppSpacing.sm),
                    // Description
                    Text(
                      config.description,
                      style: AppTypography.bodyDefault.copyWith(
                        color: AppColor.colorTextSecondary,
                      ),
                    ),
                    AppSpacing.gapH(AppSpacing.lg),
                    // Image с fade-анимацией
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLg),
                      child: _FadeInImage(
                        asset: config.imageAsset,
                        height: 200,
                      ),
                    ),
                    AppSpacing.gapH(AppSpacing.xl),
                    // Primary Button с иконкой
                    BizLevelButton(
                      icon: Icon(config.primaryIcon, size: 20),
                      label: config.primaryLabel,
                      size: BizLevelButtonSize.lg,
                      fullWidth: true,
                      onPressed: _busy ? null : _handlePrimaryAction,
                    ),
                    if (config.secondaryLabel != null) ...[
                      AppSpacing.gapH(AppSpacing.md), // Увеличен с sm до md
                      BizLevelButton(
                        label: config.secondaryLabel!,
                        variant: BizLevelButtonVariant.text, // Менее навязчивый
                        fullWidth: true,
                        onPressed: _busy ? null : _handleSecondaryAction,
                      ),
                    ],
                    // Дополнительный отступ снизу для bubble
                    AppSpacing.gapH(AppSpacing.x2l),
                  ],
                ),
              ),
            ),
            // Max Bubble — переиспользуемый виджет
            Positioned(
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: DiscussBubble.max(
                onTap: _openMaxChatSheet,
                pulse: shouldPulse,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fade-in анимация для изображения
class _FadeInImage extends StatefulWidget {
  final String asset;
  final double height;

  const _FadeInImage({required this.asset, required this.height});

  @override
  State<_FadeInImage> createState() => _FadeInImageState();
}

class _FadeInImageState extends State<_FadeInImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.normal,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onImageLoaded() {
    if (!_loaded) {
      _loaded = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: double.infinity,
        height: widget.height,
        color: AppColor.colorBackgroundSecondary,
        child: Image.asset(
          widget.asset,
          width: double.infinity,
          height: widget.height,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              _onImageLoaded();
              return child;
            }
            if (frame != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _onImageLoaded();
              });
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onImageLoaded();
            });
            return const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColor.colorTextTertiary,
                size: 48,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Конфигурация чекпоинта с иконками для кнопок
class CheckpointConfig {
  final String title;
  final String header;
  final String description;
  final String imageAsset;
  final String primaryLabel;
  final IconData primaryIcon;
  final String? secondaryLabel;
  final String successMessage;

  const CheckpointConfig({
    required this.title,
    required this.header,
    required this.description,
    required this.imageAsset,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.secondaryLabel,
    required this.successMessage,
  });

  factory CheckpointConfig.fromType(CheckpointType type) {
    switch (type) {
      case CheckpointType.l1:
        return const CheckpointConfig(
          title: 'Уровень 1',
          header: 'Поставь первую цель',
          description:
              'Сформулируй короткую и измеримую цель. Это опорная точка для всего пути обучения.',
          imageAsset: 'assets/images/lvls/level_1.png',
          primaryLabel: 'Сформулировать цель',
          primaryIcon: Icons.flag_outlined,
          secondaryLabel: 'Позже',
          successMessage: 'Чекпоинт L1 завершён',
        );
      case CheckpointType.l4:
        return const CheckpointConfig(
          title: 'Уровень 4',
          header: 'Начни вести журнал',
          description:
              'Регулярность — главный ускоритель роста. Отмечай применения навыков в журнале и следи за прогрессом.',
          imageAsset: 'assets/images/lvls/level_4.png',
          primaryLabel: 'Перейти в журнал',
          primaryIcon: Icons.edit_note_outlined,
          secondaryLabel: 'Позже',
          successMessage: 'Чекпоинт L4 завершён',
        );
      case CheckpointType.l7:
        return const CheckpointConfig(
          title: 'Уровень 7',
          header: 'Настрой напоминания',
          description:
              'Напоминания помогут удерживать регулярность и не терять темп обучения.',
          imageAsset: 'assets/images/lvls/level_7.png',
          primaryLabel: 'Настроить напоминания',
          primaryIcon: Icons.notifications_outlined,
          secondaryLabel: 'Позже',
          successMessage: 'Чекпоинт L7 завершён',
        );
    }
  }
}
