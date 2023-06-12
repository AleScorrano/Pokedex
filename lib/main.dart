import 'package:flutter/material.dart';
import 'package:pokedex/app.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService databaseService = DatabaseService();
  await databaseService.initialize();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  runApp(App(
    databaseService: databaseService,
  ));
}
