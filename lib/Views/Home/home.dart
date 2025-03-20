import 'package:flutter/material.dart';
import 'package:sae_mobile/Views/Home/viewRestaurant.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IUTable"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Liste horizontale des restaurants
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft, // Alignement du texte à gauche
                    child: Text("les mieux notés"),
                  ),
                  Expanded(child: ViewRestaurant()), //  Expanded Répartit bien la hauteur
                  SizedBox(height: 20), // Espacement entre les éléments
                  Container(
                    alignment: Alignment.centerLeft, // Alignement du texte à gauche
                    child: Text("les mieux notés"),
                  ),
                  Expanded(child: ViewRestaurant()),
                  SizedBox(height: 20), // Espacement entre les éléments
                  Container(
                    alignment: Alignment.centerLeft, // Alignement du texte à gauche
                    child: Text("les mieux notés"),
                  ),
                  Expanded(child: ViewRestaurant()),
                ],
              ),
            ),
            // Deuxième section
            SizedBox(height: 50), // Espacement entre les éléments
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Ligne 2",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
