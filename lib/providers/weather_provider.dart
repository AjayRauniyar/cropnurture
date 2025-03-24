import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class WeatherProvider with ChangeNotifier {
  String locationName = 'Fetching location...';
  String weatherText = '';
  String temperature = '';
  String weatherIconUrl = '';
  double? latitude;
  double? longitude;

  Future<void> fetchLocationAndWeather() async {
    final location = Location();

    try {
      // Check if permission is granted
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          locationName = 'Location service is disabled';
          notifyListeners();
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          locationName = 'Location permission denied';
          notifyListeners();
          return;
        }
      }

      // Get the current location
      final currentLocation = await location.getLocation();
      latitude = currentLocation.latitude;
      longitude = currentLocation.longitude;

      // Fetch weather data
      await fetchWeather();
    } catch (error) {
      locationName = 'Error fetching location';
      notifyListeners();
    }
  }

  Future<void> fetchWeather() async {
    if (latitude == null || longitude == null) return;

    final String apiKey = "b1f167d835524000bd0165053242911";
    final String weatherUrl =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude&aqi=no";

    try {
      final response = await http.get(Uri.parse(weatherUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        locationName = data['location']['name'];
        temperature = '${data['current']['temp_c']}°C';
        weatherText = data['current']['condition']['text'];
        weatherIconUrl = 'https:${data['current']['condition']['icon']}';
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (error) {
      locationName = 'Error fetching weather data';
      weatherText = '';
      temperature = '';
      weatherIconUrl = '';
    }
    notifyListeners();
  }
}
