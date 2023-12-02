import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
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
        children: [
          CalculatorDisplay(),
          CalculatorRow()
        ],
      ),
    );
  }
}

class CalculatorDisplay extends StatefulWidget {
  const CalculatorDisplay({super.key});

  @override createState() => _CalculatorDisplayState();
}

class _CalculatorDisplayState extends State<CalculatorDisplay> {
  var result = 0;

  @override
  Widget build(BuildContext context) {
    return Text(result.toString());
  }
}

class CalculatorRow extends StatelessWidget {
  const CalculatorRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}