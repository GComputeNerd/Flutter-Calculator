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
  var result = 0;

  void updateNumber(int x) {
    result = result*10 + x;
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
    return Container(
      padding: const EdgeInsets.all(3),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           CalculatorDisplay(),
          CalculatorRow(buttons: [
            NumberButton(number: 1),
            NumberButton(number: 2),
            NumberButton(number: 3),
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
    var appState = context.watch<CalculatorData>();
    
    var result = appState.result.toString();

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
    return Row(
      children: this.buttons
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