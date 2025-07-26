import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/jemaah_controller/fix_maps_controller.dart';
import 'package:ahes_maps/widgets/carousel_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:ahes_maps/screens/new_home_screen/ar_screen.dart';

class FixMapsScreen extends StatelessWidget {
  FixMapsScreen({super.key});

  final controller = Get.put(FixMapsController());
  Widget _buildControlButton({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: putih),
        title: Text(
          'Ahes Maps',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: putih,
          ),
        ),
        centerTitle: true,
        backgroundColor: hijauMuda,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: FasilitasSearchDelegate(controller),
              );
              if (result != null) {
                // Pindahkan kamera mapbox ke lokasi fasilitas
                controller.mapboxMap?.flyTo(
                  CameraOptions(
                    center: Point(
                      coordinates: Position(
                        double.parse(result['long']),
                        double.parse(result['lat']),
                      ),
                    ),
                    zoom: 17,
                  ),
                  MapAnimationOptions(duration: 1000),
                );
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              Get.offAllNamed('/login');
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.isMapReady.value) {
          // Tampilkan loading indicator selama data belum siap
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SafeArea(
            child: Stack(
              children: [
                // Map
                MapWidget(
                  key: const ValueKey("mapWidget"),
                  mapOptions: MapOptions(
                    pixelRatio: MediaQuery.of(context).devicePixelRatio,
                  ),
                  cameraOptions: controller.initialCameraPosition,
                  onMapCreated: controller.onMapCreated,
                  styleUri: MapboxStyles.MAPBOX_STREETS,
                  // adding location me
                ),
                // Carousel
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Obx(
                    // Obx ini akan bereaksi ketika nilai 'jarak' di asramaBaru berubah
                    () => CarouselSlider(
                      items: controller.asramaBaru.map((item) {
                        // pastikan untuk menghandle nilai null atau 0 dengan baik
                        final jarakValue = item['jarak'] ?? 0.0;
                        return carouselCard(
                          context,
                          item['nama_gedung'] ?? 'Tanpa Nama',
                          item['gambar'] ?? 'https://via.placeholder.com/150',
                          jarakValue.toString(),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 90,
                        viewportFraction: 0.6,
                        initialPage: controller.pageIndex.value,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, _) {
                          controller.pageIndex.value = index;
                          controller.addSourceAndLineLayer(index, true);
                        },
                      ),
                    ),
                  ),
                ),
                // Tombol AR khusus Gedung Muzdhalifah
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 70, // Atur posisi agar tidak menumpuk tombol lain
                  child: Obx(() {
                    final selectedItem = controller.asramaBaru[controller.pageIndex.value];
                    final namaGedung = selectedItem['nama_gedung'] ?? '';
                    if (namaGedung.toString().toUpperCase() == "GEDUNG MUZDHALIFAH") {
                      return ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to WebAR screen
                          Navigator.of(context).pushNamed('/webAR');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.view_in_ar, size: 24),
                        label: const Text(
                          'AR Gedung Muzdhalifah',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ),
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(230),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Zoom in
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: controller.zoomIn,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                        const Divider(height: 1, thickness: 1),
                        // Zoom out
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: controller.zoomOut,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),

                // My Location button
                Positioned(
                  right: MediaQuery.of(context).size.width * 0.06,
                  bottom: MediaQuery.of(context).size.height * 0.27,
                  child: Column(
                    children: [
                      _buildControlButton(
                        icon: Icons.my_location,
                        backgroundColor: Colors.green,
                        iconColor: Colors.white,
                        onPressed: controller.centerOnUser,
                      ),
                      const SizedBox(height: 8),
                      _buildControlButton(
                        icon: Icons.view_in_ar,
                        backgroundColor: Colors.green,
                        iconColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/webAR');
                        },
                      ),
                    //   _buildControlButton(
                    //   icon: Icons.view_in_ar,
                    //   backgroundColor: Colors.green,
                    //   iconColor: Colors.white,
                    //   onPressed: () {
                    //     Get.to(() => const ARNavigationScreen());
                    //   },
                    // ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      // Tombol Rute
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.navigateToGoogleMaps();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1ED760),
                            foregroundColor: Colors.white,
                            shape:
                                const StadiumBorder(), // Membuat bentuk tombol menjadi pill/kapsul
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.navigation, size: 24),
                          label: const Text(
                            'Mulai Rute',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12), // Memberi spasi antar tombol

                      // Tombol Mulai AR
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to WebAR screen
                            Navigator.of(context).pushNamed('/webAR');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1ED760),
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.view_in_ar, size: 24),
                          label: const Text(
                            'Mulai AR',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

class FasilitasSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  final FixMapsController controller;
  FasilitasSearchDelegate(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = controller.asramaBaru.where((fasilitas) {
      final nama = (fasilitas['nama_gedung'] ?? '').toString().toLowerCase();
      return nama.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(child: Text('Fasilitas tidak ditemukan.'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final fasilitas = results[index];
        return ListTile(
          title: Text(fasilitas['nama_gedung'] ?? '-'),
          subtitle: Text('Lat: ${fasilitas['lat']}, Long: ${fasilitas['long']}'),
          onTap: () => close(context, fasilitas),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
