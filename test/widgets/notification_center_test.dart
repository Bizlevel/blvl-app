import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();
Widget wrap(Widget child) => MaterialApp(
      scaffoldMessengerKey: messengerKey,
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('NotificationCenter.showSuccess shows MaterialBanner',
      (tester) async {
    await tester.pumpWidget(wrap(const SizedBox.shrink()));
    NotificationCenter.showSuccess(
      tester.element(find.byType(SizedBox)),
      'Успешно',
      ms: 1,
    );
    await tester.pump();
    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.text('Успешно'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2));
  });

  testWidgets('NotificationCenter.showWarn hides banner on action',
      (tester) async {
    await tester.pumpWidget(wrap(const SizedBox.shrink()));
    NotificationCenter.showWarn(
      tester.element(find.byType(SizedBox)),
      'Недостаточно GP',
      onAction: () => messengerKey.currentState?.hideCurrentMaterialBanner(),
      actionLabel: 'Купить GP',
      ms: 1,
    );
    await tester.pump();
    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.text('Недостаточно GP'), findsOneWidget);
    expect(find.text('Купить GP'), findsOneWidget);
    final banner = find.byType(MaterialBanner);
    final action =
        find.descendant(of: banner, matching: find.text('Купить GP'));
    await tester.tap(action, warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    // Баннер должен скрыться после action
    expect(find.byType(MaterialBanner), findsNothing);
    await tester.pump(const Duration(milliseconds: 2));
  });
}
