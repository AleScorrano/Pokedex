import 'package:flutter/material.dart';
import 'package:pokedex/app.dart';
import 'package:pokedex/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService databaseService = DatabaseService();
  await databaseService.initialize();

  runApp(App(
    databaseService: databaseService,
  ));
}
