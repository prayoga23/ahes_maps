import 'package:ahes_maps/controller/admin_controller/fasilitas_admin_controller.dart';
import 'package:ahes_maps/controller/admin_controller/jadwal_keberangkatan_admin_controller.dart';
import 'package:ahes_maps/widgets/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AgendaController extends GetxController {
  final namaKegiatanController = TextEditingController();
  final tanggalKegiatanController = TextEditingController();
  final lokasiKegiatanController = TextEditingController();
  final jamAwalKegiatanController = TextEditingController();
  final jamAkhirKegiatanController = TextEditingController();

  var listAgenda = <Map<String, dynamic>>[].obs;

  var isPostData = false.obs;
  var isLoading = false.obs;
  var isEditData = false.obs;
  var idAgenda = ''.obs;

  Future<void> postAgenda() async {
    isLoading.value = true;
    final uid = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
    final docRef =
        FirebaseFirestore.instance.collection('agenda_kegiatan').doc();

    if (namaKegiatanController.text.isEmpty ||
        tanggalKegiatanController.text.isEmpty ||
        lokasiKegiatanController.text.isEmpty ||
        jamAwalKegiatanController.text.isEmpty ||
        jamAkhirKegiatanController.text.isEmpty) {
      ToastMessage.showWarning(Get.context!, 'Semua field harus diisi');
      isLoading.value = false;
      return;
    }

    if (!validasiJam()) {
      ToastMessage.showWarning(
          Get.context!, 'Jam awal harus lebih kecil dari jam akhir');
      isLoading.value = false;
      return;
    }

    try {
      final tanggal = tanggalKegiatanController.text.trim();
      final jamAwal = jamAwalKegiatanController.text.trim();
      final combinedDateTime =
          DateFormat("dd/MM/yyyy HH:mm").parse("$tanggal $jamAwal");

      await docRef.set({
        'id': docRef.id,
        'created_by': uid,
        'created_date': FieldValue.serverTimestamp(),
        'modified_by': null,
        'modified_date': null,
        'deleted': false,
        'nama_kegiatan': namaKegiatanController.text.trim(),
        'tanggal_kegiatan': tanggal,
        'lokasi_kegiatan': lokasiKegiatanController.text.trim(),
        'jam_awal_kegiatan': jamAwal,
        'jam_akhir_kegiatan': jamAkhirKegiatanController.text.trim(),
        'datetime_awal_kegiatan': Timestamp.fromDate(combinedDateTime),
      });

      ToastMessage.showSuccess(Get.context!, 'Agenda berhasil ditambahkan');
      closeForm();
      clearForm();
      listAgenda.clear();
      getAllAgenda();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal menambahkan data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllAgenda() async {
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

  Future<void> softDeleteAgenda(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
    try {
      await FirebaseFirestore.instance
          .collection('agenda_kegiatan')
          .doc(id)
          .update({
        'deleted': true,
        'modified_by': uid,
        'modified_date': FieldValue.serverTimestamp(),
      });
      ToastMessage.showSuccess(Get.context!, 'Agenda berhasil dihapus');
      getAllAgenda();
      Get.back();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal menghapus data: $e');
    }
  }

  Future<void> editAgenda(String id) async {
    isLoading.value = true;
    final uid = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';

    if (namaKegiatanController.text.isEmpty ||
        tanggalKegiatanController.text.isEmpty ||
        lokasiKegiatanController.text.isEmpty ||
        jamAwalKegiatanController.text.isEmpty ||
        jamAkhirKegiatanController.text.isEmpty) {
      ToastMessage.showWarning(Get.context!, 'Semua field harus diisi');
      isLoading.value = false;
      return;
    }

    if (!validasiJam()) {
      ToastMessage.showWarning(
          Get.context!, 'Jam awal harus lebih kecil dari jam akhir');
      isLoading.value = false;
      return;
    }

    try {
      final tanggal = tanggalKegiatanController.text.trim();
      final jamAwal = jamAwalKegiatanController.text.trim();
      final combinedDateTime =
          DateFormat("dd/MM/yyyy HH:mm").parse("$tanggal $jamAwal");

      await FirebaseFirestore.instance
          .collection('agenda_kegiatan')
          .doc(id)
          .update({
        'modified_by': uid,
        'modified_date': FieldValue.serverTimestamp(),
        'nama_kegiatan': namaKegiatanController.text.trim(),
        'tanggal_kegiatan': tanggal,
        'lokasi_kegiatan': lokasiKegiatanController.text.trim(),
        'jam_awal_kegiatan': jamAwal,
        'jam_akhir_kegiatan': jamAkhirKegiatanController.text.trim(),
        'datetime_awal_kegiatan': Timestamp.fromDate(combinedDateTime),
      });

      ToastMessage.showSuccess(Get.context!, 'Agenda berhasil diedit');
      closeForm();
      clearForm();
      listAgenda.clear();
      getAllAgenda();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal mengedit data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    namaKegiatanController.clear();
    tanggalKegiatanController.clear();
    lokasiKegiatanController.clear();
    jamAwalKegiatanController.clear();
    jamAkhirKegiatanController.clear();
  }

  void openForm() {
    isPostData.value = true;
  }

  void closeForm() {
    isPostData.value = false;
    isEditData.value = false;
    idAgenda.value = '';
    clearForm();
  }

  bool validasiJam() {
    if (jamAwalKegiatanController.text.isEmpty ||
        jamAkhirKegiatanController.text.isEmpty) {
      return false;
    }
    final jamAwal = DateFormat.Hm().parse(jamAwalKegiatanController.text);
    final jamAkhir = DateFormat.Hm().parse(jamAkhirKegiatanController.text);
    return jamAwal.isBefore(jamAkhir);
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Kegiatan',
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
      tanggalKegiatanController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void selectTimeAwal(BuildContext context) async {
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
      helpText: 'Pilih Jam Mulai Kegiatan',
      cancelText: 'Batalkan',
      confirmText: 'Pilih',
      errorInvalidText: 'Jam tidak valid',
      hourLabelText: 'Jam',
      minuteLabelText: 'Menit',
    );
    if (picked != null) {
      jamAwalKegiatanController.text = picked.format(Get.context!);
    }
  }

  void selectTimeAkhir(BuildContext context) async {
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
      helpText: 'Pilih Jam Selesai Kegiatan',
      cancelText: 'Batalkan',
      confirmText: 'Pilih',
      errorInvalidText: 'Jam tidak valid',
      hourLabelText: 'Jam',
      minuteLabelText: 'Menit',
    );
    if (picked != null) {
      jamAkhirKegiatanController.text = picked.format(Get.context!);
    }
  }

  @override
  void onInit() {
    Get.delete<FasilitasController>(force: true);
    Get.delete<JadwalKeberangkatanController>(force: true);
    super.onInit();
    getAllAgenda();
  }
}
