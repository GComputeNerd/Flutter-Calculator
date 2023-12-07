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
    var buffer = calcState.getBufferString();

    var widgetsToDisplay = <Widget>[
      ResultDisplay(width:width, result: result,)
    ];

    if (buffer != "") {
      widgetsToDisplay.add(BufferDisplay(width:width, buffer: buffer));
    }

    return Card(
      color: Colors.amber,
      child: Container(
        width: width*0.8,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: widgetsToDisplay,
        ),
      ),
    );
  }
}

class ResultDisplay extends StatelessWidget {
  const ResultDisplay({
    super.key,
    required this.width,
    required this.result,
  });

  final double width;
  final String result;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        result,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),),
    );
  }
}

class BufferDisplay extends StatelessWidget {
  const BufferDisplay({
    super.key,
    required this.width,
    required this.buffer,
  });

  final double width;
  final String buffer;

  @override
  Widget build(BuildContext context) {
    var calcData = context.watch<CalculatorData>();
    var buffer = calcData.getBufferString();

    return Text("Buffer : $buffer");
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