import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/admin_controller/jadwal_keberangkatan_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostJadwalKeberangkatan extends StatelessWidget {
  PostJadwalKeberangkatan({super.key});
  final controller = Get.find<JadwalKeberangkatanController>();

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
                    controller.isEditing.value
                        ? "Edit Data Keberangkatan"
                        : "Tambah Data Keberangkatan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Nomor Rombongan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.rombonganController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.group, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Masukkan Nomor Rombongan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Tanggal Keberangkatan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.tanggalController,
                readOnly: true,
                onTap: () => controller.selectDate(context),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.date_range, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Pilih Tanggal Keberangkatan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Jam Keberangkatan",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.jamController,
                readOnly: true,
                onTap: () => controller.selectTime(context),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.access_time, color: hijauUtama),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "Pilih Jam Keberangkatan",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Status",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedStatus.value,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: hijauUtama,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    items: ["Terkonfirmasi", "Reschedule", "Dibatalkan"]
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedStatus.value = value;
                      }
                    },
                  )),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isEditing.value) {
                      controller.editJadwal(
                        controller.idJadwal.value,
                      );
                    } else {
                      controller.postJadwalKeberangkatan();
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
