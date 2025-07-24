import 'package:flutter_test/flutter_test.dart';
import 'package:online_course/utils/deep_link.dart';

void main() {
  group('Deep link mapping', () {
    test('maps bizlevel://levels/42 to /levels/42', () {
      const link = 'bizlevel://levels/42';
      expect(mapBizLevelDeepLink(link), '/levels/42');
    });

    test('returns null for unknown scheme', () {
      const link = 'https://example.com/levels/3';
      expect(mapBizLevelDeepLink(link), isNull);
    });
  });
}
