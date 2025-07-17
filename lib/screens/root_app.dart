import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:online_course/screens/profile_screen.dart';
import 'package:online_course/screens/leo_chat_screen.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/constant.dart';
import 'package:online_course/widgets/bottombar_item.dart';
import 'package:online_course/screens/levels_map_screen.dart';

// Provider to hold index of active tab
final _rootTabProvider = StateProvider<int>((ref) => 0);

class RootApp extends ConsumerWidget {
  const RootApp({super.key});

  static final _tabs = [
    {
      "icon": "assets/icons/home.svg",
      "page": const LevelsMapScreen(),
    },
    {
      "icon": "assets/icons/chat.svg",
      "page": const LeoChatScreen(),
    },
    {
      "icon": "assets/icons/profile.svg",
      "page": const ProfileScreen(),
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(_rootTabProvider);

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      bottomNavigationBar: _buildBottomBar(ref, activeTab),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: ANIMATED_BODY_MS),
        child: _tabs[activeTab]["page"] as Widget,
      ),
    );
  }

  Widget _buildBottomBar(WidgetRef ref, int activeTab) {
    return Container(
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
            color: AppColor.shadowColor.withOpacity(0.1),
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
          children: List.generate(
            _tabs.length,
            (index) => BottomBarItem(
              _tabs[index]["icon"] as String,
              isActive: activeTab == index,
              activeColor: AppColor.primary,
              onTap: () => ref.read(_rootTabProvider.notifier).state = index,
            ),
          ),
        ),
      ),
    );
  }
}
