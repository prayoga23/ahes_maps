import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/jemaah_controller/jadwal_jemaah_controller.dart';
import 'package:ahes_maps/widgets/agenda_card.dart';
import 'package:ahes_maps/widgets/jadwal_keberangkatan_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JadwalJemaahScreen extends StatelessWidget {
  JadwalJemaahScreen({super.key});

  final JadwalJemaahController controller = Get.put(JadwalJemaahController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: RefreshIndicator(
            onRefresh: () async => {
              controller.getAllJadwal(),
              controller.getAllAgenda(),
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200, // Atur tinggi sesuai kebutuhan
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: controller.listJadwal.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 0,
                            right: index == controller.listJadwal.length - 1
                                ? 0
                                : 0,
                          ),
                          child: JadwalCard(
                            rombongan:
                                "${controller.listJadwal[index]['nomor_rombongan']}",
                            tanggal:
                                "${controller.listJadwal[index]['tanggal_keberangkatan']}",
                            waktu:
                                "${controller.listJadwal[index]['jam_keberangkatan']} WIB",
                            status: "${controller.listJadwal[index]['status']}",
                            onEdit: () {},
                            onDelete: () {},
                            isAdmin: false,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text(
                          "Agenda Kegiatan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Hari Ini',
                            style: TextStyle(
                              color: hijauPekat,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.listAgenda.length,
                      itemBuilder: (context, index) {
                        return AgendaCard(
                          namaKegiatan:
                              "${controller.listAgenda[index]['nama_kegiatan']}",
                          tanggal:
                              "${controller.listAgenda[index]['tanggal_kegiatan']}",
                          lokasi:
                              "${controller.listAgenda[index]['lokasi_kegiatan']}",
                          jamAwal:
                              "${controller.listAgenda[index]['jam_awal_kegiatan']}",
                          jamAkhir:
                              "${controller.listAgenda[index]['jam_akhir_kegiatan']}",
                          onEdit: () {},
                          onDelete: () {},
                          isAdmin: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
