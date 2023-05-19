/// A class representing an exchange rate for a specific date.
class ExchangeRate {
  /// The date for the exchange rate.
  final DateTime date;

  /// The exchange rate.
  final double rate;

  /// Creates an instance of [ExchangeRate] with the specified date and rate.
  ///
  /// The [date] parameter specifies the date for the exchange rate.
  ///
  /// The [rate] parameter specifies the exchange rate.
  const ExchangeRate({required this.date, required this.rate});
}