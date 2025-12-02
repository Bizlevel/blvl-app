import 'dart:io' show Platform;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:photo_manager/photo_manager.dart';

/// Unified media picker that replaces legacy DKImagePickerController / file_picker.
class MediaPickerService {
  MediaPickerService._();

  static final MediaPickerService instance = MediaPickerService._();

  /// Opens a lightweight gallery selector (iOS/Android) or file selector (other platforms).
  Future<MediaPickerResult?> pickImageFromGallery(BuildContext context) async {
    if (kIsWeb || (!Platform.isIOS && !Platform.isAndroid)) {
      return _pickViaFileSelector(
        const XTypeGroup(
          label: 'Images',
          extensions: ['jpg', 'jpeg', 'png', 'heic'],
          mimeTypes: ['image/jpeg', 'image/png', 'image/heic'],
        ),
      );
    }

    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      if (!context.mounted) return null;
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(
          content: Text(
              'Нет доступа к фото. Разрешите его в настройках и повторите.'),
        ),
      );
      if (permission.hasAccess) {
        PhotoManager.presentLimited();
      } else {
        await PhotoManager.openSetting();
      }
      return null;
    }

    if (!context.mounted) return null;
    return showModalBottomSheet<MediaPickerResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _PhotoGridSheet(),
    );
  }

  /// Opens a platform file selector for arbitrary documents.
  Future<MediaPickerResult?> pickDocument({
    List<String>? allowedExtensions,
    String label = 'Файл',
  }) async {
    final typeGroup = XTypeGroup(
      label: label,
      extensions: allowedExtensions,
    );
    return _pickViaFileSelector(typeGroup);
  }

  Future<MediaPickerResult?> _pickViaFileSelector(XTypeGroup typeGroup) async {
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    return MediaPickerResult(
      name: file.name,
      bytes: bytes,
      mimeType: file.mimeType,
    );
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

class _PhotoGridSheet extends StatefulWidget {
  const _PhotoGridSheet();

  @override
  State<_PhotoGridSheet> createState() => _PhotoGridSheetState();
}

class _PhotoGridSheetState extends State<_PhotoGridSheet> {
  late Future<List<AssetEntity>> _assetsFuture;

  @override
  void initState() {
    super.initState();
    _assetsFuture = _loadAssets();
  }

  Future<List<AssetEntity>> _loadAssets() async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );
    if (paths.isEmpty) {
      return <AssetEntity>[];
    }
    return paths.first.getAssetListPaged(page: 0, size: 80);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return FutureBuilder<List<AssetEntity>>(
          future: _assetsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final assets = snapshot.data ?? <AssetEntity>[];
            if (assets.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child:
                      Text('Галерея пуста. Сделайте фото и попробуйте снова.'),
                ),
              );
            }
            return GridView.builder(
              controller: controller,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return GestureDetector(
                  onTap: () => _handleSelect(asset),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    child: FutureBuilder<Uint8List?>(
                      future: asset
                          .thumbnailDataWithSize(const ThumbnailSize.square(300)),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            color: Colors.grey.shade300,
                          );
                        }
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _handleSelect(AssetEntity asset) async {
    final bytes = await asset.originBytes;
    if (!mounted) return;
    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось загрузить фото')),
      );
      return;
    }
    Navigator.of(context).pop(
      MediaPickerResult(
        name: asset.title ?? 'photo.jpg',
        bytes: bytes,
        mimeType: asset.mimeType,
      ),
    );
  }
}
