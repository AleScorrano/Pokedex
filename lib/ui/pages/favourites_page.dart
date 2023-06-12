import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ui/widget/pokemon_card.dart';
import 'package:pokedex/ui/widget/search_field.dart';

class FavouritePage extends StatefulWidget {
  static const String route = "/favourite-page";
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<Pokemon> favourites = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listenableBuilder(),
    );
  }

  Widget _listenableBuilder() => ValueListenableBuilder(
        valueListenable: BlocProvider.of<PokemonBloc>(context).getFavourites(),
        builder: (context, Box<Pokemon> pokemonBox, _) {
          favourites = pokemonBox.values
              .where((pokemon) => pokemon.isFavourite)
              .toList();
          if (favourites.isEmpty) {
            return _noPokemonsBody();
          } else {
            return _body();
          }
        },
      );

  Widget _body() => CustomScrollView(
        slivers: [
          _appBar(),
          _pokemonsGrid(),
        ],
      );

  Widget _appBar() => SliverAppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 10,
        pinned: true,
        title: Text(
          "Favourites",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        bottom: favourites.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size(double.maxFinite, 60),
                child: SearchField(
                  controller: _searchController,
                ),
              )
            : null,
      );

  Widget _noPokemonsBody() => Scaffold(
        body: CustomScrollView(
          slivers: [
            _appBar(),
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/sad-pickachu.png",
                    width: 200,
                    color: Colors.amber.shade600,
                  ),
                  Center(
                    child: Text(
                      "No pokemons in favourites",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _pokemonsGrid() => SliverPadding(
        padding: const EdgeInsets.only(top: 10),
        sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: _searchResults().length,
              (context, index) => PokemonCard(
                pokemon: _searchResults()[index],
                scope: Scope.grid,
              ),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2)),
      );

  List<Pokemon> _searchResults() {
    final searchQuery = _searchController.text.trim();
    return favourites.where((pokemon) {
      final pokemonName = pokemon.name.toLowerCase();
      final pokemonId = pokemon.id.toString();
      return pokemonName.contains(searchQuery) || pokemonId == searchQuery;
    }).toList(growable: false);
  }
}
