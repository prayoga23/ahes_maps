import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:ahes_maps/constants/asrama.dart';
import 'package:ahes_maps/requests/mapbox_requests.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get capture the current user location
    LocationData locationData = await location.getLocation();
    Point currentLocation = Point(
      coordinates: Position(locationData.longitude!, locationData.latitude!),
    );

    // Store the user location in sharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', locationData.latitude!);
    await prefs.setDouble('longitude', locationData.longitude!);

    // Get and store the directions API response in sharedPreferences
    for (int i = 0; i < asrama.length; i++) {
      Map<String, dynamic> modifiedResponse = await getCyclingRouteUsingMapbox(
        currentLocation,
        Point(
          coordinates: Position(
            double.parse(asrama[i]['coordinates']['longitude']),
            double.parse(asrama[i]['coordinates']['latitude']),
          ),
        ),
      );
      await prefs.setString('directions_$i', json.encode(modifiedResponse));
    }

    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox.expand(
        child: Image.asset(
          'assets/splash/start.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}