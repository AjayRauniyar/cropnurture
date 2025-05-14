import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiProvider extends ChangeNotifier {
  String _prediction = "";

  String get prediction => _prediction;

  Future<void> fetchPrediction(Map<String, dynamic> inputs) async {
    // final url = Uri.parse("https://sih-1638-app.onrender.com/predict");
    final url = Uri.parse("http://192.168.0.112:5001/predict");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inputs),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _prediction = responseData["Predicted Label"];
      } else {
        _prediction = "Error occurred while predicting";
      }
    } catch (e) {
      _prediction = "Error: ${e.toString()}";
    }

    notifyListeners();
   // notifyListeners();
  }

  void resetPrediction() {
    _prediction = "";
    notifyListeners();
  }
}
