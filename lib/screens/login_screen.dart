import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ahes_maps/constants/colors.dart';
import 'package:ahes_maps/controller/login_controller.dart';
import 'package:ahes_maps/screens/new_home_screen/main_jemaah_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/image/background_login.png',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Center(
                        child: Image.asset('assets/image/logo_kemenag.png'),
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      Obx(
                        () => Visibility(
                          visible: !controller.isAdmin.value,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.offAll(() => MainJemaahScreen());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Lanjut Sebagai Jemaat',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: putih,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins'),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: putih,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'atau',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: putih,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                              ),
                              SizedBox(height: 16),
                              InkWell(
                                onTap: () {
                                  controller.isAdmin.value = true;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 28),
                                  decoration: BoxDecoration(
                                    color: putih,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    'Masuk Sebagai Admin',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: hitam,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(() => Visibility(
                            visible: controller.isAdmin.value,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.arrow_back, color: putih),
                                      onPressed: () {
                                        controller.emailController.clear();
                                        controller.passwordController.clear();
                                        controller.isAdmin.value = false;
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Masuk Sebagai Admin',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: putih,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: controller.emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    suffixIcon: Icon(Icons.email, color: hitam),
                                    labelStyle: TextStyle(color: hitam),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide:
                                          BorderSide(color: putih, width: 2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: controller.passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan password',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    suffixIcon: Icon(Icons.lock, color: hitam),
                                    labelStyle: TextStyle(color: hitam),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide:
                                          BorderSide(color: putih, width: 2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: () {
                                    controller.login(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 28),
                                    decoration: BoxDecoration(
                                      color: putih,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Obx(() => controller.isLoading.value
                                        ? CircularProgressIndicator()
                                        : Text(
                                            'Masuk',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: hitam,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins'),
                                          )),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
