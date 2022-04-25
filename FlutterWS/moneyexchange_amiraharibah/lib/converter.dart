import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConverterPage extends StatelessWidget {
  const ConverterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[600],
          title: const Text('Bitcoin Currency Converter App')),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              color: Colors.grey,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Image.asset('assets/images/bitcoinlogo.png', scale: 3),
                  ]),
                ],
              )),
          Container(
              color: Colors.grey,
              height: 1000,
              width: 1000,
              child: const HomePage()),
        ]),
      ),
    ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController bitcoinValueEditorController = TextEditingController();
  String selectCurrency = "btc";
  String desc = "No result";
  String desc2 = "No exchanged made";
  String exchange = "Exchanged Value";
  var name = "";
  var unit = "";
  var value = 0.0;
  var equalsTo = 0.0;
  var result = 0.0;

  List<String> curList = [
    "btc",
    "eth",
    "ltc",
    "bch",
    "bnb",
    "eos",
    "xrp",
    "xlm",
    "link",
    "dot",
    "yfi",
    "usd",
    "aed",
    "ars",
    "aud",
    "bdt",
    "bhd",
    "bmd",
    "brl",
    "cad",
    "chf",
    "clp",
    "cny",
    "czk",
    "dkk",
    "eur",
    "gbp",
    "hkd",
    "huf",
    "idr",
    "ils",
    "inr",
    "jpy",
    "krw",
    "kwd",
    "lkr",
    "mmk",
    "mxn",
    "myr",
    "ngn",
    "nok",
    "nzd",
    "php",
    "pkr",
    "pln",
    "rub",
    "sar",
    "sek",
    "sgd",
    "thb",
    "try",
    "twd",
    "uah",
    "vef",
    "vnd",
    "zar",
    "xdr",
    "xag",
    "xau",
    "bits",
    "sats",
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 2),
          TextField(
            controller: bitcoinValueEditorController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black54,
                hintStyle: const TextStyle(color: Colors.white),
                hintText: "Enter Bitcoin (BTC) Value",
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0))),
          ),
          const SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text(
              "Select currency: ",
              style: TextStyle(fontSize: 17),
            ),
            DropdownButton(
              itemHeight: 60,
              value: selectCurrency,
              onChanged: (newValue) {
                setState(() {
                  selectCurrency = newValue.toString();
                });
              },
              items: curList.map((selectCurrency) {
                return DropdownMenuItem(
                  child: Text(
                    selectCurrency,
                  ),
                  value: selectCurrency,
                );
              }).toList(),
            )
          ]),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadCurrency,
            child: const Text("CONVERT",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(170, 55),
                primary: Colors.orange[600],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
          const SizedBox(height: 15),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(exchange,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                      )),
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  desc2,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ])),
        ],
      ),
    );
  }

  Future<void> _loadCurrency() async {
    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      name = parsedData['rates'][selectCurrency]['name'];
      unit = parsedData['rates'][selectCurrency]['unit'];
      value = parsedData['rates'][selectCurrency]['value'];

      setState(() {
        double insertValue = double.parse(bitcoinValueEditorController.text);
        equalsTo = value * 1;
        result = insertValue * value;
        exchange = "1 BTC is equal to $unit $value";
        desc = "$unit $result";
        desc2 = "Bitcoin exchange to $name";
      });
    }
  }
}
