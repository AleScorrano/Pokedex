import 'package:flutter/material.dart';

import 'package:pokedex/di/dependency_injector.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/ui/pages/favourites_page.dart';
import 'package:pokedex/ui/pages/home_page.dart';

class App extends StatelessWidget {
  final DatabaseService databaseService;

  const App({Key? key, required this.databaseService}) : super(key: key);

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
        onGenerateRoute: (settings) => _routeBuilder(settings),
        initialRoute: HomePage.route,
      ),
    );
  }

  PageRouteBuilder _routeBuilder(RouteSettings settings) => PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) {
          Widget page;
          switch (settings.name) {
            case HomePage.route:
              page = const HomePage();
              break;
            case FavouritePage.route:
              page = const FavouritePage();
              break;
            default:
              page = const HomePage();
          }

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: page,
          );
        },
      );
}
