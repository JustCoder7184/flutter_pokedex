import 'package:flutter/material.dart';
import 'package:pokedex_app/utilities/custom_extensions.dart';
import 'package:pokedex_app/utilities/pkmn_type_colours.dart';

import '../models/pokemon.dart';

class PokemonTypeChip extends StatelessWidget {
  const PokemonTypeChip({
    super.key,
    required this.type,
  });

  final Type type;

  @override
  Widget build(BuildContext context) {
    final typeColor = pkmTypeColors[type.name]!;
    return Chip(
        backgroundColor: Color(typeColor),
        label: Text(type.name.capitalize(),
            style: const TextStyle(color: Colors.white)));
  }
}
