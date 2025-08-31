import 'package:flutter_test/flutter_test.dart';
import 'package:bizlevel/services/gp_service.dart';

void main() {
  test('GpService balance cache save/read roundtrip', () async {
    final sample = {'balance': 12, 'total_earned': 50, 'total_spent': 38};
    await GpService.saveBalanceCache(sample);
    final read = GpService.readBalanceCache();
    expect(read, isNotNull);
    expect(read!['balance'], 12);
    expect(read['total_earned'], 50);
    expect(read['total_spent'], 38);
  });
}
