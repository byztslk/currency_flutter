import 'dart:convert';
import 'package:http/http.dart' as http;
import 'exchange_rate.dart';

Future<List<ExchangeRate>> fetchExchangeRates(String currency) async {
  final response = await http
      .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/$currency'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    Map<String, dynamic> rates = jsonResponse['rates'];
    return rates.entries
        .map((entry) =>
            ExchangeRate(currency: entry.key, rate: entry.value.toDouble()))
        .toList();
  } else {
    throw Exception('Failed to load exchange rates');
  }
}
