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
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 103, 174, 181)),
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

    notifyListeners(); //notifica a los widgets que hubo un cambio y toca hacer build de nuevo
  }

  //guardo una lista de palabras favoritas
  var favorites = <WordPair>[];

  void toggleFavorites() {
    if (favorites.contains(current)){
      favorites.remove(current);
      }else{
        favorites.add(current);
      }
      notifyListeners(); 
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) { //esto asegura que pair no sea null.
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

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
            SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  //objeto3
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
                ElevatedButton.icon(
                  onPressed: (){
                    appState.toggleFavorites();
                  },
                  icon: Icon(icon),
                  label: Text('Like')
                  ),
                  SizedBox(height: 15),
              ],
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
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
        color: theme.colorScheme.primary,
        elevation: 19.0, //sombreado
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            pair.asLowerCase,
            style: style, //estilo de letras heredadas del tema
            semanticsLabel:
                "${pair.first} ${pair.second}", //permite a lectores de pantalla leer mejor las palabras
          ),
        ));
  }
}
