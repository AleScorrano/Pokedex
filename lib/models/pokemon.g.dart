// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PokemonCWProxy {
  Pokemon id(int id);

  Pokemon name(String name);

  Pokemon height(int height);

  Pokemon weight(int weight);

  Pokemon stats(PokemonStats stats);

  Pokemon abilities(List<String> abilities);

  Pokemon isFavourite(bool isFavourite);

  Pokemon image(Uint8List? image);

  Pokemon types(List<String> types);

  Pokemon ability(String? ability);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Pokemon(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Pokemon(...).copyWith(id: 12, name: "My name")
  /// ````
  Pokemon call({
    int? id,
    String? name,
    int? height,
    int? weight,
    PokemonStats? stats,
    List<String>? abilities,
    bool? isFavourite,
    Uint8List? image,
    List<String>? types,
    String? ability,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPokemon.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPokemon.copyWith.fieldName(...)`
class _$PokemonCWProxyImpl implements _$PokemonCWProxy {
  const _$PokemonCWProxyImpl(this._value);

  final Pokemon _value;

  @override
  Pokemon id(int id) => this(id: id);

  @override
  Pokemon name(String name) => this(name: name);

  @override
  Pokemon height(int height) => this(height: height);

  @override
  Pokemon weight(int weight) => this(weight: weight);

  @override
  Pokemon stats(PokemonStats stats) => this(stats: stats);

  @override
  Pokemon abilities(List<String> abilities) => this(abilities: abilities);

  @override
  Pokemon isFavourite(bool isFavourite) => this(isFavourite: isFavourite);

  @override
  Pokemon image(Uint8List? image) => this(image: image);

  @override
  Pokemon types(List<String> types) => this(types: types);

  @override
  Pokemon ability(String? ability) => this(ability: ability);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Pokemon(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Pokemon(...).copyWith(id: 12, name: "My name")
  /// ````
  Pokemon call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? height = const $CopyWithPlaceholder(),
    Object? weight = const $CopyWithPlaceholder(),
    Object? stats = const $CopyWithPlaceholder(),
    Object? abilities = const $CopyWithPlaceholder(),
    Object? isFavourite = const $CopyWithPlaceholder(),
    Object? image = const $CopyWithPlaceholder(),
    Object? types = const $CopyWithPlaceholder(),
    Object? ability = const $CopyWithPlaceholder(),
  }) {
    return Pokemon(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      height: height == const $CopyWithPlaceholder() || height == null
          ? _value.height
          // ignore: cast_nullable_to_non_nullable
          : height as int,
      weight: weight == const $CopyWithPlaceholder() || weight == null
          ? _value.weight
          // ignore: cast_nullable_to_non_nullable
          : weight as int,
      stats: stats == const $CopyWithPlaceholder() || stats == null
          ? _value.stats
          // ignore: cast_nullable_to_non_nullable
          : stats as PokemonStats,
      abilities: abilities == const $CopyWithPlaceholder() || abilities == null
          ? _value.abilities
          // ignore: cast_nullable_to_non_nullable
          : abilities as List<String>,
      isFavourite:
          isFavourite == const $CopyWithPlaceholder() || isFavourite == null
              ? _value.isFavourite
              // ignore: cast_nullable_to_non_nullable
              : isFavourite as bool,
      image: image == const $CopyWithPlaceholder()
          ? _value.image
          // ignore: cast_nullable_to_non_nullable
          : image as Uint8List?,
      types: types == const $CopyWithPlaceholder() || types == null
          ? _value.types
          // ignore: cast_nullable_to_non_nullable
          : types as List<String>,
      ability: ability == const $CopyWithPlaceholder()
          ? _value.ability
          // ignore: cast_nullable_to_non_nullable
          : ability as String?,
    );
  }
}

extension $PokemonCopyWith on Pokemon {
  /// Returns a callable class that can be used as follows: `instanceOfPokemon.copyWith(...)` or like so:`instanceOfPokemon.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PokemonCWProxy get copyWith => _$PokemonCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonAdapter extends TypeAdapter<Pokemon> {
  @override
  final int typeId = 0;

  @override
  Pokemon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pokemon(
      id: fields[0] as int,
      name: fields[1] as String,
      height: fields[2] as int,
      weight: fields[3] as int,
      stats: fields[4] as PokemonStats,
      abilities: (fields[5] as List).cast<String>(),
      isFavourite: fields[8] as bool,
      image: fields[9] as Uint8List?,
      types: (fields[6] as List).cast<String>(),
      ability: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Pokemon obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.stats)
      ..writeByte(5)
      ..write(obj.abilities)
      ..writeByte(6)
      ..write(obj.types)
      ..writeByte(7)
      ..write(obj.imageURL)
      ..writeByte(8)
      ..write(obj.isFavourite)
      ..writeByte(9)
      ..write(obj.image)
      ..writeByte(10)
      ..write(obj.ability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
