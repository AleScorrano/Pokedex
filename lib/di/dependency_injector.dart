import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/blocs/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/mappers/pokemon_mapper.dart';
import 'package:pokedex/mappers/pokemon_stats_mapper.dart';
import 'package:pokedex/repositories/pokemon_repository.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/network_service.dart';
import 'package:provider/provider.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;
  final DatabaseService databaseService;
  const DependencyInjector(
      {super.key, required this.child, required this.databaseService});

  @override
  Widget build(BuildContext context) => _providers(
        child: _mappers(
          child: _repositories(
            child: _blocs(child: child),
          ),
        ),
      );

  Widget _blocs({required Widget child}) => MultiBlocProvider(
        providers: [
          BlocProvider<PokemonBloc>(
            create: (context) => PokemonBloc(
              pokemonRepository: context.read(),
            )..fetchInitialData(),
          ),
        ],
        child: child,
      );

  Widget _providers({required Widget child}) => MultiProvider(
        providers: [
          Provider<NetworkService>(
            create: (_) => NetworkService(),
          ),
          Provider<DatabaseService>(
            create: (_) => databaseService,
          ),
        ],
        child: child,
      );

  Widget _repositories({required Widget child}) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<PokemonRepository>(
            create: (context) => PokemonRepository(
                pokemonMapper: context.read(),
                networkService: context.read(),
                databaseService: context.read(),
                requestLimit: 50),
          ),
        ],
        child: child,
      );
  Widget _mappers({required Widget child}) => MultiProvider(
        providers: [
          Provider<PokemonStatsMapper>(
            create: (_) => PokemonStatsMapper(),
          ),
          Provider<PokemonMapper>(
            create: (context) => PokemonMapper(),
          )
        ],
        child: child,
      );

  Future<DatabaseService> _initializeDatabaseService() async {
    final databaseService = DatabaseService();
    await databaseService.initialize();
    return databaseService;
  }
}
