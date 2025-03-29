import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Model/Restaurant.dart'; // Assurez-vous que le chemin est correct.

class ViewRestaurant extends StatelessWidget {
  final Axis axis; // Propriété pour définir l'axe de défilement
  final List<Restaurant> _restaurants; // Liste des restaurants

  ViewRestaurant({
    super.key,
    required this.axis,
    required List<Restaurant> restaurants,
  }) : _restaurants = restaurants;


  // Méthode pour afficher chaque carte de restaurant
  Widget _restaurantCard(BuildContext context, Restaurant restaurant) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.8; // 80% de la largeur de l'écran

    return SizedBox(
      width: cardWidth.clamp(200, 400), // Largeur entre 200 et 400 pour éviter les tailles extrêmes
      child: Card(
        child: InkWell(
          onTap: () {
            // Navigation vers la page de détails du restaurant via son ID
            context.push('/restaurants/${restaurant.osmid}');
          },
          child: ListTile(
            title: Text(restaurant.nomRestaurant),
            subtitle: Text("Statut: ${restaurant.telephone ?? 'Non précisé'}"),
            trailing: Text('${restaurant.etoiles} étoiles'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Hauteur fixe pour que le ListView fonctionne correctement
      child: ListView.builder(
        scrollDirection: axis, // Utilisation de la propriété de classe pour l'axe de défilement
        itemCount: _restaurants.length, // Nombre d'éléments dans la liste de restaurants
        itemBuilder: (context, index) {
          return _restaurantCard(context, _restaurants[index]);
        },
      ),
    );
  }
}
