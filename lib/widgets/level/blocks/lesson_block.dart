import 'package:flutter/material.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/widgets/lesson_widget.dart';
import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';

class LessonBlock extends LevelPageBlock {
  final LessonModel lesson;
  final void Function(int) onWatched;
  LessonBlock({required this.lesson, required this.onWatched});
  @override
  Widget build(BuildContext context, int index) {
    final bool isTablet =
        MediaQuery.of(context).size.shortestSide >= 600;
    return LessonWidget(
      key: ValueKey('lesson_${lesson.id}'),
      lesson: lesson,
      onWatched: () => onWatched(index),
      // На iPad авто‑fullscreen может зависать в landscape, выключаем на планшетах.
      autoFullscreenOnPlay: !isTablet,
    );
  }
}
