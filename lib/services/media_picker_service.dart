// Заглушка медиапикера: загрузка из галереи/файлов отключена.
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class MediaPickerService {
  MediaPickerService._();

  static final MediaPickerService instance = MediaPickerService._();

  Future<MediaPickerResult?> pickImageFromGallery(BuildContext context) async {
    // Функционал выбора фото отключён.
    return null;
  }

  Future<MediaPickerResult?> pickDocument({
    List<String>? allowedExtensions,
    String label = 'Файл',
  }) async {
    // Загрузка файлов не используется.
    return null;
  }
}

class MediaPickerResult {
  final String name;
  final Uint8List bytes;
  final String? mimeType;

  const MediaPickerResult({
    required this.name,
    required this.bytes,
    this.mimeType,
  });
}
