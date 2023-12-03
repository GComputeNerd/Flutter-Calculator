import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class CalculatorData extends ChangeNotifier {
  num result = 0; // Stores current result
  num prevResult = 0; // Stores previous result
  int currentOP = -1; // Tracks current operation being used.

  bool applied = false; // Checks whether the operation has been applied or not.

  // To keep track of decimals
  bool isDecimal = false;
  int decimalPower = 0; 

  String getResult() {
    if (!(isDecimal) || decimalPower > 0) {
      return result.toString();
    }

    // The number is decimal
    if (decimalPower == 0) { // No decimal part
      return result.toString() +(".");
    }

    return "ERROR COULD NOT GET RESULT STRING";
  }

  void updateNumber(num x) {
    // Check whether to update current result, or start a new calculation
    if (applied == true && currentOP == -1) {
      if (currentOP == -1) {
        // Operations were all applied. So type new number
        result = 0;
        prevResult = 0;
        applied = false;
      } else {
        // Currently in a new operation. Must retain result
        applied = false;
      }
    }

    // Logic to update number
    if (result >= 0) {
      result = result*pow(10, decimalPower + 1) + x;
    } else {
      result = result*pow(10, decimalPower + 1) - x;
    }

    // Update DecimalPower if necessary
    if (isDecimal) {
      result = result / pow(10,++decimalPower);
    }

    notifyListeners();
  }

  void makeDecimal() {
    isDecimal = true;

    notifyListeners();
  }

  void apply() {
    switch (currentOP) {
      case 1: // Addition
        result = result + prevResult;
        break;
      case 2: // Subtraction
        result = prevResult - result;
        break;
      case 3: // Multiplication
        result = prevResult * result;
        break;
      case 4: // Division
        result = prevResult / result;
    }

    if (currentOP != -1) { // No operation was used, so no need to reset
      prevResult = 0;
      currentOP = -1;
      applied = true;
      notifyListeners();
    }
  }

  void setOP(int opCode) {
    apply();
    currentOP = opCode;
    prevResult = result;
    result = 0;
    notifyListeners();
  }

  void reset() {
    result = 0;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff84abb4),
      body: CalculatorMain(),
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
            const NumberButton(number: 1),
            const NumberButton(number: 2),
            const NumberButton(number: 3),
            OperationButton(operation: () => calcState.makeDecimal(), text: "."),
          ]),
          const CalculatorRow(buttons: [
            NumberButton(number: 4),
            NumberButton(number: 5),
            NumberButton(number: 6),
          ]),
          const CalculatorRow(buttons: [
            NumberButton(number: 7),
            NumberButton(number: 8),
            NumberButton(number: 9),
          ]),
          CalculatorRow(buttons: [
            OperationButton(operation: () => calcState.setOP(1),
            text: "+"),
            OperationButton(operation: () => calcState.setOP(2),
            text: "-"),
            OperationButton(operation: () => calcState.apply(),
            text: "="),
            OperationButton(operation: () => calcState.reset(), text: "AC")
          ])
        ],
      ),
    );
  }
}

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var calcState = context.watch<CalculatorData>();
    
    var result = calcState.getResult(); // Get result to display

    return Container(
      color: Colors.amber,
      width: width*0.8,
      margin: const EdgeInsets.symmetric(vertical: 9),
      padding: const EdgeInsets.all(5),
      child: Text(
        result,
        textAlign: TextAlign.right,),
    );
  }
}

class CalculatorRow extends StatelessWidget {
  final List<Widget> buttons;

  const CalculatorRow({
    super.key,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final int? number;

  const NumberButton({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CalculatorData>();

    return ElevatedButton(onPressed: () => appState.updateNumber(number!),
    child: Text(number.toString()));
  }
}

class OperationButton extends StatelessWidget {
  final Function operation;
  final String text;

  const OperationButton({super.key, 
    required this.operation,
    required this.text,});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => operation(), 
      child: Text(text));
  }
}