import 'package:flutter/material.dart';

class ViewRestaurant extends StatelessWidget {
  const ViewRestaurant({super.key});

  Widget _restaurant2Widget(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.8; // 80% de la largeur de l'écran

    return SizedBox(
      width: cardWidth.clamp(200, 400), // Min 200, Max 400 pour éviter des tailles extrêmes
      child: Card(
        child: ListTile(
          title: Text("title"),
          subtitle: Text("ouvert"),
          trailing: Text('Note'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Fixe une hauteur sinon ListView ne fonctionne pas bien
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Scroll horizontal
        itemCount: 10,
        itemBuilder: (context, index) {
          return _restaurant2Widget(context);
        },
      ),
    );
  }
}
