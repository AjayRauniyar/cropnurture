import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  DoctorCard({required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(doctor.image, height: 150, fit: BoxFit.cover)
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(delay: 300.ms),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                      .animate()
                      .slideX(duration: 500.ms, delay: 300.ms),
                  Text(doctor.specialty, style: TextStyle(color: Colors.grey))
                      .animate()
                      .fadeIn(delay: 500.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scaleXY(end: 1.02, duration: 400.ms, delay: 400.milliseconds);
  }
}
