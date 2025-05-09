
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  String? _diagnosisResult;
  String? _recommendation;
  String _selectedCrop = 'mango';

  final List<Map<String, dynamic>> crops = [
    {"name": "Mango", "value": "mango", "image": "assets/disease/img.png"},
    {"name": "Maize", "value": "maize", "image": "assets/disease/img_1.png"},
    {"name": "Potato", "value": "potato", "image": "assets/disease/img_2.png"},
    {"name": "Rice", "value": "rice", "image": "assets/disease/img_3.png"},
    {"name": "Tomato", "value": "tomato", "image": "assets/disease/img_4.png"},
    {"name": "Wheat", "value": "wheat", "image": "assets/disease/img_5.png"},
  ];

  void _resetScan() {
    setState(() {
      _selectedImage = null;
      _diagnosisResult = null;
      _recommendation = null;
      _isLoading = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _diagnosisResult = null;
        _recommendation = null;
      });
    }
  }

  Future<void> _handleDiagnosis() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
      _diagnosisResult = null;
      _recommendation = null;
    });

    // Update with your Flask server URL
    final uri = Uri.parse('http://192.168.0.112:5000/');

    // Create multipart request
    final request = http.MultipartRequest('POST', uri);

    // Add crop selection
    request.fields['crop'] = _selectedCrop;

    // Add image file
    final file = await http.MultipartFile.fromPath('image', _selectedImage!.path);
    request.files.add(file);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final String responseBody = response.body;

        // Print the full response for debugging
        print("Server response: $responseBody");

        // Extract disease information using regex
        // The pattern matches the entire HTML content to extract the disease prediction
        final RegExp predictionRegex = RegExp(r'Disease:\s*([^<\n]+)');
        final match = predictionRegex.firstMatch(responseBody);

        if (match != null && match.group(1) != null) {
          final disease = match.group(1)!.trim();

          // Extract crop from your selected crop instead of parsing
          final crop = _selectedCrop.capitalize();

          setState(() {
            _diagnosisResult = disease;
            _recommendation = _getRecommendation(disease);
            _isLoading = false;
          });

          print("Extracted disease: $disease for crop: $crop");
        } else {
          // Try an alternative parsing approach
          if (responseBody.contains("Disease:")) {
            final int diseaseIndex = responseBody.indexOf("Disease:") + 8;
            final int endIndex = responseBody.indexOf("<", diseaseIndex);
            if (endIndex > diseaseIndex) {
              final disease = responseBody.substring(diseaseIndex, endIndex).trim();

              setState(() {
                _diagnosisResult = disease;
                _recommendation = _getRecommendation(disease);
                _isLoading = false;
              });

              print("Extracted disease using alternative method: $disease");
            } else {
              setState(() {
                _diagnosisResult = 'Could not parse disease information';
                _isLoading = false;
              });
            }
          } else {
            setState(() {
              _diagnosisResult = 'No disease information found in response';
              _isLoading = false;
            });
          }
        }
      } else {
        setState(() {
          _diagnosisResult = 'Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _diagnosisResult = 'Failed to connect to the server: $error';
        _isLoading = false;
      });
    }
  }

  String _getCropDisplayName(String cropValue) {
    final cropMap = crops.firstWhere(
          (crop) => crop['value'] == cropValue,
      orElse: () => {'name': cropValue.capitalize(), 'value': cropValue},
    );
    return cropMap['name'] as String;
  }

  String _getRecommendation(String disease) {
    // Add more detailed recommendations based on the disease
    final recommendations = {
      'Anthracnose': 'Apply copper-based fungicides. Prune affected branches and improve air circulation.',
      'Bacterial Canker': 'Remove and destroy affected plant parts. Apply copper-based bactericides.',
      'Healthy': 'Your plant is healthy! Continue good agricultural practices.',
      'Powdery Mildew': 'Apply sulfur-based fungicides. Avoid overhead watering.',
      'Late Blight': 'Apply fungicides containing chlorothalonil or copper. Destroy infected plants.',
      'Early Blight': 'Apply fungicides, ensure proper spacing between plants for airflow.',
      'Brown Spot': 'Apply fungicides containing propiconazole. Maintain proper water management.',
      'Bacterial Blight': 'Use copper-based bactericides. Practice crop rotation.',
      'Leaf Smut': 'Apply fungicides containing azoxystrobin. Remove infected plants.',
      'Yellow Rust': 'Apply fungicides containing tebuconazole. Use resistant cultivars.',
      'Brown Rust': 'Apply fungicides containing propiconazole. Practice crop rotation.',
    };

    return recommendations[disease] ??
        'Consult with a crop expert for specific treatment recommendations for this disease.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Disease Scanner'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crop selection
              Text(
                'Select Crop',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: crops.length,
                  itemBuilder: (context, index) {
                    final crop = crops[index];
                    final isSelected = crop['value'] == _selectedCrop;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCrop = crop['value'];
                        });
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 15),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected ? Colors.green : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              crop['image'],
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              crop['name'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.green : Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // Image selection area
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 80,
                      color: Colors.green.shade300,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Upload leaf image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Image selection buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Scan button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedImage == null || _isLoading
                      ? null
                      : _handleDiagnosis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Scan For Disease',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // In the ScanScreen class, update the display results section:

// Display results
              if (_diagnosisResult != null)
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.green.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bug_report,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Diagnosis Result',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Show the crop name
                                Row(
                                  children: [
                                    Text(
                                      'Crop: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    Text(
                                      _getCropDisplayName(_selectedCrop),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Show the disease name
                                Row(
                                  children: [
                                    Text(
                                      'Disease: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _diagnosisResult!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: _diagnosisResult!.toLowerCase().contains('healthy')
                                              ? Colors.green.shade600
                                              : Colors.orange.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_recommendation != null) ...[
                        const Divider(height: 30),
                        Text(
                          'Recommendation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _recommendation!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _resetScan,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.green.shade700),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Scan New Image',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
// Add this helper method to the _ScanScreenState class to get the display name of the crop

extension on String {
  capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 20),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This feature is under development',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}