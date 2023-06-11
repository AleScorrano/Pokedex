import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/models/pokemon_stats.dart';

part 'pokemon.g.dart';

@CopyWith()
@HiveType(typeId: 0)
class Pokemon extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int height;
  @HiveField(3)
  final int weight;
  @HiveField(4)
  final PokemonStats stats;
  @HiveField(5)
  final List<String> abilities;
  @HiveField(6)
  final List<String> types;
  @HiveField(7)
  final String imageURL;
  @HiveField(8)
  final bool isFavourite;
  @HiveField(9)
  final Uint8List? image;
  @HiveField(10)
  final String? ability;

  const Pokemon(
      {required this.id,
      required this.name,
      required this.height,
      required this.weight,
      required this.stats,
      required this.abilities,
      required this.isFavourite,
      required this.image,
      required this.types,
      required this.ability})
      : imageURL =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";

  @override
  List<Object?> get props => [
        id,
        name,
        height,
        weight,
        stats,
        abilities,
        types,
        isFavourite,
      ];
  Pokemon toggleFavourite() {
    return copyWith(isFavourite: !isFavourite);
  }
}
