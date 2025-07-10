import 'package:flutter/material.dart';

class OnboardingProfileScreen extends StatelessWidget {
  const OnboardingProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Онбординг: Профиль')),
      body: const Center(
        child: Text('Экран онбординга будет реализован в Задаче 3.3'),
      ),
    );
  }
}
