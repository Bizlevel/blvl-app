import 'package:bizlevel/screens/library/library_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LibraryScreen renders tabs and sections', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: LibraryScreen()),
    ));

    await tester.pump();
    expect(find.text('Библиотека'), findsOneWidget);
    expect(find.text('Разделы'), findsOneWidget);
    expect(find.text('Избранное'), findsOneWidget);
    expect(find.text('Курсы'), findsOneWidget);
    expect(find.text('Гранты и поддержка'), findsOneWidget);
    expect(find.text('Акселераторы'), findsOneWidget);
  });
}
