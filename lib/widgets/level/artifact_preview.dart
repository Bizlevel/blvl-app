import 'package:flutter/material.dart';
import 'package:bizlevel/widgets/artifact_viewer.dart';
import 'package:bizlevel/theme/spacing.dart';
import 'package:bizlevel/theme/dimensions.dart';
import 'package:bizlevel/services/supabase_service.dart';

class ArtifactPreview extends StatelessWidget {
  const ArtifactPreview({super.key, required this.levelId, this.levelNumber});
  final int levelId;
  final int? levelNumber;

  @override
  Widget build(BuildContext context) {
    Widget buildCard(int ln) {
      if (ln < 1 || ln > 10) return const SizedBox.shrink();
      final front = 'assets/images/artefacts/art-$ln-1.png';
      final back = 'assets/images/artefacts/art-$ln-2.png';
      return LayoutBuilder(builder: (context, constraints) {
        final double maxW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final double cardWidth = (maxW * 0.55).clamp(0, 220);
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.black.withValues(alpha: 0.85),
                pageBuilder: (ctx, _, __) => ArtifactViewer(
                  front: front,
                  back: back,
                ),
              ),
            );
          },
          child: Align(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              child: SizedBox(
                width: cardWidth,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(front, fit: BoxFit.cover),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: AppSpacing.insetsSymmetric(
                              h: AppSpacing.md, v: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusMd),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.touch_app,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('Тапните',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }

    if (levelNumber != null) {
      return buildCard(levelNumber!);
    }

    return FutureBuilder<int>(
      future: SupabaseService.levelNumberFromId(levelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return buildCard(snapshot.data ?? 0);
      },
    );
  }
}
