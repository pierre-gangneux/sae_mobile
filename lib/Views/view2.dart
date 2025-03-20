import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class View2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View2")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/View3'); // Navigation vers View3
          },
          child: Text("Aller à View3"),
        ),
      ),
    );
  }
}
