import 'package:pokedex/dto/pokemon_dto.dart';
import 'package:pokedex/mappers/mapper.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_stats.dart';

class PokemonMapper extends DTOMapper<PokemonDTO, Pokemon> {
  @override
  Pokemon toModel(PokemonDTO dto) => Pokemon(
      id: dto.id,
      name: dto.name,
      height: dto.height,
      weight: dto.weight,
      stats: PokemonStats.toModel(dto.stats),
      abilities: dto.abilities,
      types: dto.types,
      isFavourite: false,
      image: null,
      ability: null);

  @override
  Map<String, dynamic> toTransferObject(Pokemon model) {
    throw UnimplementedError();
  }
}
