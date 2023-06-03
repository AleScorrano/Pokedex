import 'package:pokedex/dto/pokemon_stats_dto.dart';
import 'package:pokedex/mappers/mapper.dart';
import 'package:pokedex/models/pokemon_stats.dart';

class PokemonStatsMapper extends DTOMapper<PokemonStatsDTO, PokemonStats> {
  @override
  PokemonStats toModel(PokemonStatsDTO dto) => PokemonStats(
        hp: dto.hp,
        attack: dto.attack,
        defense: dto.defense,
        specialAttack: dto.specialAttack,
        specialDefense: dto.specialDefense,
        speed: dto.speed,
      );

  @override
  Map<String, dynamic> toTransferObject(PokemonStats model) {
    throw UnimplementedError();
  }
}
