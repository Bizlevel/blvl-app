import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:online_course/models/lesson_model.dart';
import 'package:video_player/video_player.dart';

class LessonWidget extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onWatched;
  const LessonWidget({Key? key, required this.lesson, required this.onWatched})
      : super(key: key);

  @override
  State<LessonWidget> createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _initialized = false;
  bool _isEnded = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // Кэшируем видео локально
      final file =
          await DefaultCacheManager().getSingleFile(widget.lesson.videoUrl);
      _videoController = VideoPlayerController.file(File(file.path));
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        aspectRatio: _videoController!.value.aspectRatio == 0
            ? 9 / 16
            : _videoController!.value.aspectRatio,
      );
      _videoController!.addListener(_listener);
      setState(() {
        _initialized = true;
      });
    } catch (_) {
      // ignore errors for now – UI покажет fallback
    }
  }

  void _listener() {
    if (!_isEnded &&
        _videoController!.value.position >= _videoController!.value.duration) {
      _isEnded = true;
      widget.onWatched();
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_listener);
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio == 0
              ? 9 / 16
              : _videoController!.value.aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),
        const SizedBox(height: 10),
        Text(
          widget.lesson.description,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
