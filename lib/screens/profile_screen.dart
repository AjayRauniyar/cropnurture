import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Profile", style: TextStyle(color: Colors.white)),
      //   backgroundColor: Colors.green,
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            SizedBox(height: 20),
            ProfileDetailsSection(),
            SizedBox(height: 20),
            BusinessMetricsSection(),
          ],
        ),
      ),

    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(padding: EdgeInsets.all(10)),
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        Positioned(
          left: 40,
          top: 100,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/farmer.jpg'), // Replace with local image
          ),
        ),
        Positioned(
          left: 170,
          top: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rahul Raj",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Bengaluru",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Regular Member",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileDetailsSection extends StatelessWidget {
  final details = [
    {"icon": Icons.person, "title": "Gender", "value": "Male"},
    {"icon": Icons.phone, "title": "Contact", "value": "+911234567890"},
    {"icon": Icons.grass, "title": "Farm Size", "value": "5 Acres"},
    {"icon": Icons.local_florist, "title": "Crops", "value": "Wheat, Corn"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Column(
            children: details.map((detail) {
              return Card(
                margin: EdgeInsets.only(bottom: 15),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(detail['icon'] as IconData, color: Colors.green),
                  title: Text(detail['title'] as String, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(detail['value'] as String),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class BusinessMetricsSection extends StatelessWidget {
  final metrics = [
    {"icon": Icons.image, "title": "Images Uploaded", "value": "120"},
    {"icon": Icons.bar_chart, "title": "Game Score", "value": "85%"},
    {"icon": Icons.shopping_bag, "title": "Total Sales", "value": "\R\s 50,000"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Business Metrics",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: metrics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(metric['icon'] as IconData, size: 40, color: Colors.green),
                    SizedBox(height: 10),
                    Text(
                      metric['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      metric['value'] as String,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

