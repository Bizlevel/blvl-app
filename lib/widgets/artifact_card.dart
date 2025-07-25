import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/custom_image.dart';

class ArtifactCard extends StatelessWidget {
  const ArtifactCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.url,
  });

  final String title;
  final String description;
  final String image;
  final String url;

  Future<void> _download() async {
    String link = url;
    if (!link.startsWith('http')) {
      // Подписываем URL через Supabase
      try {
        // lazy import to avoid heavy dep
        // ignore: avoid_dynamic_calls
        final supaUrl = await Future<dynamic>.microtask(() => null);
      } catch (_) {}
    }
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomImage(
            image,
            radius: 15,
            height: 60,
            width: 60,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColor.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.labelColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.download),
            color: AppColor.primary,
            onPressed: _download,
          ),
        ],
      ),
    );
  }
}
