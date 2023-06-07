import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ui/widget/connection_banner.dart';
import 'package:pokedex/ui/widget/error_widget.dart';
import 'package:pokedex/ui/widget/loading_indicator.dart';
import 'package:pokedex/ui/widget/pokemon_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double appBarHeight;
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
            return const Center(
              child:
                  LoadingIndicator(message: "Download Pokemons...", size: 300),
            );
          } else if (state is PokemonFetchedState) {
            return _pokemonsfetchedBody(state.pokemons);
          } else if (state is ErrorPokemonState) {
            return MyErrorWidget(message: state.message ?? "General error");
          } else {
            return const SizedBox();
          }
        },
      );

  Widget _pokemonsfetchedBody(List<Pokemon> pokemons) =>
      BlocConsumer<PokemonBloc, PokemonState>(
        listener: (context, state) {
          _loadingToggle(state);
        },
        builder: (context, state) {
          return RefreshIndicator(
            color: Colors.transparent,
            onRefresh: () async => _refreshPokemons(),
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _pokemonslistController,
                  slivers: [
                    _appBar(),
                    SliverList.separated(
                      itemCount: pokemons.length + 1,
                      itemBuilder: (context, index) {
                        if (index == pokemons.length) {
                          return state is FetchingMoreDataState
                              ? const LoadingIndicator()
                              : const SizedBox();
                        } else if (index == 0) {
                          return state is RefreshingPokemonsState
                              ? const LoadingIndicator(
                                  message: "Updating all pokemons...")
                              : const SizedBox();
                        }
                        return PokemonCard(pokemon: pokemons[index - 1]);
                      },
                      separatorBuilder: (context, index) => index == 0
                          ? const SizedBox(
                              height: 28,
                            )
                          : _divider(),
                    ),
                  ],
                ),
                const ConnectionBanner(),
              ],
            ),
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

  Widget _divider() => Divider(
        indent: 100,
        endIndent: 10,
        color: Colors.grey.shade300,
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

  void _loadingToggle(PokemonState state) {
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

  void _refreshPokemons() =>
      BlocProvider.of<PokemonBloc>(context).refreshData();
}
