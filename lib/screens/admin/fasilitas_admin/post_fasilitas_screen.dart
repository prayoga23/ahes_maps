import 'dart:io';

import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/admin_controller/fasilitas_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostFasilitasScreen extends StatelessWidget {
  PostFasilitasScreen({super.key});
  final controller = Get.find<FasilitasController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          controller.closeForm();
                        },
                        child: const Center(
                          child: Icon(Icons.arrow_back, size: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.isEditing.value
                        ? "Edit Data Fasilitas"
                        : "Tambah Data Fasilitas",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Nama Bangunan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.namaGedungController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.home, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Masukkan Nama Bangunan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Longitude",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.longController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.explore, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Masukkan Longitude",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text("Latitude",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.latController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.explore, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Masukkan Latitude",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text("Deskripsi",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Masukkan Deskripsi Fasilitas",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              const Text("Gambar Fasilitas",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: Obx(() {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      image: controller.selectedImagePath.value != null
                          ? DecorationImage(
                              image: FileImage(
                                File(controller.selectedImagePath.value!),
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Colors.grey.shade100,
                    ),
                    child: controller.selectedImagePath.value == null
                        ? const Center(child: Icon(Icons.add_a_photo))
                        : null,
                  );
                }),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Simpan data fasilitas, lalu baru upload gambar jika ada
                    if (controller.isEditing.value) {
                      controller
                          .updateDataFasilitas(controller.idFasilitas.value);
                    } else {
                      controller.postFasilitas();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    return Text(
                      controller.isEditing.value ? "UPDATE" : "SIMPAN",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
