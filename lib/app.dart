import 'package:flutter/material.dart';
import 'package:pokedex/di/dependency_injector.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/ui/pages/home_page.dart';

class App extends StatelessWidget {
  final DatabaseService databaseService;
  const App({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      databaseService: databaseService,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
