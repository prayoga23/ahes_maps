// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// // Tambahkan late variable untuk SharedPreferences
// late SharedPreferences sharedPreferences;

// // Tambahkan fungsi inisialisasi
// Future<void> initializeSharedPreferences() async {
//   sharedPreferences = await SharedPreferences.getInstance();
// }

// Point getLatLngFromSharedPrefs() {
//   return Point(
//     coordinates: Position(
//       sharedPreferences.getDouble('longitude') ?? 112.7521, // Default Surabaya
//       sharedPreferences.getDouble('latitude') ?? -7.2575,
//     ),
//   );
// }

// Map getDecodedResponseFromSharedPrefs(int index) {
//   String key = 'asrama--$index'; // Ganti 'restaurant' menjadi 'asrama'
//   String? jsonString = sharedPreferences.getString(key);
//   if (jsonString == null) {
//     return {}; // Return empty map if no data found
//   }
//   return json.decode(jsonString);
// }

// num getDistanceFromSharedPrefs(int index) {
//   Map response = getDecodedResponseFromSharedPrefs(index);
//   return response['distance'] ?? 0;
// }

// num getDurationFromSharedPrefs(int index) {
//   Map response = getDecodedResponseFromSharedPrefs(index);
//   return response['duration'] ?? 0;
// }

// Map getGeometryFromSharedPrefs(int index) {
//   Map response = getDecodedResponseFromSharedPrefs(index);
//   return response['geometry'] ?? {};
// }
