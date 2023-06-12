import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/models/pokemon.dart';

class FavouriteButton extends StatefulWidget {
  final Pokemon pokemon;
  final Color? color;
  const FavouriteButton({
    super.key,
    required this.pokemon,
    this.color,
  });

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      buildWhen: (previous, current) {
        return current is PokemonFetchedState ||
            current is ErrorPokemonState ||
            current is FetchingDataState;
      },
      builder: (context, state) {
        if (state is PokemonFetchedState) {
          Pokemon listeningiItem = state.pokemons
              .firstWhere((element) => widget.pokemon.id == element.id);
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: _favouriteToggle,
              icon: Icon(
                listeningiItem.isFavourite
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                color: widget.color ?? Colors.red,
                size: 30,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void _favouriteToggle() =>
      BlocProvider.of<PokemonBloc>(context).toggleFavourite(widget.pokemon);
}
