import '../models/doctor.dart';

final Map<String, List<Doctor>> doctorsData = {
  "Apple": [
    Doctor(
      name: "Dr. John Appleton",
      specialty: "Apple Pathology",
      image: "assets/doctor/dr1.jpeg",
      description: "Expert in Apple diseases like Scab and Black Rot.",
    ),
    Doctor(
      name: "Dr. Sarah Fruits",
      specialty: "Apple Agronomy",
      image: "assets/doctor/dr2.jpeg",
      description: "Specialist in Apple orchard management.",
    ),
  ],
  "Corn": [
    Doctor(
      name: "Dr. Rohan Malhotra",
      specialty: "Corn Pathology",
      image: "assets/doctor/dr3.jpeg",
      description: "Expert in Corn diseases like Common Rust.",
    ),
  ],
};
