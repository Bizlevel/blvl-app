import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bizlevel/providers/lesson_progress_provider.dart';

void main() {
  group('Requirement 4 – Progress persistence', () {
    setUp(() {
      // Ensure a clean preferences store before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('Progress is saved and restored correctly', () async {
      const levelId = 1;

      // Create first notifier and update progress
      final notifier = LessonProgressNotifier(levelId);
      // Allow internal _load to complete
      await Future.delayed(const Duration(milliseconds: 50));

      notifier.unlockPage(2);
      notifier.markVideoWatched(1);
      notifier.markQuizPassed(1);

      // Wait for async save to prefs
      await Future.delayed(const Duration(milliseconds: 50));

      // Verify data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('level_progress_$levelId');
      expect(stored, isNotNull, reason: 'Progress should be stored in prefs');

      // Create a new notifier (simulates app restart)
      final notifier2 = LessonProgressNotifier(levelId);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(notifier2.state.unlockedPage, 2);
      expect(notifier2.state.watchedVideos.contains(1), isTrue);
      expect(notifier2.state.passedQuizzes.contains(1), isTrue);
    });
  });
}
