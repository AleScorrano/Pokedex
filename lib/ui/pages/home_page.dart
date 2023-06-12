import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ui/pages/favourites_page.dart';
import 'package:pokedex/ui/widget/connection_banner.dart';
import 'package:pokedex/ui/widget/error_widget.dart';
import 'package:pokedex/ui/widget/loading_indicator.dart';
import 'package:pokedex/ui/widget/pokemon_card.dart';
import 'package:pokedex/ui/widget/search_field.dart';

class HomePage extends StatefulWidget {
  static const String route = "/home-page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double appBarHeight;
  final ScrollController _pokemonslistController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Pokemon> _pokemons = [];
  bool _isLoading = false;
  bool _isSearching = false;
  @override
  void initState() {
    _pokemonslistController.addListener(
      () {
        if (!_isLoading &&
            !_isSearching &&
            _pokemonslistController.position.maxScrollExtent ==
                _pokemonslistController.offset) {
          _fetchMorePokemons();
          _pokemonslistController
              .jumpTo(_pokemonslistController.position.maxScrollExtent);
        }
      },
    );

    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isEmpty) {
          _isSearching = false;
        } else {
          _isSearching = true;
        }
      });
    });

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
            _pokemons = state.pokemons;
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
                    _pokemonList(_searchResults(), state),
                  ],
                ),
                const ConnectionBanner(),
              ],
            ),
          );
        },
      );

  Widget _pokemonList(List<Pokemon> pokemons, PokemonState state) =>
      pokemons.isEmpty
          ? const SliverToBoxAdapter(child: Center(child: Text("No Pokemons")))
          : SliverPadding(
              padding: const EdgeInsets.only(top: 10),
              sliver: SliverList.builder(
                itemCount: _isSearching ? pokemons.length : pokemons.length + 1,
                itemBuilder: (context, index) {
                  if (index == pokemons.length && !_isSearching) {
                    return state is FetchingMoreDataState
                        ? const LoadingIndicator()
                        : const SizedBox();
                  } else if (index == 0 && !_isSearching) {
                    return state is RefreshingPokemonsState
                        ? const LoadingIndicator(
                            message: "Updating all pokemons...")
                        : const SizedBox();
                  }
                  return PokemonCard(
                    pokemon: pokemons[!_isSearching ? index - 1 : index],
                    scope: Scope.list,
                  );
                },
              ),
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
            onPressed: () => Navigator.pushNamed(context, FavouritePage.route),
            icon: Icon(
              CupertinoIcons.star_fill,
              color: Colors.amber.shade700,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.maxFinite, 60),
          child: SearchField(controller: _searchController),
        ),
      );

  void _loadingToggle(PokemonState state) {
    if (state is FetchingMoreDataState) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is PokemonFetchedState) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Pokemon> _searchResults() {
    final searchQuery = _searchController.text.trim();
    return _pokemons.where((pokemon) {
      final pokemonName = pokemon.name.toLowerCase();
      final pokemonId = pokemon.id.toString();
      return pokemonName.contains(searchQuery) || pokemonId == searchQuery;
    }).toList(growable: false);
  }

  void _fetchMorePokemons() => BlocProvider.of<PokemonBloc>(context).moreData();

  void _refreshPokemons() =>
      BlocProvider.of<PokemonBloc>(context).refreshData();
}
