import 'package:intl/intl.dart';

class CurrencyData {
  final double usdToTry;
  final double eurToTry;
  final DateTime lastUpdate;

  CurrencyData({
    required this.usdToTry,
    required this.eurToTry,
    required this.lastUpdate,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    final dateStr = json['time_last_update_utc'] as String;
    final DateTime parsedDate =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss '+0000'").parse(dateStr);

    return CurrencyData(
      usdToTry: json['conversion_rates']['TRY'].toDouble(),
      eurToTry:
          (json['conversion_rates']['TRY'] / json['conversion_rates']['EUR'])
              .toDouble(),
      lastUpdate: parsedDate,
    );
  }
}
