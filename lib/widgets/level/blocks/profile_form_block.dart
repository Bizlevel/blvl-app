import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/widgets/common/bizlevel_text_field.dart';
import 'package:bizlevel/theme/ui_strings.dart';
import 'package:bizlevel/providers/levels_provider.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/providers/user_skills_provider.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/services/supabase_service.dart';

import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';

class ProfileFormBlock extends LevelPageBlock {
  final int levelId;
  final TextEditingController nameController;
  final TextEditingController aboutController;
  final TextEditingController goalController;
  final int selectedAvatarId;
  final bool isEditing;
  final bool Function()? canCompleteLevel;
  final VoidCallback onEdit;
  final VoidCallback onSaved;
  final void Function(int) onAvatarChanged;

  ProfileFormBlock({
    required this.levelId,
    required this.nameController,
    required this.aboutController,
    required this.goalController,
    required this.selectedAvatarId,
    required this.isEditing,
    required this.canCompleteLevel,
    required this.onEdit,
    required this.onSaved,
    required this.onAvatarChanged,
  });

  Future<void> _showAvatarPicker(BuildContext context) async {
    final selectedId = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
          ),
          itemCount: 12,
          itemBuilder: (_, index) {
            final id = index + 1;
            final asset = 'assets/images/avatars/avatar_$id.png';
            final isSelected = id == selectedAvatarId;
            return GestureDetector(
              onTap: () => Navigator.of(ctx).pop(id),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                    child: Image.asset(asset, fit: BoxFit.cover),
                  ),
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primary, width: 3),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selectedId != null) {
      onAvatarChanged(selectedId);
    }
  }

  @override
  Widget build(BuildContext context, int index) {
    return Consumer(builder: (context, ref, _) {
      Future<void> save() async {
        final name = nameController.text.trim();
        final about = aboutController.text.trim();
        final goal = goalController.text.trim();
        if (name.isEmpty || about.isEmpty || goal.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(UIS.pleaseFillAllFields)),
          );
          return;
        }

        try {
          await ref.read(authServiceProvider).updateProfile(
                name: name,
                about: about,
                goal: goal,
                avatarId: selectedAvatarId,
                onboardingCompleted: true,
              );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(UIS.profileSaved)),
            );
          }
          onSaved();
        } on AuthFailure catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message)),
            );
          }
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(UIS.saveErrorGeneric)),
            );
          }
        }
      }

      return LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              GestureDetector(
                onTap: isEditing ? () => _showAvatarPicker(context) : null,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                      child: Image.asset(
                        'assets/images/avatars/avatar_$selectedAvatarId.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: isEditing
                          ? Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColor.surface,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radius14,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColor.shadow,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: AppColor.primary,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BizLevelTextField(
                label: 'Как к вам обращаться?',
                hint: 'Имя',
                controller: nameController,
                readOnly: !isEditing,
                prefix: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              BizLevelTextField(
                label: 'Кратко о себе',
                hint: 'О себе',
                controller: aboutController,
                readOnly: !isEditing,
                prefix: const Icon(Icons.info_outline),
              ),
              const SizedBox(height: 16),
              BizLevelTextField(
                label: 'Ваша цель обучения',
                hint: 'Цель',
                controller: goalController,
                readOnly: !isEditing,
                prefix: const Icon(Icons.flag_outlined),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: BizLevelButton(
                  label: 'Перейти на Уровень 1',
                  onPressed: () async {
                    await save();
                    final bool canComplete = canCompleteLevel?.call() ?? true;
                    if (!canComplete) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Сначала посмотрите все видео этого уровня'),
                          ),
                        );
                      }
                      return;
                    }
                    if (!context.mounted) return;
                    try {
                      await SupabaseService.completeLevel(levelId);
                      if (!context.mounted) return;
                      ref.invalidate(levelsProvider);
                      ref.invalidate(currentUserProvider);
                      ref.invalidate(userSkillsProvider);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(UIS.firstStepDone)),
                      );
                      GoRouter.of(context).go('/tower?scrollTo=1');
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка: $e')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
