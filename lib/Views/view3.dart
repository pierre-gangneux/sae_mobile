import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class View3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View3")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/home'); // Navigation vers home
          },
          child: Text("Aller à Home"),
        ),
      ),
    );
  }
}
