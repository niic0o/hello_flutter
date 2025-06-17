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

// Generás un color aleatorio para el texto
int r = random.nextInt(256);
int g = random.nextInt(256);
int b = random.nextInt(256);

textColor = Color.fromARGB(255, r, g, b);

// Calculás el color inverso para el fondo
bgColor = Color.fromARGB(255, 255 - r, 255 - g, 255 - b);

    notifyListeners(); //notifica a los widgets que hubo un cambio y toca hacer build de nuevo
  }

  //guardo una lista de palabras favoritas
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: appState.bgColor, // Fondo más amplio
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Text(
              ' Añade tu palabra favorita ',
              style: TextStyle(
                fontSize: 30,
                color: appState.textColor,
              ),
            ),
          ),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

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
