import 'package:flutter/material.dart';
import 'package:bizlevel/services/supabase_service.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/widgets/level/artifact_preview.dart';
import 'package:bizlevel/widgets/level/blocks/level_page_block.dart';

class ArtifactBlock extends LevelPageBlock {
  final int levelId;
  final int? levelNumber;
  ArtifactBlock({required this.levelId, this.levelNumber});

  Future<Map<String, dynamic>?> _fetchArtifact() async {
    return SupabaseService.fetchLevelArtifactMeta(levelId);
  }

  @override
  Widget build(BuildContext context, int index) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchArtifact(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data?['artifact_url'] == null) {
          return const Center(child: Text('Артефакт отсутствует'));
        }

        final data = snapshot.data!;
        final title = (data['artifact_title'] as String?) ?? 'Артефакт';
        final description = (data['artifact_description'] as String?) ?? '';

        return Padding(
          padding: AppSpacing.insetsAll(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              AppSpacing.gapH(AppSpacing.md),
              if (description.isNotEmpty)
                Text(description, textAlign: TextAlign.center),
              AppSpacing.gapH(AppSpacing.xl),
              ArtifactPreview(levelId: levelId, levelNumber: levelNumber),
            ],
          ),
        );
      },
    );
  }
}
