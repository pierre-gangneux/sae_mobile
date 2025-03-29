import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/profilView.dart';
import 'Views/home.dart';
import 'Views/navigBottom.dart';
import 'Views/restaurantDetailView.dart';
import 'Views/searchView.dart';
import 'Views/mapView.dart';
import 'ViewModels/restaurantViewModel.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionANav');


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RestaurantViewModel(),
      child: MyApp(),
    ),
  );
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
                path: '/restaurants',
                builder: (BuildContext context, GoRouterState state) => SearchView(),
                routes: [
                  GoRoute(
                      path: ':id', // Chemin enfant dynamique pour le détail du restaurant
                      builder: (BuildContext context, GoRouterState state) {
                        final String restaurantId = state.pathParameters['id']!;
                        // Récupérer l'objet Restaurant en fonction de l'ID via Provider
                        final restaurantViewModel = Provider.of<RestaurantViewModel>(context);
                        final restaurant = restaurantViewModel.getRestaurantById(restaurantId);

                        if (restaurant == null) {
                          return Scaffold(body: Center(child: Text('Restaurant non trouvé')));
                        }

                        // Passer l'objet Restaurant au widget RestaurantDetailView
                        return RestaurantDetailView(restaurant: restaurant);

                      },
                    ),
                  ],
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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // Fond bleu pour l'AppBar
          elevation: 0, // Tu peux ajuster l'élévation si nécessaire
          titleTextStyle: TextStyle(
            color: Colors.white, // Couleur du texte de l'AppBar
            fontSize: 20, // Taille de police du titre
          ),
        ),
      ),

      routerConfig: _router,
    );
  }
}

