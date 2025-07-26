import 'package:ahes_maps/widgets/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class JadwalJemaahController extends GetxController {
  var listJadwal = <Map<String, dynamic>>[].obs;
  var listAgenda = <Map<String, dynamic>>[].obs;

  Future<void> getAllJadwal() async {
    if (kDebugMode) {
      print("Get All Jadwal Called");
    }
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('jadwal_keberangkatan')
          .where('deleted', isEqualTo: false) // soft delete filter
          .orderBy('created_date', descending: true)
          .get();

      listJadwal.value = snapshot.docs.map((doc) => doc.data()).toList();
      listJadwal.refresh();
    } catch (e) {
      listJadwal.value = [];
      listJadwal.refresh();
      ToastMessage.showError(Get.context!, 'Gagal memuat data: $e');
    }
  }

  Future<void> getAllAgenda() async {
    if (kDebugMode) {
      print("Get All Agenda Called");
    }
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('agenda_kegiatan')
          .where('deleted', isEqualTo: false)
          .orderBy('datetime_awal_kegiatan')
          .get();

      listAgenda.clear();
      listAgenda.value = snapshot.docs.map((doc) => doc.data()).toList();
      listAgenda.refresh();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal mendapatkan data: $e');
      listAgenda.value = [];
      listAgenda.refresh();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAllJadwal();
    getAllAgenda();
  }
}
