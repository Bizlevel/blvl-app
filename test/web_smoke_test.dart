import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/widgets/lesson_widget.dart';
import 'package:flutter/widgets.dart';

void main() {
  if (WidgetsBinding.instance == null) {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  }

  testWidgets('Smoke test – LessonWidget renders on Web', (tester) async {
    // Dummy lesson with Vimeo ID to avoid network calls to Supabase in tests.
    const lesson = LessonModel(
      id: 1,
      levelId: 1,
      order: 1,
      title: 'Test lesson',
      description: 'Test description',
      vimeoId: '76979871', // Public Vimeo demo video
      videoUrl: null,
      durationMinutes: 1,
      quizQuestions: <dynamic>[],
      correctAnswers: <int>[],
      createdAt: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LessonWidget(
          lesson: lesson,
          onWatched: () {}, // No-op for smoke test
        ),
      ),
    );

    // Allow asynchronous initialization to complete.
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect that the loading indicator disappeared and description text is shown.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Test description'), findsOneWidget);

    // The widget tree should now contain either an HtmlElementView (Web iframe) or AspectRatio.
    expect(
      find.byWidgetPredicate(
          (widget) => widget is HtmlElementView || widget is AspectRatio),
      findsOneWidget,
    );
  });
}
