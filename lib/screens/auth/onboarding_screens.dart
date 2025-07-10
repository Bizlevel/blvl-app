import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_service.dart';
import '../../theme/color.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_image.dart';

class OnboardingProfileScreen extends ConsumerStatefulWidget {
  const OnboardingProfileScreen({Key? key}) : super(key: key);

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

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final about = _aboutController.text.trim();
    final goal = _goalController.text.trim();

    if (name.isEmpty || about.isEmpty || goal.isEmpty) {
      _showSnackBar('Пожалуйста, заполните все поля');
      return;
    }

    setState(() => _saving = true);
    try {
      await AuthService.updateProfile(name: name, about: about, goal: goal);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingVideoScreen()),
      );
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
              child: CustomImage(
                'https://placehold.co/90x90',
                width: 90,
                height: 90,
                radius: 15,
              ),
            ),
            const SizedBox(height: 32),
            const Text('Как к вам обращаться?',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            CustomTextBox(
              hint: 'Имя',
              controller: _nameController,
              prefix: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 24),
            const Text('Кратко о себе'),
            const SizedBox(height: 8),
            CustomTextBox(
              hint: 'О себе',
              controller: _aboutController,
              prefix: const Icon(Icons.info_outline),
            ),
            const SizedBox(height: 24),
            const Text('Ваша цель обучения'),
            const SizedBox(height: 8),
            CustomTextBox(
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

// Placeholder for next step, to be implemented in Task 3.4
class OnboardingVideoScreen extends StatelessWidget {
  const OnboardingVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Онбординг: Видео')),
      body: const Center(
        child: Text('Экран видео будет реализован в Задаче 3.4'),
      ),
    );
  }
}
