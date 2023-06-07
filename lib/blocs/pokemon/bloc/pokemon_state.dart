part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => [];
}

class PokemonInitial extends PokemonState {}

class FetchingDataState extends PokemonState {}

class PokemonFetchedState extends PokemonState {
  final List<Pokemon> pokemons;
  const PokemonFetchedState({required this.pokemons});

  @override
  List<Object> get props => [pokemons];
}

class FetchingMoreDataState extends PokemonState {}

class RefreshingPokemonsState extends PokemonState {}

class ErrorPokemonState extends PokemonState {}

class NoMorePokemonsState extends PokemonState {}
