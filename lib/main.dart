import 'package:flutter/material.dart';
import 'exchange_rate.dart';
import 'api.dart';
import 'currency_button.dart';

void main() {
  runApp(const CurrencyExchangeApp());
}

class CurrencyExchangeApp extends StatelessWidget {
  const CurrencyExchangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyExchangeHomePage(),
    );
  }
}

class CurrencyExchangeHomePage extends StatefulWidget {
  const CurrencyExchangeHomePage({super.key});

  @override
  State<CurrencyExchangeHomePage> createState() =>
      _CurrencyExchangeHomePageState();
}

class _CurrencyExchangeHomePageState extends State<CurrencyExchangeHomePage> {
  Color currentColor = const Color.fromARGB(148, 93, 191, 221);
  Future<List<ExchangeRate>>? futureExchangeRates;
  List<String> currecyValues = ["USD", "EUR", "TRY"];
  String selectedValue = "TRY";
  @override
  void initState() {
    super.initState();
    futureExchangeRates = fetchExchangeRates(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange App'),
        backgroundColor: currentColor,
        toolbarHeight: 0,
      ),
      body: Center(
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 23, 184, 212),
                Color.fromARGB(255, 5, 3, 49)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: selectedValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    selectedValue = value!;
                  });
                  futureExchangeRates = fetchExchangeRates(selectedValue);
                },
                items:
                    currecyValues.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Currency Exchange",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<ExchangeRate>>(
                future: futureExchangeRates,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (!snapshot.hasData) {
                    return const Text("No data available");
                  } else {
                    List<ExchangeRate> rates = snapshot.data!;
                    List<ExchangeRate> filteredRates = rates
                        .where((rate) => ['USD', 'TRY', 'EUR', 'GBP', 'JPY']
                            .contains(rate.currency))
                        .toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: filteredRates.length,
                        itemBuilder: (context, index) {
                          ExchangeRate rate = filteredRates[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CurrencyButton(
                                  currency: rate.currency,
                                  rate: rate.rate,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }
}
