import 'package:flutter/material.dart';
import 'package:sae_mobile/Views/home.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Widget> _vues = <Widget>[Home(), Home()];

  var _index = 0;

  void _onItemTapped(int currentIndex){
    setState(() {
      _index = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IUTables’O',
      home: Scaffold(
        appBar: AppBar(),
        body: _vues[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Les Restaurants'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Les Restaurants 2'
            )
          ],
        ),
      ),
    );
  }
}

