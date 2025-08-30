// Подписки отключены (этап 39.1). Файл оставлен для совместимости импортов.
// Провайдер всегда возвращает null.
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionProvider = StreamProvider<String?>((ref) {
  return const Stream.empty();
});
