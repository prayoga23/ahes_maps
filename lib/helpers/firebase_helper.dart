// import 'package:firebase_installations/firebase_installations.dart';
// import 'package:firebase_core/firebase_core.dart';

// Future<String> getFirebaseInstallationId() async {
//   try {
//     // Using the correct method for the current API version
//     final String id = await FirebaseInstallations().id;
//     print('Firebase Installation ID: $id');
//     return id;
//   } catch (e) {
//     print('Error getting Firebase ID: $e');
//     return '';
//   }
// }

// String getFirebaseAppId() {
//   try {
//     final FirebaseApp app = Firebase.app();
//     final String appId = app.options.appId;
//     print('Firebase App ID: $appId');
//     return appId;
//   } catch (e) {
//     print('Error getting Firebase App ID: $e');
//     return '';
//   }
// }