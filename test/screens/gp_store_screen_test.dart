import 'package:bizlevel/screens/gp_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('GpStoreScreen renders and shows KZT price label fallback',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: GpStoreScreen()),
    ));

    // AppBar title
    expect(find.text('Магазин GP'), findsOneWidget);

    // Expect at least one price label button exists (fallback may show ₸)
    // We do a loose check to avoid coupling to exact formatting
    expect(find.textContaining('₸'), findsWidgets);

    // Verify presence of action button "Проверить"
    expect(find.text('Проверить'), findsOneWidget);
  });
}
