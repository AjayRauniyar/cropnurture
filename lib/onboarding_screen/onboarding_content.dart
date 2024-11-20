
class OnboardingContents {
  final String title;
  final String image;
  final String desc;
  final List<String>? points;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
    this.points,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome to CropNurture",
    image: "assets/images/onboarding1.jpeg",
    desc: "",
  ),
  OnboardingContents(
    title: "Features",
    image: "assets/images/onboarding2.jpg",
    desc: "",
    points: [
      "We help the farmers to predict disease",
      "We help the farmers with outbreak alerts",
      "We have dedicated discussion community page",
      "We have education resources available ",
      "We have online consultation services",
      "We 24x7 helpline number for farmer",
    ],
  ),
  OnboardingContents(
    title: "About us",
    image: "assets/images/onboarding3.jpg",
    desc: "We provide the solution for the farmer crop disease based on ML model along with outbreak alerts from them.",
  ),
];