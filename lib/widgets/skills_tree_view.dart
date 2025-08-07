import 'package:flutter/material.dart';
import 'package:bizlevel/models/user_skill_model.dart';

class SkillsTreeView extends StatelessWidget {
  final List<UserSkillModel> skills;

  const SkillsTreeView({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const Center(
        child: Text('Навыки пока не прокачаны.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Древо навыков",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...skills.map((skill) => _buildSkillProgress(skill)),
      ],
    );
  }

  Widget _buildSkillProgress(UserSkillModel skill) {
    // Предполагаем, что максимальное количество очков для одного навыка - 10.
    const maxPoints = 10;
    final progress = skill.points / maxPoints;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.skillName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${skill.points}/$maxPoints',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
