import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/exchange_rate_controller.dart';
import '../../utils/app_colors.dart';
import '../widgets/widgets.dart';

/// The screen that displays the exchange rates between two currencies.
class CurrencyConversionScreen extends StatefulWidget {
  /// The currency to which the exchange rate is being converted.
  final String? targetCurrency;

  /// The base currency from which the exchange rate is being calculated.
  final String? baseCurrency;

  const CurrencyConversionScreen({
    Key? key,
    required this.targetCurrency,
    required this.baseCurrency,
  }) : super(key: key);

  @override
  _CurrencyConversionScreenState createState() =>
      _CurrencyConversionScreenState();
}

class _CurrencyConversionScreenState extends State<CurrencyConversionScreen> {
  /// The controller that manages the state of the exchange rate screen.
  final exchangeRateController = Get.put(ExchangeRateController());

  /// The formatter used to format dates.
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  /// The text controller for the base currency input field.
  final baseCurrencyController = TextEditingController();

  /// The text controller for the target currency input field.
  final targetCurrencyController = TextEditingController();

  /// The controller for the pull-to-refresh widget.
  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Set the initial state of the exchange rate controller.
      exchangeRateController.currentPage.value = 0;
      exchangeRateController.exchangeRatesList.clear();
      // Fetch the exchange rates.
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Rates List', showBack: true),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Obx(
              () {
            return (exchangeRateController.isLoading.value)
                ? Center(
              child: LoadingBouncingGrid.circle(
                size: 40,
                backgroundColor: mainColor,
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    onLoading: _onLoading,
                    controller: refreshController,
                    footer: CustomFooter(
                      builder: (BuildContext? context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const Text('loading...');
                        } else if (mode == LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.noMore) {
                          body = const Text('No more Data');
                        } else {
                          body = const Text('');
                        }
                        return SizedBox(
                          height: 50.0,
                          child: Align(
                              alignment: Alignment.center, child: body),
                        );
                      },
                    ),
                    child: ListView.builder(
                      controller: exchangeRateController.scrollController,
                      itemCount:
                      exchangeRateController.exchangeRatesList.length,
                      itemBuilder: (context, index) {
                        final exchangeRate = exchangeRateController
                            .exchangeRatesList[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              '${exchangeRate!.date.day}/${exchangeRate.date.month}/${exchangeRate.date.year}',
                            ),
                            subtitle: Text(
                              '1 ${exchangeRateController.baseCurrencyController.text} = ${exchangeRate.rate} ${exchangeRateController.targetCurrencyController.text}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  /// Fetches the exchange rates between the two currencies.
  fetchData() {
    late DateTime endDate;
    late DateTime startDate;
    if (exchangeRateController.listOfDays.isNotEmpty) {
      startDate = exchangeRateController.listOfDays[0];
      if (exchangeRateController.listOfDays.length < 10) {
        endDate = exchangeRateController
            .listOfDays[exchangeRateController.listOfDays.length - 1];
        exchangeRateController.listOfDays
            .removeRange(0, exchangeRateController.listOfDays.length);
      } else {
        endDate = exchangeRateController.listOfDays[9];
        exchangeRateController.listOfDays.removeRange(0, 10);
      }
      exchangeRateController.loadExchangeRates(startDate, endDate);
      refreshController.loadComplete();
      setState(() {});
    } else {
      refreshController.loadNoData();
      setState(() {});
    }
  }

  /// Called when the pull-to-refresh widget is triggered.
  void _onLoading() async {
    exchangeRateController.currentPage.value++;
    await fetchData();
  }
}