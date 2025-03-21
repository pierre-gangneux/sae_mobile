import 'package:flutter/material.dart';

class ViewRestaurant extends StatelessWidget {
  const ViewRestaurant({super.key});

  Widget _restaurant2Widget() {
    return SizedBox(
      width: 250, // Fixe une largeur pour éviter les erreurs
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
          return _restaurant2Widget();
        },
      ),
    );
  }
}
