import 'package:flutter/material.dart';
import 'package:bizlevel/widgets/common/bizlevel_button.dart';

class LevelNavBar extends StatelessWidget {
  final bool canBack;
  final bool canNext;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onDiscuss;
  final bool showDiscuss;
  const LevelNavBar({
    super.key,
    required this.canBack,
    required this.canNext,
    required this.onBack,
    required this.onNext,
    required this.onDiscuss,
    this.showDiscuss = true,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BizLevelButton(
            label: 'Назад',
            onPressed: canBack ? onBack : null,
          ),
          if (showDiscuss)
            BizLevelButton(
              label: 'Обсудить с Лео',
              onPressed: onDiscuss,
            ),
          BizLevelButton(
            label: 'Далее',
            onPressed: canNext ? onNext : null,
          ),
        ],
      ),
    );
  }
}

