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
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/typography.dart';

class LessonWidget extends ConsumerStatefulWidget {
  final LessonModel lesson;
  final VoidCallback onWatched;
  /// Автовход в fullscreen после первого play на mobile.
  ///
  /// В mini-case лучше держать выключенным: fullscreen-переход + AVAudioSession могут
  /// коррелировать с iOS hang/gesture-timeout и Impeller "no drawable" в логах.
  final bool autoFullscreenOnPlay;
  const LessonWidget(
      {super.key,
      required this.lesson,
      required this.onWatched,
      this.autoFullscreenOnPlay = true});

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
  int _initSeq = 0; // cancellation token for async init
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _startInit();
  }

  @override
  void didUpdateWidget(covariant LessonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // In case the same State gets reused (e.g. list rebuilds without keys),
    // re-init player when lesson changes.
    if (oldWidget.lesson.id != widget.lesson.id ||
        oldWidget.lesson.videoUrl != widget.lesson.videoUrl) {
      _startInit(resetProgress: true);
    }
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

  void _startInit({bool resetProgress = false}) {
    // invalidate any in-flight init
    _initSeq++;
    _enteredFullscreen = false;
    if (resetProgress) {
      _progressSent = false;
    }
    // cleanup existing controllers (best-effort, dispose() is async in plugin)
    _disposeControllersBestEffort();
    _videoController = null;
    _chewieController = null;
    _webIframeUrl = null;
    _initialized = false;
    if (mounted) setState(() {});
    // ignore: discarded_futures
    _initPlayer(seq: _initSeq);
  }

  void _disposeControllersBestEffort() {
    try {
      // На iOS/AVFoundation лучше явно выйти из fullscreen перед dispose,
      // чтобы уменьшить шанс PlayerRemoteXPC/Fig* ошибок при резком уходе со страницы.
      _chewieController?.exitFullScreen();
    } catch (_) {}
    try {
      // Best-effort: остановим воспроизведение перед dispose.
      _videoController?.pause();
    } catch (_) {}
    try {
      // Chewie holds listeners/timers; dispose it first.
      _chewieController?.dispose();
    } catch (_) {}
    try {
      _videoController?.removeListener(_listener);
    } catch (_) {}
    try {
      _videoController?.dispose();
    } catch (_) {}
    _chewieController = null;
    _videoController = null;
  }

  Future<void> _initPlayer({required int seq}) async {
    VideoPlayerController? controller;
    ChewieController? chewie;
    try {
      // Choose video source: video_url only (Bunny HLS or Supabase Storage)
      String directUrl;
      if (widget.lesson.videoUrl != null &&
          widget.lesson.videoUrl!.isNotEmpty) {
        final repo = ref.read(lessonsRepositoryProvider);
        final signed = await repo.getVideoSignedUrl(widget.lesson.videoUrl!);
        if (_isDisposed || !mounted || seq != _initSeq) return;
        if (signed == null) {
          _initialized = true;
          if (mounted) setState(() {});
          _autoMarkWatched();
          return;
        }
        directUrl = signed;
      } else {
        _initialized = true;
        if (mounted) setState(() {});
        _autoMarkWatched();
        return;
      }

      // Web HLS via local helper page (hls.js) inside iframe
      if (kIsWeb && _looksLikeHls(directUrl)) {
        final encoded = Uri.encodeComponent(directUrl);
        _webIframeUrl = '/hls_player.html?src=$encoded';
        _initialized = true;
        if (mounted) setState(() {});
        _autoMarkWatched();
        return;
      }

      // Use video_player for remaining cases
      controller =
          VideoPlayerController.networkUrl(Uri.parse(directUrl.trim()));
      await controller.initialize();
      if (_isDisposed || !mounted || seq != _initSeq) {
        try {
          await controller.dispose();
        } catch (_) {}
        return;
      }
      if (!kIsWeb) {
        chewie = ChewieController(
          videoPlayerController: controller,
          playbackSpeeds: const [0.5, 0.75, 1.0, 1.25, 1.5, 2.0],
          aspectRatio: controller.value.aspectRatio == 0
              ? 9 / 16
              : controller.value.aspectRatio,
        );
      }
      if (_isDisposed || !mounted || seq != _initSeq) {
        try {
          chewie?.dispose();
        } catch (_) {}
        try {
          await controller.dispose();
        } catch (_) {}
        return;
      }

      _videoController = controller;
      _chewieController = chewie;
      _videoController!.addListener(_listener);

      _initialized = true;
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Video init error: $e');
      // Показываем заглушку вместо бесконечного индикатора
      if (_isDisposed || !mounted || seq != _initSeq) return;
      try {
        chewie?.dispose();
      } catch (_) {}
      try {
        await controller?.dispose();
      } catch (_) {}
      _disposeControllersBestEffort();
      _initialized = true;
      if (mounted) setState(() {});
    }
  }

  // bunny test helper removed (logic in _initPlayer)

  void _listener() {
    if (_isDisposed || !mounted) return;
    final controller = _videoController;
    if (controller == null) return;
    if (!controller.value.isInitialized) return;

    final position = controller.value.position;

    // Auto-enter fullscreen on first user play:
    // Disabled for Android because it increases the chance of lifecycle races
    // (fullscreen route pushes + AndroidView/texture rebuilds) and correlates with
    // 'No active player with ID ...' crashes in production.
    if (!_enteredFullscreen &&
        widget.autoFullscreenOnPlay &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.iOS) {
      if (controller.value.isPlaying) {
        _enteredFullscreen = true;
        try {
          _chewieController?.enterFullScreen();
        } catch (_) {}
      }
    }

    if (!_progressSent && position >= const Duration(seconds: 10)) {
      _progressSent = true;
      if (mounted) widget.onWatched();
    }
  }

  // Gestures and custom overlay removed in favor of Chewie controls

  @override
  void dispose() {
    _isDisposed = true;
    _initSeq++; // invalidate any in-flight init
    _hideTimer?.cancel();
    _disposeControllersBestEffort();
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
            padding: AppSpacing.insetsAll(AppSpacing.lg),
            child: Text(widget.lesson.description,
                style: AppTypography.textTheme.bodyMedium),
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
            AppSpacing.gapH(AppSpacing.lg),
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
          padding: AppSpacing.insetsAll(AppSpacing.lg),
          child: Text(
            widget.lesson.description,
            style: AppTypography.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  bool _looksLikeHls(String url) => url.contains('.m3u8');
}
