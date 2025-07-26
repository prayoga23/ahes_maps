import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/admin_controller/jadwal_keberangkatan_admin_controller.dart';
import 'package:ahes_maps/screens/admin/jadwal_keberangkatan/post_jadwal_keberangkatan_screen.dart';
import 'package:ahes_maps/widgets/jadwal_keberangkatan_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class JadwalKeberangkatanAdminScreen extends StatelessWidget {
  JadwalKeberangkatanAdminScreen({super.key});
  final controller = Get.put(JadwalKeberangkatanController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPosting.value) {
        return PostJadwalKeberangkatan();
      } else {
        return RefreshIndicator(
          onRefresh: () => controller.getAllJadwal(),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.listJadwal.length,
                  itemBuilder: (context, index) {
                    return JadwalCard(
                      rombongan:
                          "${controller.listJadwal[index]['nomor_rombongan']}",
                      tanggal:
                          "${controller.listJadwal[index]['tanggal_keberangkatan']}",
                      waktu:
                          "${controller.listJadwal[index]['jam_keberangkatan']} WIB",
                      status: "${controller.listJadwal[index]['status']}",
                      onEdit: () {
                        controller.rombonganController.text =
                            "${controller.listJadwal[index]['nomor_rombongan']}";
                        controller.tanggalController.text =
                            "${controller.listJadwal[index]['tanggal_keberangkatan']}";
                        controller.jamController.text =
                            "${controller.listJadwal[index]['jam_keberangkatan']}";
                        controller.selectedStatus.value =
                            "${controller.listJadwal[index]['status']}";
                        controller.openForm();
                        controller.idJadwal.value =
                            "${controller.listJadwal[index]['id']}";
                        controller.isEditing.value = true;
                      },
                      onDelete: () {
                        PanaraConfirmDialog.show(
                          context,
                          message:
                              "Apakah anda yakin ingin menghapus data ini?",
                          confirmButtonText: "Hapus",
                          cancelButtonText: "Batal",
                          onTapCancel: () {
                            Get.back();
                          },
                          onTapConfirm: () {
                            controller.softDeleteJadwal(
                              "${controller.listJadwal[index]['id']}",
                            );
                          },
                          color: Colors.red,
                          panaraDialogType: PanaraDialogType.custom,
                          barrierDismissible:
                              false, // optional parameter (default is true)
                        );
                      },
                      isAdmin: true,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: controller.openForm,
                  icon: Icon(Icons.add, color: putih, size: 20),
                  label: Text(
                    'Tambah Jadwal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: putih,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    });
  }
}
