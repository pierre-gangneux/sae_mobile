import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/Profil/avisView.dart';
import 'package:sae_mobile/Views/Profil/favorisView.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'ViewModels/avisViewModel.dart';
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

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web-only: initialisation de databaseFactory
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // AuthState et base de données
  final authState = AuthState();
  final database = await populateDatabase();

  runApp(MyApp( database:database, authState:authState));
}

class MyApp extends StatelessWidget {
  final Database? database;
  final AuthState authState;

  MyApp({super.key, required this.database, required this.authState});

  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: authState.isSignedIn ? '/home' : '/register',
    redirect: (BuildContext context, GoRouterState state) {
      final authState = Provider.of<AuthState>(context, listen: false);
      final isLoggingIn = state.matchedLocation == '/connexion';
      final isRegistering = state.matchedLocation == '/register';

      if (!authState.isSignedIn) {
        if (isLoggingIn || isRegistering) return null;
        return '/register';
      }

      return null;
    },
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => NavigBottom(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                builder: (context, state) => Home(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/restaurants',
                builder: (context, state) => SearchView(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final restaurantId = state.pathParameters['id']!;
                      final restaurantVM = Provider.of<RestaurantViewModel>(context, listen: false);
                      final restaurant = restaurantVM.getRestaurantById(restaurantId);

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
                builder: (context, state) => MapView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (context, state) => ProfilView(),
                routes: [
                  GoRoute(
                    path: 'favoris',
                    builder: (context, state) => FavorisView(),
                  ),
                  GoRoute(
                    path: 'avis',
                    builder: (context, state) => AvisView(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/connexion',
        builder: (context, state) => const ConnectionView(),
      ),
    ],
    errorPageBuilder: (context, state) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
      return MaterialPage(
        child: Scaffold(
          body: Home(),
        ),
      );
    },
  );



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authState.checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }


        RestaurantViewModel restaurantViewModel = RestaurantViewModel(database!);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => authState),
            ChangeNotifierProvider(create: (context) => restaurantViewModel),
            ChangeNotifierProvider(create: (context) => AvisViewModel(database!)),
            ChangeNotifierProvider(
                create: (context) {
                  LikeViewModel likeViewModel = LikeViewModel(database!, restaurantViewModel.restauRep);
                  return likeViewModel;
                }
            ),

            ChangeNotifierProvider(create: (context) => CuisineViewModel(database!)),
            ChangeNotifierProvider(create: (context) => ConnexionViewModel()),
          ],
          child: Consumer<RestaurantViewModel>(
            builder: (context, restaurantViewModel, child) {
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
                  cardTheme: CardTheme(color: Colors.grey[600]),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                routerConfig: _router,
              );
            },
          ),
        );
      },
    );
  }
}
