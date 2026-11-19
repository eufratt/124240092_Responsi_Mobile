import 'package:get/get.dart';

// GetX controller untuk BottomNavigationBar: menyimpan tab yang aktif.
// .obs membuat nilai reaktif; widget Obx otomatis rebuild saat nilainya berubah.
class MainController extends GetxController {
  final index = 0.obs;
}
