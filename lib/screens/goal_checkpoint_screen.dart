import 'package:flutter/material.dart';

class GoalCheckpointScreen extends StatelessWidget {
  final int version;
  const GoalCheckpointScreen({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чекпоинт цели (устарел)'),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Экран чекпоинтов цели устарел и больше не используется.\nПерейдите в раздел \'Цель\' или на Уровень 1 для формулировки цели.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
