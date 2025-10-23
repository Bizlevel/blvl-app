import 'package:bizlevel/providers/leo_service_provider.dart';
import 'package:bizlevel/services/leo_service.dart';
import 'package:bizlevel/widgets/leo_quiz_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeoService extends Mock implements LeoService {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  testWidgets(
      'LeoQuizWidget: правильный ответ вызывает onCorrect и показывает статус',
      (tester) async {
    final mock = _MockLeoService();
    when(() => mock.sendQuizFeedback(
          question: any(named: 'question'),
          options: any(named: 'options'),
          selectedIndex: any(named: 'selectedIndex'),
          correctIndex: any(named: 'correctIndex'),
          userContext: any(named: 'userContext'),
          maxTokens: any(named: 'maxTokens'),
        )).thenAnswer((_) async => {
          'message': {'content': 'Отлично, двигаемся дальше!'}
        });

    var passed = false;

    await tester.pumpWidget(ProviderScope(
      overrides: [leoServiceProvider.overrideWithValue(mock)],
      child: const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(8),
            child: LeoQuizWidget(
              questionData: {
                'question': 'Q?',
                'options': ['A', 'B'],
                'correct': 1,
                'script': 'Давай проверим...',
                'explanation': 'Подсказка',
              },
              initiallyPassed: false,
              userContext: 'Имя: Тест. Цель: Выучить.',
              onCorrect: _OnCorrectProbe.setPassed,
            ),
          ),
        ),
      ),
    ));

    // Привяжем колбэк к статическому флагу
    _OnCorrectProbe.bind(() => passed = true);

    // Выбираем правильный вариант через новый UI (карточки с ключами)
    await tester.tap(find.byKey(const Key('leo_quiz_option_1')));
    await tester.pumpAndSettle();

    // В новом UI проверка запускается по тапу на опцию, кнопки «Проверить» нет
    await tester.pumpAndSettle();

    // Статус «Тест пройден ✅» отображается
    expect(find.text('Тест пройден ✅'), findsOneWidget);

    // onCorrect был вызван
    expect(passed, isTrue);

    // Проверяем, что сервис вызывался с корректными параметрами
    verify(() => mock.sendQuizFeedback(
          question: 'Q?',
          options: ['A', 'B'],
          selectedIndex: 1,
          correctIndex: 1,
          userContext: 'Имя: Тест. Цель: Выучить.',
          maxTokens: any(named: 'maxTokens'),
        )).called(1);
  });

  testWidgets(
      'LeoQuizWidget: оффлайн/ошибка — локальный ответ и onCorrect вызывается',
      (tester) async {
    final mock = _MockLeoService();
    when(() => mock.sendQuizFeedback(
          question: any(named: 'question'),
          options: any(named: 'options'),
          selectedIndex: any(named: 'selectedIndex'),
          correctIndex: any(named: 'correctIndex'),
          userContext: any(named: 'userContext'),
          maxTokens: any(named: 'maxTokens'),
        )).thenThrow(LeoFailure('Нет соединения с интернетом'));

    var passed = false;

    await tester.pumpWidget(ProviderScope(
      overrides: [leoServiceProvider.overrideWithValue(mock)],
      child: MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: LeoQuizWidget(
              questionData: const {
                'question': 'Q?',
                'options': ['A', 'B'],
                'correct': 0,
              },
              onCorrect: () => passed = true,
            ),
          ),
        ),
      ),
    ));

    // Выбираем правильный вариант через новый UI
    await tester.tap(find.byKey(const Key('leo_quiz_option_0')));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();

    // Видим успешный статус
    expect(find.text('Тест пройден ✅'), findsOneWidget);
    expect(passed, isTrue);
  });
}

// Маленький трюк, чтобы сохранить минимальные правки в виджете: пробрасываем
// onCorrect через статическую обёртку, которую можно подвязать к тестовому флагу.
class _OnCorrectProbe {
  static VoidCallback? _hook;
  static void bind(VoidCallback hook) => _hook = hook;
  static void setPassed() => _hook?.call();
}
