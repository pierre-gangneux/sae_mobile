import 'package:flutter/material.dart';

class ViewRestaurants extends StatelessWidget {
  final Axis axis; // Store the axis parameter

  const ViewRestaurants({super.key, required this.axis}); // Proper constructor

  Widget _restaurant2Widget(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.8; // 80% of screen width

    return SizedBox(
      width: cardWidth.clamp(200, 400), // Min 200, Max 400 to avoid extreme sizes
      child: Card(
        child: ListTile(
          title: Text("title"),
          subtitle: Text("ouvert"),
          trailing: Text('Note'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Fixed height for ListView to work properly
      child: ListView.builder(
        scrollDirection: axis, // Use class-level property
        itemCount: 100,
        itemBuilder: (context, index) {
          return _restaurant2Widget(context);
        },
      ),
    );
  }
}
