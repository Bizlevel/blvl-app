import 'package:flutter/material.dart';

Future<DateTime?> showRuDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    locale: const Locale('ru'),
    helpText: 'Выберите дату',
    cancelText: 'Отмена',
    confirmText: 'ОК',
    builder: (ctx, child) {
      return Theme(
        data: Theme.of(ctx).copyWith(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).primaryColor,
            ),
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      );
    },
  );
}
