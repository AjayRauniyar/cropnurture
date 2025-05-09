import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class Shop {
  final String name;
  final double lat;
  final double lng;
  final String address;
  final double rating;
  final String phone;

  Shop({
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
    required this.rating,
    required this.phone,
  });
}

class AgriculturalCentersScreen extends StatefulWidget {
  const AgriculturalCentersScreen({Key? key}) : super(key: key);

  @override
  _AgriculturalCentersScreenState createState() =>
      _AgriculturalCentersScreenState();
}

class _AgriculturalCentersScreenState extends State<AgriculturalCentersScreen> {
  GoogleMapController? mapController;
  Shop? hoveredShop;
  final Set<Marker> _markers = {};
  int? selectedIndex;

  final LatLng bangaloreLocation = const LatLng(12.9716, 77.5946);

  // Hardcoded top agricultural shops/fertilizer centers in Bangalore
  final List<Shop> hardcodedShops = [
    Shop(
      name: "AgroStar Agriculture Store",
      lat: 12.9718915,
      lng: 77.6411545,
      address: "Indiranagar, Bangalore",
      rating: 4.5,
      phone: "+91 98765 43210",
    ),
    Shop(
      name: "Krishi Fertilizers",
      lat: 12.926031,
      lng: 77.676246,
      address: "Marathahalli, Bangalore",
      rating: 4.2,
      phone: "+91 98453 12345",
    ),
    Shop(
      name: "GreenGrow Farm Supplies",
      lat: 12.935223,
      lng: 77.624487,
      address: "Koramangala, Bangalore",
      rating: 4.8,
      phone: "+91 99000 11223",
    ),
    Shop(
      name: "AgriMart",
      lat: 12.9791198,
      lng: 77.5912997,
      address: "MG Road, Bangalore",
      rating: 4.1,
      phone: "+91 97400 22334",
    ),
    Shop(
      name: "Fertilizer World",
      lat: 12.971998,
      lng: 77.599887,
      address: "Majestic, Bangalore",
      rating: 4.0,
      phone: "+91 95388 99887",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    for (int i = 0; i < hardcodedShops.length; i++) {
      final shop = hardcodedShops[i];
      _markers.add(
        Marker(
          markerId: MarkerId(shop.name),
          position: LatLng(shop.lat, shop.lng),
          infoWindow: InfoWindow(
            title: shop.name,
            snippet: "${shop.address} • Rating: ${shop.rating}",
          ),
          onTap: () {
            setState(() {
              hoveredShop = shop;
              selectedIndex = i;
            });
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _openDirections(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the map.')),
      );
    }
  }

  void _makePhoneCall(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not make the call.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Agricultural Resource Centers'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: bangaloreLocation,
                zoom: 12,
              ),
              markers: _markers,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.grey[100],
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hardcodedShops.length,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemBuilder: (context, index) {
                  final shop = hardcodedShops[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        hoveredShop = shop;
                      });

                      mapController?.animateCamera(
                        CameraUpdate.newLatLng(LatLng(shop.lat, shop.lng)),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.8,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        color: selectedIndex == index ? Colors.green[50] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: selectedIndex == index ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Address: ${shop.address}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    'Rating: ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '${shop.rating}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 4),
                                  _buildRatingStars(shop.rating),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Phone: ${shop.phone}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _openDirections(shop.lat, shop.lng),
                                    icon: const Icon(Icons.directions),
                                    label: const Text('Directions'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _makePhoneCall(shop.phone),
                                    icon: const Icon(Icons.phone),
                                    label: const Text('Call'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index == rating.floor() && rating % 1 > 0) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }
}