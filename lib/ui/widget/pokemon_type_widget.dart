import 'package:flutter/material.dart';
import 'package:pokedex/utils/map_card_color.dart';
import 'package:pokedex/utils/map_type_icon.dart';

class PokemonTypeWidget extends StatelessWidget {
  final String type;
  final Color color;
  PokemonTypeWidget({super.key, required this.type})
      : color = setCardColor(type);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 6),
          Container(
            constraints: const BoxConstraints(
              minHeight: 30,
              minWidth: 30,
              maxWidth: 30,
              maxHeight: 30,
            ),
            child: Text(
              setTypeIcon(type),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "PokeGoTypes",
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            type.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
