import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Мок для HttpClient
class MockHttpClient extends Mock implements http.Client {}

// Мок для хранилища сессий Supabase
class MockGotrueAsyncStorage extends Mock implements GotrueAsyncStorage {}
