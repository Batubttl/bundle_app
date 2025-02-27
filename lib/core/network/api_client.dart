import 'package:bundle_app/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

class ApiClient {
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': ApiConstants.apiKey,
        },
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 429) {
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
