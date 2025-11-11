import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';
import 'package:bizlevel/widgets/common/breadcrumb.dart';
import 'package:bizlevel/widgets/level/parallax_image.dart';
import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';

class IntroBlock extends LevelPageBlock {
  final int levelId;
  final int levelNumber;
  IntroBlock({required this.levelId, required this.levelNumber});
  @override
  Widget build(BuildContext context, int index) {
    final bool isFirstStep = levelNumber == 0;
    final String title = isFirstStep ? 'Первый шаг' : 'Уровень $levelNumber';
    final String description = isFirstStep
        ? 'Привет! 👋\nЯ Leo, ваш персональный AI-ментор по бизнесу.\nЗа следующие пару минут Вы:\n- Узнаете, как получить максимум от BizLevel\n- Настроите свой профиль, чтобы я мог давать Вам персонализированные советы и рекомендации.\nГотовы начать свой путь в бизнесе?'
        : 'Проходите уроки по порядку и выполняйте тесты, чтобы продвигаться дальше.';

    return Padding(
      padding: AppSpacing.insetsAll(AppSpacing.lg),
      child: LayoutBuilder(builder: (context, constraints) {
        final String assetPath = 'assets/images/lvls/level_$levelNumber.png';
        final double imageHeight = constraints.maxHeight * 0.45;
        return Stack(
          children: [
            // Хлебные крошки
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Breadcrumb(
                    items: [
                      BreadcrumbItem(
                        label: 'Главная',
                        onTap: () => context.go('/home'),
                      ),
                      BreadcrumbItem(
                        label: 'Башня',
                        onTap: () => context.go('/tower?scrollTo=$levelNumber'),
                      ),
                      BreadcrumbItem(
                        label: 'Уровень $levelNumber',
                        isCurrent: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Кнопка «Назад к башне» в левом верхнем углу
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  tooltip: 'К башне',
                  onPressed: () {
                    try {
                      if (levelNumber > 0) {
                        GoRouter.of(context).go('/tower?scrollTo=$levelNumber');
                      } else {
                        GoRouter.of(context).go('/tower');
                      }
                    } catch (_) {}
                  },
                ),
              ),
            ),

            // Основной контент по центру
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Картинка уровня (для уровня 0 изображения может не быть)
                    if (!isFirstStep)
                      ParallaxImage(
                        assetPath: assetPath,
                        height: imageHeight.clamp(160, 360),
                      ),
                    if (!isFirstStep) AppSpacing.gapH(AppSpacing.lg),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge ??
                          AppTypography.textTheme.headlineLarge,
                    ),
                    AppSpacing.gapH(AppSpacing.md),
                    Padding(
                      padding: AppSpacing.insetsSymmetric(h: AppSpacing.md),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

