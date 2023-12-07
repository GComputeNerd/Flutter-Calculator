import 'dart:ffi';

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
      ResultDisplay(width:width, result: result,buffer: buffer)
    ];

    if (buffer != "") {
      widgetsToDisplay.add(BufferDisplay(width:width, buffer: buffer));
    }

    return Container(
        width: width*0.9,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: widgetsToDisplay,
        ),
      );
  }
}

class ResultDisplay extends StatelessWidget {
  const ResultDisplay({
    super.key,
    required this.width,
    required this.result,
    required this.buffer,
    this.radius = 10,
  });

  final double width;
  final String result;
  final String buffer;
  final double radius;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;

    if (buffer == "") {
      borderRadius = BorderRadius.all(Radius.circular(radius));
    } else {
      borderRadius = const BorderRadius.only(
         topLeft: Radius.circular(10),
         topRight: Radius.circular(10),
      );
    }

    return Container(
      width: width,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: borderRadius,
      ),
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

    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Text(buffer,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),),
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
  final int number;

  const NumberButton({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CalculatorData>();
    var text = number.toString();
    var onPressed = appState.updateNumber;

    return CalculatorButton(onPressed: (number) => onPressed, text: text);
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
    return CalculatorButton(onPressed: operation, text: text);
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent,
        shape: CircleBorder(),
        padding: EdgeInsets.all(23),
      ),
      child: Text(text),
    );
  }
}