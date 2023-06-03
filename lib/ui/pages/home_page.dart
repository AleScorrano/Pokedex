import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is ErrorPokemonState) {
            return const Center(child: Text("Errore"));
          } else {
            return const Center(child: Text("Tutto ok"));
          }
        },
      ),
    );
  }
}
