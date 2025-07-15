
// Vimeo/WebView support
import 'package:online_course/services/supabase_service.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:online_course/models/lesson_model.dart';
import 'package:video_player/video_player.dart';
import 'package:online_course/compat/webview_stub.dart'
    if (dart.library.io) 'package:webview_flutter/webview_flutter.dart';
import 'package:online_course/compat/ui_stub.dart' if (dart.library.html) 'dart:ui_web' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'package:online_course/compat/html_stub.dart'
    if (dart.library.html) 'dart:html'
    as html;


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

  // For iframe/WebView playback
  String? _embedUrl;
  bool _useWebView = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // Choose video source: Vimeo > Supabase Storage
      String directUrl;
      if (widget.lesson.vimeoId != null && widget.lesson.vimeoId!.isNotEmpty) {
        final embed = 'https://player.vimeo.com/video/${widget.lesson.vimeoId}?byline=0&portrait=0&playsinline=1';
        // For Web – use iframe; for iOS – use WebView; otherwise fallback to direct player
        if (kIsWeb) {
          _embedUrl = embed;
          _initialized = true;
          setState(() {});
          return;
        }
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          _embedUrl = embed;
          _useWebView = true;
          _initialized = true;
          setState(() {});
          return;
        }
        // Android/Desktop fallback: try to use video_player (may fail if Vimeo forbids)
        directUrl = embed;
      } else {
        // Fallback to Supabase Storage signed URL
        if (widget.lesson.videoUrl != null && widget.lesson.videoUrl!.isNotEmpty) {
          directUrl = await SupabaseService.getVideoSignedUrl(widget.lesson.videoUrl!) ??
              'https://acevqbdpzgbtqznbpgzr.supabase.co/storage/v1/object/public/video//DRAFT_1.2%20(1).mp4';
        } else {
          directUrl = 'https://acevqbdpzgbtqznbpgzr.supabase.co/storage/v1/object/public/video//DRAFT_1.2%20(1).mp4';
        }
      }

      // Use video_player for remaining cases
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 400,
            child: HtmlElementView(viewType: viewId),
          ),
          const SizedBox(height: 10),
          Text(widget.lesson.description, style: const TextStyle(fontSize: 14)),
        ],
      );
    }

    // iOS WebView playback
    if (_useWebView && _embedUrl != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 400,
            child: WebView(
              initialUrl: _embedUrl,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
          const SizedBox(height: 10),
          Text(widget.lesson.description, style: const TextStyle(fontSize: 14)),
        ],
      );
    }

    if (kIsWeb) {
      // Fallback: video_player widget (should rarely reach here)
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio == 0 ? 9 / 16 : _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    }

    if (_videoController == null || _chewieController == null) {
      return const Text('Видео недоступно');
    }

    return SingleChildScrollView(
      child: Column(
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
    ),
  );
  }
}
