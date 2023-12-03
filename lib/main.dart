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
  num decimalPart = 0;

  String getResultString() {
    if (!(isDecimal)) {
      return result.toString();
    }

    // The number is decimal
    if (decimalPower == 0) { // No decimal part
      return result.toString() +(".");
    }

    return "$result.$decimalPart";
  }

  num getResultDecimal() {
    if (result >= 0) {
      result = result + decimalPart/pow(10, decimalPower);
    } else {
      result = result - decimalPart/pow(10, decimalPower);
    }

    return result;
  }

  void updateNumber(num x) {
    testAndResetBuffers();

    // Logic to update number
    if (!(isDecimal)) {
      if (result >= 0) {
        result = result*10 + x;
      } else {
        result = result*10 - x;
      }
    } else {
      // is Decimal
      decimalPart = decimalPart*10 + x;
      decimalPower++;
    }

    notifyListeners();
  }

  void backspaceNumber() {
    if (isDecimal) {
      if (decimalPart == 0) {
        isDecimal = false;
      }
      decimalPart = decimalPart ~/ 10;
      decimalPower--;
    } else {
      result = result ~/ 10;
    }

    notifyListeners();
  }

  void makeDecimal() {
    testAndResetBuffers();
    isDecimal = true;

    notifyListeners();
  }

  void apply() {
    result = isDecimal ? getResultDecimal() : result;
    resetDecimal();

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

    if (currentOP != -1) { // Operation was used, need to reset
      var temp = result;
      reset();
      result = temp;
      applied = true;
    }
    notifyListeners();
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
    prevResult = 0;
    currentOP = -1;

    applied = false;

    resetDecimal();

    notifyListeners();
  }

  void resetDecimal() {
    isDecimal = false;
    decimalPower = 0;
    decimalPart = 0;
  }

  void testAndResetBuffers() {
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
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff84abb4),
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
            OperationButton(operation: () => {}, text: "X"),
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

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var calcState = context.watch<CalculatorData>();
    
    var result = calcState.getResultString(); // Get result to display

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