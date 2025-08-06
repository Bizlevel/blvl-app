import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_service.dart';
import '../../providers/auth_provider.dart';
import '../../theme/color.dart';
import '../../widgets/custom_textfield.dart';
import 'package:go_router/go_router.dart';

class OnboardingProfileScreen extends ConsumerStatefulWidget {
  const OnboardingProfileScreen({super.key});

  @override
  ConsumerState<OnboardingProfileScreen> createState() =>
      _OnboardingProfileScreenState();
}

class _OnboardingProfileScreenState
    extends ConsumerState<OnboardingProfileScreen> {
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _goalController = TextEditingController();

  bool _saving = false;
  int _selectedAvatarId = 1; // По умолчанию первый аватар

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // Проверяем, подтверждён ли e-mail – без него нельзя сохранить профиль.
    final user = ref.read(authServiceProvider).getCurrentUser();
    if (user?.email == null) {
      _showSnackBar('Подтвердите e-mail, прежде чем продолжить');
      return;
    }

    final name = _nameController.text.trim();
    final about = _aboutController.text.trim();
    final goal = _goalController.text.trim();

    if (name.isEmpty || about.isEmpty || goal.isEmpty) {
      _showSnackBar('Пожалуйста, заполните все поля');
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(authServiceProvider).updateProfile(
            name: name,
            about: about,
            goal: goal,
            avatarId: _selectedAvatarId,
          );
      if (!mounted) return;
      context.go('/onboarding/video');
    } on AuthFailure catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar('Ошибка сохранения профиля');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showAvatarPicker() async {
    final selectedId = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.medium),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.medium,
            crossAxisSpacing: AppSpacing.medium,
          ),
          itemCount: 7,
          itemBuilder: (_, index) {
            final id = index + 1;
            final asset = 'assets/images/avatars/avatar_${id}.png';
            final isSelected = id == _selectedAvatarId;
            return GestureDetector(
              onTap: () => Navigator.of(ctx).pop(id),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(asset, fit: BoxFit.cover),
                  ),
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primary, width: 3),
                          borderRadius: BorderRadius.circular(40),
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
      setState(() {
        _selectedAvatarId = selectedId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('О вас')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _showAvatarPicker,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/avatars/avatar_$_selectedAvatarId.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Как к вам обращаться?',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            CustomTextBox(
              key: const Key('name_field'),
              hint: 'Имя',
              controller: _nameController,
              prefix: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 24),
            const Text('Кратко о себе'),
            const SizedBox(height: 8),
            CustomTextBox(
              key: const Key('about_field'),
              hint: 'О себе',
              controller: _aboutController,
              prefix: const Icon(Icons.info_outline),
            ),
            const SizedBox(height: 24),
            const Text('Ваша цель обучения'),
            const SizedBox(height: 8),
            CustomTextBox(
              key: const Key('goal_field'),
              hint: 'Цель',
              controller: _goalController,
              prefix: const Icon(Icons.flag_outlined),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Далее'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
