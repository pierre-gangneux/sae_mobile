import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Avis/avisSectionView.dart';

class AvisView extends StatefulWidget {
  const AvisView({super.key});

  @override
  State<AvisView> createState() => _AvisViewState();
}

class _AvisViewState extends State<AvisView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Vos avis")
          ),
        ),
        body: AvisSectionView()
    );
  }
}
