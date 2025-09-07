import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/common/bizlevel_progress_bar.dart';
import 'package:bizlevel/models/user_skill_model.dart';

/// Виджет блока «Шкала навыков» в профиле.
/// Показывает 5 навыков с прогресс-барами и информацией о следующем уровне.
class SkillsTreeView extends StatelessWidget {
  const SkillsTreeView(
      {super.key, required this.skills, required this.currentLevel});

  /// Список навыков пользователя (всегда 5 записей, points от 0 до 10).
  final List<UserSkillModel> skills;
  final int currentLevel;

  static const int _maxPoints = 10;

  // Цвета прогресса по id навыка.
  static const Map<int, Color> _skillColors = {
    1: Color(0xFF7C3AED), // purple
    2: Color(0xFFF59E0B), // amber
    3: Color(0xFFFB923C), // orange
    4: Color(0xFF3B82F6), // blue
    5: Color(0xFF10B981), // green
  };

  // Подбор иконок (можно заменить на кастомные изображения при желании).
  static const Map<int, IconData> _skillIcons = {
    1: Icons.psychology_alt_outlined,
    2: Icons.attach_money,
    3: Icons.campaign_outlined,
    4: Icons.task_alt_outlined,
    5: Icons.trending_up,
  };

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const Center(child: Text('Навыки пока не прокачаны.'));
    }

    // Вычисляем следующий навык (минимум очков < 10).
    final UserSkillModel? nextSkill = skills
        .where((s) => s.points < _maxPoints)
        .fold<UserSkillModel?>(null, (prev, curr) {
      if (prev == null) return curr;
      return curr.points < prev.points ? curr : prev;
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Шкала навыков',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ..._buildSkillRows(),
          const SizedBox(height: 12),
          Divider(color: AppColor.divider),
          const SizedBox(height: 8),
          if (nextSkill == null)
            const Text(
              'Все навыки освоены! 🎉',
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          else ...[
            Text(
              'Следующий навык: ${nextSkill.skillName}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Уровень $currentLevel: +1 навык',
              style: const TextStyle(color: AppColor.onSurfaceSubtle),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildSkillRows() {
    final List<Widget> rows = [];
    for (var i = 0; i < skills.length; i++) {
      final skill = skills[i];
      final color = _skillColors[skill.skillId] ?? AppColor.info;
      final icon = _skillIcons[skill.skillId] ?? Icons.star_border;
      rows.add(_SkillRow(skill: skill, color: color, icon: icon));
      if (i != skills.length - 1) {
        rows.add(Divider(color: AppColor.divider));
      }
    }
    return rows;
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow(
      {required this.skill, required this.color, required this.icon});

  final UserSkillModel skill;
  final Color color;
  final IconData icon;

  static const int _maxPoints = SkillsTreeView._maxPoints;

  @override
  Widget build(BuildContext context) {
    final progress = skill.points / _maxPoints;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  skill.skillName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text('${skill.points}/$_maxPoints'),
            ],
          ),
          const SizedBox(height: 6),
          BizLevelProgressBar(value: progress, color: color),
        ],
      ),
    );
  }
}
