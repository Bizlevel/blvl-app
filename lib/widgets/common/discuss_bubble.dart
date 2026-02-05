import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/theme/animations.dart';

/// Переиспользуемый floating bubble для вызова чата с AI-ассистентом.
///
/// Используется в:
/// - [LevelDetailScreen] — "Обсудить с Лео"
/// - [CheckpointScreen] — "Обсудить с Максом"
class DiscussBubble extends StatelessWidget {
  /// Текст кнопки (например "Обсудить с Лео")
  final String label;

  /// Путь к изображению аватара
  final String avatarAsset;

  /// Callback при нажатии
  final VoidCallback onTap;

  /// Включить pulse-анимацию для привлечения внимания
  final bool pulse;

  /// Семантическая метка для accessibility
  final String? semanticsLabel;

  const DiscussBubble({
    super.key,
    required this.label,
    required this.avatarAsset,
    required this.onTap,
    this.pulse = false,
    this.semanticsLabel,
  });

  /// Фабрика для создания bubble с Лео
  factory DiscussBubble.leo({
    Key? key,
    required VoidCallback onTap,
    bool pulse = false,
  }) {
    return DiscussBubble(
      key: key,
      label: 'Обсудить с Лео',
      avatarAsset: 'assets/images/avatars/avatar_leo.png',
      onTap: onTap,
      pulse: pulse,
      semanticsLabel: 'Открыть чат с Лео',
    );
  }

  /// Фабрика для создания bubble с Максом
  factory DiscussBubble.max({
    Key? key,
    required VoidCallback onTap,
    bool pulse = false,
  }) {
    return DiscussBubble(
      key: key,
      label: 'Обсудить с Максом',
      avatarAsset: 'assets/images/avatars/avatar_max.png',
      onTap: onTap,
      pulse: pulse,
      semanticsLabel: 'Открыть чат с Максом',
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget bubble = _buildBubble(context);
    final Widget button = _buildButton(bubble);

    if (!pulse) return button;

    return _PulseAnimation(child: button);
  }

  Widget _buildBubble(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.colorSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColor.colorPrimary),
        boxShadow: [
          BoxShadow(
            color: AppColor.colorPrimary.withValues(alpha: 0.2),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage(avatarAsset),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColor.colorPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(Widget bubble) {
    return Semantics(
      label: semanticsLabel ?? label,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          onTap: onTap,
          child: bubble,
        ),
      ),
    );
  }
}

/// Pulse-анимация для привлечения внимания
class _PulseAnimation extends StatefulWidget {
  final Widget child;

  const _PulseAnimation({required this.child});

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.pulse,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
