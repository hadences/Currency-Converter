import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> _currencyOptions = ['USD', 'Won', 'Yen'];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Currency Converter (By jaesu)'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _controller = TextEditingController();
  final String _selectedCurrency = _currencyOptions.first;
  String _fromCurrency = _currencyOptions.first;
  String _toCurrency = _currencyOptions.first;
  double _result = 0.0;

  final Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'Won': 1380.44,
    'Yen': 160.96,
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void convert(double amount) {
    //convert the value to USD first then to the target currency
    double inUSD = amount / _exchangeRates[_fromCurrency]!;
    setState(() {
      _result = inUSD * _exchangeRates[_toCurrency]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
        backgroundColor: Theme.of(context).splashColor,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  onChanged: (String str) {
                    convert(double.parse(_controller.text));
                  },
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the currency value to convert.'
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownMenu<String>(
                    onSelected: (String? value) {
                      setState(() {
                        _fromCurrency = value!;
                        convert(double.parse(_controller.text));
                      });
                    },
                    label: const Text('From'),
                    initialSelection: _selectedCurrency,
                      dropdownMenuEntries: _currencyOptions.map((String value) {
                        return DropdownMenuEntry(value: value, label: value);
                      }).toList(),
                  ),
                  DropdownMenu<String>(
                    onSelected: (String? value) {
                      setState(() {
                        _toCurrency = value!;
                        convert(double.parse(_controller.text));
                      });
                    },
                    label: const Text('To'),
                    initialSelection: _selectedCurrency,
                    dropdownMenuEntries: _currencyOptions.map((String value) {
                      return DropdownMenuEntry(value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                convert(double.parse(_controller.text));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Convert')
          ),
          const SizedBox(height: 20.0),
          Text(
            '${_controller.text} $_fromCurrency -> $_result $_toCurrency',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


