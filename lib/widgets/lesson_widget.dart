
// Vimeo support removed, using Supabase Storage signed URLs
import 'package:online_course/services/supabase_service.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
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
  bool _progressSent = false;

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

      // Для Web и Mobile используем потоковое воспроизведение
      _videoController = VideoPlayerController.network(directUrl);
      await _videoController!.initialize();
      if (!kIsWeb) {
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
      }
      _videoController!.addListener(_listener);
      if (!mounted) return;
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      debugPrint('Video init error: $e');
      // Показываем заглушку вместо бесконечного индикатора
      if (!mounted) return;
      setState(() {
        _initialized = true;
        _videoController = null;
        _chewieController = null;
      });
    }
  }



  void _listener() {
    final position = _videoController!.value.position;
    if (!_progressSent && position >= const Duration(seconds: 10)) {
      _progressSent = true;
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

    if (kIsWeb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio == 0 ? 9 / 16 : _videoController!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_videoController!),
                if (!_videoController!.value.isPlaying)
                  IconButton(
                    iconSize: 64,
                    color: Colors.white,
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () => _videoController!.play(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(widget.lesson.description, style: const TextStyle(fontSize: 14)),
        ],
      );
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
