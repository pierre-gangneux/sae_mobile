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
        padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajoute de la marge à gauche et à droite
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligne tout à gauche
            children: [
              Text(
                "Recommander",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left
              ),
              Expanded(child: ViewRestaurant()),
              // Deuxième section
              SizedBox(height: 35), // Espacement entre les éléments
              Text(
                  "Récemment consulté",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left
              ),
              Expanded(child: ViewRestaurant()),
            ],
          ),
      ),
      );
  }
}
