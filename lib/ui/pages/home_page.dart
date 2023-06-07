import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ui/widget/pokemon_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _pokemonslistController = ScrollController();
  bool isLoading = false;
  @override
  void initState() {
    _pokemonslistController.addListener(
      () {
        if (!isLoading &&
            _pokemonslistController.position.maxScrollExtent ==
                _pokemonslistController.offset) {
          _fetchMorePokemons();
          _pokemonslistController
              .jumpTo(_pokemonslistController.position.maxScrollExtent);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => BlocProvider.of<PokemonBloc>(context).deleteAll()),
      body: _body(),
    );
  }

  Widget _body() => BlocBuilder<PokemonBloc, PokemonState>(
        buildWhen: (previous, current) {
          return current is PokemonFetchedState ||
              current is ErrorPokemonState ||
              current is FetchingDataState;
        },
        builder: (context, state) {
          if (state is FetchingDataState) {
            return _loadingWidget();
          } else if (state is PokemonFetchedState) {
            return _pokemonsList(state.pokemons);
          } else {
            return const SizedBox();
          }
        },
      );

  Widget _pokemonsList(List<Pokemon> pokemons) =>
      BlocConsumer<PokemonBloc, PokemonState>(
        listener: (context, state) {
          _updateLoadingInfo(state);
        },
        builder: (context, state) {
          return CustomScrollView(
            controller: _pokemonslistController,
            slivers: [
              _appBar(),
              SliverList.builder(
                itemCount: pokemons.length + 1,
                itemBuilder: (context, index) {
                  if (index == pokemons.length) {
                    return state is FetchingMoreDataState
                        ? _loadingWidget()
                        : const SizedBox();
                  } else if (index == 0) {
                    return state is RefreshingPokemonsState
                        ? _loadingWidget()
                        : const SizedBox();
                  }
                  return PokemonCard(pokemon: pokemons[index]);
                },
              )
            ],
          );
        },
      );

  Widget _appBar() => SliverAppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 10,
        pinned: true,
        title: Text(
          "Pokemons",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.moon_fill,
              color: Colors.amber.shade700,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.star_fill,
              color: Colors.amber.shade700,
            ),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size(double.maxFinite, 40),
            child: _textField()),
      );

  Widget _loadingWidget() => Column(
        children: [
          Center(
            child: Image.asset(
              "assets/images/loading-pokeball.gif",
              color: Colors.grey.shade400,
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 20),
        ],
      );

  Widget _divider(BuildContext context) => const Divider(
        height: 1,
        color: Colors.transparent,
      );

  Widget _textField() => Container(
        height: 40,
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(CupertinoIcons.search),
            hintText: "Cerca per nome o numero...",
            hintStyle: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Colors.grey.shade600),
            border: InputBorder.none,
          ),
        ),
      );

  void _updateLoadingInfo(PokemonState state) {
    if (state is FetchingMoreDataState) {
      setState(() {
        isLoading = true;
      });
    } else if (state is PokemonFetchedState) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _fetchMorePokemons() => BlocProvider.of<PokemonBloc>(context).moreData();
}
