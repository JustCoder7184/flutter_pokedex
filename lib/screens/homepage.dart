import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/utilities/custom_extensions.dart';
import 'package:pokedex_app/utilities/pkmn_type_colours.dart';
import 'package:pokedex_app/widget/pkmn_type_chip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pokemons = <Pokemon>[];
  final scrollController = ScrollController();
  var isFetching = false;

  @override
  void initState() {
    super.initState();

    fetchPokemons(start: 1);
    scrollController.addListener(onScroll);
  }

  onScroll() {
    final current = scrollController.position.pixels;
    final bottom = scrollController.position.maxScrollExtent;
    final atBottom = current == bottom;

    if (atBottom) {
      if (isFetching) return;
      fetchPokemons(start: pokemons.length + 1);
      scrollController.jumpTo(current + 100);
    }
  }

  fetchPokemons({required int start, int count = 1016}) async {
    setState(() {
      isFetching = true;
    });
    final end = min(start + count, 1017);
    for (var i = start; i <= end; i++) {
      final link = 'https://pokeapi.co/api/v2/pokemon/$i';
      final uri = Uri.parse(link);
      final response = await get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final pkmn = Pokemon.fromJson(json);
        setState(() {
          pokemons.add(pkmn);
        });
      }
    }

    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Pokedex'), centerTitle: false, actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ]),
      body: GridView.builder(
        controller: scrollController,
        itemCount: pokemons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 3,
        ),
        itemBuilder: (context, index) {
          final pkmn = pokemons[index];
          return PokemonCard(pokemon: pkmn).animate().flipH();
        },
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final mainType = pokemon.types.first.name;
    final mainColor = pkmTypeColors[mainType]!;
    return LayoutBuilder(
      builder: (context, constraint) {
        return Card(
          color: Color(mainColor),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'pokemon_detail',
                  arguments: pokemon);
            },
            child: Stack(
              children: [
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Opacity(
                      opacity: 0.5,
                      child: Image.network(
                        'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/16c93e3b-ce11-48da-a4a8-ad1dca9081ec/dmh4ei-666ff8b3-1e52-4318-93a8-50fa1f33ab6c.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzE2YzkzZTNiLWNlMTEtNDhkYS1hNGE4LWFkMWRjYTkwODFlY1wvZG1oNGVpLTY2NmZmOGIzLTFlNTItNDMxOC05M2E4LTUwZmExZjMzYWI2Yy5wbmcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.Ktgv0vpDRHcZ4SHaIFm-Zqz_gyM92dOk7Z3jFxi-4a0',
                        width: 150,
                        height: 150,
                      )),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraint.maxHeight * 0.85,
                      maxWidth: constraint.maxWidth * 0.85,
                    ),
                    child: Hero(
                      tag: pokemon.defaultImage,
                      child: Image.network(pokemon.defaultImage),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Column(
                      children: [
                        Text(
                          pokemon.name.capitalize(),
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        for (final type in pokemon.types)
                          PokemonTypeChip(type: type),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
