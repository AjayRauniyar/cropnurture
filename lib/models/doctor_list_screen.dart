import 'package:cropnurture/screens/analyse_screen/fertilizer_crop_screen.dart';
import 'package:flutter/material.dart';

import '../screens/analyse_screen/cause_crop_screen.dart';
import '../screens/analyse_screen/treatment_crop_screen.dart';
import '../widgets/doctor_card.dart';
import '../widgets/doctor_data.dart';
import 'doctor_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DoctorListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant Doctor Consultation",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: doctorsData.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800]),
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(delay: 300.ms),
              SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final doctor = entry.value[index];
                  return DoctorCard(
                    doctor: doctor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailsScreen(doctor: doctor),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0,bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to the previous page or perform an action
                Navigator.pop(context);
              },
              backgroundColor: Colors.green.shade700,
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0,bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to the next page or perform an action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FertilizerScreen()),
                );
              },
              backgroundColor: Colors.green.shade700,
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
