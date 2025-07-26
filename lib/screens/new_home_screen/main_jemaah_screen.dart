import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/jemaah_controller/main_jemaah_controller.dart';
import 'package:ahes_maps/screens/new_home_screen/home_jemaah_screen.dart';
import 'package:ahes_maps/screens/new_home_screen/jadwal_jemaah_screen.dart';
import 'package:ahes_maps/screens/new_home_screen/peta_jemaah_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainJemaahScreen extends StatelessWidget {
  MainJemaahScreen({super.key});

  final MainJemaahController mainController = Get.put(MainJemaahController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
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
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                mainController.doLogout();
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: mainController.currentIndex.value,
          children: [
            HomeJemaahScreen(),
            JadwalJemaahScreen(),
            PetaJemaahScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: mainController.currentIndex.value,
          onTap: mainController.changePage,
          selectedItemColor: hijauUtama,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
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
        ),
      );
    });
  }
}
