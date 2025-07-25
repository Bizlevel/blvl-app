import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class PaymentService {
  final SupabaseClient _client;
  PaymentService(this._client);

  /// Запускает чек-аут с указанной суммой и провайдером.
  /// Возвращает [PaymentRedirect] c URL, который нужно открыть во внешнем браузере
  /// или WebView. При ошибке выбрасывает [PaymentFailure].
  Future<PaymentRedirect> startCheckout({
    required int amount,
    String provider = 'kaspi',
  }) async {
    try {
      final response = await _client.functions.invoke(
        'create-checkout-session',
        body: {
          'amount': amount,
          'provider': provider,
        },
      );

      final dynamic data = response.data;
      if (data == null || data['url'] == null) {
        throw PaymentFailure('Не удалось получить URL оплаты');
      }

      return PaymentRedirect(data['url'] as String);
    } on PaymentFailure {
      rethrow; // уже типизированная ошибка
    } catch (e, st) {
      // Логируем в Sentry и пробрасываем типизированную ошибку дальше.
      await Sentry.captureException(e, stackTrace: st);
      throw PaymentFailure('Не удалось создать сессию оплаты');
    }
  }
}

/// Обёртка вокруг URL перенаправления на платёжную страницу.
class PaymentRedirect {
  final String url;
  const PaymentRedirect(this.url);

  @override
  String toString() => 'PaymentRedirect(url: $url)';
}

/// Типизированная ошибка, возникающая при проблемах с оплатой.
class PaymentFailure implements Exception {
  final String message;
  PaymentFailure(this.message);

  @override
  String toString() => 'PaymentFailure: $message';
}
