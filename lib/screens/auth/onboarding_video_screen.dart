import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:online_course/services/supabase_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../root_app.dart';
import '../../theme/color.dart';


class OnboardingVideoScreen extends StatefulWidget {
  const OnboardingVideoScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingVideoScreen> createState() => _OnboardingVideoScreenState();
}

class _OnboardingVideoScreenState extends State<OnboardingVideoScreen> {
  static const _relativeVideoPath = 'onboarding.mp4';

  ChewieController? _chewieController;
  VideoPlayerController? _videoController;
  bool _canSkip = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _startSkipTimer();
  }

  Future<void> _initVideo() async {
    try {
      // Кэшируем видео файл
      final signedUrl = await SupabaseService.getVideoSignedUrl(
            _relativeVideoPath) ??
        'https://acevqbdpzgbtqznbpgzr.supabase.co/storage/v1/object/public/video//DRAFT_1.2%20(1).mp4';
      final file = await DefaultCacheManager().getSingleFile(signedUrl);
      _videoController = VideoPlayerController.file(File(file.path));
      await _videoController!.initialize();
      _videoController!.setLooping(false);

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        allowPlaybackSpeedChanging: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColor.primary,
          handleColor: AppColor.primary,
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.grey.shade400,
        ),
        autoInitialize: true,
        showControls: true,
      );

      // переход на RootApp после окончания
      _videoController!.addListener(() {
        if (_videoController!.value.position >=
            _videoController!.value.duration) {
          _goToApp();
        }
      });

      setState(() {});
    } catch (e) {
      debugPrint('Video init error: $e');
    }
  }

  void _startSkipTimer() {
    Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _canSkip = true);
    });
  }

  void _goToApp() async {
    // Помечаем, что онбординг пройден
    final user = SupabaseService.client.auth.currentUser;
    if (user != null) {
      try {
        await SupabaseService.client
            .from('users')
            .update({'onboarding_completed': true}).eq('id', user.id);
      } catch (_) {}
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RootApp()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Chewie(controller: _chewieController!),
                    )
                  : const CircularProgressIndicator(color: Colors.white),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: TextButton(
                onPressed: _canSkip ? _goToApp : null,
                child: Text(
                  'Пропустить',
                  style: TextStyle(
                    color: _canSkip ? Colors.white : Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
              onPressed: _goToApp,
              child: const Text('Начать'),
            ),
          ),
        ),
      ),
    );
  }
}
