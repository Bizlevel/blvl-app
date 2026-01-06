import 'package:bizlevel/screens/leo_dialog_screen.dart';
import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeoService extends Mock implements LeoService {}

void main() {
  setUpAll(() {
    // Fallback для mocktail, чтобы any() работал с List<Map<String, dynamic>>
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

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

  testWidgets(
      'caseMode: ранний [CASE:FINAL] не завершает кейс, а переводит на следующий шаг',
      (tester) async {
    final mockService = _MockLeoService();

    // В этом тесте мы НЕ даём таймеру чипсов сработать (памп < 1000мс),
    // поэтому дополнительные стабы не обязательны.
    when(() => mockService.sendMessageWithRAG(
          messages: any(named: 'messages'),
          userContext: any(named: 'userContext'),
          levelContext: any(named: 'levelContext'),
          bot: any(named: 'bot'),
          chatId: any(named: 'chatId'),
          skipSpend: any(named: 'skipSpend'),
          caseMode: any(named: 'caseMode'),
        )).thenAnswer((_) async => {
          'message': {
            'role': 'assistant',
            // Модель «ошибочно» пытается завершить кейс на первом шаге
            'content': 'EXCELLENT. Хорошо. [CASE:FINAL]'
          }
        });

    await tester.pumpWidget(ProviderScope(
      overrides: [leoServiceProvider.overrideWithValue(mockService)],
      child: const MaterialApp(
        home: LeoDialogScreen(
          caseMode: true,
          systemPrompt: 'sys',
          firstPrompt: 'Задание 1',
          casePrompts: ['Задание 1', 'Задание 2'],
          caseContexts: ['', ''],
        ),
      ),
    ));

    // Стартовое задание уже показано
    expect(find.text('Задание 1'), findsWidgets);

    // Отправляем ответ пользователя
    await tester.enterText(find.byType(TextField), 'мой ответ');
    await tester.tap(find.byKey(const Key('chat_send_button')));
    await tester.pump(); // обработка onPressed

    // Дебаунс отправки: 500мс
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    // Bottom-sheet «Кейс завершён» не должен появиться
    expect(find.text('Кейс завершён'), findsNothing);

    // Должно автоматически появиться следующее задание
    expect(find.text('Задание 2'), findsOneWidget);

    // И вызов должен был уйти в caseMode
    verify(() => mockService.sendMessageWithRAG(
          messages: any(named: 'messages'),
          userContext: any(named: 'userContext'),
          levelContext: any(named: 'levelContext'),
          bot: any(named: 'bot'),
          chatId: any(named: 'chatId'),
          skipSpend: any(named: 'skipSpend'),
          caseMode: true,
        )).called(1);
  });
}
