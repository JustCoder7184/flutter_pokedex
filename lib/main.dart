import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/screens/pkmn_detail_page.dart';

import 'screens/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const PokemonApp(),
  );
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
          useMaterial3: true,
          textTheme:
              GoogleFonts.pressStart2pTextTheme(Theme.of(context).textTheme)
                  .apply(fontSizeFactor: 0.5)),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        'pokemon_detail': (context) {
          final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
          return PokemonDetailPage(pokemon: pokemon);
        }
      },
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
