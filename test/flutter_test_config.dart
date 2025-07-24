import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

/// Простейшая заглушка для [VideoPlayerPlatform].
class _FakeVideoPlayerPlatform extends VideoPlayerPlatform {
  @override
  Future<void> init() async {}

  @override
  Future<int?> create(DataSource dataSource) async => 1;

  @override
  Future<void> dispose(int textureId) async {}

  @override
  Future<void> setLooping(int textureId, bool looping) async {}

  @override
  Future<void> play(int textureId) async {}

  @override
  Future<void> pause(int textureId) async {}

  @override
  Future<Duration> getPosition(int textureId) async => Duration.zero;

  @override
  Future<Duration> getDuration(int textureId) async =>
      const Duration(seconds: 1);

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) => const Stream.empty();

  @override
  Future<void> seekTo(int textureId, Duration position) async {}

  @override
  Future<void> setVolume(int textureId, double volume) async {}

  @override
  Future<void> setPlaybackSpeed(int textureId, double speed) async {}
}

/// Вызывается **до** запуска любого теста.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Подгружаем пустые переменные окружения, чтобы не падал dotenv.
  dotenv.dotenv.testLoad(fileInput: 'SUPABASE_URL=\nSUPABASE_ANON_KEY=\n');

  // Заглушаем shared_preferences до любых обращений.
  SharedPreferences.setMockInitialValues({});

  // Инициализируем Supabase с фиктивными значениями.
  await Supabase.initialize(url: 'https://test.supabase.co', anonKey: 'test');

  // Заменяем платформенную реализацию видеоплеера на фейк.
  VideoPlayerPlatform.instance = _FakeVideoPlayerPlatform();

  await testMain();
}
