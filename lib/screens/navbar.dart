import 'package:cropnurture/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home_screen.dart';

class FarmerHome extends StatefulWidget {
  @override
  _FarmerHomeState createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  int _currentIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    HomeScreen(),
    WeatherScreen(),
    MarketScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.green.shade700,
        buttonBackgroundColor: Colors.green,
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.cloud, size: 30, color: Colors.white),
          Icon(Icons.attach_money, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// // Screens
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Home")),
//       body: Center(
//         child: Text(
//           "Welcome to Farmer's Dashboard",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather")),
      body: Center(
        child: Text(
          "Weather Updates",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Market Prices")),
      body: Center(
        child: Text(
          "Market Price Information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

