part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();
  @override
  List<Object> get props => [];
}

class FetchInitialDataEvent extends PokemonEvent {}

class FetchMorePokemonEvent extends PokemonEvent {}

class RefreshDataEvent extends PokemonEvent {}
