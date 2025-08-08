import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/utils/deep_link.dart';

void main() {
  group('Deep link mapping', () {
    test('maps bizlevel://levels/42 to /levels/42', () {
      const link = 'bizlevel://levels/42';
      expect(mapBizLevelDeepLink(link), '/levels/42');
    });

    test('maps bizlevel://auth/confirm to /login?registered=true', () {
      const link = 'bizlevel://auth/confirm';
      expect(mapBizLevelDeepLink(link), '/login?registered=true');
    });

    test('returns null for unknown scheme', () {
      const link = 'https://example.com/levels/3';
      expect(mapBizLevelDeepLink(link), isNull);
    });

    test('returns null for unknown auth path', () {
      const link = 'bizlevel://auth/unknown';
      expect(mapBizLevelDeepLink(link), isNull);
    });
  });
}
