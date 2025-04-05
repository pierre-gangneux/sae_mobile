import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'Model/authentification.dart';
import 'Views/connectionView.dart';
import 'Views/registerView.dart';
import 'Views/home.dart';
import 'Views/searchView.dart';
import 'Views/mapView.dart';
import 'Views/restaurantDetailView.dart';
import 'Views/navigBottom.dart';
import 'Views/Profil/profilView.dart';
import 'Views/Profil/favorisView.dart';
import 'Views/Profil/commentsView.dart';

import 'ViewModels/restaurantViewModel.dart';
import 'ViewModels/LikeViewModel.dart';
import 'ViewModels/cuisineViewModel.dart';
import 'database.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// Cle pour les branch pour essayer de régler une erreur de redirection
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'homeNav');
final GlobalKey<NavigatorState> _restaurantsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'restaurantsNav');
final GlobalKey<NavigatorState> _mapNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'mapNav');
final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profileNav');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  final db = await populateDatabase();

  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()..autoLogin(username)),
        ChangeNotifierProvider(create: (_) => RestaurantViewModel(db!)),
        ChangeNotifierProvider(
          create: (context) => LikeViewModel(
            db!,
            Provider.of<RestaurantViewModel>(context, listen: false).listeRestaux,
          ),
        ),
        ChangeNotifierProvider(create: (_) => CuisineViewModel(db!)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/register',
    redirect: (context, state) {
      final authState = Provider.of<AuthState>(context, listen: false);
      final isLoggingIn = state.matchedLocation == '/connexion';
      final isRegistering = state.matchedLocation == '/register';

      if (!authState.isSignedIn && !isLoggingIn && !isRegistering) {
        return '/register';
      }

      if (authState.isSignedIn && (isLoggingIn || isRegistering)) {
        return '/home';
      }

      return null;
    },

    errorPageBuilder: (context, state) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
      return MaterialPage(child: Home());
    },

    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            NavigBottom(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey, // Cle pour home
            routes: [
              GoRoute(path: '/home', builder: (context, state) => Home()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _restaurantsNavigatorKey, // Cle pour restaurant
            routes: [
              GoRoute(
                path: '/restaurants',
                builder: (context, state) => SearchView(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final restaurantId = state.pathParameters['id']!;
                      final viewModel = Provider.of<RestaurantViewModel>(context);
                      final restaurant = viewModel.getRestaurantById(restaurantId);
                      if (restaurant == null) {
                        return const Scaffold(
                          body: Center(child: Text('Restaurant non trouvé')),
                        );
                      }
                      return RestaurantDetailView(restaurant: restaurant);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _mapNavigatorKey, // Cle pour map
            routes: [
              GoRoute(path: '/map', builder: (context, state) => MapView()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey, // Cle pour profil
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilView(),
                routes: [
                  GoRoute(path: "favoris", builder: (context, state) => const FavorisView()),
                  GoRoute(path: "comments", builder: (context, state) => const CommentsView()),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/register', builder: (context, state) => const RegisterView()),
      GoRoute(path: '/connexion', builder: (context, state) => const ConnectionView()),
    ],
  );

  @override
  Widget build(BuildContext context) {
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
  }
}


