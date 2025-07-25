// Vimeo/WebView support
import 'package:bizlevel/providers/lessons_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:video_player/video_player.dart';
import 'package:bizlevel/compat/webview_stub.dart'
    if (dart.library.io) 'package:webview_flutter/webview_flutter.dart';
import 'package:bizlevel/compat/ui_stub.dart'
    if (dart.library.html) 'dart:ui_web' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'package:bizlevel/compat/html_stub.dart'
    if (dart.library.html) 'dart:html' as html;

class LessonWidget extends ConsumerStatefulWidget {
  final LessonModel lesson;
  final VoidCallback onWatched;
  const LessonWidget(
      {super.key, required this.lesson, required this.onWatched});

  @override
  ConsumerState<LessonWidget> createState() => _LessonWidgetState();
}

class _LessonWidgetState extends ConsumerState<LessonWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _initialized = false;
  bool _progressSent = false;

  // For iframe/WebView playback
  String? _embedUrl;
  bool _useWebView = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  /// Если мы не можем отследить прогресс (iframe/WebView) – считаем урок просмотренным
  void _autoMarkWatched() {
    if (_progressSent) return;
    _progressSent = true;
    // Откладываем модификацию провайдера до конца кадра, чтобы избежать ошибки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onWatched();
    });
  }

  Future<void> _initPlayer() async {
    try {
      // Choose video source: Vimeo > Supabase Storage
      String directUrl;
      if (widget.lesson.vimeoId != null && widget.lesson.vimeoId!.isNotEmpty) {
        final embed =
            'https://player.vimeo.com/video/${widget.lesson.vimeoId}?byline=0&portrait=0&playsinline=1';
        // For Web – use iframe; for iOS – use WebView; otherwise fallback to direct player
        if (kIsWeb) {
          _embedUrl = embed;
          _initialized = true;
          setState(() {});
          // Нет возможности трекать воспроизведение iframe → сразу помечаем просмотренным
          _autoMarkWatched();
          return;
        }
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          _embedUrl = embed;
          _useWebView = true;
          _initialized = true;
          setState(() {});
          _autoMarkWatched();
          return;
        }
        // Android/Desktop fallback: try to use video_player (may fail if Vimeo forbids)
        directUrl = embed;
      } else {
        // Fallback to Supabase Storage signed URL если указан путь
        if (widget.lesson.videoUrl != null &&
            widget.lesson.videoUrl!.isNotEmpty) {
          final repo = ref.read(lessonsRepositoryProvider);
          final signed = await repo.getVideoSignedUrl(widget.lesson.videoUrl!);
          if (signed == null) {
            // Нет видео → помечаем как просмотренное и показываем заглушку
            _initialized = true;
            setState(() {});
            _autoMarkWatched();
            return;
          }
          directUrl = signed;
        } else {
          // Нет источника видео – помечаем просмотренным и выходим
          _initialized = true;
          setState(() {});
          _autoMarkWatched();
          return;
        }
      }

      // Use video_player for remaining cases
      _videoController = VideoPlayerController.networkUrl(Uri.parse(directUrl));
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

    // Web iframe playback
    if (kIsWeb && _embedUrl != null) {
      final viewId = 'vimeo-${widget.lesson.vimeoId}';
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
        final iframe = html.IFrameElement()
          ..src = _embedUrl!
          ..style.border = 'none'
          ..allowFullscreen = true;
        return iframe;
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              const ratio = 9 / 16; // width / height for portrait
              double maxH = constraints.maxHeight;
              double maxW = constraints.maxWidth;
              double h = maxW / ratio;
              double w = maxW;
              if (h > maxH) {
                h = maxH;
                w = h * ratio;
              }
              return Center(
                child: SizedBox(
                  width: w,
                  height: h,
                  child: HtmlElementView(viewType: viewId),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.lesson.description,
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      );
    }

    // iOS WebView playback
    if (_useWebView && _embedUrl != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              const ratio = 9 / 16;
              double maxH = constraints.maxHeight;
              double maxW = constraints.maxWidth;
              double h = maxW / ratio;
              double w = maxW;
              if (h > maxH) {
                h = maxH;
                w = h * ratio;
              }
              return Center(
                child: SizedBox(
                  width: w,
                  height: h,
                  child: WebView(
                    initialUrl: _embedUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.lesson.description,
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      );
    }

    if (kIsWeb) {
      // Fallback: video_player widget (should rarely reach here)
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio == 0
            ? 9 / 16
            : _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    }

    if (_videoController == null || _chewieController == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Видео недоступно'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onWatched,
              child: const Text('Пропустить'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final ratio = _videoController!.value.aspectRatio == 0
                  ? 9 / 16
                  : _videoController!.value.aspectRatio;
              double maxH = constraints.maxHeight;
              double maxW = constraints.maxWidth;
              double h = maxW / ratio;
              double w = maxW;
              if (h > maxH) {
                h = maxH;
                w = h * ratio;
              }
              return Center(
                child: SizedBox(
                  width: w,
                  height: h,
                  child: Chewie(controller: _chewieController!),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.lesson.description,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
