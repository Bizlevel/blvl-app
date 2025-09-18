import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';
import 'package:bizlevel/widgets/bottombar_item.dart';
import 'package:bizlevel/widgets/desktop_nav_bar.dart';
import 'package:bizlevel/screens/main_street_screen.dart';
import 'package:bizlevel/screens/goal_screen.dart';
import 'package:bizlevel/screens/profile_screen.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/services/context_service.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const _routes = ['/home', '/goal', '/profile'];
  PageController? _pageController;
  int _currentIndex = 0;
  bool _isSyncing = false;

  Future<String?> _buildUserContext(WidgetRef ref) =>
      ContextService.buildUserContext(ref.read(currentUserProvider).value);

  Future<String?> _buildLevelContext(WidgetRef ref) =>
      ContextService.buildLevelContext(ref.read(currentUserProvider).value);

  int _locationToTab(String location) {
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  void _ensureController(int initialPage) {
    _pageController ??=
        PageController(initialPage: initialPage, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    final String location =
        GoRouter.of(context).routeInformationProvider.value.location;
    final int activeTab = _locationToTab(location);

    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1024;

    void _goTab(int index) {
      if (_pageController != null && _pageController!.positions.isNotEmpty) {
        _pageController!.animateToPage(index,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      } else {
        context.go(_routes[index]);
      }
    }

    // Базовые табы только на точных путях '/home' | '/goal' | '/profile'.
    // Вложенные маршруты (например, '/goal-checkpoint/:v') не должны попадать в PageView.
    final bool isBaseRoute =
        location == '/home' || location == '/goal' || location == '/profile';

    // Создаём/синхронизируем контроллер для PageView на базовых табах
    if (!isDesktop && isBaseRoute) {
      _ensureController(activeTab);
      if (_currentIndex != activeTab && _pageController != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (_pageController != null &&
              _pageController!.positions.isNotEmpty) {
            _isSyncing = true;
            _pageController!.jumpToPage(activeTab);
            _currentIndex = activeTab;
            // Сброс флага после кадра, чтобы onPageChanged не триггерил go
            Future.microtask(() => _isSyncing = false);
          }
        });
      }
    } else {
      // На небазовых маршрутах не держим контроллер привязанным
      _pageController = null;
    }

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.bottomBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withValues(alpha: 0.1),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(1, 1),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(_routes.length, (index) {
                      final icon = index == 0
                          ? Icons.map
                          : index == 1
                              ? Icons.flag
                              : Icons.person;
                      return BottomBarItem(
                        icon,
                        isActive: activeTab == index,
                        activeColor: AppColor.primary,
                        onTap: () => _goTab(index),
                        iconWidget: index == 1
                            ? Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child:
                                    _GoalSvgIcon(isActive: activeTab == index),
                              )
                            : null,
                      );
                    }),
                    // Четвёртая кнопка: быстрый чат с Лео, наполовину торчит над баром
                    if (!isDesktop && isBaseRoute)
                      Transform.translate(
                        offset: const Offset(0, -18),
                        child: _LeoBottomActionButton(
                          onTap: () {
                            try {
                              HapticFeedback.lightImpact();
                            } catch (_) {}
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FutureBuilder<List<String?>>( 
                                  future: Future.wait([
                                    _buildUserContext(ref),
                                    _buildLevelContext(ref),
                                  ]),
                                  builder: (context, snap) {
                                    final userCtx = (snap.data!=null) ? snap.data![0] : null;
                                    final lvlCtx = (snap.data!=null) ? snap.data![1] : null;
                                    return LeoDialogScreen(
                                      userContext: userCtx,
                                      levelContext: lvlCtx,
                                      bot: 'leo',
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
      body: isDesktop
          ? Row(
              children: [
                DesktopNavBar(
                  tabs: const [
                    {'icon': Icons.map, 'label': 'Главная'},
                    {'icon': Icons.flag, 'label': 'Цель'},
                    {'icon': Icons.person, 'label': 'Профиль'},
                  ],
                  activeIndex: activeTab,
                  onTabSelected: (index) => context.go(_routes[index]),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: widget.child),
              ],
            )
          : isBaseRoute
              ? PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    _currentIndex = i;
                    if (_isSyncing) return;
                    try {
                      HapticFeedback.selectionClick();
                    } catch (_) {}
                    // Навигацию откладываем на пост-кадр, чтобы не вызывать go в build/скролле
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      context.go(_routes[i]);
                    });
                  },
                  children: [
                    const MainStreetScreen(key: PageStorageKey('tab_home')),
                    _GoalTabGate(key: const PageStorageKey('tab_goal')),
                    const ProfileScreen(key: PageStorageKey('tab_profile')),
                  ],
                )
              : widget.child,
    );
  }
}

class _GoalTabGate extends ConsumerWidget {
  const _GoalTabGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).asData?.value;
    final currentLevel = user?.currentLevel ?? 0;
    final allowed = currentLevel >= 2;
    if (!allowed) {
      return Center(
        child: Semantics(
          label: 'Вкладка Недоступна',
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, color: AppColor.labelColor, size: 36),
              SizedBox(height: 8),
              Text('Раздел "Цель" откроется после Уровня 1',
                  style: TextStyle(color: AppColor.onSurfaceSubtle)),
            ],
          ),
        ),
      );
    }
    return const GoalScreen();
  }
}

class _GoalSvgIcon extends StatelessWidget {
  const _GoalSvgIcon({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/goal.svg',
      width: 26,
      height: 26,
      colorFilter: ColorFilter.mode(
        isActive ? AppColor.primary : Colors.grey,
        BlendMode.srcIn,
      ),
    );
  }
}

class _LeoBottomActionButton extends StatelessWidget {
  const _LeoBottomActionButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Новый диалог с Лео',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Shadow
              CustomPaint(
                size: const Size(56, 56),
                painter: _HexagonPainter(
                  color: AppColor.shadowColor.withValues(alpha: 0.2),
                  cornerRadius: 4,
                  padding: 2,
                  offset: const Offset(0, 4),
                  blurSigma: 8,
                ),
              ),
              // Fill
              CustomPaint(
                size: const Size(56, 56),
                painter: _HexagonPainter(
                  color: AppColor.primary,
                  cornerRadius: 4,
                  padding: 2,
                ),
              ),
              const Icon(Icons.chat_bubble, color: AppColor.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _HexagonPainter extends CustomPainter {
  _HexagonPainter({
    required this.color,
    required this.cornerRadius,
    this.padding = 0,
    this.offset = Offset.zero,
    this.blurSigma,
  });

  final Color color;
  final double cornerRadius; // закругление боковых углов
  final double padding; // внутренний отступ от границ
  final Offset offset; // смещение для тени
  final double? blurSigma; // если задано — рисуем размытый слой (тень)

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (blurSigma != null && blurSigma! > 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma!);
    }

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final Path path = _roundedHexagonPath(size, padding, cornerRadius);
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  Path _roundedHexagonPath(Size size, double pad, double rr) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = math.min(w, h) / 2 - pad;

    // 6 вершин (pointy top): 0=top, 1=upper-right, 2=lower-right, 3=bottom, 4=lower-left, 5=upper-left
    final List<Offset> v = List.generate(6, (i) {
      final double ang = -math.pi / 2 + i * math.pi / 3;
      return Offset(cx + r * math.cos(ang), cy + r * math.sin(ang));
    });

    // Какие вершины скругляем (оставляем острыми 0 и 3)
    bool roundIndex(int i) => i != 0 && i != 3;

    final Path p = Path();

    Offset cutPoint(Offset a, Offset b, double dist) {
      final dir = (b - a);
      final len = dir.distance;
      if (len == 0) return a;
      final t = (dist / len).clamp(0.0, 0.5);
      return a + dir * t;
    }

    for (int i = 0; i < 6; i++) {
      final int prev = (i + 5) % 6;
      final int next = (i + 1) % 6;
      final Offset vi = v[i];
      if (i == 0) {
        // начинаем с верхней вершины
        p.moveTo(vi.dx, vi.dy);
        continue;
      }
      if (roundIndex(i)) {
        final Offset a = v[prev];
        final Offset b = v[next];
        final Offset p1 = cutPoint(vi, a, rr);
        final Offset p2 = cutPoint(vi, b, rr);
        p.lineTo(p1.dx, p1.dy);
        p.arcToPoint(
          p2,
          radius: Radius.circular(rr),
          clockwise: true,
        );
      } else {
        p.lineTo(vi.dx, vi.dy);
      }
    }
    // замыкаем к верхней вершине с учётом, что последняя дуга уже учтена
    p.close();
    return p;
  }

  @override
  bool shouldRepaint(covariant _HexagonPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.padding != padding ||
        oldDelegate.offset != offset ||
        oldDelegate.blurSigma != blurSigma;
  }
}
