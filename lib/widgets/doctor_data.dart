import '../models/doctor.dart';

final Map<String, List<Doctor>> doctorsData = {
  "Rice": [
    Doctor(
      name: "Dr Virender Kumar",
      specialty: "Rice Breeding Expert",
      image: "assets/doctor/DR-1 RICE-modified.png",
      description: "Expert in Rice breeding, disease resistance(IRRI).",
    ),
    Doctor(
      name: "Dr T. Mohapatra",
      specialty: "Rice disease Expert",
      image: "assets/doctor/IMG-20241211-WA0011-modified.png",
      description: "Specialist in Advanced research in rice disease,genetics(ICAR).",
    ),
    Doctor(
      name: "Dr Himanshu Pathak",
      specialty: "Rice disease Expert",
      image: "assets/doctor/IMG-20241211-WA0012-modified.png",
      description: "Expert in Climate-resilient agriculture,rice research,disease management(ICAR).",
    ),
  ],
};
