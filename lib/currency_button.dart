import 'package:flutter/material.dart';

class CurrencyButton extends StatelessWidget {
  final String currency;
  final double rate;

  const CurrencyButton({Key? key, required this.currency, required this.rate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Currency: $currency, Rate: $rate');
      },
      child: Text('$currency: $rate'),
    );
  }
}
