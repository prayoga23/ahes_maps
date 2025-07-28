import 'package:flutter/material.dart';
import '../models/fasilitas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'facility_ar_screen.dart';

class LokasiFasilitasPage extends StatefulWidget {
  const LokasiFasilitasPage({super.key});

  @override
  State<LokasiFasilitasPage> createState() => _LokasiFasilitasPageState();
}

class _LokasiFasilitasPageState extends State<LokasiFasilitasPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Fasilitas> _fasilitasList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFasilitas();
  }

  Future<void> _loadFasilitas() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('fasilitas').get();
      setState(() {
        _fasilitasList = snapshot.docs
            .map((doc) => Fasilitas.fromJson(doc.data()))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal Mengambil data dari Fasilitas';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Ahes Maps'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cari Gedung, Kamar, Dan Fasilitas Lain',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari Lokasi Gedung Anda...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: _fasilitasList.length,
                        itemBuilder: (context, index) {
                          final fasilitas = _fasilitasList[index];
                          return _buildFacilityCard(
                            fasilitas.title,
                            fasilitas.description,
                            fasilitas.distance,
                            fasilitas.imagePath,
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Set to 2 for Peta
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Peta',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildFacilityCard(
      String title, String description, String distance, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jarak Lokasi : $distance',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildActionButton(
                        'Rute', 
                        Icons.navigation,
                        Colors.purple[100]!, 
                        Colors.purple,
                        title,
                        imagePath,
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        'AR', 
                        Icons.view_in_ar,
                        Colors.blue[100]!, 
                        Colors.blue,
                        title,
                        imagePath,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color bgColor, Color iconColor, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (label == 'AR') {
          _openARNavigation(title, imagePath);
        } else if (label == 'Rute') {
          // Implementasi rute normal dapat ditambahkan di sini
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _openARNavigation(String title, String imagePath) {
    // Cari fasilitas yang sesuai dengan title
    Fasilitas? selectedFasilitas;
    for (var fasilitas in _fasilitasList) {
      if (fasilitas.title == title) {
        selectedFasilitas = fasilitas;
        break;
      }
    }
    
    // Koordinat default berdasarkan title
    String latitude = '-7.28526975568221';
    String longitude = '112.778024470646';
    
    // Mapping koordinat berdasarkan nama fasilitas
    if (title.contains('Zam-zam') || title.contains('Zam-zam')) {
      latitude = '-7.28526975568221';
      longitude = '112.778024470646';
    } else if (title.contains('Mina') || title.contains('Hall Mina')) {
      latitude = '-7.284952331606736';
      longitude = '112.77897043496384';
    } else if (title.contains('Muzdalifah')) {
      latitude = '-7.2852341338859725';
      longitude = '112.77900526197112';
    } else if (title.contains('Masjid')) {
      latitude = '-7.282747114926446';
      longitude = '112.77830549612212';
    }
    
    // Data lokasi untuk AR Navigation
    final targetLocation = {
      'id': selectedFasilitas?.title ?? '0',
      'name': title,
      'image': imagePath,
      'coordinates': {
        'latitude': latitude,
        'longitude': longitude,
      }
    };
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FacilityARScreen(facility: targetLocation),
      ),
    );
  }
}
