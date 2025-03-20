import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart'; // Import de AppRouter

void main() {
  final appRouter = AppRouter();

  runApp(MyApp(router: appRouter.getRouter));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation',
      routerConfig: router,
    );
  }
}
