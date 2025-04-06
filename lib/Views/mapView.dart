import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sae_mobile/ViewModels/restaurantViewModel.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  String? selectedOsmid;
  LatLng? userLocation; // User's geolocation
  final MapController _mapController = MapController(); // Map controller
  LatLngBounds? mapBounds; // Map bounds

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permissions are permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });

    // Move the map to the user's location
    _mapController.move(userLocation!, 13.0);
  }

  @override
  Widget build(BuildContext context) {
    final restaurantViewModel = Provider.of<RestaurantViewModel>(context);

    // Get the restaurants within the current map bounds
    final restaurantsInBounds = mapBounds != null
        ? restaurantViewModel.getRestaurantsInBounds(
            minLatitude: mapBounds!.south,
            maxLatitude: mapBounds!.north,
            minLongitude: mapBounds!.west,
            maxLongitude: mapBounds!.east,
          )
        : [];

    return Scaffold(
      appBar: AppBar(title: const Text("Map with Restaurants")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: userLocation ?? LatLng(48.8566, 2.3522),
              initialZoom: 13.0,
              onPositionChanged: (position, hasGesture) {
                setState(() {
                  mapBounds = position.visibleBounds;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                tileProvider: CancellableNetworkTileProvider(),
              ),
              MarkerLayer(
                markers: [
                  // User location marker
                  if (userLocation != null)
                    Marker(
                      point: userLocation!,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                  // Restaurant markers
                  ...restaurantsInBounds.map((restaurant) {
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
                })
                ],
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
                itemCount: restaurantsInBounds.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantsInBounds[index];
                  final isSelected = restaurant.osmid == selectedOsmid;

                  return Card(
                    elevation: isSelected ? 4 : 1,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(restaurant.nomRestaurant),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(restaurant.type),
                              const SizedBox(height: 4),
                              RatingBarIndicator(
                                rating: restaurant.etoiles.toDouble(),
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
                              selectedOsmid = restaurant.osmid;
                            });
                            debugPrint("Selected ${restaurant.nomRestaurant}");
                          },
                        ),
                        if (isSelected)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the restaurant's page
                                Navigator.pushNamed(
                                  context,
                                  '/restaurants/${restaurant.osmid}',
                                );
                              },
                              child: const Text("Go to Page"),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Reset position button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                if (userLocation != null) {
                  _mapController.move(userLocation!, 13.0);
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
