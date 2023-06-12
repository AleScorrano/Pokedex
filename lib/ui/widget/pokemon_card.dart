import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pokedex/cubits/dark_mode_cubit.dart';
import 'package:pokedex/extensions/capitalize.dart';
import 'package:pokedex/extensions/pokemon_id_formatter.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ui/pages/pokemon_details_sheet.dart';
import 'package:pokedex/ui/widget/favourite_button.dart';
import 'package:pokedex/ui/widget/type_icon_widget.dart';
import 'package:pokedex/utils/map_type_icon.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  final Scope? scope;
  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.scope,
  });

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool isLightMode = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DarkModeCubit, bool>(
      builder: (context, mode) {
        isLightMode = mode;
        return InkWell(
          onTap: () => _openDetailSheet(),
          child: widget.scope == Scope.list ? _forListScope() : _forGridScope(),
        );
      },
    );
  }

  Widget _forListScope() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(4),
        child: Stack(
          children: [
            _typeIcon(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _gradient(),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _favouritesButton(),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 4, bottom: 8),
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
                  _pokemonImage(),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _forGridScope() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            _typeIcon(),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    widget.pokemon.color,
                    widget.pokemon.color.withOpacity(0.9),
                    widget.pokemon.color.withOpacity(0.8),
                    widget.pokemon.color.withOpacity(0.6),
                    widget.pokemon.color.withOpacity(0.1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _pokemonName(),
                    _pokemonID(),
                    _pokemonImage(size: 120),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: -5,
              child: _favouritesButton(),
            )
          ],
        ),
      );

  Widget _favouritesButton() => FavouriteButton(
        color: isLightMode ? Colors.white70 : Colors.black54,
        pokemon: widget.pokemon,
      );

  Widget _typeIcon() {
    String type = setTypeIcon(widget.pokemon.types.first);
    return Positioned(
      right: type == "K" ? 10 : -10,
      top: widget.scope == Scope.list ? -20 : 60,
      bottom: widget.scope == Scope.list ? -20 : 0,
      child: Text(
        type,
        style: TextStyle(
          fontSize: 110,
          fontFamily: "PokeGoTypes",
          color: isLightMode ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _pokemonImage({double? size}) => widget.pokemon.image != null
      ? Image.memory(
          widget.pokemon.image!,
          width: size ?? 100,
          height: size ?? 100,
        )
      : const SizedBox();

  Widget _pokemonID() => Text(
        widget.pokemon.id.toString().pokemonIdFormatter(),
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.bold, color: Theme.of(context).hintColor),
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
          (index) => TypeIcon(
            type: widget.pokemon.types[index],
          ),
        ),
      );

  LinearGradient _gradient() => LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          widget.pokemon.color,
          widget.pokemon.color.withOpacity(0.9),
          widget.pokemon.color.withOpacity(0.8),
          widget.pokemon.color.withOpacity(0.6),
          widget.pokemon.color.withOpacity(0.4),
          widget.pokemon.color.withOpacity(0.2),
          widget.pokemon.color.withOpacity(0.1),
          isLightMode ? Colors.white12 : Colors.transparent,
        ],
      );

  void _openDetailSheet() => showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => PokemonDetailsSheet(pokemon: widget.pokemon));
}

enum Scope {
  list,
  grid,
}
