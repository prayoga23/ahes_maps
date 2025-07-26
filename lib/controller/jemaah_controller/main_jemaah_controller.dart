import 'package:ahes_maps/controller/admin_controller/fasilitas_admin_controller.dart';
import 'package:ahes_maps/controller/jemaah_controller/home_jemaah_controller.dart';
import 'package:ahes_maps/controller/jemaah_controller/jadwal_jemaah_controller.dart';
import 'package:ahes_maps/controller/jemaah_controller/peta_jemaah_controller.dart';
import 'package:get/get.dart';

class MainJemaahController extends GetxController {
  var currentIndex = 0.obs;

  void doLogout() {
    Get.offAllNamed('/login');
    Get.delete<HomeJemaahController>(force: true);
    Get.delete<JadwalJemaahController>(force: true);
    Get.delete<PetaJemaahController>(force: true);
    Get.delete<FasilitasController>(force: true);
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
