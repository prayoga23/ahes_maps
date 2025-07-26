// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constants/asrama.dart';
// import '../requests/mapbox_requests.dart';

// // Tambahkan variabel untuk menyimpan instance SharedPreferences
// late SharedPreferences _sharedPreferences;

// // Tambahkan fungsi inisialisasi
// Future<void> initializeDirectionsHandler() async {
//   _sharedPreferences = await SharedPreferences.getInstance();
// }

// Future<Map> getDirectionsAPIResponse(Point source, int index) async {
//   final destination = Point(
//     coordinates: Position(
//       double.parse(asrama[index]['coordinates']['longitude']),
//       double.parse(asrama[index]['coordinates']['latitude']),
//     ),
//   );

//   final response = await getCyclingRouteUsingMapbox(source, destination);
//   return {
//     "geometry": response['routes'][0]['geometry'],
//     "duration": response['routes'][0]['duration'],
//     "distance": response['routes'][0]['distance'],
//   };
// }

// void saveDirectionsAPIResponse(int index, String response) async {
//   // Pastikan SharedPreferences sudah diinisialisasi jika belum
//   await initializeDirectionsHandler();
//   await _sharedPreferences.setString('asrama--$index', response);
// }
