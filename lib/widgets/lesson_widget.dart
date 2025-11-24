// Video playback via video_url (Bunny HLS or Supabase Storage)
import 'package:bizlevel/providers/lessons_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chewie/chewie.dart';
import 'dart:async';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:video_player/video_player.dart';
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
  // Legacy flag (custom overlay removed after enabling Chewie controls)
  Timer? _hideTimer;
  bool _enteredFullscreen = false; // auto-fullscreen on mobile after first play

  // For Web iframe playback (local helper page with hls.js)
  String? _webIframeUrl;

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
      // Choose video source: video_url only (Bunny HLS or Supabase Storage)
      String directUrl;
      if (widget.lesson.videoUrl != null &&
          widget.lesson.videoUrl!.isNotEmpty) {
        final repo = ref.read(lessonsRepositoryProvider);
        final signed = await repo.getVideoSignedUrl(widget.lesson.videoUrl!);
        if (signed == null) {
          _initialized = true;
          setState(() {});
          _autoMarkWatched();
          return;
        }
        directUrl = signed;
      } else {
        _initialized = true;
        setState(() {});
        _autoMarkWatched();
        return;
      }

      // Web HLS via local helper page (hls.js) inside iframe
      if (kIsWeb && _looksLikeHls(directUrl)) {
        final encoded = Uri.encodeComponent(directUrl);
        _webIframeUrl = '/hls_player.html?src=$encoded';
        _initialized = true;
        setState(() {});
        _autoMarkWatched();
        return;
      }

      // Use video_player for remaining cases
      _videoController = VideoPlayerController.networkUrl(Uri.parse(directUrl));
      await _videoController!.initialize();
      if (!kIsWeb) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          playbackSpeeds: const [0.5, 0.75, 1.0, 1.25, 1.5, 2.0],
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

  // bunny test helper removed (logic in _initPlayer)

  void _listener() {
    final position = _videoController!.value.position;
    // Auto-enter fullscreen on first user play on mobile platforms
    if (!_enteredFullscreen && !kIsWeb) {
      final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android;
      if (isMobile && _videoController!.value.isPlaying) {
        _enteredFullscreen = true;
        try {
          _chewieController?.enterFullScreen();
        } catch (_) {}
      }
    }
    if (!_progressSent && position >= const Duration(seconds: 10)) {
      _progressSent = true;
      widget.onWatched();
    }
    if (mounted) setState(() {});
  }

  // Gestures and custom overlay removed in favor of Chewie controls

  @override
  void dispose() {
    _hideTimer?.cancel();
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

    // Web iframe playback (HLS)
    if (kIsWeb && _webIframeUrl != null) {
      final viewId = 'hls-web-${widget.lesson.levelId}-${widget.lesson.order}';
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
        final iframe = html.IFrameElement()
          ..style.border = 'none'
          ..allowFullscreen = true;
        iframe.src = _webIframeUrl!;
        return iframe;
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              const ratio = 9 / 16; // width / height for portrait
              final double maxH = constraints.maxHeight;
              final double maxW = constraints.maxWidth;
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

    // No explicit Web fallback here; other formats handled below

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
              final double maxH = constraints.maxHeight;
              final double maxW = constraints.maxWidth;
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

  bool _looksLikeHls(String url) => url.contains('.m3u8');
}
