import 'package:bizlevel/widgets/home/home_continue_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeContinueCard renders (smoke)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeContinueCard(
            subtitle: 'Уровень 2: Стресс-Менеджмент',
            levelNumber: 2,
            onTap: () {},
          ),
        ),
      ),
    );
    // Важно: внутри карточки может быть несколько текстов с "Уровень ...",
    // поэтому проверяем точный subtitle, который мы передали.
    expect(find.text('Уровень 2: Стресс-Менеджмент'), findsOneWidget);
    expect(find.text('Продолжить обучение'), findsOneWidget);
  }, skip: false);
}


