import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommentsView extends StatefulWidget {
  const CommentsView({super.key});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {

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
                label: Text("Retour")
              )
          ),
        ),
        body: Center(child: Text("Commentaires"))
    );
  }
}
