import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

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
      // Получаем прямой URL (для Vimeo преобразуем)
      final directUrl = await _resolvePlayableUrl(widget.lesson.videoUrl);

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

  /// If URL is a plain Vimeo page, fetches player config and returns direct mp4/HLS url.
  Future<String> _resolvePlayableUrl(String url) async {
    if (url.contains('vimeo.com') && !url.contains('player.vimeo.com')) {
      final idMatch = RegExp(r'vimeo\.com\/(\d+)').firstMatch(url);
      if (idMatch != null) {
        final id = idMatch.group(1);
        final configUrl = 'https://player.vimeo.com/video/$id/config';
        try {
          final response = await Dio().get(configUrl);
          final data = response.data is String
              ? jsonDecode(response.data as String)
              : response.data;

          // предпочитаем mp4 progressive
          final progressive =
              (data['request']['files']['progressive'] as List?) ?? [];
          if (progressive.isNotEmpty) {
            return progressive.first['url'] as String;
          }
          // fallback to hls
          final hls = data['request']['files']['hls']?['cdns'] as Map?;
          if (hls != null && hls.isNotEmpty) {
            return (hls.values.first as Map)['url'] as String;
          }
        } catch (e) {
          debugPrint('Failed to resolve Vimeo url: $e');
        }
      }
    }
    return url;
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
