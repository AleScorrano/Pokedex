import 'dart:async';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pokedex/dto/pokemon_dto.dart';
import 'package:pokedex/errors/connection_state_error.dart';
import 'package:pokedex/errors/repository_error.dart';
import 'package:pokedex/exception/no_more_pokemon_exception.dart';
import 'package:pokedex/mappers/pokemon_mapper.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_response.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/network_service.dart';

class PokemonRepository {
  final PokemonMapper pokemonMapper;
  final NetworkService networkService;
  final DatabaseService databaseService;

  final int requestLimit;
  int lastOffset = 0;

  PokemonRepository({
    required this.pokemonMapper,
    required this.networkService,
    required this.databaseService,
    required this.requestLimit,
  });

//****************************************************************************
//****************************************************************************

  Future<List<Pokemon>> initializeData(
      {required ConnectivityResult connectionState}) async {
    try {
      final List<Pokemon> pokemonsInCache = databaseService.allPokemons();
      lastOffset = pokemonsInCache.length;
      if (pokemonsInCache.isEmpty) {
        if (connectionState == ConnectivityResult.none) {
          throw ConnectionStateError();
        }
        return await getDataFromApi();
      } else {
        return pokemonsInCache;
      }
    } on ConnectionStateError {
      rethrow;
    } catch (error) {
      throw RepositoryError(error.toString());
    }
  }

//****************************************************************************
//****************************************************************************

  Future<List<Pokemon>> getDataFromApi() async {
    try {
      if (lastOffset >= 1280) {
        throw NoMorePokemonsException();
      }
      final pokemonsList =
          await _getPokemonList(limit: requestLimit, offset: lastOffset);
      await _addPokemonsToCache(pokemonsList);
      lastOffset = databaseService.getLastDbIndex();
      return pokemonsList;
    } catch (error) {
      throw RepositoryError(error.toString());
    }
  }

//****************************************************************************
//****************************************************************************

  Future<List<Pokemon>> refreshData() async {
    List<Pokemon> refreshedList = [];

    try {
      List<Pokemon> initialList = databaseService.allPokemons();
      int startOffset = 0;
      while (startOffset < lastOffset) {
        await Future.delayed(const Duration(seconds: 1));
        List<Pokemon> pokemonsRequest =
            await _getPokemonList(limit: requestLimit, offset: startOffset);
        refreshedList.addAll(pokemonsRequest);
        startOffset = startOffset + requestLimit;
      }

      _keepInfavourites(
          originalList: initialList, refreshedList: refreshedList);

      await cleanCache();
      await _addPokemonsToCache(refreshedList);
      lastOffset = databaseService.getLastDbIndex();
      return refreshedList;
    } catch (error) {
      throw RepositoryError(error.toString());
    }
  }

//****************************************************************************
//****************************************************************************

  Future<List<Pokemon>> _getPokemonList(
      {required int limit, required int offset}) async {
    final PokemonResponse pokemonResponse =
        await networkService.getPokemonsURLList(limit: limit, offset: offset);
    List<Pokemon> pokemons =
        await Future.wait(pokemonResponse.results.map((mapPokemon) async {
      return await _pokemonBuilder(mapPokemon["url"]);
    }).toList(growable: false));

    return pokemons;
  }

//****************************************************************************
//****************************************************************************

  Future<Pokemon> _pokemonBuilder(String url) async {
    PokemonDTO pokemonDTO = await networkService.getPokemon(url: url);
    Pokemon pokemon = pokemonMapper.toModel(pokemonDTO);
    Uint8List? image = await networkService.getPokemonImage(pokemon.imageURL);
    String? ability = await networkService.getPokemonAbility(pokemon.id);
    return pokemon.copyWith(
      image: image,
      ability: ability,
    );
  }

//****************************************************************************
//****************************************************************************
  Future<void> _addPokemonsToCache(List<Pokemon> pokemons) async =>
      await Future.wait(pokemons
          .map((pokemon) async => await databaseService.addPokemon(pokemon)));

//****************************************************************************
//****************************************************************************

  Future<void> toggleFavourite(Pokemon pokemon) async =>
      databaseService.addPokemon(pokemon);

//****************************************************************************
//****************************************************************************

  void _keepInfavourites(
      {required List<Pokemon> originalList,
      required List<Pokemon> refreshedList}) {
    for (var pokemon in refreshedList) {
      if (originalList.elementAt(pokemon.id - 1).isFavourite) {
        refreshedList[pokemon.id - 1] = pokemon.copyWith(isFavourite: true);
      }
    }
  }

//****************************************************************************
//****************************************************************************

  ValueListenable<Box<Pokemon>> getFavourites() => databaseService.favourites();

  Future<void> cleanCache() async => await databaseService.deleteAll();
}
