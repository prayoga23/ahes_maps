import 'package:ahes_maps/screens/login_screen.dart';
import 'package:ahes_maps/widgets/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAdminController extends GetxController {
  var selectedIndex = 0.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void selectIndex(int index) {
    selectedIndex.value = index;
  }

  String get email => _auth.currentUser?.email ?? '';

  doLogout(BuildContext context) async {
    try {
      await _auth.signOut();

      Get.offAll(() => LoginScreen());

      final prefs = await SharedPreferences.getInstance();
      prefs.remove('isLoggedInAdmin');
      prefs.remove('adminEmail');

      ToastMessage.showSuccess(Get.context!, 'Logout berhasil!');
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Logout failed: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = 0;
  }

  @override
  void onClose() {
    super.onClose();
    selectedIndex.value = 0;
  }
}
