import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/extensions/capitalize.dart';
import 'package:pokedex/extensions/pokemon_id_formatter.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ui/widget/type_icon_widget.dart';
import 'package:pokedex/utils/map_card_color.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonCard({super.key, required this.pokemon});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  late Color _pokemonColor;

  @override
  void initState() {
    _pokemonColor = setCardColor(widget.pokemon.types.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.rectangle,
        border: Border.all(color: _pokemonColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _pokemonImage(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pokemonName(),
                _pokemonID(),
              ],
            ),
          ),
          const Spacer(),
          _types(),
          const SizedBox(width: 10),
          _favouriteButton(),
        ],
      ),
    );
  }

  Widget _pokemonImage() => Stack(
        children: [
          Image.asset("assets/images/pokeball.png",
              fit: BoxFit.cover,
              width: 80,
              height: 80,
              color: _pokemonColor.withOpacity(0.2)),
          widget.pokemon.image != null
              ? Image.memory(
                  widget.pokemon.image!,
                  width: 80,
                  height: 80,
                )
              : const SizedBox()
        ],
      );

  Widget _pokemonID() => Text(
        widget.pokemon.id.toString().pokemonIdFormatter(),
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
      );

  Widget _favouriteButton() => IconButton(
        onPressed: () {},
        icon: Icon(
          CupertinoIcons.star,
          color: Colors.amber.shade700,
        ),
      );

  Widget _pokemonName() => Text(
        widget.pokemon.name.capitalize(),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      );

  Widget _types() => Row(
        children: List<Widget>.generate(
          widget.pokemon.types.length,
          (index) => TypeIcon(type: widget.pokemon.types[index]),
        ),
      );
}
