import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("HISTORYPAGE")),
        body: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Go Back!"),
        )
      ),
    );
  }
}