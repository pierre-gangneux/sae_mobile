import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Views/home.dart'; // Import de Home
import 'Views/view2.dart'; // Import de View2

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Home(),
      ),
      GoRoute(
        path: '/route2',
        builder: (context, state) => View2(),
      ),
    ],
  );

  GoRouter get getRouter => router;
}
