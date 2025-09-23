import 'package:flutter/material.dart';

/// Mixin для унификации back-UX: сначала пытаемся goRouter.pop(),
/// иначе Navigator.maybePop(), иначе fallback-роут
mixin BackNavigationMixin<T extends StatefulWidget> on State<T> {
  Future<bool> handleBack({VoidCallback? onFallback}) async {
    try {
      final popped = Navigator.of(context).maybePop();
      final canPop = await popped;
      if (canPop) return true;
    } catch (_) {}
    onFallback?.call();
    return false;
  }
}
