import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/utils/deep_link.dart';

void main() {
  group('mapBizLevelDeepLink', () {
    test('levels link maps to /levels/:id', () {
      expect(mapBizLevelDeepLink('bizlevel://levels/42'), '/levels/42');
    });

    test('auth confirm maps to /login?registered=true', () {
      expect(mapBizLevelDeepLink('bizlevel://auth/confirm'),
          '/login?registered=true');
    });

    test('unknown returns null', () {
      expect(mapBizLevelDeepLink('bizlevel://foo/bar'), isNull);
      expect(mapBizLevelDeepLink('https://example.com'), isNull);
    });

    test('levels with invalid id returns null', () {
      expect(mapBizLevelDeepLink('bizlevel://levels/abc'), isNull);
    });
  });
}
