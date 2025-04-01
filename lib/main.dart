import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'Views/Profil/profilView.dart';
import 'Views/connectionView.dart';
import 'Views/home.dart';
import 'Views/navigBottom.dart';
import 'Views/registerView.dart';
import 'Views/searchView.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      // Route principale vers la page d'accueil
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const Home();
        },
      ),
      // Route vers la page de connexion
      GoRoute(
        path: '/profile/connection',
        builder: (BuildContext context, GoRouterState state) {
          return const ConnectionView();
        },
      ),
      // Route vers la page d'inscription
      GoRoute(
        path: '/profile/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterView();
        },
      ),
      // Route vers la page Profil avec un paramètre `child` nécessaire
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return ProfilView(child: const NavigBottom());
        },
        routes: [
          // Routes imbriquées pour les différentes vues du profil
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return Home();
            },
          ),
          GoRoute(
            path: 'search',
            builder: (BuildContext context, GoRouterState state) {
              return SearchView();
            },
          ),
          GoRoute(
            path: 'map',
            builder: (BuildContext context, GoRouterState state) {
              return MapView();
            },
          ),
          GoRoute(
            path: 'restaurants',
            builder: (BuildContext context, GoRouterState state) {
              return const ViewRestaurants();
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SAE Mobile',
      routerConfig: _router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

