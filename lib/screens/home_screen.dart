import 'package:ahes_maps/screens/jadwal.dart';
import 'package:ahes_maps/screens/jadwal_ibadah.dart';
import 'package:ahes_maps/screens/login_screen.dart';
import 'package:ahes_maps/screens/lokasi_fasilitas.dart';
import 'package:ahes_maps/screens/panduan_haji.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ahes Maps'),
        centerTitle: true,
        backgroundColor: Colors.green,
        toolbarHeight: 45,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    color: Color(0xFF004D40),
                    child: Center(
                      child: Image.asset(
                        'assets/icon/logo1.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width - 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Para Jamaah Haji Di Asrama\nHaji Embarkasi Surabaya',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        1.6, // Increased from 1.5 to make cards shorter
                    children: [
                      _buildMenuCard(context, 'Jadwal\nIbadah', Icons.mosque),
                      _buildMenuCard(
                          context,
                          'Jadwal\nKeberangkatan &\nAgenda Kegiatan',
                          Icons.calendar_month),
                      _buildMenuCard(
                          context, 'Lokasi\nFasilitas', Icons.location_on),
                      _buildMenuCard(context, 'Panduan\nHaji', Icons.book),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Berita Terkini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                          child: Image.asset(
                            'assets/image/jadwal.jpg',
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update Jadwal\nKeberangkatan Jamaah Haji 2025',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Informasi terbaru mengenai jadwal keberangkatan jamaah...',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Set to 0 for Home page
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
          if (index == 1) {
            // Jadwal
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JadwalPage()),
            );
          } else if (index == 2) {
            // Peta
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LokasiFasilitasPage()),
            );
          }
          // Add navigation for other tabs as needed
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String label, IconData icon) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (label.contains('Jadwal\nKeberangkatan')) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JadwalPage()),
            );
          } else if (label.contains('Jadwal\nIbadah')) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JadwalIbadahPage()),
            );
          } else if (label.contains('Panduan\nHaji')) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PanduanHajiPage()),
            );
          } else if (label.contains('Lokasi\nFasilitas')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LokasiFasilitasPage()),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.green),
            SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
