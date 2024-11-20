import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Icon(Icons.add, size: 30),
      ),

    );
  }
}

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Image.asset(
              'assets/images/banner.jpeg', // Replace with your local image path
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 220,
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, Farmer!",
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
                        "Your Location",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.wb_sunny, color: Colors.yellow, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "28°C | Clear Sky",
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
  final List<String> imagePaths = [
    'assets/images/banner.jpeg', // Replace with your local image paths
    'assets/images/banner.jpeg',
    'assets/images/banner.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: imagePaths.map((path) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(path),
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
              "Learn Seasonal Crop Tips!",
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
    {"icon": Icons.local_florist, "title": "Disease Detection", "color": Colors.teal},
    {"icon": Icons.phone, "title": "Helpline", "color": Colors.blue},
    {"icon": Icons.grass, "title": "Crop Care", "color": Colors.green},
    {"icon": Icons.cloud, "title": "Weather Forecast", "color": Colors.orange},
    {"icon": Icons.price_check, "title": "Market Prices", "color": Colors.purple},
    {"icon": Icons.book, "title": "Knowledge Hub", "color": Colors.red},
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
        );
      },
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  FeatureTile({required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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

