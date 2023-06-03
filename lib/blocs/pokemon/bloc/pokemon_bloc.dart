import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/repositories/pokemon_repository.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository pokemonRepository;
  List<Pokemon> pokemons = [];
  PokemonBloc({
    required this.pokemonRepository,
  }) : super(PokemonInitial()) {
    on<FetchInitialDataEvent>(_fetchInitialData);
    on<FetchMorePokemonEvent>(_getMoreData);
    on<RefreshDataEvent>(_refreshData);
  }

//****************************************************************************
//****************************************************************************

  FutureOr<void> _fetchInitialData(
      FetchInitialDataEvent event, Emitter<PokemonState> emit) async {
    try {
      emit(FetchingDataState());
      final pokemonsResult = await pokemonRepository.initializeData();
      pokemons.addAll(pokemonsResult);
      emit(PokemonFetchedState(pokemons: pokemons));
    } catch (error) {
      emit(ErrorPokemonState());
    }
  }

//****************************************************************************
//****************************************************************************

  FutureOr<void> _getMoreData(
      FetchMorePokemonEvent event, Emitter<PokemonState> emit) async {
    try {
      emit(FetchingMoreDataState());
      final pokemonsResult = await pokemonRepository.getDataFromApi();
      pokemons.addAll(pokemonsResult);
      emit(PokemonFetchedState(pokemons: pokemons));
    } catch (error) {
      emit(ErrorPokemonState());
    }
  }

//****************************************************************************
//****************************************************************************

  FutureOr<void> _refreshData(
      RefreshDataEvent event, Emitter<PokemonState> emit) async {
    try {
      emit(RefreshPokemonsState());
      final pokemonResults = await pokemonRepository.refreshData();
      pokemons.clear();
      pokemons.addAll(pokemonResults);
      emit(PokemonFetchedState(pokemons: pokemons));
    } catch (error) {
      emit(ErrorPokemonState());
    }
  }

//****************************************************************************
//****************************************************************************

  void fetchInitialData() => add(FetchInitialDataEvent());
  void moreData() => add(FetchMorePokemonEvent());
  void refreshData() => add(RefreshDataEvent());
}
