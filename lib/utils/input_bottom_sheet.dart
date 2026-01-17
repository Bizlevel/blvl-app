import 'package:flutter/material.dart';

Future<T?> showBizLevelInputBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool showDragHandle = false,
  bool useRootNavigator = true,
  bool applyKeyboardInset = true,
  EdgeInsets? contentPadding,
  Color? backgroundColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: useRootNavigator,
    showDragHandle: showDragHandle,
    backgroundColor: backgroundColor,
    builder: (ctx) {
      final media = MediaQuery.of(ctx);
      final bottomInset = applyKeyboardInset ? media.viewInsets.bottom : 0.0;
      final padding = contentPadding ??
          EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: bottomInset + media.padding.bottom + 16,
          );
      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: padding,
        child: builder(ctx),
      );
    },
  );
}
