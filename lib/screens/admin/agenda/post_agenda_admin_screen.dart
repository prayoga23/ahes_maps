import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/admin_controller/agenda_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostAgenda extends StatelessWidget {
  PostAgenda({super.key});
  final controller = Get.find<AgendaController>();

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
                          controller.clearForm();
                        },
                        child: const Center(
                          child: Icon(Icons.arrow_back, size: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.isEditData.value
                        ? "Edit Data Agenda"
                        : "Tambah Data Agenda",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Nama Kegiatan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.namaKegiatanController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.local_activity, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Masukkan Nama Kegiatan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Lokasi Kegiatan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.lokasiKegiatanController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.location_city, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Masukkan Lokasi Kegiatan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Tanggal Kegiatan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.tanggalKegiatanController,
                readOnly: true,
                onTap: () => controller.selectDate(context),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.date_range, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Pilih Tanggal Kegiatan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Jam Awal Kegiatan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.jamAwalKegiatanController,
                readOnly: true,
                onTap: () => controller.selectTimeAwal(context),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.access_time, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Pilih Jam Awal Kegiatan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Jam Akhir Kegiatan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.jamAkhirKegiatanController,
                readOnly: true,
                onTap: () => controller.selectTimeAkhir(context),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.access_time, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Pilih Jam Akhir Kegiatan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isEditData.value) {
                      controller.editAgenda(
                        controller.idAgenda.value,
                      );
                    } else {
                      controller.postAgenda();
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
                        controller.isEditData.value ? "UPDATE" : "SIMPAN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: putih,
                        ));
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
