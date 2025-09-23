import 'package:flutter/material.dart';
import 'package:bizlevel/theme/color.dart';

class BizLevelLoading {
  static Widget fullscreen({String? message}) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(message),
            ],
          ],
        ),
      ),
    );
  }

  static Widget inline({double size = 24}) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(),
    );
  }

  static Widget sliver({String? message}) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message),
            ],
          ],
        ),
      ),
    );
  }
}
