import 'package:calculator/calculator.dart';
import 'package:calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var calcData = context.watch<CalculatorData>() ;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var homePageColor = const Color(0xff37474F);

    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
       ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: PreferredSize(
        //     preferredSize: Size.fromHeight(height*0.5),
        //     child: const Text("History",
        //         textAlign: TextAlign.center,  
        //         style: TextStyle(
        //           fontSize: 45,
        //           color: Color(0xffCFD8DC),
        //           fontStyle: FontStyle.italic,
        //           fontFamily: 'Montserrat',
        //         ),
        //       ),
        //   ),
        //   backgroundColor: const Color(0xff263238),
        //   centerTitle: true,
        // ),
        backgroundColor: homePageColor,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HistoryList(height: height, calcData: calcData),
                ElevatedButton(onPressed: () => Navigator.pop(context),
                 child: const Text("Go Back"),),
              ],
            ),
        ),
        )
      );
  }
}

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    required this.height,
    required this.calcData,
  });

  final double height;
  final CalculatorData calcData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height*0.6,
      child: ListView.builder(
        itemCount: calcData.history.length,
        itemBuilder: (BuildContext context, int index) {
        return HistoryCard(tile: calcData.history[calcData.history.length -1 -index],
          height: height*0.09,);
      }),
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.tile,
    required this.height,
  });

  final HistoryTile tile;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Card(
        color: Color(0xff0097A7),
        child: Center(child: tile)
      )
    );
  }
}

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    super.key,
    required this.answer,
    required this.question,
  });

  final String answer;
  final String question;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(answer,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 23,
        ),
      ),
      trailing: Text(question,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.italic
        ),
      ),
    );
  }
}