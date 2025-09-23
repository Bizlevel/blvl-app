import 'package:bizlevel/models/user_skill_model.dart';
import 'package:bizlevel/widgets/skills_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SkillsTreeView shows skills data correctly',
      (WidgetTester tester) async {
    final skills = [
      const UserSkillModel(
        userId: '1',
        skillId: 1,
        points: 5,
        skillName: 'Финансы',
      ),
      const UserSkillModel(
        userId: '1',
        skillId: 2,
        points: 8,
        skillName: 'Маркетинг',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SkillsTreeView(skills: skills, currentLevel: 0),
        ),
      ),
    );

    expect(find.text('Финансы'), findsOneWidget);
    expect(find.text('5/10'), findsOneWidget);
    expect(find.text('Маркетинг'), findsOneWidget);
    expect(find.text('8/10'), findsOneWidget);
  });

  testWidgets('SkillsTreeView shows empty message when no skills are provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SkillsTreeView(skills: [], currentLevel: 0),
        ),
      ),
    );

    expect(find.text('Навыки пока не прокачаны.'), findsOneWidget);
  });
}
