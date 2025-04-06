import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae_mobile/Views/viewRestaurant.dart';

import '../Model/Restaurant/Restaurant.dart';
import '../ViewModels/restaurantViewModel.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
              Expanded(child: ViewRestaurant(axis: Axis.horizontal, restaurants: context.watch<RestaurantViewModel>().getRestaurants())),
              // Deuxième section
              SizedBox(height: 35), // Espacement entre les éléments
              Text(
                  "Récemment consulté",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left
              ),
              FutureBuilder<List<Restaurant>>(
                future: context.watch<RestaurantViewModel>().getViewedRestaurants(), // Appel asynchrone pour récupérer les restaurants
                builder: (context, snapshot) {
                  if (snapshot.data?.isEmpty ?? true) {
                    return Expanded(child: Center(child: Text('Aucun restaurant consulté')));
                  }
                  return Expanded(child: ViewRestaurant(axis: Axis.horizontal, restaurants: snapshot.data! ));
                }
              ),
            ],
          ),
      ),
      );
  }
}
