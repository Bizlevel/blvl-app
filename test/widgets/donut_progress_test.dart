import 'package:bizlevel/widgets/common/donut_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DonutProgress renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: DonutProgress(value: 0.15)),
        ),
      ),
    );
    expect(find.textContaining('%'), findsOneWidget);
  });
}


