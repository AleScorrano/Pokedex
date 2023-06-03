import 'package:equatable/equatable.dart';

class PokemonStatsDTO extends Equatable {
  final int pokemonId;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;

  const PokemonStatsDTO({
    required this.pokemonId,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  factory PokemonStatsDTO.fromJson(List<dynamic> data, int pokemonId) =>
      PokemonStatsDTO(
        pokemonId: pokemonId,
        hp: data[0]["base_stat"],
        attack: data[1]["base_stat"],
        defense: data[2]["base_stat"],
        specialAttack: data[3]["base_stat"],
        specialDefense: data[4]["base_stat"],
        speed: data[5]["base_stat"],
      );

  @override
  List<Object?> get props => [
        hp,
        attack,
        defense,
        specialAttack,
        specialDefense,
        speed,
      ];
}
