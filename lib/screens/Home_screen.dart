import 'package:cropnurture/models/doctor_list_screen.dart';
import 'package:cropnurture/screens/analyse_screen/fertilizer_crop_screen.dart';
import 'package:cropnurture/screens/crop_screen.dart';
import 'package:cropnurture/screens/discussion_page.dart';
import 'package:cropnurture/screens/navbar.dart';
import 'package:cropnurture/screens/outbreak_alerts_screen.dart';
import 'package:cropnurture/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);

    // Fetch location and weather data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      weatherProvider.fetchLocationAndWeather();
    });
    return Scaffold(
      appBar: CurvedAppBar(),
      body: Column(
        children: [
          SizedBox(height: 25,),
          WeatherBannerWithImages(),
          SizedBox(height: 5,),
          Expanded(child: FeatureGrid()),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Colors.green,
      //   child: Icon(Icons.add, size: 30),
      // ),

    );
  }
}

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Container(
      height: 400,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Image.asset(
              'assets/images/home2.webp', // Replace with your local image path
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, Farmer !",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 20),
                      Text(
                        weatherProvider.locationName,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      weatherProvider.weatherIconUrl.isNotEmpty
                          ? Image.network(weatherProvider.weatherIconUrl,
                          width: 30, height: 30)
                          : Icon(Icons.cloud, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "${weatherProvider.temperature} | ${weatherProvider.weatherText}",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(280);
}
class WeatherBannerWithImages extends StatelessWidget {
  final List<Map<String, String>> bannerItems = [
    {
      'imagePath': 'assets/images/home1.jpg',
      'text': 'Learn how to grow rice in the rainy season!',
    },
    {
      'imagePath': 'assets/images/home3.jpg',
      'text': 'Best tips for cultivating wheat during winter!',
    },
    {
      'imagePath': 'assets/images/home4.jpg',
      'text': 'Summer crops that thrive under the sun!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: bannerItems.map((item) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(item['imagePath']!),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              item['text']!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}


class FeatureGrid extends StatelessWidget {
  final features = [
    {"icon": Icons.camera_alt, "title": "Disease Detection", "color": Colors.teal, "route": FarmerHome(defaultIndex: 1,)},
    {"icon": Icons.add_alert, "title": "Outbreak", "color": Colors.blue, "route": FarmerHome(defaultIndex: 2,)},
    {"icon": Icons.sanitizer, "title": "Fertilizer", "color": Colors.green, "route": FertilizerScreen()},
    {"icon": Icons.chat, "title": "Discussion", "color": Colors.orange, "route": FarmerHome(defaultIndex: 3,)},
    {"icon": Icons.help, "title": "Crop Expert", "color": Colors.purple, "route": DoctorListScreen()},
    {"icon": Icons.person, "title": "Profile", "color": Colors.red, "route": FarmerHome(defaultIndex: 4,)},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(15),
      itemCount: features.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjusted to fit smaller icons in one screen
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return FeatureTile(
          icon: features[index]['icon'] as IconData,
          title: features[index]['title'] as String,
          color: features[index]['color'] as Color,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => features[index]['route'] as Widget),
            );
          },
        );
      },
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  FeatureTile({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.5), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white), // Smaller size
            SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
