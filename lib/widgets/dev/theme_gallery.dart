import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/typography.dart';

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
        padding: EdgeInsets.all(AppSpacing.screenPadding),
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
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'user@example.com',
                  ),
                ),
                AppSpacing.gapH(AppSpacing.lg),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
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
                Chip(
                  label: const Text('Success'),
                  backgroundColor: AppColor.backgroundSuccess,
                  labelStyle: const TextStyle(color: AppColor.success),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Карточка',
            child: Card(
              elevation: AppDimensions.elevationHairline,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.cardPadding),
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
                        color: colors.onSurface.withOpacity(0.4)),
                  ],
                ),
              ),
            ),
          ),
          _Section(
            title: 'Прогресс и стрик',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: colors.surfaceVariant,
                  color: colors.primary,
                  minHeight: 8,
                ),
                AppSpacing.gapH(AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: AppColor.warmAccent),
                    AppSpacing.gapW(AppSpacing.xs),
                    Text('Streak: 5 дней', style: textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
          ),
          _Section(
            title: 'Палитра',
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: const [
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

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
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
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
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
