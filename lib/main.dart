import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Hello Flutter',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  Color textColor = Colors.indigoAccent;
  Color bgColor = Colors.deepOrange.shade100;

  void getNext() {
    
    current = WordPair.random();

    final random = Random();
    
    textColor = Color.fromARGB(
      255, // opacidad máxima
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    
    bgColor = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hola soy un texto centrado',
                style: TextStyle(
                    fontSize: 30,
                    color: appState.textColor,
                    backgroundColor: appState.bgColor)),
            BigCard(pair: pair), //objeto2
            ElevatedButton(
              //objeto3
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

@override
Widget build(BuildContext context) {

  final theme = Theme.of(context);

  return Card(
    color: theme.colorScheme.primary,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(pair.asLowerCase),
    )
  );
}
}
