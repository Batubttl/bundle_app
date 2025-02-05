import 'package:dio/dio.dart';

class ApiClient {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '2a3eb28f3687475c833ad29a6085fcb2';

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': '2a3eb28f3687475c833ad29a6085fcb2',
        },
      ),
    );

    // Debug için logging interceptor ekle
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    // Interceptor ekle
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 429) {
            // Rate limit aşıldığında 2 saniye bekle ve tekrar dene
            await Future.delayed(const Duration(seconds: 2));
            return handler.resolve(await _dio.fetch(error.requestOptions));
          }
          return handler.next(error);
        },
      ),
    );
  }

  late final Dio _dio;
  Dio get dio => _dio;
}
