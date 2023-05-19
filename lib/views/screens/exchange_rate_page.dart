import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:intl/intl.dart';

import '../../controllers/exchange_rate_controller.dart';
import '../../utils/app_colors.dart';
import '../widgets/widgets.dart';
import 'currency_conversion_list_screen.dart';

/// The screen that allows the user to select the start and end dates, base
/// currency, and target currency for the exchange rates.
class ExchangeRatePage extends StatefulWidget {
  @override
  _ExchangeRatePageState createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  final exchangeRateController = Get.put(ExchangeRateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Exchange Rates', showBack: false),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            customEditTextStyle('Start Date',
                controller: exchangeRateController.startDateController,
                onTap: _onStartDateTap,
                enabled: false),
            const SizedBox(
              height: 10.0,
            ),
            customEditTextStyle('End Date',
                controller: exchangeRateController.endDateController,
                onTap: _onEndDateTap,
                enabled: false),
            const SizedBox(
              height: 10.0,
            ),
            customEditTextStyle(
              'Base Currency',
              controller: exchangeRateController.baseCurrencyController,
            ),
            const SizedBox(
              height: 10.0,
            ),
            customEditTextStyle(
              'Target Currency',
              controller: exchangeRateController.targetCurrencyController,
            ),
            const SizedBox(
              height: 30.0,
            ),
            Obx(
              () => (exchangeRateController.isDataProcessing.value)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                          child: LoadingBouncingGrid.circle(
                        size: 40,
                        backgroundColor: mainColor,
                      )),
                    )
                  : containerButton(
                      onTap: () {
                        bool valid = isDataValid();
                        if (valid) {
                          // 1) divide the whole period to 10-days-periods
                          String startDateString =
                              exchangeRateController.startDateController.text;
                          String endDateString =
                              exchangeRateController.endDateController.text;
                          DateTime startDate = DateTime.parse(startDateString);
                          DateTime endDate = DateTime.parse(endDateString);
                          final List<DateTime> days = [];
                          for (int i = 0;
                              i <= endDate.difference(startDate).inDays;
                              i++) {
                            days.add(startDate.add(Duration(days: i)));
                          }
                          exchangeRateController.listOfDays = days;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CurrencyConversionScreen(
                                      baseCurrency: exchangeRateController
                                          .baseCurrencyController.text,
                                      targetCurrency: exchangeRateController
                                          .targetCurrencyController.text,
                                    )),
                          ).then((value) {
                            // Clear the text fields when the user returns from the conversion screen.
                            exchangeRateController.startDateController.text =
                                "";
                            exchangeRateController.endDateController.text = "";
                            exchangeRateController.baseCurrencyController.text =
                                "";
                            exchangeRateController
                                .targetCurrencyController.text = "";
                          });
                        }
                      },
                      label: "Apply",
                      btnWidth: MediaQuery.of(context).size.width),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a date picker and updates the given [controller] with the selected date.
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (selectedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  /// Validates the data entered by the user in the text fields.
  bool isDataValid() {
    bool valid = true;
    if (exchangeRateController.startDateController.text.isEmpty ||
        exchangeRateController.endDateController.text.isEmpty ||
        exchangeRateController.baseCurrencyController.text.isEmpty ||
        exchangeRateController.targetCurrencyController.text.isEmpty) {
      customSnackBar(context, msg: "All Fields Required");
      valid = false;
    } else {
      valid = true;
    }

    return valid;
  }

  /// Called when the user taps on the 'Start Date' field to select a date.
  void _onStartDateTap() async {
    await _selectDate(exchangeRateController.startDateController);
  }

  /// Called when the user taps on the 'End Date' field to select a date.
  void _onEndDateTap() async {
    await _selectDate(exchangeRateController.endDateController);
  }
}
