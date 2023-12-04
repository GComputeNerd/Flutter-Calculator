import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:calculator/calculator.dart';

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

    return OutlinedButton(
      onPressed: () => appState.updateNumber(number!),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(23),
      ),
      child: Text(number.toString())
    );
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
    return OutlinedButton(
      onPressed: () => operation(), 
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Text(text),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(23),
      ),
    );
  }
}