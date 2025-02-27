import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../model/currency_model.dart';

class CurrencyService {
  final Dio _dio = Dio();

  Future<CurrencyData> getCurrencyRates() async {
    try {
      final response = await _dio.get(ApiConstants.getCurrencyRate());

      if (response.statusCode == 200) {
        return CurrencyData.fromJson(response.data);
      }
      throw Exception(AppStrings.errorCurrency);
    } catch (e) {
      throw Exception('${AppStrings.errorCurrency} $e');
    }
  }
}
