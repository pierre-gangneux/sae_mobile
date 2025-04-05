import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Avis/avisSectionView.dart';

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
              child: Text("Vos commentaires")
          ),
        ),
        body: AvisSectionView()
    );
  }
}
