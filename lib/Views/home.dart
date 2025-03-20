import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IUTable"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,  // Aligner en haut
        crossAxisAlignment: CrossAxisAlignment.stretch,  // Étendre pour toute la largeur
        children: [
          // Première ligne (haut de la page)
          // Première ligne plus grande (flex = 2)
          Flexible(
            flex: 2,  // Cette ligne prendra 2x plus d'espace que les autres
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Text(
                  "Ligne 1 - Plus grande",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          // Deuxième ligne (flex = 1)
          Flexible(
            flex: 1,  // Prend une portion d'espace normale
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
    );
  }
}
