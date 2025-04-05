import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/Profil/commentsView.dart';
import 'package:sae_mobile/Views/Profil/favorisView.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'Model/Connexion/authentification.dart';
import 'ViewModels/connexionViewModel.dart';
import 'Views/connectionView.dart';
import 'ViewModels/LikeViewModel.dart';
import 'ViewModels/cuisineViewModel.dart';
import 'Views/home.dart';
import 'package:sae_mobile/Views/Profil/profilView.dart';
import 'Views/navigBottom.dart';
import 'Views/registerView.dart';
import 'Views/restaurantDetailView.dart';
import 'Views/searchView.dart';
import 'Views/mapView.dart';
import 'database.dart';
import 'ViewModels/restaurantViewModel.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de databaseFactory pour le Web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; // Initialisation de databaseFactory pour le Web
  }

  // Initialisation de SharedPreferences et vérification de l'état de connexion
  final authState = AuthState();
  await authState.checkLoginStatus(); // Assurez-vous que l'authState est initialisé avant de l'utiliser.

  final database = await populateDatabase();

  runApp(MyApp(database: database, authState: authState)); // Passe authState comme paramètre au lieu de l'initialiser ici
}

class MyApp extends StatelessWidget {
  final Database? database;
  final AuthState authState;

  MyApp({super.key, required this.database, required this.authState});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authState.checkLoginStatus(), // Attendre la vérification du statut de connexion
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement pendant l'initialisation
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final GoRouter _router = GoRouter(
          navigatorKey: _rootNavigatorKey,
          initialLocation: authState.isSignedIn ? '/home' : '/register', // Redirige selon l'état de connexion
          redirect: (BuildContext context, GoRouterState state) {
            final authState = Provider.of<AuthState>(context, listen: false);

            // Vérifie si l'utilisateur essaye de tricher
            final isLoggingIn = state.matchedLocation == '/connexion';
            final isRegistering = state.matchedLocation == '/register';

            // Si l'utilisateur n'est pas connecté, on autorise la connexion ou l'inscription
            if (!authState.isSignedIn) {
              // Autorise l'accès aux pages de connexion et d'inscription
              if (isLoggingIn || isRegistering) {
                return null;
              }
              return '/register'; // Renvoie vers /register si non connecté
            }

            // Sinon, c'est bon, on laisse l'utilisateur continuer
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
                      builder: (BuildContext context, GoRouterState state) =>
                          SearchView(),
                      routes: [
                        GoRoute(
                          path: ':id',
                          builder: (BuildContext context, GoRouterState state) {
                            final String restaurantId = state.pathParameters['id']!;
                            // Récupérer l'objet Restaurant en fonction de l'ID via Provider
                            final restaurantViewModel =
                            Provider.of<RestaurantViewModel>(context);
                            final restaurant =
                            restaurantViewModel.getRestaurantById(restaurantId);

                            if (restaurant == null) {
                              return Scaffold(
                                  body: Center(child: Text('Restaurant non trouvé')));
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
                      builder: (BuildContext context, GoRouterState state) =>
                          ProfilView(),
                      routes: <RouteBase>[
                        GoRoute(
                          path: "favoris",
                          builder: (BuildContext context, GoRouterState state) =>
                              FavorisView(),
                        ),
                        GoRoute(
                          path: "comments",
                          builder: (BuildContext context, GoRouterState state) =>
                              CommentsView(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Route pour la page d'inscription
            GoRoute(
              path: '/register',
              builder: (BuildContext context, GoRouterState state) =>
              const RegisterView(),
            ),
            // Route pour la page de connexion
            GoRoute(
              path: '/connexion',
              builder: (BuildContext context, GoRouterState state) =>
              const ConnectionView(),
            ),
          ],
          // Tentative de garder les URLs correctes
          errorPageBuilder: (context, state) {
            // Redirection vers la page d'accueil avec l'URL correcte
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/home');
            });

            // Retourner une page avec la structure de base et la barre de navigation
            return MaterialPage(
              child: Scaffold(
                body: Home(), // Affiche la page d'accueil
              ),
            );
          },
        );

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => authState), // Utilisation de l'authState passé
            ChangeNotifierProvider(create: (context) => RestaurantViewModel(database!)),
            ChangeNotifierProvider(create: (_) {
              LikeViewModel likeViewModel =
              LikeViewModel(database!, Provider.of<RestaurantViewModel>(context).restauRep);
              return likeViewModel;
            }),
            ChangeNotifierProvider(create: (_) {
              CuisineViewModel cuisineViewModel = CuisineViewModel(database!);
              return cuisineViewModel;
            }),
            ChangeNotifierProvider(create: (_) {
              ConnexionViewModel connexionViewModel = ConnexionViewModel();
              return connexionViewModel;
            }),
          ],
          child: Consumer<RestaurantViewModel>(builder: (context, restaurantViewModel, child) {
            return MaterialApp.router(
              title: 'SAE Mobile',
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
          }),
        );
      },
    );
  }
}
