import 'package:dio/dio.dart';

class ApiClient {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '2a3eb28f3687475c833ad29a6085fcb2';

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        queryParameters: {'apiKey': _apiKey},
      ),
    );
  }

  late final Dio _dio;
  Dio get dio => _dio;
}
