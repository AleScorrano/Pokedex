import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pokedex/errors/connection_state_error.dart';
import 'package:pokedex/exception/no_more_pokemon_exception.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/repositories/pokemon_repository.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository pokemonRepository;
  final Stream<ConnectivityResult> connectionStateStream =
      Connectivity().onConnectivityChanged;

  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  ConnectivityResult? connectionState;
  List<Pokemon> pokemons = [];
  PokemonBloc({
    required this.pokemonRepository,
  }) : super(PokemonInitial()) {
    on<FetchInitialDataEvent>(_fetchInitialData);
    on<FetchMorePokemonEvent>(_getMoreData);
    on<RefreshDataEvent>(_refreshData);
    on<ToggleFavoriteEvent>(_toggleFavorite);

    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((currentConnectionState) {
      connectionState = currentConnectionState;
    });
  }

//****************************************************************************
//****************************************************************************

  FutureOr<void> _fetchInitialData(
      FetchInitialDataEvent event, Emitter<PokemonState> emit) async {
    try {
      emit(FetchingDataState());
      final connectivityResult = await (Connectivity().checkConnectivity());
      final pokemonsResult = await pokemonRepository.initializeData(
          connectionState: connectivityResult);
      pokemons.addAll(pokemonsResult);
      emit(PokemonFetchedState(pokemons: pokemons));
    } on ConnectionStateError catch (_) {
      emit(const ErrorPokemonState(message: "No connection"));
    } catch (error) {
      emit(const ErrorPokemonState());
    }
  }

//****************************************************************************
//****************************************************************************

  FutureOr<void> _getMoreData(
      FetchMorePokemonEvent event, Emitter<PokemonState> emit) async {
    try {
      if (state is FetchingMoreDataState ||
          connectionState == ConnectivityResult.none) {
        return;
      }
      emit(FetchingMoreDataState());
      final pokemonsResult = await pokemonRepository.getDataFromApi();
      pokemons.addAll(pokemonsResult);
      emit(PokemonFetchedState(pokemons: pokemons));
    } on NoMorePokemonsException {
      emit(NoMorePokemonsState());
    } catch (error) {
      emit(const ErrorPokemonState());
    }
  }

//****************************************************************************
//****************************************************************************

  FutureOr<void> _refreshData(
      RefreshDataEvent event, Emitter<PokemonState> emit) async {
    try {
      if (connectionState == ConnectivityResult.none) {
        return;
      }
      emit(RefreshingPokemonsState());
      final pokemonResults = await pokemonRepository.refreshData();
      pokemons.clear();
      pokemons.addAll(pokemonResults);
      emit(PokemonFetchedState(pokemons: pokemons));
    } catch (error) {
      emit(const ErrorPokemonState());
    }
  }

//****************************************************************************
//****************************************************************************

  FutureOr<void> _toggleFavorite(
      ToggleFavoriteEvent event, Emitter<PokemonState> emit) async {
    final updatedPokemons = List<Pokemon>.from(pokemons);

    final index =
        updatedPokemons.indexWhere((item) => item.id == event.pokemon.id);
    if (index != -1) {
      final pokemonToToggle = updatedPokemons[index];
      final updatedPokemon = pokemonToToggle.toggleFavourite();
      updatedPokemons[index] = updatedPokemon;
      await pokemonRepository.toggleFavourite(updatedPokemon);
      pokemons = updatedPokemons;
    }
    emit(PokemonFetchedState(pokemons: pokemons));
  }

//****************************************************************************
//****************************************************************************

  void fetchInitialData() => add(FetchInitialDataEvent());
  void moreData() => add(FetchMorePokemonEvent());
  void refreshData() => add(RefreshDataEvent());
  void toggleFavourite(Pokemon pokemon) =>
      add(ToggleFavoriteEvent(pokemon: pokemon));
  ValueListenable<Box<Pokemon>> getFavourites() =>
      pokemonRepository.getFavourites();
}
