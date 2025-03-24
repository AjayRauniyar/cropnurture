import 'package:cropnurture/models/doctor_list_screen.dart';
import 'package:cropnurture/screens/analyse_screen/cause_crop_screen.dart';
import 'package:cropnurture/screens/analyse_screen/fertilizer_crop_screen.dart';
import 'package:cropnurture/screens/analyse_screen/treatment_crop_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:camera/camera.dart';
import '../providers/crop_scanner_provider.dart';
import 'dart:io';

class CropScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cropScannerProvider = Provider.of<CropScannerProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Custom Curved AppBar
          ClipPath(
            clipper: CustomAppBarClipper(),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF388E3C),
                    Color(0xFF66BB6A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      scale: 12,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Krishi Aarogya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header Section
                  if (cropScannerProvider.selectedImage != null &&
                      !cropScannerProvider.isLoading &&
                      cropScannerProvider.diagnosisResult == null)
                  HeaderSection(title: "Scan Your Crop"),
                  SizedBox(height: 20),
                  // Camera Preview Section
                  if (cropScannerProvider.selectedImage == null &&
                      !cropScannerProvider.isLoading)
                    CameraPreviewSection(),

                  // Image Preview
                  if (cropScannerProvider.selectedImage != null &&
                      !cropScannerProvider.isLoading &&
                      cropScannerProvider.diagnosisResult == null)
                    ImagePreview(
                      imageFile: cropScannerProvider.selectedImage!,
                    ),

                  SizedBox(height: 5),

                  // Image Selection Buttons or Submit Button
                  if (cropScannerProvider.selectedImage == null &&
                      !cropScannerProvider.isLoading &&
                      cropScannerProvider.diagnosisResult == null)
                    ImageSelectionButtons(),

                  if (cropScannerProvider.selectedImage != null &&
                      !cropScannerProvider.isLoading &&
                      cropScannerProvider.diagnosisResult == null)
                    ElevatedButton(
                      onPressed: cropScannerProvider.handleDiagnosis,
                      child: Text(
                        "Submit for Scanning",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF388E3C),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 30.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                  // Loading Animation
                  if (cropScannerProvider.isLoading) LoadingIndicator(),

                  // Diagnosis and Recommendations
                  if (cropScannerProvider.diagnosisResult != null)
                    DiagnosisResultSection(),



                  // Feature Grid
                  if (cropScannerProvider.diagnosisResult != null)
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: FeatureGrid(),
                    ),

                  // Retry Button
                  if (cropScannerProvider.diagnosisResult != null)
                    ElevatedButton(
                      onPressed: cropScannerProvider.resetScan,
                      child: Text(
                        "Try again",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF388E3C),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 40.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class ImagePreview extends StatelessWidget {
  final File imageFile;

  const ImagePreview({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF388E3C), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          imageFile, // Use File directly
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Header Section Widget
class HeaderSection extends StatelessWidget {
  final String title;

  const HeaderSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF388E3C),
        ),
      ),
    );
  }
}

// Camera Preview Section Widget
class CameraPreviewSection extends StatefulWidget {
  @override
  _CameraPreviewSectionState createState() => _CameraPreviewSectionState();
}

class _CameraPreviewSectionState extends State<CameraPreviewSection> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras[0],
          ResolutionPreset.high,
        );
        _initializeControllerFuture = _controller.initialize();
        setState(() {}); // Trigger a rebuild after initialization
      } else {
        print("No cameras available");
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            width: 300,
            height: 300,
            child: CameraPreview(_controller),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// Image Selection Buttons Widget
class ImageSelectionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cropScannerProvider = Provider.of<CropScannerProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: SvgPicture.asset(
            'assets/svg/gallery.svg',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          onPressed: cropScannerProvider.pickImage,
          label: Text("Gallery",style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF388E3C),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton.icon(
          icon: SvgPicture.asset(
            'assets/svg/camera.svg',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          onPressed: cropScannerProvider.pickImageFromCamera,
          label: Text("Camera",style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF388E3C),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

// Loading Indicator Widget
class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/loading.json',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
class DiagnosisResultSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cropScannerProvider = Provider.of<CropScannerProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Diagnosis Result Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF388E3C), size: 30),
                  SizedBox(width: 10),
                  Text(
                    "Diagnosis Result",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 30,
              ),

              // Diagnosis Message
              Text(
                cropScannerProvider.diagnosisResult! ,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              SizedBox(height: 16),

              // Recommendation Section
              if (cropScannerProvider.recommendation != null)
                Column(
                  children: [

                    Text(
                      cropScannerProvider.recommendation!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),


              // Button to Download Report

            ],
          ),
        ),
      ),
    );
  }
}

class FeatureGrid extends StatelessWidget {

  final features = [
    {"icon": Icons.health_and_safety_sharp, "title": "Cause of crop", "color": Colors.teal, "page": CropDiseaseScreen()},
    {"icon": Icons.agriculture, "title": "Treament of crop", "color": Colors.blue, "page": TreatmentCropScreen()},
    {"icon": Icons.sanitizer, "title": "Fertilizer", "color": Colors.green, "page":FertilizerScreen()},
    {"icon": Icons.quick_contacts_dialer_rounded , "title": "Consultant", "color": Colors.orange, "page": DoctorListScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
      shrinkWrap: true, // Ensures the grid takes only the necessary space
      physics: NeverScrollableScrollPhysics(), // Disables internal scrolling
      itemCount: features.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return FeatureTile(
          icon: features[index]['icon'] as IconData,
          title: features[index]['title'] as String,
          color: features[index]['color'] as Color,
          page: features[index]['page'] as Widget,
        );
      },
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget page;

  FeatureTile({required this.icon, required this.title, required this.color, required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the respective page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.5), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
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
            Icon(icon, size: 50, color: Colors.white), // Smaller size
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

