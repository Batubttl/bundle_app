import 'package:flutter/material.dart';
import '../../model/currency_model.dart';
import '../../services/currency_service.dart';

class CurrencyViewModel extends ChangeNotifier {
  final CurrencyService _currencyService;

  CurrencyViewModel(this._currencyService) {
    _loadCurrencyRates();
  }

  bool isLoading = false;
  String? error;
  CurrencyData? currencyData;

  Future<void> _loadCurrencyRates() async {
    try {
      isLoading = true;
      notifyListeners();

      currencyData = await _currencyService.getCurrencyRates();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshRates() async {
    await _loadCurrencyRates();
  }

  String get usdRate => currencyData?.usdToTry.toStringAsFixed(3) ?? '--';

  String get eurRate => currencyData?.eurToTry.toStringAsFixed(3) ?? '--';
}
