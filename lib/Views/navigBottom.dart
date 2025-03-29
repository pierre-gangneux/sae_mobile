import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigBottom extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigBottom({super.key, required this.navigationShell});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // Affiche la page active
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => navigationShell.goBranch(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Recherche"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Carte"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
