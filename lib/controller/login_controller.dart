import 'package:ahes_maps/screens/admin/home_admin_screen.dart';
import 'package:ahes_maps/widgets/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isAdmin = false.obs;
  var isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ToastMessage.showWarning(context, 'Email dan Password harus diisi');
      return;
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      ToastMessage.showWarning(context, 'Format email tidak valid');
      return;
    }

    isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedInAdmin', true);
      await prefs.setString('adminEmail', email); // Optional

      ToastMessage.showSuccess(Get.context!, 'Login Berhasil!');

      Get.offAll(() => HomeAdminScreen());
      emailController.clear();
      passwordController.clear();
      isAdmin.value = false;
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan';
      switch (e.code) {
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'user-disabled':
          message = 'Akun dengan email ini telah dinonaktifkan';
          break;
        case 'user-not-found':
          message = 'Akun dengan email ini tidak ditemukan';
          break;
        case 'wrong-password':
          message = 'Password salah';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan, coba lagi nanti';
          break;
        case 'user-token-expired':
          message = 'Token pengguna telah kedaluwarsa, harap login ulang';
          break;
        case 'network-request-failed':
          message = 'Terjadi masalah jaringan, periksa koneksi internet Anda';
          break;
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
          message = 'Akun email/password tidak valid';
          break;
        case 'operation-not-allowed':
          message =
              'Akun email/password belum diaktifkan, harap periksa pengaturan di Firebase Console';
          break;
        default:
          message = e.message ?? 'Login gagal, coba lagi';
      }
      ToastMessage.showError(Get.context!, message);
    } catch (e) {
      ToastMessage.showError(Get.context!, 'Login gagal, silakan coba lagi');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
