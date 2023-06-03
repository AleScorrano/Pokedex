import 'package:pokedex/models/pokemon.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/models/pokemon_stats.dart';

class DatabaseService {
  static String pokemonsBoxPath = "pokemons";
  late Box<Pokemon> _pokemonBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PokemonAdapter());
    Hive.registerAdapter(PokemonStatsAdapter());
    await Hive.openBox<Pokemon>(pokemonsBoxPath);
    _pokemonBox = Hive.box<Pokemon>(pokemonsBoxPath);
  }

  List<Pokemon> allPokemons() => _pokemonBox.values.toList();

  Future<void> addPokemon(Pokemon pokemon) async =>
      _pokemonBox.put(pokemon.id, pokemon);

  int getLastDbIndex() => _pokemonBox.values.length;

  Future<void> deleteAll() async => await _pokemonBox.clear();

  Future<void> closeDatabase() => Hive.close();
}
