import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/screens/home_page.dart';
import 'package:weather_app/services/weather_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () async {
      final position = await getLocation();

      String query = '';
      if (position == null) {
        query = 'colombo';
      } else {
        query = '${position.latitude},${position.longitude}';
      }

      final currentWeather = await WeatherServices().getCurrentWeather(query);

      if (currentWeather != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(currentWeather: currentWeather),
          ),
        );
      }
    });
  }

  Future<Position?> getLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 50,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'From Weather Map',
              style: TextStyle(
                color: Colors.grey.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lotties/weather_day.json'),
            Text(
              'Weather App',
              style: TextStyle(
                color: Colors.grey.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
