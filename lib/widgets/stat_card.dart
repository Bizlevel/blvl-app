import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

/// Универсальная карточка для отображения числовой статистики с иконкой.
/// Используется в ProfileScreen и LeoChatScreen вместо дублирующегося UI.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.icon,
    this.color = AppColor.primary,
    this.height = 110,
    this.showChevron = false,
    this.chevronIcon = Icons.expand_more,
  });

  /// Текст внутри карточки (например «3 LVL» / «12 Leo»)
  final String title;

  /// Иконка, отображаемая сверху.
  final IconData icon;

  /// Основной цвет текста и иконки.
  final Color color;

  /// Фиксированная высота карточки для единообразия сетки.
  final double height;

  /// Показать стрелку в правом верхнем углу внутри карточки.
  final bool showChevron;

  /// Иконка стрелки (по умолчанию вниз).
  final IconData chevronIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 24, color: color),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Positioned(
                right: 6,
                top: 6,
                child: Icon(
                  chevronIcon,
                  size: 16,
                  color: AppColor.labelColor.withValues(alpha: 0.9),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
