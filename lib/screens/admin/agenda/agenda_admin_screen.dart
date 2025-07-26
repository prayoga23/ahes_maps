import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/admin_controller/agenda_admin_controller.dart';
import 'package:ahes_maps/screens/admin/agenda/post_agenda_admin_screen.dart';
import 'package:ahes_maps/widgets/agenda_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class AgendaAdminScreen extends StatelessWidget {
  AgendaAdminScreen({super.key});
  final controller = Get.put(AgendaController()); //

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPostData.value) {
        return PostAgenda();
      } else {
        return RefreshIndicator(
          onRefresh: () => controller.getAllAgenda(),
          child: Column(
            children: [
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
                      onEdit: () {
                        controller.namaKegiatanController.text =
                            "${controller.listAgenda[index]['nama_kegiatan']}";
                        controller.tanggalKegiatanController.text =
                            "${controller.listAgenda[index]['tanggal_kegiatan']}";
                        controller.lokasiKegiatanController.text =
                            "${controller.listAgenda[index]['lokasi_kegiatan']}";
                        controller.jamAwalKegiatanController.text =
                            "${controller.listAgenda[index]['jam_awal_kegiatan']}";
                        controller.jamAkhirKegiatanController.text =
                            "${controller.listAgenda[index]['jam_akhir_kegiatan']}";
                        controller.openForm();
                        controller.idAgenda.value =
                            "${controller.listAgenda[index]['id']}";
                        controller.isEditData.value = true;
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
                            controller.softDeleteAgenda(
                              "${controller.listAgenda[index]['id']}",
                            );
                          },
                          color: Colors.red,
                          panaraDialogType: PanaraDialogType.custom,
                          barrierDismissible:
                              false, // optional parameter (default is true)
                        );
                      },
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
                    'Tambah Agenda',
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
