import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentService {
  final SupabaseClient _client;
  PaymentService(this._client);

  /// Запускает чек-аут с указанной суммой и провайдером.
  /// Возвращает URL платежа, который нужно открыть в WebView.
  Future<String> startCheckout(
      {required int amount, String provider = 'kaspi'}) async {
    try {
      final response = await _client.functions.invoke('create-checkout-session',
          body: {'amount': amount, 'provider': provider});

      if (response.data == null || response.data['url'] == null) {
        throw Exception('Не удалось получить URL оплаты');
      }
      return response.data['url'] as String;
    } catch (e) {
      rethrow;
    }
  }
}
