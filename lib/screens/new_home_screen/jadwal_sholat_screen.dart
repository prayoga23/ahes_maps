import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/jemaah_controller/jadwal_sholat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JadwalSholatScreen extends StatelessWidget {
  JadwalSholatScreen({super.key});
  final JadwalSholatController controller = Get.put(JadwalSholatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hijauMuda,
      appBar: AppBar(
        title: Text('Jadwal Sholat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: putih,
            )),
        backgroundColor: hijauMuda,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: putih),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.22,
            width: double.infinity,
            decoration: BoxDecoration(
              color: hijauMuda,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: putih),
                  SizedBox(width: 10),
                  Text(
                    'Surabaya, Jawa Timur',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: putih,
                    ),
                  ),
                  SizedBox(width: 20),
                  // SimpleCircularProgressBar(
                  //   progressColors: const [Colors.cyan],
                  // )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: putih,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: putih,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: hijauMuda,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                size: 30,
                              ),
                              onPressed: () {
                                controller.minOneDay();
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectDate(context);
                                },
                                child: Center(
                                  child: Obx(() => Text(
                                        controller.tanggalController.value,
                                        style: TextStyle(fontSize: 16),
                                      )),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                size: 30,
                              ),
                              onPressed: () {
                                controller.addOneDay();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            _buildPrayerTimeCard(
                              'Subuh',
                              controller
                                      .jadwalSholatModel?.data?.jadwal?.subuh ??
                                  '00:00',
                              Icons.access_alarm,
                            ),
                            _buildPrayerTimeCard(
                              'Dzuhur',
                              controller.jadwalSholatModel?.data?.jadwal
                                      ?.dzuhur ??
                                  '00:00',
                              Icons.access_alarm,
                            ),
                            _buildPrayerTimeCard(
                              'Ashar',
                              controller
                                      .jadwalSholatModel?.data?.jadwal?.ashar ??
                                  '00:00',
                              Icons.access_alarm,
                            ),
                            _buildPrayerTimeCard(
                              'Maghrib',
                              controller.jadwalSholatModel?.data?.jadwal
                                      ?.maghrib ??
                                  '00:00',
                              Icons.access_alarm,
                            ),
                            _buildPrayerTimeCard(
                              'Isya',
                              controller
                                      .jadwalSholatModel?.data?.jadwal?.isya ??
                                  '00:00',
                              Icons.access_alarm,
                            ),
                          ],
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPrayerTimeCard(String name, String time, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
