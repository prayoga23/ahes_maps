import 'package:ahes_maps/controller/admin_controller/agenda_admin_controller.dart';
import 'package:ahes_maps/controller/admin_controller/fasilitas_admin_controller.dart';
import 'package:ahes_maps/widgets/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class JadwalKeberangkatanController extends GetxController {
  final rombonganController = TextEditingController();
  final tanggalController = TextEditingController();
  final jamController = TextEditingController();
  final RxString selectedStatus = 'Terkonfirmasi'.obs;
  var listJadwal = <Map<String, dynamic>>[].obs;

  var isPosting = false.obs;
  var isLoading = false.obs;
  var isEditing = false.obs;
  var idJadwal = ''.obs;

  Future<void> postJadwalKeberangkatan() async {
    isLoading.value = true;
    final uid = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
    final docRef =
        FirebaseFirestore.instance.collection('jadwal_keberangkatan').doc();

    if (rombonganController.text.isEmpty ||
        tanggalController.text.isEmpty ||
        jamController.text.isEmpty) {
      ToastMessage.showWarning(Get.context!, 'Semua field harus diisi');
      return;
    }

    try {
      await docRef.set({
        'id': docRef.id,
        'created_by': uid,
        'created_date': FieldValue.serverTimestamp(),
        'modified_by': null,
        'modified_date': null,
        'deleted': false,
        'nomor_rombongan': rombonganController.text.trim(),
        'tanggal_keberangkatan': tanggalController.text.trim(),
        'jam_keberangkatan': jamController.text.trim(),
        'status': selectedStatus.value,
      });
      ToastMessage.showSuccess(Get.context!, 'Jadwal berhasil ditambahkan');
      closeForm();
      rombonganController.clear();
      tanggalController.clear();
      jamController.clear();
      selectedStatus.value = 'Terkonfirmasi';
      listJadwal.clear();
      getAllJadwal();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal menambahkan data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllJadwal() async {
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

  Future<void> softDeleteJadwal(String id) async {
    isPosting.value = true;
    final uid = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';

    try {
      await FirebaseFirestore.instance
          .collection('jadwal_keberangkatan')
          .doc(id)
          .update({
        'deleted': true,
        'modified_date': FieldValue.serverTimestamp(),
        'modified_by': uid,
      });
      ToastMessage.showSuccess(Get.context!, 'Data berhasil dihapus');
      getAllJadwal();
      Get.back();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal menghapus data: $e');
    } finally {
      isPosting.value = false;
    }
  }

  Future<void> editJadwal(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('jadwal_keberangkatan')
          .doc(id)
          .update({
        'nomor_rombongan': rombonganController.text.trim(),
        'tanggal_keberangkatan': tanggalController.text.trim(),
        'jam_keberangkatan': jamController.text.trim(),
        'status': selectedStatus.value,
        'modified_by': FirebaseAuth.instance.currentUser?.email ?? 'anonymous',
        'modified_date': FieldValue.serverTimestamp(),
      });

      ToastMessage.showSuccess(Get.context!, 'Data berhasil diperbarui');
      getAllJadwal();
      closeForm();
      rombonganController.clear();
      tanggalController.clear();
      jamController.clear();
      selectedStatus.value = 'Terkonfirmasi';
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal memperbarui data: $e');
    }
  }

  void clearForm() {
    rombonganController.clear();
    tanggalController.clear();
    jamController.clear();
    selectedStatus.value = 'Terkonfirmasi';
  }

  void openForm() {
    isPosting.value = true;
  }

  void closeForm() {
    isPosting.value = false;
    isEditing.value = false;
    idJadwal.value = '';
    clearForm();
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Keberangkatan',
      cancelText: 'Batalkan',
      confirmText: 'Pilih',
      errorFormatText: 'Format tidak valid',
      errorInvalidText: 'Tanggal tidak valid',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: ColorScheme.light(primary: Colors.green),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      tanggalController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: ColorScheme.light(primary: Colors.green),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      helpText: 'Pilih Jam Keberangkatan',
      cancelText: 'Batalkan',
      confirmText: 'Pilih',
      errorInvalidText: 'Jam tidak valid',
      hourLabelText: 'Jam',
      minuteLabelText: 'Menit',
    );
    if (picked != null) {
      jamController.text = picked.format(Get.context!);
    }
  }

  @override
  void onInit() {
    Get.delete<FasilitasController>(force: true);
    Get.delete<AgendaController>(force: true);
    super.onInit();
    getAllJadwal();
  }
}
