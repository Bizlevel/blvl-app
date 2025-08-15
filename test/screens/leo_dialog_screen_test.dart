import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeoService extends Mock implements LeoService {}

void main() {
  testWidgets('LeoDialogScreen shows Leo in title by default', (tester) async {
    final mockService = _MockLeoService();
    when(() => mockService.checkMessageLimit()).thenAnswer((_) async => 0);
    await tester.pumpWidget(ProviderScope(
      overrides: [leoServiceProvider.overrideWithValue(mockService)],
      child: const MaterialApp(home: LeoDialogScreen()),
    ));

    expect(find.text('Лео'), findsOneWidget);
  });

  testWidgets('LeoDialogScreen shows Max title when bot=max', (tester) async {
    final mockService = _MockLeoService();
    when(() => mockService.checkMessageLimit()).thenAnswer((_) async => 0);
    await tester.pumpWidget(ProviderScope(
      overrides: [leoServiceProvider.overrideWithValue(mockService)],
      child: const MaterialApp(home: LeoDialogScreen(bot: 'max')),
    ));

    expect(find.text('Макс'), findsOneWidget);
  });
}
