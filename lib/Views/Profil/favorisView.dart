import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavorisView extends StatefulWidget {
  const FavorisView({super.key});

  @override
  State<FavorisView> createState() => _FavorisViewState();
}

class _FavorisViewState extends State<FavorisView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              context.go('/profile');
            },
            label: Text("Retour"),
          )
        ),
      ),
      body: Center(child: Text("Favoris"))
    );
  }
}
