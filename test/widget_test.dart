import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mockito/mockito.dart';
import 'package:exercise_2/controllers/exchange_rate_controller.dart';
import 'package:exercise_2/models/exchange_rate.dart';
import 'package:exercise_2/views/screens/exchange_rate_page.dart';

class MockExchangeRateController extends Mock implements ExchangeRateController {}

void main() {
  group('ExchangeRatePage', () {
    late ExchangeRateController exchangeRateController;
    final startDate = DateTime.now().subtract(Duration(days: 1));
    final endDate = DateTime.now();
    final baseCurrency = 'USD';
    final targetCurrency = 'EUR';

    setUp(() {
      exchangeRateController = MockExchangeRateController();
      when(exchangeRateController.startDateController)
          .thenReturn(TextEditingController(text: startDate.toString()));
      when(exchangeRateController.endDateController)
          .thenReturn(TextEditingController(text: endDate.toString()));
      when(exchangeRateController.baseCurrencyController)
          .thenReturn(TextEditingController(text: baseCurrency));
      when(exchangeRateController.targetCurrencyController)
          .thenReturn(TextEditingController(text: targetCurrency));
      Get.put(exchangeRateController);
    });

    testWidgets('should display all text fields', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ExchangeRatePage()));
      expect(find.text('Start Date'), findsOneWidget);
      expect(find.text('End Date'), findsOneWidget);
      expect(find.text('Base Currency'), findsOneWidget);
      expect(find.text('Target Currency'), findsOneWidget);
    });

    testWidgets('should show loading animation when applying data', (WidgetTester tester) async {
      when(exchangeRateController.isDataProcessing.value).thenReturn(true);
      await tester.pumpWidget(MaterialApp(home: ExchangeRatePage()));
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(LoadingBouncingGrid), findsOneWidget);
    });


    testWidgets('should call exchange rate controller when applying data', (WidgetTester tester) async {
      when(exchangeRateController.isDataProcessing.value).thenReturn(false);
      await tester.pumpWidget(MaterialApp(home: ExchangeRatePage()));
      await tester.tap(find.text('Apply'));
      verify(exchangeRateController.loadExchangeRates(startDate, endDate)).called(1);
    });

    testWidgets('should show error when applying invalid data', (WidgetTester tester) async {
      when(exchangeRateController.isDataProcessing.value).thenReturn(false);
      when(exchangeRateController.startDateController)
          .thenReturn(TextEditingController(text: startDate.toString()));
      when(exchangeRateController.endDateController).thenReturn(TextEditingController(text: ''));
      when(exchangeRateController.baseCurrencyController)
          .thenReturn(TextEditingController(text: baseCurrency));
      when(exchangeRateController.targetCurrencyController)
          .thenReturn(TextEditingController(text: targetCurrency));
      await tester.pumpWidget(MaterialApp(home: ExchangeRatePage()));
      await tester.tap(find.text('Apply'));
      expect(find.text('Please enter a valid End Date'), findsOneWidget);
    });

    testWidgets('ExchangeRatePage should show exchange rates when data is fetched', (WidgetTester tester) async {
      // Arrange
      final exchangeRateController = ExchangeRateController();
      exchangeRateController.isDataProcessing.value = false;
      exchangeRateController.exchangeRatesList.value = [
        ExchangeRate(date: DateTime(2022, 1, 1), rate: 1.0),
        ExchangeRate(date: DateTime(2022, 1, 2), rate: 1.1),
        ExchangeRate(date: DateTime(2022, 1, 3), rate: 1.2),
      ];

      // Build the ExchangeRatePage widget
      await tester.pumpWidget(MaterialApp(home: ExchangeRatePage()));

      // Assert
      expect(find.text('2022-01-01'), findsOneWidget);
      expect(find.text('1.0'), findsOneWidget);
      expect(find.text('2022-01-02'), findsOneWidget);
      expect(find.text('1.1'), findsOneWidget);
      expect(find.text('2022-01-03'), findsOneWidget);
      expect(find.text('1.2'), findsOneWidget);
    });

    testWidgets('ExchangeRatePage should show error when data fetch fails', (WidgetTester tester) async {
      // Arrange
      final exchangeRateController = ExchangeRateController();
      exchangeRateController.isDataProcessing.value = false;
      exchangeRateController.errorMessage = 'Error fetching data';

      // Build the ExchangeRatePage widget
      await tester.pumpWidget(MaterialApp(home: ExchangeRatePage()));

      // Assert
      expect(find.text('Error fetching data'), findsOneWidget);
    });
  });
}