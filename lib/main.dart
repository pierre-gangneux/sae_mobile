import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/Profil/commentsView.dart';
import 'package:sae_mobile/Views/Profil/favorisView.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'Model/authentification.dart';
import 'Views/connectionView.dart';
import 'ViewModels/LikeViewModel.dart';
import 'Views/home.dart';
import 'package:sae_mobile/Views/Profil/profilView.dart';
import 'Views/navigBottom.dart';
import 'Views/registerView.dart';
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

  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final Database? database;

  MyApp(this.database, {super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/register', // Route initiale
    redirect: (BuildContext context, GoRouterState state) {
      final authState = Provider.of<AuthState>(context, listen: false);

      // Vérifie si l'utilisateur essaye de tricher
      final isLoggingIn = state.matchedLocation == '/connexion';
      final isRegistering = state.matchedLocation == '/register';

      // Si l'utilisateur essaye de tricher
      if (!authState.isSignedIn) {
        // A le droit d'aller sur /connexion ou /register
        if (isLoggingIn || isRegistering) {
          return null;
        }
        return '/register'; // Renvoie vers /register
      }

      // Sinon c'est bon
      return null;
    },
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
                    path: ':id',
                    builder: (BuildContext context, GoRouterState state) {
                      final String restaurantId = state.pathParameters['id']!;
                      final restaurantViewModel = Provider.of<RestaurantViewModel>(context);
                      final restaurant = restaurantViewModel.getRestaurantById(restaurantId);

                      if (restaurant == null) {
                        return Scaffold(body: Center(child: Text('Restaurant non trouvé')));
                      }

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
                builder: (BuildContext context, GoRouterState state) => ProfilView(),
                routes: <RouteBase>[
                  GoRoute(
                    path: "favoris",
                    builder: (BuildContext context, GoRouterState state) => FavorisView(),
                  ),
                  GoRoute(
                    path: "comments",
                    builder: (BuildContext context, GoRouterState state) => CommentsView(),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) => const RegisterView(),
      ),
      GoRoute(
        path: '/connexion',
        builder: (BuildContext context, GoRouterState state) => const ConnectionView(),
      ),
    ],
  );


  @override
  Widget build(BuildContext context) {
    RestaurantViewModel restaurantViewModel = RestaurantViewModel(database!);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthState()),
        ChangeNotifierProvider(create: (context) => restaurantViewModel),
        ChangeNotifierProvider(
            create: (_) {
              LikeViewModel likeViewModel = LikeViewModel(
                  database!, restaurantViewModel.listeRestaux);
              return likeViewModel;
            })
      ],
      child: Consumer<RestaurantViewModel>(
        builder: (context, restaurantViewModel, child) {
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
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                elevation: 0,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
