import 'dart:convert';
import 'dart:io';

import 'package:ahes_maps/controller/admin_controller/agenda_admin_controller.dart';
import 'package:ahes_maps/controller/admin_controller/jadwal_keberangkatan_admin_controller.dart';
import 'package:ahes_maps/widgets/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class FasilitasController extends GetxController {
  final cloudName = 'dzc26f4ae';
  final uploadPreset = 'flutter-ahass';

  var isPostingDataScreen = false.obs;
  var isLoading = false.obs;
  var isEditing = false.obs;

  final searchController = TextEditingController();
  final keyword = ''.obs;
  final selectedImagePath = RxnString();

  var idFasilitas = ''.obs;

  final namaGedungController = TextEditingController();
  final deskripsiController = TextEditingController();
  final longController = TextEditingController();
  final latController = TextEditingController();

  var listFasilitas = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    Get.delete<AgendaController>(force: true);
    Get.delete<JadwalKeberangkatanController>(force: true);
    super.onInit();
    listFasilitas.value = [];
    getAllFasilitas();
  }

  void openForm() {
    isPostingDataScreen.value = true;
  }

  void closeForm() {
    isPostingDataScreen.value = false;
    isEditing.value = false;
    idFasilitas.value = '';
    clearForm();
  }

  void clearForm() {
    namaGedungController.clear();
    deskripsiController.clear();
    longController.clear();
    latController.clear();
    selectedImagePath.value = null;
  }

  Future<void> getAllFasilitas() async {
    try {
      if (keyword.value.isNotEmpty) {
        final keywordUpper = keyword.value.trim().toUpperCase();

        final snapshot = await FirebaseFirestore.instance
            .collection('fasilitas')
            .where('deleted', isEqualTo: false)
            .orderBy('nama_gedung')
            .startAt([keywordUpper]).endAt(['$keywordUpper\uf8ff']).get();

        listFasilitas.value = snapshot.docs.map((doc) => doc.data()).toList();
        listFasilitas.refresh();
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('fasilitas')
          .where('deleted', isEqualTo: false)
          .orderBy('created_date', descending: true)
          .get();
      listFasilitas.value = snapshot.docs.map((doc) => doc.data()).toList();
      listFasilitas.refresh();
    } catch (e) {
      ToastMessage.showError(
          Get.context!, 'Gagal mengambil data fasilitas: $e');
    }
  }

  Future<void> pickImage() async {
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      Get.snackbar('Permission', 'Akses galeri ditolak');
      return;
    }
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      selectedImagePath.value = result.files.single.path;
    }
  }

  Future<String?> uploadImageToCloudinary(File file) async {
    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      final resStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final json = jsonDecode(resStr);
        return json['secure_url'];
      } else {
        ToastMessage.showError(
            Get.context!, 'Gagal mengupload gambar: ${response.statusCode}');
        print('Error uploading image: $response');
        return null;
      }
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal mengupload gambar: $e');
      print('Error uploading image: $e');
      isLoading.value = false;
      return null;
    }
  }

  Future<void> postFasilitas() async {
    isLoading.value = true;
    final uid = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
    final docRef = FirebaseFirestore.instance.collection('fasilitas').doc();

    if (namaGedungController.text.isEmpty ||
        deskripsiController.text.isEmpty ||
        longController.text.isEmpty ||
        latController.text.isEmpty ||
        selectedImagePath.value == null) {
      ToastMessage.showWarning(Get.context!, 'Semua field harus diisi');
      isLoading.value = false;
      return;
    }

    try {
      final imageUrl =
          await uploadImageToCloudinary(File(selectedImagePath.value!));

      if (imageUrl == null) {
        ToastMessage.showError(Get.context!, 'Gambar gagal diupload');
        return;
      }
      await docRef.set({
        'id': docRef.id,
        'created_by': uid,
        'created_date': FieldValue.serverTimestamp(),
        'modified_by': null,
        'modified_date': null,
        'deleted': false,
        'nama_gedung': namaGedungController.text.trim().toUpperCase(),
        'deskripsi': deskripsiController.text.trim(),
        'long': longController.text.trim(),
        'lat': latController.text.trim(),
        'gambar': imageUrl,
        'jarak': '0.0',
      });
      ToastMessage.showSuccess(Get.context!, 'Fasilitas berhasil ditambahkan');
      closeForm();
      listFasilitas.clear();
      getAllFasilitas();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal menambahkan data: $e');
      return;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDataFasilitas(String id) async {
    isLoading.value = true;
    final uid = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
    final docRef = FirebaseFirestore.instance.collection('fasilitas').doc(id);

    if (namaGedungController.text.isEmpty ||
        deskripsiController.text.isEmpty ||
        longController.text.isEmpty ||
        latController.text.isEmpty) {
      ToastMessage.showWarning(Get.context!, 'Semua field harus diisi');
      isLoading.value = false;
      return;
    }

    try {
      String? imageUrl;
      if (selectedImagePath.value != null) {
        imageUrl =
            await uploadImageToCloudinary(File(selectedImagePath.value!));
        if (imageUrl == null) {
          ToastMessage.showError(Get.context!, 'Gambar gagal diupload');
          return;
        }
      }

      await docRef.update({
        'modified_by': uid,
        'modified_date': FieldValue.serverTimestamp(),
        'nama_gedung': namaGedungController.text.trim().toUpperCase(),
        'deskripsi': deskripsiController.text.trim(),
        'long': longController.text.trim(),
        'lat': latController.text.trim(),
        if (imageUrl != null) 'gambar': imageUrl,
      });
      ToastMessage.showSuccess(Get.context!, 'Fasilitas berhasil diperbarui');
      closeForm();
      listFasilitas.clear();
      getAllFasilitas();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal memperbarui data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteImageUrl(String id) async {
    final docRef = FirebaseFirestore.instance.collection('fasilitas').doc(id);
    try {
      await docRef.update({
        'gambar': null,
        'modified_date': FieldValue.serverTimestamp(),
        'modified_by': FirebaseAuth.instance.currentUser?.email ?? 'anonymous',
      });
      ToastMessage.showSuccess(Get.context!, 'Fasilitas berhasil dihapus');
      listFasilitas.clear();
      getAllFasilitas();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal menghapus data: $e');
    }
  }

  Future<void> onDeleteFasilitas(String id) async {
    final docRef = FirebaseFirestore.instance.collection('fasilitas').doc(id);
    try {
      await docRef.update({
        'deleted': true,
        'modified_date': FieldValue.serverTimestamp(),
      });
      ToastMessage.showSuccess(Get.context!, 'Fasilitas berhasil dihapus');
      listFasilitas.clear();
      getAllFasilitas();
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Gagal menghapus data: $e');
    }
  }
}
