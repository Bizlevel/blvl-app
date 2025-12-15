import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementations for Dio HTTP client
class MockDio extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {}

class MockRequestOptions extends Mock implements RequestOptions {}
