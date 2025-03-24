import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class NearbyStoresScreen extends StatefulWidget {
  const NearbyStoresScreen({Key? key}) : super(key: key);

  @override
  State<NearbyStoresScreen> createState() => _NearbyStoresScreenState();
}

class _NearbyStoresScreenState extends State<NearbyStoresScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _defaultLocation = LatLng(37.7749, -122.4194); // Default to San Francisco
  LatLng? _currentLocation;
  List<Map<String, dynamic>> _places = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    setState(() => _loading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar("Location services are disabled. Please enable them.");
      _currentLocation = _defaultLocation;
      setState(() => _loading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar("Location permission denied. Using default location.");
        _currentLocation = _defaultLocation;
        setState(() => _loading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar("Location permissions are permanently denied.");
      _currentLocation = _defaultLocation;
      setState(() => _loading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _loading = false;
    });

    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    if (_currentLocation == null) return;

    const apiKey = 'AIzaSyAIvOQ5TMxm9IdWuZeipj4OyASsOyiKLTo'; // Replace with your actual API key
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation!.latitude},${_currentLocation!.longitude}&radius=2000&type=store&keyword=agriculture&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        final results = data['results'] as List;

        setState(() {
          _places = results.map((place) {
            return {
              'name': place['name'],
              'address': place['vicinity'],
              'rating': place['rating'],
              'location': LatLng(
                place['geometry']['location']['lat'],
                place['geometry']['location']['lng'],
              ),
              'image': place['photos'] != null
                  ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place['photos'][0]['photo_reference']}&key=$apiKey'
                  : null,
            };
          }).toList();
        });
      } else {
        _showSnackbar("Failed to fetch places. Error: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackbar("An error occurred: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Stores'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: _currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? _defaultLocation,
                zoom: 14.0,
              ),
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              markers: _places.map((place) {
                return Marker(
                  markerId: MarkerId(place['name']),
                  position: place['location'],
                  infoWindow: InfoWindow(
                    title: place['name'],
                    snippet: place['address'],
                  ),
                );
              }).toSet(),
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          place['image'] != null
                              ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              place['image'],
                              width: 300,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(
                            width: 300,
                            height: 150,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.store,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              place['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              place['address'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                Text(
                                  place['rating'] != null
                                      ? '${place['rating']}'
                                      : 'N/A',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
