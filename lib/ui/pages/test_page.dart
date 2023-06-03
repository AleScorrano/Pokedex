import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Text(state.toString()),
                    const Divider(),
                    TextButton(
                        onPressed: () => refresh(context),
                        child: const Text("refresh")),
                    TextButton(
                        onPressed: () => newPage(context),
                        child: const Text("new page")),
                    TextButton(
                        onPressed: () {}, child: const Text("clean cache")),
                    const Divider(),
                    state is PokemonFetchedState
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(state.pokemons.length.toString()),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.pokemons.length,
                                  itemBuilder: (contex, index) => ListTile(
                                    leading: state.pokemons[index].image != null
                                        ? Image.memory(
                                            state.pokemons[index].image!)
                                        : Icon(Icons.error),
                                    title: Text(
                                        "${state.pokemons[index].id} : ${state.pokemons[index].name}"),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void refresh(BuildContext context) =>
      BlocProvider.of<PokemonBloc>(context).refreshData();

  void newPage(BuildContext context) =>
      BlocProvider.of<PokemonBloc>(context).moreData();
}
