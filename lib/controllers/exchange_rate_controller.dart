import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_services/exchange_rate_api_service.dart';
import '../models/exchange_rate.dart';

/// A controller for managing exchange rates.
class ExchangeRateController extends GetxController {
  /// A list of exchange rates.
  RxList<ExchangeRate?> exchangeRatesList = RxList<ExchangeRate>();

  /// A controller for the start date text field.
  final _startDateController = TextEditingController();

  /// A controller for the end date text field.
  final _endDateController = TextEditingController();

  /// A controller for the base currency text field.
  final _baseCurrencyController = TextEditingController();

  /// A controller for the target currency text field.
  final _targetCurrencyController = TextEditingController();

  /// An observable boolean indicating whether exchange rates are currently being loaded.
  final isLoading = false.obs;

  /// The current page number.
  final currentPage = 0.obs;

  /// An observable boolean indicating whether data is currently being processed.
  var isDataProcessing = false.obs;

  /// A list of days in the selected date range.
  List<DateTime> listOfDays = [];

  // For Pagination
  /// A scroll controller for the exchange rate list view.
  ScrollController scrollController = ScrollController();

  /// An observable boolean indicating whether more data is available for pagination.
  var isMoreDataAvailable = true.obs;

  var errorMessage = "Something went wrong!";

  /// The/// number of exchange rates to fetch per page.
  var pageSize = 10;

  /// Gets the start date text field controller.
  TextEditingController get startDateController => _startDateController;

  /// Gets the end date text field controller.
  TextEditingController get endDateController => _endDateController;

  /// Gets the base currency text field controller.
  TextEditingController get baseCurrencyController => _baseCurrencyController;

  /// Gets the target currency text field controller.
  TextEditingController get targetCurrencyController =>
      _targetCurrencyController;

  @override
  void onInit() {
    super.onInit();
  }

  /// Loads exchange rates for the specified date range and currency pair.
  ///
  /// The [startDate] and [endDate] parameters specify the date range for which to load exchange rates.
  ///
  /// If [currentPage] is 0, sets [isLoading] to true while loading.
  ///
  /// Throws an exception if the API request fails.
  Future<void> loadExchangeRates(DateTime startDate, DateTime endDate) async {
    try {
      if (currentPage.value == 0) isLoading(true);
      final exchangeRateMaps =
          await ExchangeRateApiService().fetchExchangeRates(
        startDate: startDate,
        endDate: endDate,
        baseCurrency: _baseCurrencyController.text,
        targetCurrency: _targetCurrencyController.text,
        page: currentPage.value,
        pageSize: pageSize,
      );
      final exchangeRates = exchangeRateMaps.map((exchangeRateMap) {
        final date = exchangeRateMap['date'] as DateTime;
        final rate = exchangeRateMap['rate'] as double;
        return ExchangeRate(date: date, rate: rate);
      }).toList();
      exchangeRatesList.addAll(exchangeRates);
      if (currentPage.value == 0) isLoading(false);
    } catch (exception) {
      showSnackBar("Exception", errorMessage, Colors.red);
    }
  }

  /// Shows a snack bar with the specified title, message, and background color.
  ///
  /// The [title] parameter specifies the title of the snack bar.
  ///
  /// The [message] parameter specifies the message of the snack bar.
  ///
  /// The [backgroundColor] parameter specifies the background color of the snack bar.
  void showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        colorText: Colors.white);
  }
}
