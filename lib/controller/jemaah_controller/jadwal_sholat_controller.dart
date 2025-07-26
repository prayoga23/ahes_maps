import 'dart:convert';

import 'package:ahes_maps/models/jadwal_sholat_new_model.dart';
import 'package:ahes_maps/widgets/toast_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class JadwalSholatController extends GetxController {
  var tanggalController = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;

  JadwalSholatModel? jadwalSholatModel;

  final String baseUrl = 'https://api.myquran.com/v2/sholat/jadwal/';
  final String cityId = '1638';
  var isLoading = false.obs;

  void addOneDay() {
    final DateTime currentDate = DateTime.parse(tanggalController.value);
    final DateTime nextDate = currentDate.add(const Duration(days: 1));
    tanggalController.value = DateFormat('yyyy-MM-dd').format(nextDate);
    getJadwalSholat();
  }

  void minOneDay() {
    final DateTime currentDate = DateTime.parse(tanggalController.value);
    final DateTime nextDate = currentDate.subtract(const Duration(days: 1));
    tanggalController.value = DateFormat('yyyy-MM-dd').format(nextDate);
    getJadwalSholat();
  }

  Future<void> getJadwalSholat() async {
    final String url = '$baseUrl$cityId/${tanggalController.value}';
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        jadwalSholatModel =
            JadwalSholatModel.fromJson(jsonDecode(response.body));
        update();
        if (jadwalSholatModel?.status == false) {
          ToastMessage.showError(
              Get.context!, jadwalSholatModel?.message ?? 'Error');
        }

        if (kDebugMode) {
          print('Jadwal Sholat: ${jadwalSholatModel?.data?.jadwal?.ashar}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
      ToastMessage.showError(Get.context!, 'Gagal mengambil data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Sholat',
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
      tanggalController.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  void onInit() {
    super.onInit();
    tanggalController.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    getJadwalSholat();
  }

}
