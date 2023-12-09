import 'package:calculator/gui/history_page.dart';
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

  final Color homePageColor = const Color(0xff37474F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePageColor,
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
            CalculatorButton.icon(()=>calcState.backspaceNumber(), 
            Icon(IconData(0xeeb5, fontFamily: 'MaterialIcons', matchTextDirection: true))),
            OperationButton(operation: () => calcState.makePercentage(), text: "%"),
            OperationButton(operation: () => calcState.setOP(1), text: "+"),
          ]),
          CalculatorRow(buttons: [
            const NumberButton(number: 1),
            const NumberButton(number: 2),
            const NumberButton(number: 3),
            OperationButton(operation: () => calcState.makeNegative(), text: "-"),
          ]),
          CalculatorRow(buttons: [
            const NumberButton(number: 4),
            const NumberButton(number: 5),
            const NumberButton(number: 6),
            OperationButton(operation: () => calcState.setOP(3), text: "×"),
          ]),
          CalculatorRow(buttons: [
            const NumberButton(number: 7),
            const NumberButton(number: 8),
            const NumberButton(number: 9),
            OperationButton(operation: () => calcState.setOP(4), text: "÷"),
          ]),
          CalculatorRow(buttons: [
            OperationButton(operation: () => calcState.setOP(6), text: "aᵇ"),
            const NumberButton(number: 0),
            OperationButton(operation: () => calcState.makeDecimal(), text: "."),
            OperationButton(operation: () => calcState.equalsButton(), text: "="),
          ]),
          ElevatedButton(
          onPressed: () => Navigator.of(context).push(_createRoute()),
          child: Text("Show History"),),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HistoryPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}