import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../screens/analyse_screen/chat_screen.dart';

import 'package:flutter_animate/flutter_animate.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailsScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(doctor.image, height: 200, width: double.infinity, fit: BoxFit.cover)
                .animate()
                .fadeIn()
                .scale(),
            SizedBox(height: 16),
            Text(
              doctor.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )
                .animate()
                .slideX(duration: 500.ms),
            Text(
              doctor.specialty,
              style: TextStyle(color: Colors.grey),
            ).animate().fadeIn(delay: 200.ms),
            SizedBox(height: 16),
            Text(doctor.description).animate().fadeIn(delay: 400.ms),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(doctor: doctor),
                      ),
                    );
                  },
                  icon: Icon(Icons.chat,color: Colors.white,),
                  label: Text("Chat",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ).animate().scale(delay: 600.ms),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.video_call,color: Colors.white,),
                  label: Text("Video",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ).animate().scale(delay: 800.ms),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.call,color: Colors.white,),
                  label: Text("Call",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ).animate().scale(delay: 400.milliseconds),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
