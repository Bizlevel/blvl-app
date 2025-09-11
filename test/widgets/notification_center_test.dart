import 'package:bizlevel/widgets/common/notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('NotificationCenter.showSuccess shows MaterialBanner',
      (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    NotificationCenter.showSuccess(
        tester.element(find.byType(SizedBox)), 'Успешно');
    await tester.pump();
    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.text('Успешно'), findsOneWidget);
  });

  testWidgets('NotificationCenter.showWarn supports action callback',
      (tester) async {
    bool tapped = false;
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    NotificationCenter.showWarn(
      tester.element(find.byType(SizedBox)),
      'Недостаточно GP',
      onAction: () => tapped = true,
      actionLabel: 'Купить GP',
    );
    await tester.pump();
    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.text('Недостаточно GP'), findsOneWidget);
    expect(find.text('Купить GP'), findsOneWidget);
    await tester.tap(find.text('Купить GP'));
    expect(tapped, isTrue);
  });
}
