import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Мок для HttpClient
class MockHttpClient extends Mock implements http.Client {}

/// Клиент, имитирующий оффлайн: любой запрос бросает SocketException.
class AlwaysFailHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Имитируем отсутствие сети, чтобы репозитории переходили в оффлайн-ветку.
    throw const SocketException('offline');
  }
}

/// Клиент для тестов: всегда возвращает HTTP 400 без реальных сетевых вызовов.
class TestHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Возвращаем валидный JSON, чтобы Postgrest корректно бросал PostgrestException
    const body = '{"code":"PGRST100","message":"Bad request (test)"}';
    final bytes = Stream<List<int>>.value(body.codeUnits);
    return http.StreamedResponse(
      bytes,
      400,
      reasonPhrase: 'Test HTTP 400',
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
}

// Мок для хранилища сессий Supabase
class MockGotrueAsyncStorage extends Mock implements GotrueAsyncStorage {}
