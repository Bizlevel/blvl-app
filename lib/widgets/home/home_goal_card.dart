import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/providers/goals_providers.dart';
import 'package:bizlevel/providers/goals_repository_provider.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';

class HomeGoalCard extends ConsumerWidget {
  const HomeGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(userGoalProvider);
    return Semantics(
      label: 'Моя цель',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/goal'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints: const BoxConstraints(
                minHeight: AppDimensions.homeGoalMinHeight),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: goalAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Не удалось загрузить цель'),
              data: (goal) {
                final repo = ref.read(goalsRepositoryProvider);
                final progress = repo.computeGoalProgressPercent(goal) ?? 0.0;
                final percent = (progress * 100).clamp(0, 100).round();
                final String goalText = (goal?['goal_text'] ?? '').toString();

                int? daysLeft;
                try {
                  final td = (goal?['target_date']?.toString());
                  final dt =
                      td == null ? null : DateTime.tryParse(td)?.toLocal();
                  if (dt != null) {
                    daysLeft = dt.difference(DateTime.now()).inDays;
                  }
                } catch (_) {}

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Text('🎯 МОЯ ЦЕЛЬ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.textColor)),
                        const Spacer(),
                        Text('$percent%',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColor.premium)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: (progress).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xFF4A90E2),
                                Color(0xFF5BC1FF)
                              ]),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      goalText.isEmpty ? 'Цель не задана' : goalText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15,
                          height: 22 / 15,
                          color: AppColor.textColor),
                    ),
                    const SizedBox(height: 12),
                    if (daysLeft != null)
                      Row(
                        children: [
                          const Text('⏱ ', style: TextStyle(fontSize: 16)),
                          Text(
                            daysLeft < 0
                                ? 'Дедлайн прошёл'
                                : 'Осталось $daysLeft дней',
                            style: TextStyle(
                              fontSize: 14,
                              color: daysLeft < 0
                                  ? const Color(0xFFE11D48)
                                  : const Color(0xFF7F8C8B),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            label: 'Открыть журнал применений',
                            button: true,
                            child: OutlinedButton(
                              onPressed: () => context.go('/goal'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 36),
                                side: const BorderSide(color: AppColor.border),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                foregroundColor: AppColor.primary,
                              ),
                              child: const Text('📝 Прогресс'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Semantics(
                            label: 'Обсудить цель с тренером Максом',
                            button: true,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LeoDialogScreen(
                                      bot: 'max',
                                      userContext: [
                                        if (goalText.isNotEmpty)
                                          'goal_text: $goalText'
                                      ].join('\n'),
                                      levelContext: '',
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 36),
                                side: const BorderSide(color: AppColor.border),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                foregroundColor: AppColor.primary,
                              ),
                              child: const Text('💬 Макс'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
