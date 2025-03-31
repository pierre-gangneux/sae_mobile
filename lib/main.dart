import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/Profil/authentifiedView.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'Views/home.dart';
import 'package:sae_mobile/Views/Profil/connectionView.dart';
import 'package:sae_mobile/Views/Profil/profilView.dart';
import 'package:sae_mobile/Views/Profil/registerView.dart';
import 'Views/navigBottom.dart';
import 'Views/restaurantDetailView.dart';
import 'Views/searchView.dart';
import 'Views/mapView.dart';
import 'database.dart';
import 'ViewModels/restaurantViewModel.dart';

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

  runApp(
      ChangeNotifierProvider(
        create: (context) => RestaurantViewModel(database),
        child: MyApp(database),
      )
  );
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
                redirect: (BuildContext context, GoRouterState state) {
                  if (state.fullPath == '/profile') {
                    return '/profile/register';
                  }
                  return null;
                },
                routes: <RouteBase>[
                  ShellRoute(
                    builder: (BuildContext context, GoRouterState state, Widget child) {
                      return ProfilView(child: child);
                    },
                    routes: [
                      GoRoute(
                        path: "register",
                        builder: (BuildContext context, GoRouterState state) => RegisterView(),
                      ),
                      GoRoute(
                        path: "connection",
                        builder: (BuildContext context, GoRouterState state) => ConnectionView(),
                      ),
                      GoRoute(
                        path: "authentified",
                        builder: (BuildContext context, GoRouterState state) => AuthentifiedView(),
                      ),
                      GoRoute(
                        path: "favoris",
                        builder: (BuildContext context, GoRouterState state) => AuthentifiedView(),
                      ),
                      GoRoute(
                        path: "comments",
                        builder: (BuildContext context, GoRouterState state) => AuthentifiedView(),
                      )
                    ],
                  ),
                ],
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
