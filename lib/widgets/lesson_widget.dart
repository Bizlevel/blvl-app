import 'dart:io';
// Vimeo support removed, using Supabase Storage signed URLs
import 'package:online_course/services/supabase_service.dart';

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
      // Получаем подписанный URL из Supabase Storage
      final directUrl = await SupabaseService.getVideoSignedUrl(
            widget.lesson.videoUrl) ??
          'https://acevqbdpzgbtqznbpgzr.supabase.co/storage/v1/object/public/video//DRAFT_1.2%20(1).mp4';

      // Кэшируем файл локально, если это mp4
      Uri uri = Uri.parse(directUrl);
      if (uri.path.endsWith('.mp4')) {
        final file = await DefaultCacheManager().getSingleFile(directUrl);
        _videoController = VideoPlayerController.file(File(file.path));
      } else {
        // потоковое воспроизведение (HLS / DASH)
        _videoController = VideoPlayerController.network(directUrl);
      }
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
    } catch (e) {
      debugPrint('Video init error: $e');
      // Показываем заглушку вместо бесконечного индикатора
      setState(() {
        _initialized = true;
        _videoController = null;
        _chewieController = null;
      });
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

    if (_videoController == null || _chewieController == null) {
      return const Text('Видео недоступно');
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
