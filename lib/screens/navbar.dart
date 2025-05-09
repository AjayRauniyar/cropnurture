import 'package:cropnurture/screens/Google_maps_screen.dart';
import 'package:cropnurture/screens/crop_screen.dart';
import 'package:cropnurture/screens/discussion_page.dart';
import 'package:cropnurture/screens/disease_scan_screen.dart';
import 'package:cropnurture/screens/education_screen.dart';
import 'package:cropnurture/screens/outbreak_alerts_screen.dart';
import 'package:cropnurture/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Home_screen.dart';

class FarmerHome extends StatefulWidget {
  final int defaultIndex; // Accept default index as a parameter

  FarmerHome({this.defaultIndex = 0}); // Default index is 0 if not specified

  @override
  _FarmerHomeState createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.defaultIndex; // Initialize with the provided default index
  }

  // List of pages for navigation
  final List<Widget> _pages = [
    HomeScreen(),
    CropScannerScreen(),
    ScanScreen(),
    PredictionScreen(),
    DiscussionPage(),
    AgriculturalCentersScreen(),
    EducationScreen(),
    ProfileScreen(),
  ];

  // Method to navigate while keeping the navbar visible
  void _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
          Icon(FontAwesomeIcons.plantWilt, size: 30, color: Colors.white),
          Icon(FontAwesomeIcons.seedling, size: 30, color: Colors.white),
          Icon(Icons.grass_sharp, size: 30, color: Colors.white),
          Icon(Icons.chat_rounded, size: 30, color: Colors.white),
          Icon(Icons.near_me_sharp, size: 30, color: Colors.white),
          Icon(Icons.video_collection, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        index: _currentIndex, // Set the index for the navbar
        onTap: _navigateTo,
      ),
    );
  }
}
