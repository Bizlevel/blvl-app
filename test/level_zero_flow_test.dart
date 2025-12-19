import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bizlevel/screens/level_detail_screen.dart';
import 'package:bizlevel/providers/lessons_provider.dart';
import 'package:bizlevel/models/lesson_model.dart';
import 'package:bizlevel/providers/auth_provider.dart';
import 'package:bizlevel/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockAuthService extends Mock implements AuthService {}
class _MockUser extends Mock implements User {}

void main() {
  setUpAll(() {
    registerFallbackValue(<LessonModel>[]);
  });

  testWidgets('Level 0: Intro → Next → Profile save calls updateProfile',
      (tester) async {
    // Стандартный тестовый viewport 800x600 слишком мал для формы профиля (она в scroll view),
    // из-за чего tap() может промахиваться. Делаем экран ближе к реальным мобилкам.
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    final mockAuth = _MockAuthService();
    final mockUser = _MockUser();
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockAuth.getCurrentUser()).thenReturn(mockUser);
    when(() => mockAuth.updateProfile(
          name: any(named: 'name'),
          about: any(named: 'about'),
          goal: any(named: 'goal'),
          avatarId: any(named: 'avatarId'),
          onboardingCompleted: any(named: 'onboardingCompleted'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lessonsProvider.overrideWithProvider(
            FutureProvider.family<List<LessonModel>, int>((ref, levelId) async {
              return <LessonModel>[];
            }),
          ),
          authServiceProvider.overrideWithValue(mockAuth),
        ],
        child: const MaterialApp(
          home: LevelDetailScreen(levelId: 1000, levelNumber: 0),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Нажать «Далее» (из навигации уровня) для перехода со вступления на следующий блок
    await tester.tap(find.text('Далее'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    // На странице профиля навбар скрыт, должна быть CTA сохранения профиля
    expect(find.text('Перейти на Уровень 1'), findsOneWidget);

    // Включаем режим редактирования
    await tester.ensureVisible(find.byTooltip('Редактировать'));
    await tester.tap(find.byTooltip('Редактировать'), warnIfMissed: false);
    await tester.pump();

    // В форме профиля три текстовых поля
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(3));
    await tester.enterText(textFields.at(0), 'Иван');
    await tester.enterText(textFields.at(1), 'О себе');
    await tester.enterText(textFields.at(2), 'Цель');

    // Сохраняем профиль
    await tester.ensureVisible(find.text('Перейти на Уровень 1'));
    await tester.tap(find.text('Перейти на Уровень 1'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    verify(() => mockAuth.updateProfile(
          name: 'Иван',
          about: 'О себе',
          goal: 'Цель',
          avatarId: any(named: 'avatarId'),
          onboardingCompleted: true,
        )).called(1);
  });
}
