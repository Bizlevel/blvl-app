import 'package:flutter/material.dart';

/// Кастомный роут для модальных окон снизу экрана.
/// Используется вместо showModalBottomSheet для полного контроля над поведением.
/// 
/// Особенности:
/// - Прозрачный фон с затемнением
/// - Анимация снизу вверх
/// - Закрытие по тапу мимо окна
/// - Работает с adjustPan в манифесте (окно не меняет размер)
class CustomModalBottomSheetRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  CustomModalBottomSheetRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          opaque: false, // Прозрачный фон
          barrierDismissible: true, // Закрытие по тапу мимо окна
          barrierColor: Colors.black54,
          // ВАЖНО: fullscreenDialog: false - не используем полноэкранный режим,
          // чтобы избежать конфликтов с обработкой клавиатуры
          fullscreenDialog: false,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Анимация снизу вверх
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeOut)),
              ),
              child: child,
            );
          },
        );
}
