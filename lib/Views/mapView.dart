import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the rating bar package
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

  // State variable to track the selected restaurant
  String? selectedOsmid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map with Restaurants")),
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
                    ),
                    child: Tooltip(
                      message: restaurant.nomRestaurant,
                      child: IconButton(
                        iconSize: restaurant.osmid == selectedOsmid ? 40.0 : 30.0,
                        icon: Icon(
                          Icons.location_pin,
                          color: restaurant.osmid == selectedOsmid
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          // Update the selected restaurant
                          setState(() {
                            selectedOsmid = restaurant.osmid;
                          });
                          debugPrint("Selected ${restaurant.nomRestaurant}");
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(restaurants[index].type),
                        const SizedBox(height: 4),
                        RatingBarIndicator(
                          rating: restaurants[index].etoiles.toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Update the selected restaurant when tapped in the list
                      setState(() {
                        selectedOsmid = restaurants[index].osmid;
                      });
                      debugPrint("Selected ${restaurants[index].nomRestaurant}");
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
