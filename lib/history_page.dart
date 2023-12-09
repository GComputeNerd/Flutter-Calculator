import 'package:calculator/calculator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var calcData = context.watch<CalculatorData>() ;

    var height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("HISTORYPAGE")),
        body:Column(
            children: [
              Container(
                height: height*0.6,
                child: ListView.builder(
                  itemCount: calcData.history.length,
                  itemBuilder: (BuildContext context, int index) {
                  return calcData.history[index];
                }),
              ),
              ElevatedButton(onPressed: () => Navigator.pop(context),
               child: const Text("Go Back"),),
            ],
          ),
        )
      );
  }
}