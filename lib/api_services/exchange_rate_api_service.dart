import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/app_constant.dart';

/// A service for fetching exchange rates from an API.
class ExchangeRateApiService {
  /// Fetches a list of exchange rates for a given time range, base currency, and target currency.
  ///
  /// The [startDate] and [endDate] parameters specify the time range for which to fetch exchange rates.
  ///
  /// The [baseCurrency] parameter specifies the base currency for the exchange rates.
  ///
  /// The [targetCurrency] parameter specifies the target currency for the exchange rates.
  ///
  /// The [page] and [pageSize] parameters specify the page number and page size for the results.
  ///
  /// Returns a list of maps, where each map represents an exchange rate and has two keys: 'date' and 'rate'.
  ///
  /// Throws an exception if the API request fails.
  Future<List<Map<String, dynamic>>> fetchExchangeRates({
    required DateTime startDate,
    required DateTime endDate,
    required String baseCurrency,
    required String targetCurrency,
    required int page,
    required int pageSize,
  }) async {
    final start = startDate.toIso8601String().substring(0, 10);
    final end = endDate.toIso8601String().substring(0, 10);
    final url =
        '$baseUrl/timeseries?start_date=$start&end_date=$end&base=$baseCurrency&symbols=$targetCurrency&page=$page&limit=$pageSize';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch exchange rates');
    }
    final data = jsonDecode(response.body);
    final rates = data['rates'] as Map<String, dynamic>;
    return rates.entries.map((entry) {
      final date = DateTime.parse(entry.key);
      final rate = entry.value[targetCurrency] as double;
      return {'date': date, 'rate': rate};
    }).toList();
  }
}
