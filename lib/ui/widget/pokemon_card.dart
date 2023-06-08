import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pokedex/extensions/capitalize.dart';
import 'package:pokedex/extensions/pokemon_id_formatter.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ui/pages/pokemon_details_sheet.dart';
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
    return InkWell(
      onTap: () => _openDetailSheet(),
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pokemonImage(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 14, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _pokemonName(),
                  _pokemonID(),
                  _types(),
                ],
              ),
            ),
            const Spacer(),
            _favouriteButton(),
          ],
        ),
      ),
    );
  }

  Widget _pokemonImage() => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              _pokemonColor.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
        child: Stack(
          children: [
            TypeIcon(
              type: widget.pokemon.types.first,
              size: 80,
              opacity: 0.3,
            ),
            widget.pokemon.image != null
                ? Image.memory(
                    widget.pokemon.image!,
                    width: 100,
                    height: 100,
                  )
                : const SizedBox()
          ],
        ),
      );

  Widget _pokemonID() => Text(
        widget.pokemon.id.toString().pokemonIdFormatter(),
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
      );

  Widget _favouriteButton() => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.star,
            color: Colors.amber.shade700,
          ),
        ),
      );

  Widget _pokemonName() => Text(
        widget.pokemon.name.capitalize(),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
      );

  Widget _types() => Row(
        children: List<Widget>.generate(
          widget.pokemon.types.length,
          (index) => TypeIcon(type: widget.pokemon.types[index]),
        ),
      );

  _openDetailSheet() => showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => PokemonDetailsSheet(pokemon: widget.pokemon));
}
