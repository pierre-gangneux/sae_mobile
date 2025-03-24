import 'package:flutter/material.dart';

class ProfilView extends StatelessWidget {
  final Widget child;

  const ProfilView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: child,
    );
  }
}