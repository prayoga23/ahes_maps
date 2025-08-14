import 'package:ahes_maps/controller/admin_controller/fasilitas_admin_controller.dart';
import 'package:ahes_maps/screens/admin/fasilitas_admin/post_fasilitas_screen.dart';
import 'package:ahes_maps/screens/web_ar_screen.dart';
import 'package:ahes_maps/screens/new_home_screen/fix_maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class FasilitasAdminScreen extends StatelessWidget {
  final bool isJemaah;
  FasilitasAdminScreen({super.key, required this.isJemaah});
  final controller = Get.put(FasilitasController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPostingDataScreen.value) {
        return PostFasilitasScreen();
      } else {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.getAllFasilitas();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: (value) => {
                    controller.keyword.value = value,
                    controller.getAllFasilitas()
                  },
                  decoration: InputDecoration(
                    hintText: "Cari Lokasi Gedung Anda...",
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    suffixIcon: controller.keyword.value != ''
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.searchController.clear();
                              controller.keyword.value = '';
                              controller.getAllFasilitas();
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.listFasilitas.length,
                  itemBuilder: (context, index) {
                    final fasilitas = controller.listFasilitas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              fasilitas['gambar'],
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
                                  fasilitas['nama_gedung'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  fasilitas['deskripsi'],
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Text("Jarak Lokasi: ${fasilitas['jarak']} km"),
                                Visibility(
                                  visible: !isJemaah,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.orange),
                                        onPressed: () {
                                          controller.namaGedungController.text =
                                              fasilitas['nama_gedung'];
                                          controller.deskripsiController.text =
                                              fasilitas['deskripsi'];
                                          controller.longController.text =
                                              fasilitas['long'];
                                          controller.latController.text =
                                              fasilitas['lat'];
                                          controller.openForm();
                                          controller.isEditing.value = true;
                                          controller.idFasilitas.value =
                                              fasilitas['id'];
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
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
                                              controller.onDeleteFasilitas(
                                                  fasilitas['id']);
                                            },
                                            color: Colors.red,
                                            panaraDialogType:
                                                PanaraDialogType.custom,
                                            barrierDismissible:
                                                false, // optional parameter (default is true)
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isJemaah,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => FixMapsScreen());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.navigation,
                                                color: Colors.purple),
                                            SizedBox(width: 8),
                                            Text('Route',
                                                style: TextStyle(
                                                    color: Colors.purple)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => WebARScreen());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.view_in_ar,
                                                color: Colors.purple),
                                            SizedBox(width: 8),
                                            Text('AR',
                                                style: TextStyle(
                                                    color: Colors.purple)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: !isJemaah,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: controller.openForm,
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    label: const Text(
                      'Tambah Fasilitas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                ),
              )
            ],
          ),
        );
      }
    });
  }
}
