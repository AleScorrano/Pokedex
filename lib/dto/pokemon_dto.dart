import 'package:equatable/equatable.dart';
import 'package:pokedex/dto/pokemon_stats_dto.dart';

class PokemonDTO extends Equatable {
  final int id;
  final String name;
  final int height;
  final int weight;
  final PokemonStatsDTO stats;
  final List<String> abilities;
  final List<String> types;

  const PokemonDTO({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.types,
  });

  factory PokemonDTO.fromJson(Map<String, dynamic> data) => PokemonDTO(
        id: data["id"],
        name: data["name"],
        height: data["height"],
        weight: data["weight"],
        stats: PokemonStatsDTO.fromJson(data["stats"], data["id"]),
        abilities: (data["abilities"] as List)
            .map((type) => type["ability"]["name"] as String)
            .toList(),
        types: (data["types"] as List)
            .map((type) => type["type"]["name"] as String)
            .toList(),
      );

  @override
  List<Object?> get props => [
        id,
        name,
        weight,
        stats,
        abilities,
      ];
}
