import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter_localization/flutter_localization.dart';
import 'app_locale.dart';

final FlutterLocalization localization = FlutterLocalization.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  // Inicializás la traducción ANTES de correr la app
  localization.init(
    mapLocales: [
      const MapLocale('en', AppLocale.en),
      const MapLocale('es', AppLocale.es),
    ],
    initLanguageCode: 'es',
  );

  runApp(MyApp(localization: localization));
}

class MyApp extends StatelessWidget {
  final FlutterLocalization localization;
  const MyApp({super.key, required this.localization});
  @override
  Widget build(BuildContext context) {
    //notificador de cambios para el arbol de widgets
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Hello Flutter',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 103, 174, 181)),
        ),
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritePage();
        break;
      default:
        throw UnimplementedError(
            'no widget for $selectedIndex'); //evita errores por falta de implementacion de case
    }

    return LayoutBuilder(builder: (context, constraints) {
      //construye el layout segun las dimensiones de la pantalla indicadas en constraints
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text(AppLocale.home.getString(context)),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text(AppLocale.favorites.getString(context)),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  //"item seleccionado con el mouse: (indice del widget seleccionado) "
                  setState(() {
                    //setState es metodo de state y recibe una funcion callback "()"
                    selectedIndex =
                        value; // actualiza una variable global y retorna la ejecucion.
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child:
                    page, //dependiendo el selectedIndex es la pagina que se va a rebuild
              ),
            ),
          ],
        ),
      );
    });
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
              AppLocale.addFavorite.getString(context),
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
                label: Text(AppLocale.like.getString(context)),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text(AppLocale.next.getString(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.favorites.isEmpty) {
      return Center(
        child: Text(AppLocale.noFavorites.getString(context)),
      );
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: appState.favorites.map((pair) {
        return Card(
          color: Colors.amber.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pair.asPascalCase,
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }).toList(),
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
