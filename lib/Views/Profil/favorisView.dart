import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        title: Text("Vos favoris"),
      ),
      body: Center(child: Text("Favoris"))
    );
  }
}
