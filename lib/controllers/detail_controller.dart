import 'package:get/get.dart';
import '../services/api_service.dart';

// GetX controller untuk halaman detail: state loading, error, dan data satu show.
class DetailController extends GetxController {
  final String id;
  DetailController(this.id);

  final show = Rxn<Map<String, dynamic>>(); // null selama belum ada data
  final loading = true.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    loading.value = true;
    error.value = null;
    try {
      show.value = await ApiService.fetchAnime(id);
    } catch (e) {
      error.value = '$e';
    }
    loading.value = false;
  }
}
