class ExchangeRate {
  final String currency;
  final double rate;

  ExchangeRate({required this.currency, required this.rate});

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      currency: json['currency'],
      rate: json['rate'].toDouble(),
    );
  }
}
