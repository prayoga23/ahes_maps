import 'package:ahes_maps/controller/jemaah_controller/peta_jemaah_controller.dart';
import 'package:ahes_maps/screens/admin/fasilitas_admin/fasilitas_admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetaJemaahScreen extends StatelessWidget {
  PetaJemaahScreen({super.key});

  final PetaJemaahController controller = Get.put(PetaJemaahController());

  @override
  Widget build(BuildContext context) {
    return FasilitasAdminScreen(key: UniqueKey(), isJemaah: true);
  }
}
