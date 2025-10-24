import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:bizlevel/services/gp_service.dart';

void main() {
  test('GpService balance cache save/read roundtrip', () async {
    // Инициализируем box gp для кеша
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(p.join(tempDir.path, 'hive_gp'));
    await Hive.openBox('gp');
    final sample = {'balance': 12, 'total_earned': 50, 'total_spent': 38};
    await GpService.saveBalanceCache(sample);
    final read = GpService.readBalanceCache();
    expect(read, isNotNull);
    expect(read!['balance'], 12);
    expect(read['total_earned'], 50);
    expect(read['total_spent'], 38);
    await Hive.box('gp').close();
    await tempDir.delete(recursive: true);
  });
}
