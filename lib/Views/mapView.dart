import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../Model/Restaurant/Restaurant.dart'; // Adjust the import path as needed

class MapView extends StatefulWidget {
  const MapView({super.key});
  
  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  // Sample list of restaurants
  final List<Restaurant> restaurants = [
    Restaurant(
      osmid: "1",
      nomRestaurant: "Restaurant A",
      type: "Italian",
      etoiles: 4,
      latitude: "48.8566",
      longitude: "2.3522",
    ),
    Restaurant(
      osmid: "2",
      nomRestaurant: "Restaurant B",
      type: "French",
      etoiles: 5,
      latitude: "48.8566",
      longitude: "2.3622",
    ),
    Restaurant(
      osmid: "3",
      nomRestaurant: "Restaurant C",
      type: "Japanese",
      etoiles: 3,
      latitude: "48.8566",
      longitude: "2.3722",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map with Restaurants")),
      body: Stack(
        children: [
          // FlutterMap widget
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(48.8566, 2.3522), // Center of the map
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: restaurants.map((restaurant) {
                  return Marker(
                    point: LatLng(
                      double.parse(restaurant.latitude ?? "0"),
                      double.parse(restaurant.longitude ?? "0"),
                    ),                    child: Tooltip(
                      message: restaurant.nomRestaurant,
                      child: IconButton(
                        icon: Icon(Icons.location_pin),
                        onPressed: () {
                          // Handle marker tap
                          debugPrint("Tapped on ${restaurant.nomRestaurant}");
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // ListView overlay in the top-left corner
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 200, // Adjust width as needed
              height: 300, // Adjust height as needed
              color: Colors.white.withValues(alpha: 0.8),
              child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(restaurants[index].nomRestaurant),
                    subtitle: Text("${restaurants[index].type} - ${restaurants[index].etoiles}⭐"),
                    onTap: () {
                      // Handle restaurant tap
                      debugPrint("Tapped on ${restaurants[index].nomRestaurant}");
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
