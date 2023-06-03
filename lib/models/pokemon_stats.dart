import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/dto/pokemon_stats_dto.dart';

part "pokemon_stats.g.dart";

@HiveType(typeId: 1)
class PokemonStats extends Equatable {
  @HiveField(0)
  final int hp;
  @HiveField(1)
  final int attack;
  @HiveField(2)
  final int defense;
  @HiveField(3)
  final int specialAttack;
  @HiveField(4)
  final int specialDefense;
  @HiveField(5)
  final int speed;

  const PokemonStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  factory PokemonStats.toModel(PokemonStatsDTO data) => PokemonStats(
        hp: data.hp,
        attack: data.attack,
        defense: data.defense,
        specialAttack: data.specialAttack,
        specialDefense: data.specialDefense,
        speed: data.speed,
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
