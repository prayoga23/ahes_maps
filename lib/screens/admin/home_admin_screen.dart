import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/admin_controller/home_admin_controller.dart';
import 'package:ahes_maps/screens/admin/agenda/agenda_admin_screen.dart';
import 'package:ahes_maps/screens/admin/fasilitas_admin/fasilitas_admin_screen.dart';
import 'package:ahes_maps/screens/admin/jadwal_keberangkatan/jadwal_keberangkatan_admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAdminScreen extends StatelessWidget {
  HomeAdminScreen({super.key});
  final controller = Get.put(HomeAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijauMuda,
        title: Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return Text('Fasilitas');
            case 1:
              return Text('Agenda');
            case 2:
              return Text('Jadwal Keberangkatan');
            default:
              return Text('Home Admin');
          }
        }),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              controller.doLogout(context);
            },
          ),
        ],
      ),
      drawer: Obx(() => SafeArea(
            child: Drawer(
              backgroundColor: hijauMuda,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/image/user_admin.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi Admin',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: putih,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  controller.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: putih,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.close, color: putih),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Menu Admin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: putih,
                      ),
                    ),
                  ),
                  // Fasilitas ListTile
                  AdminMenuItem(
                    index: 0,
                    selectedIndex: controller.selectedIndex.value,
                    icon: Icons.home,
                    title: 'Fasilitas',
                    onTap: () {
                      Get.back();
                      controller.selectIndex(0);
                    },
                  ),
                  AdminMenuItem(
                    index: 1,
                    selectedIndex: controller.selectedIndex.value,
                    icon: Icons.event,
                    title: 'Agenda',
                    onTap: () {
                      Get.back();
                      controller.selectIndex(1);
                    },
                  ),
                  AdminMenuItem(
                    index: 2,
                    selectedIndex: controller.selectedIndex.value,
                    icon: Icons.schedule,
                    title: 'Jadwal Keberangkatan',
                    onTap: () {
                      Get.back();
                      controller.selectIndex(2);
                    },
                  ),

                  SizedBox(height: 20),
                  Divider(
                    height: 1,
                    thickness: 2,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  // LOGOUT BUTTON
                  GestureDetector(
                    onTap: () {
                      controller.doLogout(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: hijauMuda,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            size: 28,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return FasilitasAdminScreen(key: UniqueKey(), isJemaah: false);
          case 1:
            return AgendaAdminScreen(key: UniqueKey());
          case 2:
            return JadwalKeberangkatanAdminScreen(key: UniqueKey());
          default:
            return Center(child: Text('Home Admin Screen'));
        }
      }),
    );
  }
}

class AdminMenuItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AdminMenuItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == selectedIndex;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: isActive
              ? Border.all(color: Colors.black, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
