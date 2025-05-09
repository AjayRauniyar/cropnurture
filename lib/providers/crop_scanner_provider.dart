import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CropScannerProvider with ChangeNotifier {
    File? _selectedImage;
    bool _isLoading = false;
    String? _diagnosisResult;
    String? _recommendation;

    File? get selectedImage => _selectedImage;
    bool get isLoading => _isLoading;
    String? get diagnosisResult => _diagnosisResult;
    String? get recommendation => _recommendation;
    void resetScan() {
        _selectedImage = null;
        _diagnosisResult = null;
        _recommendation = null;
        _isLoading = false;
        notifyListeners();
    }

    Future<void> pickImage() async {
        final ImagePicker picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
            _selectedImage = File(pickedFile.path);
            notifyListeners();
        }
    }

    Future<void> pickImageFromCamera() async {
        final ImagePicker picker = ImagePicker();
        final pickedFile = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 100,
        );
        if (pickedFile != null) {
            _selectedImage = File(pickedFile.path);
            notifyListeners();
        }
    }

    Future<void> handleDiagnosis() async {
        if (_selectedImage == null) return;

        _isLoading = true;
        _diagnosisResult = null;
        _recommendation = null;
        notifyListeners();
        final uri = Uri.parse('http://192.168.0.112:5002/predict');
        // final uri = Uri.parse('http://192.168.110.237:5002/predict');
        final request = http.MultipartRequest('POST', uri);
        final file = await http.MultipartFile.fromPath('file', _selectedImage!.path);

        request.files.add(file);

        try {
            final response = await request.send();
            if (response.statusCode == 200) {
                final responseData = await response.stream.bytesToString();
                final data = jsonDecode(responseData);

                String prediction = data['prediction'] ?? 'No prediction available';
                String recommendationHtml = data['recommendation'] ?? '';

                RegExp cropRegEx = RegExp(r'<b>Crop</b>: (\w+)');
                RegExp diseaseRegEx = RegExp(r'Disease: (\w+ \w+)');

                String? crop = cropRegEx.firstMatch(recommendationHtml)?.group(1);
                String? disease = diseaseRegEx.firstMatch(recommendationHtml)?.group(1);

                String formattedRecommendation = '';
                if (crop != null && disease != null) {
                    formattedRecommendation = 'Crop: $crop\nDisease: $disease';
                }

                _diagnosisResult = prediction;
                _recommendation = formattedRecommendation;
            } else {
                _diagnosisResult = 'Error: ${response.statusCode}';
            }
        } catch (error) {
            _diagnosisResult = 'Failed to connect to the server: $error';
        } finally {
            _isLoading = false;
            notifyListeners();
        }
    }
}
