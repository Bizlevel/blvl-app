import 'package:flutter/material.dart';
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
    1: Colors.purple, // Фокус лидера
    2: Colors.amber, // Денежный контроль
    3: Colors.orange, // Магнит клиентов
    4: Colors.blue, // Система действий
    5: Colors.green, // Скорость роста
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
          Divider(color: Colors.grey.shade300),
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
              style: const TextStyle(color: Colors.grey),
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
      final color = _skillColors[skill.skillId] ?? Colors.blue;
      final icon = _skillIcons[skill.skillId] ?? Icons.star_border;
      rows.add(_SkillRow(skill: skill, color: color, icon: icon));
      if (i != skills.length - 1) {
        rows.add(Divider(color: Colors.grey.shade300));
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
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              );
            },
          ),
        ],
      ),
    );
  }
}
