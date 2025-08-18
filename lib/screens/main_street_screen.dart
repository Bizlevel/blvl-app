import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/user_info_bar.dart';

class MainStreetScreen extends ConsumerWidget {
  const MainStreetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top bar with avatar/name/progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Expanded(child: UserInfoBar()),
                ],
              ),
            ),
            // Illustration
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/Bizlevel-map-buildings.png',
                            fit: BoxFit.cover,
                          ),
                          // Simple tappable overlay areas (MVP): center building → floor 1, others → SnackBar
                          Align(
                            alignment: Alignment.center,
                            child: _BuildingTapArea(
                              onTap: () => context.go('/floor/1'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/floor/1');
                      },
                      child: const Text('Продолжить: Уровень 101'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => context.go('/tower'),
                      child: const Text('Открыть Башню БизЛевел'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildingTapArea extends StatelessWidget {
  final VoidCallback onTap;
  const _BuildingTapArea({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 180,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}


