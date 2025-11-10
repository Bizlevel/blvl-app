import 'package:bizlevel/widgets/home/home_quote_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeQuoteCard mounts without crash', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeQuoteCard(),
        ),
      ),
    );
    // При отсутствии данных виджет скрывается — smoke без проверок
    expect(find.byType(HomeQuoteCard), findsOneWidget);
  });
}


