import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:calculator/calculator.dart';
import 'package:calculator/history_page.dart';

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
        width: width,
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
    double vertical;

    if (buffer == "") {
      borderRadius = BorderRadius.all(Radius.circular(radius));
      vertical = 15;
    } else {
      vertical = 8;
      borderRadius = const BorderRadius.only(
         topLeft: Radius.circular(10),
         topRight: Radius.circular(10),
      );
    }

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal:7,
      vertical: vertical),
      decoration: BoxDecoration(
        color: Color(0xffE0E0E0),
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
      padding: EdgeInsets.symmetric(vertical: 3),
      decoration: const BoxDecoration(
        color: Color(0xff00BFA5),
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
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      child: SizedBox(
        width: width*0.95,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons,
        ),
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

    return CalculatorButton(onPressed: () => onPressed(number), text: text);
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
    return CalculatorButton(onPressed: () => operation(), text: text);
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

  factory CalculatorButton.icon(Function onPressed, Icon icon){
    return _CalculatorButtonIcon(
      onPressed: onPressed,
      icon: icon,
    );
  }

  final Color buttonColor = const Color(0xff0097A7);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width*0.2,
      height: height*0.1,
      child: TextButton(
        onPressed: () => onPressed(),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: buttonColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(23),
        ),
        child: AutoSizeText(text,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _CalculatorButtonIcon extends CalculatorButton {
  const _CalculatorButtonIcon({
  required super.onPressed,
  super.text = "",
  required this.icon});

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width*0.2,
      height: height*0.1,
      child: TextButton(
        onPressed: () => onPressed(),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: super.buttonColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(23),
        ),
        child: icon,
      ),
    );
  }
}