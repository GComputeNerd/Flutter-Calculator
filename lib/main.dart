import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calculator.dart';
import 'gui/calculator_components.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculatorData(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 115, 42, 188),
      body: Center(child: CalculatorMain()),
    );
  }
}

class CalculatorMain extends StatelessWidget {
  const CalculatorMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var calcState = context.watch<CalculatorData>();

    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CalculatorDisplay(),
          CalculatorRow(buttons: [
            OperationButton(operation: () => calcState.reset(), text: "AC"),
            CalculatorButton(onPressed: () => calcState.setOP(5), text: "%"),
            OperationButton(operation: () => calcState.backspaceNumber(), text: "Back"),
            OperationButton(operation: () => calcState.setOP(1), text: "+"),
          ]),
          CalculatorRow(buttons: [
            const NumberButton(number: 1),
            const NumberButton(number: 2),
            const NumberButton(number: 3),
            OperationButton(operation: () => calcState.setOP(2), text: "-"),
          ]),
          CalculatorRow(buttons: [
            const NumberButton(number: 4),
            const NumberButton(number: 5),
            const NumberButton(number: 6),
            OperationButton(operation: () => calcState.setOP(3), text: "*"),
          ]),
          CalculatorRow(buttons: [
            const NumberButton(number: 7),
            const NumberButton(number: 8),
            const NumberButton(number: 9),
            OperationButton(operation: () => calcState.setOP(4), text: "/"),
          ]),
          CalculatorRow(buttons: [
            OperationButton(operation: () => {}, text: "X"),
            const NumberButton(number: 0),
            OperationButton(operation: () => calcState.makeDecimal(), text: "."),
            OperationButton(operation: () => calcState.apply(), text: "="),
          ]),
        ],
      ),
    );
  }
}