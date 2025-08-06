import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Эта конфигурация гарантирует, что `TestWidgetsFlutterBinding.ensureInitialized`
  // вызывается только один раз для всех тестов, предотвращая ошибку
  // "Binding is already initialized".
  TestWidgetsFlutterBinding.ensureInitialized();
  await testMain();
}
