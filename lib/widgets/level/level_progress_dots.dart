import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class LevelProgressDots extends StatelessWidget {
  final int current;
  final int total;
  final bool vertical;
  const LevelProgressDots(
      {super.key,
      required this.current,
      required this.total,
      this.vertical = false});
  @override
  Widget build(BuildContext context) {
    final dots = List.generate(
      total,
      (i) => Container(
        margin: const EdgeInsets.all(4),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: i <= current ? AppColor.primary : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      ),
    );

    return vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: dots)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dots,
            ),
          );
  }
}

