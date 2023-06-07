import 'dart:async';
import 'dart:typed_data';
import 'package:pokedex/dto/pokemon_dto.dart';
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

  Future<List<Pokemon>> initializeData() async {
    final List<Pokemon> pokemonsInCache = databaseService.allPokemons();
    lastOffset = pokemonsInCache.length;

    if (pokemonsInCache.isEmpty) {
      return await getDataFromApi();
    } else {
      return pokemonsInCache;
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
    List<Pokemon> pokemonsList = [];
    try {
      int startOffset = 0;
      while (startOffset < lastOffset) {
        await Future.delayed(const Duration(seconds: 1));
        List<Pokemon> pokemonsRequest =
            await _getPokemonList(limit: requestLimit, offset: startOffset);
        pokemonsList.addAll(pokemonsRequest);
        startOffset = startOffset + requestLimit;
      }
      await cleanCache();
      await _addPokemonsToCache(pokemonsList);
      lastOffset = databaseService.getLastDbIndex();
      return pokemonsList;
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
    return pokemon.copyWith(image: image);
  }

//****************************************************************************
//****************************************************************************
  Future<void> _addPokemonsToCache(List<Pokemon> pokemons) async =>
      await Future.wait(pokemons
          .map((pokemon) async => await databaseService.addPokemon(pokemon)));

//****************************************************************************
//****************************************************************************

  Future<void> cleanCache() async => await databaseService.deleteAll();
}
