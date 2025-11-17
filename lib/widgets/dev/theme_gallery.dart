import 'package:flutter/material.dart';
import 'package:bizlevel/theme/design_tokens.dart';

class ThemeGalleryScreen extends StatelessWidget {
  const ThemeGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Gallery'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          _Section(
            title: 'Типографика',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Display Large', style: textTheme.displayLarge),
                Text('Headline Medium', style: textTheme.headlineMedium),
                Text('Title Large', style: textTheme.titleLarge),
                Text('Body Medium', style: textTheme.bodyMedium),
                Text('Label Small', style: textTheme.labelSmall),
              ],
            ),
          ),
          _Section(
            title: 'Кнопки',
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Primary'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('Tonal'),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Поля ввода',
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'user@example.com',
                  ),
                ),
                AppSpacing.gapH(AppSpacing.lg),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                  ),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Чипы',
            child: Wrap(
              spacing: AppSpacing.sm,
              children: [
                Chip(
                    label: const Text('Default'),
                    backgroundColor: colors.surface),
                Chip(
                  label: const Text('Primary'),
                  backgroundColor: colors.primaryContainer,
                  labelStyle: TextStyle(color: colors.onPrimaryContainer),
                ),
                const Chip(
                  label: Text('Success'),
                  backgroundColor: AppColor.backgroundSuccess,
                  labelStyle: TextStyle(color: AppColor.success),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Карточка',
            child: Card(
              elevation: AppDimensions.elevationHairline,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      child: const Icon(Icons.school),
                    ),
                    AppSpacing.gapW(AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Урок 1. Основы', style: textTheme.titleMedium),
                          AppSpacing.gapH(AppSpacing.xs),
                          Text('10 мин · видео + квиз',
                              style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        color: colors.onSurface.withValues(alpha: 0.4)),
                  ],
                ),
              ),
            ),
          ),
          _Section(
            title: 'Domain Themes (Chat/Quiz/GP/Progress)',
            child: _DomainThemesPreview(),
          ),
          _Section(
            title: 'Diagnostics',
            child: _Diagnostics(),
          ),
          const _Section(
            title: 'Палитра',
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _Swatch(tokenName: 'Primary', color: AppColor.primary),
                _Swatch(tokenName: 'Premium', color: AppColor.premium),
                _Swatch(tokenName: 'Success', color: AppColor.success),
                _Swatch(tokenName: 'Info', color: AppColor.info),
                _Swatch(tokenName: 'Warning', color: AppColor.warning),
                _Swatch(tokenName: 'Error', color: AppColor.error),
                _Swatch(tokenName: 'Surface', color: AppColor.surface),
                _Swatch(tokenName: 'Text', color: AppColor.textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DomainThemesPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chat = theme.extension<ChatTheme>();
    final quiz = theme.extension<QuizTheme>();
    final gp = theme.extension<GpTheme>();
    final prog = theme.extension<GameProgressTheme>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _BubbleSample('AI', chat?.colors.aiBg ?? Colors.grey.shade200,
                chat?.colors.aiText ?? theme.colorScheme.onSurface),
            _BubbleSample(
                'You',
                chat?.colors.userBg ?? theme.colorScheme.primary,
                chat?.colors.userText ?? theme.colorScheme.onPrimary),
          ],
        ),
        AppSpacing.gapH(AppSpacing.md),
        if (quiz != null)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: quiz.colors.optionBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: quiz.colors.borderColor),
                  ),
                  child: const Text('Option'),
                ),
              ),
              AppSpacing.gapW(AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: quiz.colors.selectedBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: const Text('Selected'),
                ),
              ),
              AppSpacing.gapW(AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: quiz.colors.correctBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: const Text('Correct'),
                ),
              ),
            ],
          ),
        if (quiz != null) AppSpacing.gapH(AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            _Badge('GP +50', gp?.colors.badgeBg ?? Colors.blue.shade50,
                gp?.colors.badgeText ?? Colors.blue),
            _Badge(
                'Spend -5',
                (gp?.colors.negative ?? Colors.red).withValues(alpha: 0.1),
                gp?.colors.negative ?? Colors.red),
          ],
        ),
        AppSpacing.gapH(AppSpacing.md),
        LinearProgressIndicator(
          value: 0.6,
          backgroundColor:
              prog?.progressBg ?? theme.colorScheme.surfaceContainerHighest,
          color: prog?.progressFg ?? theme.colorScheme.primary,
          minHeight: 8,
        ),
        AppSpacing.gapH(AppSpacing.md),
        _PreviewThemesRow(),
      ],
    );
  }
}

class _PreviewThemesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThemePreviewCard(title: 'Light', theme: AppTheme.light()),
        ),
        AppSpacing.gapW(AppSpacing.sm),
        Expanded(
          child: _ThemePreviewCard(title: 'Dark', theme: AppTheme.dark()),
        ),
        AppSpacing.gapW(AppSpacing.sm),
        Expanded(
          child: _ThemePreviewCard(title: 'OLED', theme: AppTheme.darkOled()),
        ),
      ],
    );
  }
}

class _Diagnostics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.bodySmall!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brightness: ${cs.brightness}'),
            Text('onSurface: 0x${cs.onSurface.toARGB32().toRadixString(16)}'),
            Text('surface:   0x${cs.surface.toARGB32().toRadixString(16)}'),
            Text('primary:   0x${cs.primary.toARGB32().toRadixString(16)}'),
          ],
        ),
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const _ThemePreviewCard({required this.title, required this.theme});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final t = Theme.of(context);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.textTheme.titleMedium),
                  AppSpacing.gapH(AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Button'),
                      ),
                      const Chip(label: Text('Chip')),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BubbleSample extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _BubbleSample(this.text, this.bg, this.fg);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Text(text, style: TextStyle(color: fg)),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge(this.label, this.bg, this.fg);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(title, style: AppTypography.textTheme.titleLarge),
          ),
          child,
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final String tokenName;
  final Color color;

  const _Swatch({required this.tokenName, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 120,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border:
            Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Text(
        tokenName,
        style: theme.textTheme.labelMedium?.copyWith(
          color: _onColor(color),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Color _onColor(Color bg) {
  // Простая эвристика для контраста над образцом цвета
  final double luminance = bg.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}
