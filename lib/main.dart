import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sae_mobile/Views/profilView.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';  // Assurez-vous que vous avez bien importé ce package
import 'Views/home.dart';
import 'Views/navigBottom.dart';
import 'Views/searchView.dart';
import 'Views/mapView.dart';
import 'package:path/path.dart';

import 'database.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de databaseFactory pour le Web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;  // Initialisation de databaseFactory pour le Web
  }

  // Appeler la fonction pour initialiser la base de données
  final database = await populateDatabase();

  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final Database? database;
  MyApp(this.database, {super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return NavigBottom(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) => Home(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/search',
                builder: (BuildContext context, GoRouterState state) => SearchView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/map',
                builder: (BuildContext context, GoRouterState state) => MapView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (BuildContext context, GoRouterState state) => ProfilView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          elevation: 5,
        ),
        cardTheme: CardTheme(
          color: Colors.grey[600],
        ),
      ),
      routerConfig: _router,
    );
  }
}




