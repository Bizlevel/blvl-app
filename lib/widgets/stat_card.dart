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
  });

  /// Текст внутри карточки (например «3 LVL» / «12 Leo»)
  final String title;

  /// Иконка, отображаемая сверху.
  final IconData icon;

  /// Основной цвет текста и иконки.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
