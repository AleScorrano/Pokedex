import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/utils/map_card_color.dart';

class PokemonTile extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonTile({
    super.key,
    required this.pokemon,
  });

  @override
  State<PokemonTile> createState() => _PokemonTileState();
}

class _PokemonTileState extends State<PokemonTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: setCardColor(widget.pokemon.types.first).withOpacity(0.6)
          /* gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            setCardColor(widget.pokemon.types.first).withOpacity(0.6),
            Colors.transparent,
          ],
        ), */
          ),
      child: ListTile(
        minVerticalPadding: 16,
        minLeadingWidth: 70,
        title: _title(),
        subtitle: _subtitle(),
        leading: _image(),
        trailing: _favouriteButton(),
      ),
    );
  }

  Widget _subtitle() => Text(
        idFormatter(widget.pokemon.id),
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );

  Widget _title() => Text(
        widget.pokemon.name,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      );

  Widget _image() => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Transform.scale(
          scale: 1.5,
          child: Image.memory(
            widget.pokemon.image!,
          ),
        ),
      );

  Widget _favouriteButton() => const Icon(
        CupertinoIcons.star,
        color: Colors.blueGrey,
      );

  String idFormatter(int number) {
    return "#${number.toString().padLeft(3, '0')}";
  }
}
