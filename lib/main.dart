import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sae_mobile/Views/profilView.dart';
import 'Views/Home/home.dart';
import 'Views/navigBottom.dart';
import 'Views/searchView.dart';
import 'Views/mapView.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: <RouteBase>[
      // #docregion configuration-builder
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return NavigBottom(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // The route branch for the first tab of the bottom navigation bar.
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the first tab of the
                // bottom navigation bar.
                path: '/home',
                builder: (BuildContext context, GoRouterState state) => Home(),
              ),
            ],
          ),
          // The route branch for the second tab of the bottom navigation bar.
          StatefulShellBranch(
            // It's not necessary to provide a navigatorKey if it isn't also
            // needed elsewhere. If not provided, a default key will be used.
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the second tab of the
                // bottom navigation bar.
                path: '/search',
                builder: (BuildContext context, GoRouterState state) => SearchView(),
              ),
            ],
          ),

          // The route branch for the third tab of the bottom navigation bar.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the third tab of the
                // bottom navigation bar.
                path: '/map',
                builder: (BuildContext context, GoRouterState state) => MapView(),
              ),
            ],
          ),
          StatefulShellBranch(
            // It's not necessary to provide a navigatorKey if it isn't also
            // needed elsewhere. If not provided, a default key will be used.
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the second tab of the
                // bottom navigation bar.
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
        primarySwatch: Colors.blue, // Couleur principale de l'application
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // Fond blanc pour la barre de navigation
          selectedItemColor: Colors.blue, // Couleur de l'icône sélectionnée
          unselectedItemColor: Colors.grey, // Couleur des icônes non sélectionnées
          elevation: 5, // Ajoute une légère ombre
        ),
        cardTheme: CardTheme(
          color: Colors.grey[600], // Fond des cartes en gris foncé
        ),
      ),
      routerConfig: _router,
    );
  }
}
