import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/services/payment_service.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockFunctionsClient extends Mock implements FunctionsClient {}

class _FakeFunctionResponse extends Fake implements FunctionResponse {
  final dynamic data;
  _FakeFunctionResponse(this.data);
}

void main() {
  group('PaymentService.startCheckout', () {
    late _MockSupabaseClient supabase;
    late _MockFunctionsClient functions;
    late PaymentService service;

    const amount = 9990;
    const provider = 'kaspi';
    const redirectUrl = 'https://pay.test/checkout';

    setUp(() {
      supabase = _MockSupabaseClient();
      functions = _MockFunctionsClient();

      // SupabaseClient.functions getter
      when(() => supabase.functions).thenReturn(functions);

      service = PaymentService(supabase);
    });

    test('invokes edge function with correct parameters and returns redirect',
        () async {
      // Arrange
      when(() => functions.invoke('create-checkout-session', body: {
                'amount': amount,
                'provider': provider,
              }))
          .thenAnswer((_) async => _FakeFunctionResponse({'url': redirectUrl}));

      // Act
      final result =
          await service.startCheckout(amount: amount, provider: provider);

      // Assert
      expect(result.url, redirectUrl);
      verify(() => functions.invoke('create-checkout-session', body: {
            'amount': amount,
            'provider': provider,
          })).called(1);
    });

    test('throws PaymentFailure when response is missing url', () async {
      // Arrange
      when(() => functions.invoke(any<String>(), body: any(named: 'body')))
          .thenAnswer((_) async => _FakeFunctionResponse({}));

      // Act & Assert
      expect(() => service.startCheckout(amount: amount),
          throwsA(isA<PaymentFailure>()));
    });

    test('throws PaymentFailure when invoke throws', () async {
      // Arrange
      when(() => functions.invoke(any<String>(), body: any(named: 'body')))
          .thenThrow(Exception('edge function error'));

      // Act & Assert
      expect(() => service.startCheckout(amount: amount),
          throwsA(isA<PaymentFailure>()));
    });
  });
}
