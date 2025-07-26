// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ARScreen extends StatefulWidget {
//   final Map<String, dynamic> targetLocation; // Data asrama yang dipilih

//   const ARScreen({super.key, required this.targetLocation});

//   @override
//   State<ARScreen> createState() => _ARScreenState();
// }

// class _ARScreenState extends State<ARScreen> {
//   late ARSessionManager arSessionManager;
//   late ARObjectManager arObjectManager;
//   late ARLocationManager arLocationManager;
  
//   Position? _currentPosition;
//   StreamSubscription<Position>? _positionStreamSubscription;
//   double _distance = 0.0;
//   double _bearing = 0.0;
//   bool _isNavigating = false;
//   String _navigationStatus = "Siap untuk navigasi";
  
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//   }
  
//   @override
//   void dispose() {
//     _positionStreamSubscription?.cancel();
//     try {
//       // Cek apakah arSessionManager sudah diinisialisasi
//       // dengan menggunakan Dart's late variable initialization check
//       final sessionManager = arSessionManager;
//       sessionManager.dispose();
//     } catch (e) {
//       // Tangani error jika arSessionManager belum diinisialisasi
//       print("Error disposing AR session: $e");
//     }
//     super.dispose();
//   }
  
//   Future<void> _requestPermissions() async {
//     await [Permission.location, Permission.camera].request();
//     await _getCurrentLocation();
//   }
  
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high
//       );
//       setState(() {
//         _currentPosition = position;
//         _updateNavigationInfo();
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
  
//   void _startLocationTracking() {
//     _positionStreamSubscription = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 5, // Update every 5 meters
//       )
//     ).listen((Position position) {
//       setState(() {
//         _currentPosition = position;
//         _updateNavigationInfo();
//       });
//     });
//   }
  
//   void _updateNavigationInfo() {
//     if (_currentPosition != null) {
//       final targetLat = double.parse(widget.targetLocation['coordinates']['latitude']);
//       final targetLon = double.parse(widget.targetLocation['coordinates']['longitude']);
      
//       // Calculate distance
//       _distance = Geolocator.distanceBetween(
//         _currentPosition!.latitude,
//         _currentPosition!.longitude,
//         targetLat,
//         targetLon
//       );
      
//       // Calculate bearing
//       _bearing = Geolocator.bearingBetween(
//         _currentPosition!.latitude,
//         _currentPosition!.longitude,
//         targetLat,
//         targetLon
//       );
      
//       // Update navigation status
//       if (_distance < 10) {
//         _navigationStatus = "Anda telah sampai di tujuan!";
//       } else {
//         _navigationStatus = "Jarak ke tujuan: ${_distance.toStringAsFixed(0)} meter";
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final gedung = widget.targetLocation;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AR Navigation'),
//         backgroundColor: Colors.green,
//       ),
//       body: Stack(
//         children: [
//           ARView(
//             onARViewCreated: onARViewCreated,
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             right: 16,
//             child: Card(
//               child: ListTile(
//                 leading: Image.asset(gedung['image'], width: 56, height: 56, fit: BoxFit.cover),
//                 title: Text(gedung['name']),
//                 subtitle: Text(_navigationStatus),
//                 trailing: IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 40,
//             left: 16,
//             right: 16,
//             child: Column(
//               children: [
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           "Jarak: ${_distance.toStringAsFixed(0)} meter",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Arah: ${_getBearingDirection(_bearing)}",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _isNavigating ? Colors.red : Colors.green,
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isNavigating = !_isNavigating;
//                       if (_isNavigating) {
//                         _startLocationTracking();
//                       } else {
//                         _positionStreamSubscription?.cancel();
//                       }
//                     });
//                   },
//                   child: Text(
//                     _isNavigating ? "Berhenti Navigasi" : "Mulai Navigasi",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   String _getBearingDirection(double bearing) {
//     const directions = ["Utara", "Timur Laut", "Timur", "Tenggara", "Selatan", "Barat Daya", "Barat", "Barat Laut"];
//     int index = ((bearing + 22.5) % 360 / 45).floor();
//     return directions[index];
//   }

//   void onARViewCreated(
//     ARSessionManager arSessionManager,
//     ARObjectManager arObjectManager,
//     ARAnchorManager arAnchorManager,
//     ARLocationManager arLocationManager,
//   ) async {
//     this.arSessionManager = arSessionManager;
//     this.arObjectManager = arObjectManager;
//     this.arLocationManager = arLocationManager;

//     // Inisialisasi AR session
//     await arSessionManager.onInitialize();
    
//     // Aktifkan deteksi plane jika diperlukan
//     // await arSessionManager.enablePlaneDetection();

//     final targetLat = double.parse(widget.targetLocation['coordinates']['latitude']);
//     final targetLon = double.parse(widget.targetLocation['coordinates']['longitude']);

//     // Tambahkan marker tujuan (map_pointer.glb)
//     await arObjectManager.addNode(ARNode(
//       type: NodeType.localGLTF2,
//       uri: "assets/3d/map_pointer.glb",
//       scale: vector.Vector3(1.0, 1.0, 1.0),
//       position: vector.Vector3(0, 0, -1.0), // Posisi 1 meter di depan pengguna
//     ));
    
//     // Tambahkan panah penunjuk arah (arrow.glb)
//     if (_currentPosition != null) {
//       await arObjectManager.addNode(ARNode(
//         type: NodeType.localGLTF2,
//         uri: "assets/3d/arrow.glb",
//         scale: vector.Vector3(0.5, 0.5, 0.5),
//         position: vector.Vector3(0, 0.5, -2.0), // Posisi 2 meter di depan pengguna, sedikit di atas tanah
//         rotation: vector.Vector3(0, _bearing, 0), // Rotasi sesuai arah tujuan
//       ));
//     }
    
//     // Atur handler untuk update AR view
//     arSessionManager.onUpdate = _onARSessionUpdate;
//   }
  
//   void _onARSessionUpdate() {
//     // Update AR view sesuai dengan perubahan lokasi dan orientasi
//     if (_isNavigating && _currentPosition != null) {
//       // Logika update AR view dapat ditambahkan di sini
//       // Misalnya, memperbarui posisi atau rotasi objek AR
//     }
//   }
// }