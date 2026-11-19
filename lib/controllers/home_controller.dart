import 'package:get/get.dart';
import '../services/api_service.dart';

// GetX controller untuk halaman beranda: data shows, search, dan sort.
class HomeController extends GetxController {
  final shows = <Map<String, dynamic>>[].obs;
  final loading = true.obs;
  final error = RxnString(); // null = tidak ada error

  // Kata kunci pencarian (diisi dari TextField).
  final query = ''.obs;
  // Mode urutan: 'default' (urutan API), 'rating' (tertinggi), 'name' (A-Z).
  final sortMode = 'default'.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    loading.value = true;
    error.value = null;
    try {
      shows.assignAll(await ApiService.fetchAnimes());
    } catch (e) {
      error.value = '$e';
    }
    loading.value = false;
  }

  String _title(Map<String, dynamic> s) =>
      (s['attributes']['titles']?['en_jp'] ?? s['attributes']['canonicalTitle'] ?? '').toString();

  // Hasil akhir yang ditampilkan: shows -> difilter search -> diurutkan.
  // Dibaca di dalam Obx, jadi UI otomatis update saat shows/query/sortMode berubah.
  List<Map<String, dynamic>> get filtered {
    final q = query.value.toLowerCase();
    // Search: title mengandung kata kunci (tidak peduli huruf besar/kecil).
    final list = shows
        .where((s) => _title(s).toLowerCase().contains(q))
        .toList();
    // Sort: rating tertinggi dulu (null dianggap 0), atau title A-Z.
    if (sortMode.value == 'rating') {
      num r(Map<String, dynamic> s) => num.tryParse('${s['attributes']['averageRating']}') ?? 0;
      list.sort((a, b) => r(b).compareTo(r(a)));
    } else if (sortMode.value == 'name') {
      list.sort((a, b) => _title(a).compareTo(_title(b)));
    }
    return list;
  }
}
