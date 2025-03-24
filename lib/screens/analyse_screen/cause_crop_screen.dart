import 'dart:convert';
import 'package:cropnurture/screens/analyse_screen/treatment_crop_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_scanner_provider.dart';

class CropDiseaseScreen extends StatefulWidget {
  @override
  _CropDiseaseScreenState createState() => _CropDiseaseScreenState();
}

class _CropDiseaseScreenState extends State<CropDiseaseScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  String causeDetails = "";
  String? disease;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the Provider in didChangeDependencies
    final cropScannerProvider =
    Provider.of<CropScannerProvider>(context, listen: false);
    disease = cropScannerProvider.diagnosisResult;

    if (disease != null && causeDetails.isEmpty) {
      fetchGeminiDetails(disease!);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> fetchGeminiDetails(String disease) async {
    try {
      const String apiKey = "AIzaSyDshsEBQKFxUvWAUOnCWfaaFJn3IzYwUwo"; // Replace with your API key
      final apiUrl =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey";

      final requestData = {
        "contents": [
          {
            "parts": [
              {
                "text":
                "Show me the cause of the $disease in plants in 5 points only and don't show any extra summary text."
              },
            ],
          }
        ]
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          causeDetails =
              data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
                  "No details available.";
          isLoading = false;
          _fadeController.forward(); // Start the fade-in animation
        });
      } else {
        setState(() {
          causeDetails = "Failed to fetch details. Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        causeDetails = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

  Widget buildCauseDetails() {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/lottie/loading.json'), // Replace with your Lottie JSON file
      );
    }

    final causes = causeDetails.split("\n").where((e) => e.isNotEmpty).toList();

    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: causes.map((cause) {
          final styledText = _applyTextStyle(cause);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, size: 12, color: Colors.green),
                SizedBox(width: 10),
                Expanded(child: styledText),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _applyTextStyle(String text) {
    final regexBold = RegExp(r"\*\*(.*?)\*\*");
    final regexItalic = RegExp(r"\*(.*?)\*");

    final spans = <TextSpan>[];
    text.splitMapJoin(
      regexBold,
      onMatch: (match) {
        spans.add(TextSpan(
          text: match.group(1),
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green.shade700),
        ));
        return "";
      },
      onNonMatch: (remaining) {
        remaining.splitMapJoin(
          regexItalic,
          onMatch: (match) {
            spans.add(TextSpan(
              text: match.group(1),
              style: TextStyle(fontStyle: FontStyle.italic),
            ));
            return "";
          },
          onNonMatch: (nonMatchedText) {
            spans.add(TextSpan(text: nonMatchedText));
            return "";
          },
        );
        return "";
      },
    );

    return RichText(
      text: TextSpan(style: TextStyle(fontSize: 16, color: Colors.black), children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.green.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Text(
            "Crop Disease Diagnosis",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
          ),
          centerTitle: true,
          elevation: 10,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Possible Causes:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: buildCauseDetails(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.green.shade700,
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TreatmentCropScreen()),
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
