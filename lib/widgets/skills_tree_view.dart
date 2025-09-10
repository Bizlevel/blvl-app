import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/models/user_skill_model.dart';

/// Виджет блока «Дерево навыков» в профиле.
/// Показывает 5 навыков плитками с лёгкими анимациями и прогрессом.
class SkillsTreeView extends StatefulWidget {
  const SkillsTreeView(
      {super.key, required this.skills, required this.currentLevel});

  /// Список навыков пользователя (всегда 5 записей, points от 0 до 10).
  final List<UserSkillModel> skills;
  final int currentLevel;

  static const int _maxPoints = 10;

  @override
  State<SkillsTreeView> createState() => _SkillsTreeViewState();
}

class _SkillsTreeViewState extends State<SkillsTreeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final bool _isLowEnd;

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
  void initState() {
    super.initState();
    final dpr = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .devicePixelRatio;
    _isLowEnd = dpr < 2.0;
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: _isLowEnd ? 700 : 1000))
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skills = widget.skills;
    if (skills.isEmpty) {
      return const Center(child: Text('Навыки пока не прокачаны.'));
    }

    // Вычисляем следующий навык (минимум очков < 10).
    final UserSkillModel? nextSkill = skills
        .where((s) => s.points < SkillsTreeView._maxPoints)
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Дерево навыков',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                tooltip: 'О дереве навыков',
                icon: const Icon(Icons.info_outline,
                    color: AppColor.onSurfaceSubtle),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Дерево навыков',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          Text(
                            'Здесь отображается прогресс прокачки ключевых навыков предпринимателя. '
                            'Завершая уровни, вы получаете +1 к соответствующим навыкам.',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              // Один столбец: навыки расположены вертикально, один под другим
              final crossAxisCount = 1;
              final spacing = 12.0;
              final totalSpacing = spacing * (crossAxisCount - 1);
              final tileWidth =
                  (constraints.maxWidth - totalSpacing) / crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var i = 0; i < skills.length; i++)
                    _buildAnimatedTile(
                      index: i,
                      width: tileWidth,
                      skill: skills[i],
                    ),
                ],
              );
            },
          ),
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
              'Уровень ${widget.currentLevel}: +1 навык',
              style: const TextStyle(color: AppColor.onSurfaceSubtle),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnimatedTile(
      {required int index,
      required double width,
      required UserSkillModel skill}) {
    final color = _skillColors[skill.skillId] ?? AppColor.info;
    final icon = _skillIcons[skill.skillId] ?? Icons.star_border;
    final progress = (skill.points / SkillsTreeView._maxPoints).clamp(0.0, 1.0);

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.05 * index, (0.05 * index) + (_isLowEnd ? 0.4 : 0.6),
          curve: Curves.easeOut),
    );

    final double maxShift = _isLowEnd ? 8 : 12;

    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        final t = curved.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * maxShift),
            child: child,
          ),
        );
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.borderColor.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
                color: AppColor.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      color: color,
                      backgroundColor: color.withOpacity(0.15),
                    ),
                  ),
                  Icon(icon, size: 20, color: color),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.skillName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  _SegmentedProgressBar(
                    total: SkillsTreeView._maxPoints,
                    filled: skill.points,
                    color: color,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('${skill.points}/${SkillsTreeView._maxPoints}',
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar({
    required this.total,
    required this.filled,
    required this.color,
  });

  final int total;
  final int filled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final int clampedFilled = filled.clamp(0, total);
    return Row(
      children: [
        for (int i = 0; i < total; i++)
          Expanded(
            child: Container(
              height: 8,
              margin: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
              decoration: BoxDecoration(
                color: i < clampedFilled ? color : color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
      ],
    );
  }
}
