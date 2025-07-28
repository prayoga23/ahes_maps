import 'dart:convert';

import 'package:ahes_maps/widgets/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FixMapsController extends GetxController {
  var asramaBaru = <Map<String, dynamic>>[].obs;
  var isMapReady = false.obs;

// Core properties
  final Logger _logger = Logger();
  MapboxMap? mapboxMap;
  Rx<Point?> userLocation = Rx<Point?>(null);
  late CameraOptions initialCameraPosition;
  final Location _location = Location();

  // Annotation management
  PointAnnotationManager? _pointAnnotationManager;
  final Map<String, Map<String, dynamic>> _annotationData = {};

  // Carousel data
  RxList<Map<dynamic, dynamic>> carouselData = <Map<dynamic, dynamic>>[].obs;
  RxInt pageIndex = 0.obs;
  RxList<Widget> carouselItems = <Widget>[].obs;
  late List<CameraOptions> asramaLocations;

  // Route drawing
  final String _routeSourceId = 'route-source';
  final String _routeLayerId = 'route-layer';

  @override
  void onInit() {
    getAllFasilitasAndSetupMap();
    super.onInit();
  }

  // --- FUNGSI BARU UNTUK MENGHITUNG SEMUA JARAK ---
  Future<void> _calculateAllDistances() async {
    if (userLocation.value == null || asramaBaru.isEmpty) {
      _logger.w(
          "Lokasi pengguna atau data asrama belum siap untuk perhitungan jarak.");
      return;
    }
    _logger.i("Memulai perhitungan jarak untuk semua asrama...");

    final String? accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];
    if (accessToken == null) {
      _logger.e("Mapbox Access Token not found");
      return;
    }

    final userLng = userLocation.value!.coordinates.lng;
    final userLat = userLocation.value!.coordinates.lat;

    try {
      // Buat daftar future untuk semua request API
      List<Future<void>> distanceFutures = [];

      for (int i = 0; i < asramaBaru.length; i++) {
        final destinationLon = double.parse(asramaBaru[i]['long']);
        final destinationLat = double.parse(asramaBaru[i]['lat']);

        final uri =
            Uri.parse('https://api.mapbox.com/directions/v5/mapbox/driving/'
                '$userLng,$userLat;$destinationLon,$destinationLat'
                '?geometries=geojson&access_token=$accessToken');

        // Tambahkan future ke list
        distanceFutures.add(http.get(uri).then((response) {
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['routes'] != null && data['routes'].isNotEmpty) {
              final distanceInMeters = data['routes'][0]['distance'];
              // Langsung update nilai 'jarak' di dalam map
              asramaBaru[i]['jarak'] = distanceInMeters;
            }
          }
        }).catchError((e) {
          _logger.e(
              "Error menghitung jarak untuk ${asramaBaru[i]['nama_gedung']}: $e");
          asramaBaru[i]['jarak'] = 0.0; // Set nilai default jika gagal
        }));
      }

      // Tunggu semua request selesai
      await Future.wait(distanceFutures);

      // Refresh RxList untuk memastikan UI di-update
      asramaBaru.refresh();
      _logger.i("Semua jarak berhasil dihitung dan diperbarui.");
    } catch (e) {
      _logger.e("Error dalam _calculateAllDistances: $e");
    }
  }

  void _initializeMapData() {
    final defaultLat = double.parse(asramaBaru.first['long']);
    final defaultLon = double.parse(asramaBaru.first['lat']);

    initialCameraPosition = CameraOptions(
      center: Point(coordinates: Position(defaultLon, defaultLat)),
      zoom: 15,
    );

    asramaLocations = List<CameraOptions>.generate(
      asramaBaru.length,
      (index) {
        final lon = double.parse(asramaBaru[index]['long']);
        final lat = double.parse(asramaBaru[index]['lat']);
        return CameraOptions(
          center: Point(coordinates: Position(lon, lat)),
          zoom: 15,
        );
      },
    );
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      PermissionStatus permission = await _location.requestPermission();
      if (permission == PermissionStatus.denied) {
        _showPermissionDeniedDialog();
        return;
      }

      if (permission == PermissionStatus.deniedForever) {
        _showPermissionPermanentlyDeniedDialog();
        return;
      }

      _getUserLocation();
    } catch (e) {
      _logger.e("Error checking location permission: $e");
    }
  }

  Future<void> _getUserLocation() async {
    try {
      _logger.i("Fetching user location...");
      final locationData = await _location.getLocation();
      _logger.i(
          "User location: ${locationData.longitude}, ${locationData.latitude}");

      userLocation.value = Point(
        coordinates: Position(locationData.longitude!, locationData.latitude!),
      );

      if (mapboxMap != null && userLocation.value != null) {
        mapboxMap!.flyTo(
          CameraOptions(center: userLocation.value!, zoom: 15),
          MapAnimationOptions(duration: 1000),
        );
      }
    } catch (e) {
      _logger.e("Error getting user location: $e");
      Get.snackbar(
        'Error',
        'Gagal mendapatkan lokasi saat ini',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showLocationServiceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Layanan Lokasi Dinonaktifkan'),
        content: const Text(
            'Aplikasi memerlukan akses ke layanan lokasi. Mohon aktifkan GPS Anda.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _location.requestService();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Izin Lokasi Ditolak'),
        content: const Text(
            'Aplikasi memerlukan izin lokasi untuk menampilkan posisi Anda di peta.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Izin Lokasi Ditolak'),
        content: const Text(
            'Izin lokasi ditolak secara permanen. Silakan aktifkan di pengaturan aplikasi.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _location.requestPermission();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  /// MAP SETUP
  void onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    if (isMapReady.value) {
      _setupMap();
    }
  }

  Future<void> _setupMap() async {
    if (mapboxMap == null) return;

    try {
      // Create annotation manager
      _pointAnnotationManager =
          await mapboxMap!.annotations.createPointAnnotationManager();

      // Add asrama markers
      for (int i = 0; i < asramaBaru.length; i++) {
        await _addAsramaMarker(i);
      }

      // Enable location component
      await mapboxMap!.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
          pulsingColor: Colors.green.toARGB32(),
          showAccuracyRing: true,
        ),
      );

      // Add click listener for annotations
      _pointAnnotationManager!.addOnPointAnnotationClickListener(
          _PointAnnotationClickListener(onClick: (annotation) {
        final annotationData = _annotationData[annotation.id];
        if (annotationData != null && annotationData['index'] != null) {
          _drawRoute(annotationData['index'] as int);
        }
        return true;
      }));

      // Draw route to first asrama
      addSourceAndLineLayer(0, false);
    } catch (e) {
      _logger.e("Error setting up map: $e");
    }
  }

  Future<void> _addAsramaMarker(int index) async {
    if (_pointAnnotationManager == null) return;

    try {
      final lon = double.parse(asramaBaru[index]['long']);
      final lat = double.parse(asramaBaru[index]['lat']);

      // Determine icon based on facility name
      String iconPath = "assets/icon/bed.png"; // Default icon for accommodation buildings
      final namaGedung = asramaBaru[index]['nama_gedung'].toString().toLowerCase();
      
      // Icon mapping based on facility type
      if (namaGedung.contains('masjid')) {
        iconPath = "assets/icon/mosque.png"; // Mosque icon for prayer facilities
      } else if (namaGedung.contains('hall mina') || namaGedung.contains('mina')) {
        iconPath = "assets/icon/bed.png"; // Bed icon for Hall Mina accommodation
      } else if (namaGedung.contains('muzdalifah') || namaGedung.contains('muzdhalifah')) {
        iconPath = "assets/icon/bed.png"; // Bed icon for Muzdalifah accommodation
      } else if (namaGedung.contains('zam-zam') || namaGedung.contains('zamzam')) {
        iconPath = "assets/icon/bed.png"; // Bed icon for Zam-Zam accommodation
      } else if (namaGedung.contains('klinik') || namaGedung.contains('kesehatan')) {
        iconPath = "assets/icon/bed.png"; // Default icon for clinic (can be replaced with clinic.png)
      } else if (namaGedung.contains('kantin') || namaGedung.contains('makan')) {
        iconPath = "assets/icon/bed.png"; // Default icon for dining (can be replaced with dining.png)
      } else if (namaGedung.contains('toilet') || namaGedung.contains('wc')) {
        iconPath = "assets/icon/bed.png"; // Default icon for toilet (can be replaced with toilet.png)
      }
      // For future: Add more specific icons like dining.png, clinic.png, toilet.png, etc.
      
      _logger.i("Using icon: $iconPath for facility: ${asramaBaru[index]['nama_gedung']}");

      // Load icon image with fallback
      Uint8List iconImage;
      try {
        final ByteData bytes = await rootBundle.load(iconPath);
        iconImage = bytes.buffer.asUint8List();
      } catch (e) {
        _logger.e("Error loading icon $iconPath: $e, using fallback");
        final ByteData bytes = await rootBundle.load("assets/icon/bed.png");
        iconImage = bytes.buffer.asUint8List();
      }

      // Create point annotation
      final options = PointAnnotationOptions(
        geometry: Point(coordinates: Position(lon, lat)),
        iconSize: 0.5,
        image: iconImage,
        textField: asramaBaru[index]['nama_gedung'],
        textOffset: [0, 1.5],
        textColor: 0xFF000000,
        textSize: 12.0,
        textHaloColor: 0xFFFFFFFF,
        textHaloWidth: 1.0,
      );

      final annotation = await _pointAnnotationManager!.create(options);

      // Store annotation data
      _annotationData[annotation.id] = {
        'index': index,
        'name': asramaBaru[index]['nama_gedung'],
      };
    } catch (e) {
      _logger.e("Error adding asrama marker: $e");
    }
  }

  /// ROUTE HANDLING
  Future<void> addSourceAndLineLayer(int index, bool removeLayer) async {
    if (mapboxMap == null) return;

    // Fly to selected asrama
    mapboxMap!.flyTo(
      asramaLocations[index],
      MapAnimationOptions(duration: 1000),
    );

    await _drawRoute(index);
  }

  Future<void> _drawRoute(int destinationIndex) async {
    //_user location log
    _logger.i("User location: ${userLocation.value?.coordinates}, "
        "Destination: ${asramaBaru[destinationIndex]['long']}, "
        "${asramaBaru[destinationIndex]['lat']}");
    if (mapboxMap == null) return;
    if (userLocation.value == null) {
      await _getUserLocation();
      if (userLocation.value == null) return;
    }

    final String? accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];
    if (accessToken == null) {
      _logger.e("Mapbox Access Token not found");
      return;
    }

    final destinationLon = double.parse(asramaBaru[destinationIndex]['long']);
    final destinationLat = double.parse(asramaBaru[destinationIndex]['lat']);

    final uri = Uri.parse('https://api.mapbox.com/directions/v5/mapbox/driving/'
        '${userLocation.value!.coordinates.lng},${userLocation.value!.coordinates.lat};'
        '$destinationLon,$destinationLat'
        '?geometries=geojson&access_token=$accessToken');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          // Optional: Update lagi jaraknya jika diperlukan, tapi seharusnya sudah ada.
          final distanceInMeters = data['routes'][0]['distance'];
          if (asramaBaru[destinationIndex]['jarak'] == null ||
              asramaBaru[destinationIndex]['jarak'] == 0.0) {
            asramaBaru[destinationIndex]['jarak'] = distanceInMeters;
            asramaBaru.refresh();
          }

          final routeGeometry = data['routes'][0]['geometry'];
          await _removeRouteLayer();
          await mapboxMap!.style.addSource(GeoJsonSource(
              id: _routeSourceId,
              data: jsonEncode({
                'type': 'Feature',
                'properties': {},
                'geometry': routeGeometry
              })));

          await mapboxMap!.style.addLayer(LineLayer(
            id: _routeLayerId,
            sourceId: _routeSourceId,
            lineColor: Colors.blue.toARGB32(),
            lineWidth: 5.0,
            lineOpacity: 0.8,
            lineJoin: LineJoin.ROUND,
            lineCap: LineCap.ROUND,
          ));
        }
      }
    } catch (e) {
      _logger.e("Error drawing route: $e");
    }
  }

  Future<void> _removeRouteLayer() async {
    if (mapboxMap == null) return;

    try {
      bool layerExists = await mapboxMap!.style.styleLayerExists(_routeLayerId);
      if (layerExists) {
        await mapboxMap!.style.removeStyleLayer(_routeLayerId);
      }

      bool sourceExists =
          await mapboxMap!.style.styleSourceExists(_routeSourceId);
      if (sourceExists) {
        await mapboxMap!.style.removeStyleSource(_routeSourceId);
      }
    } catch (e) {
      _logger.e("Error removing route layer: $e");
    }
  }

  // Zoom controls
  Future<void> zoomIn() async {
    if (mapboxMap != null) {
      final cameraState = await mapboxMap!.getCameraState();
      mapboxMap!.flyTo(
        CameraOptions(
          zoom: cameraState.zoom + 1,
          center: cameraState.center,
        ),
        MapAnimationOptions(duration: 300),
      );
    }
  }

  Future<void> zoomOut() async {
    if (mapboxMap != null) {
      final cameraState = await mapboxMap!.getCameraState();
      mapboxMap!.flyTo(
        CameraOptions(
          zoom: cameraState.zoom - 1,
          center: cameraState.center,
        ),
        MapAnimationOptions(duration: 300),
      );
    }
  }

  // Point annotation click listener
  Future<void> getAllFasilitas() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('fasilitas')
          .where('deleted', isEqualTo: false)
          .orderBy('created_date', descending: true)
          .get();
      asramaBaru.value = snapshot.docs.map((doc) => doc.data()).toList();
      print(asramaBaru);
      asramaBaru.refresh();
    } catch (e) {
      ToastMessage.showError(
          Get.context!, 'Gagal mengambil data fasilitas: $e');
    }
  }

  Future<void> getAllFasilitasAndSetupMap() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('fasilitas')
          .where('deleted', isEqualTo: false)
          .orderBy('created_date', descending: true)
          .get();

      final data = snapshot.docs.map((doc) {
        var docData = doc.data();
        docData['jarak'] = 0.0;
        return docData;
      }).toList();

      asramaBaru.assignAll(data);

      if (asramaBaru.isNotEmpty) {
        await _checkLocationPermission();
        await _getUserLocation();

        await _calculateAllDistances();

        _initializeMapData();
        isMapReady.value = true;
      } else {
        _logger.w("Tidak ada data fasilitas yang ditemukan.");
        isMapReady.value = true; // Tetap set true agar tidak loading terus
        Get.snackbar('Info', 'Tidak ada data asrama yang bisa ditampilkan.');
      }
    } catch (e) {
      isMapReady.value = false;
      ToastMessage.showError(
          Get.context!, 'Gagal mengambil data fasilitas: $e');
      _logger.e("Error di getAllFasilitasAndSetupMap: $e");
    }
  }

  void centerOnUser() async {
    if (userLocation.value != null) {
      mapboxMap?.flyTo(
        CameraOptions(center: userLocation.value!, zoom: 15),
        MapAnimationOptions(duration: 1000),
      );
    } else {
      _getUserLocation();
    }
  }

// navigate and launch to google maps
  Future<void> navigateToGoogleMaps() async {
    if (userLocation.value == null) {
      _getUserLocation();
      return;
    }

    final destination = asramaBaru[pageIndex.value];
    final lat = destination['lat'];
    final long = destination['long'];
    // log all param
    _logger.i(
        "Navigating to Google Maps with user location: ${userLocation.value!.coordinates.lat}, "
        "Destination: $lat, $long");
    final url =
        'https://www.google.com/maps/dir/${userLocation.value!.coordinates.lat},${userLocation.value!.coordinates.lng}/$lat,$long/?travelmode=driving';

    try {
      final canLaunch = await canLaunchUrlString(url);
      if (canLaunch) {
        await launchUrlString(url,
            mode: LaunchMode
                .externalApplication); // Prefer external application for maps
      } else {
        ToastMessage.showError(Get.context!, 'Tidak dapat membuka Google Maps');
      }
    } catch (e) {
      ToastMessage.showError(
          Get.context!, 'Terjadi kesalahan saat meluncurkan Google Maps: $e');
    }
  }

  @override
  void onClose() {
    asramaBaru.clear();
  }
}

class _PointAnnotationClickListener extends OnPointAnnotationClickListener {
  final bool Function(PointAnnotation) onClick;

  _PointAnnotationClickListener({required this.onClick});

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    return onClick(annotation);
  }
}
