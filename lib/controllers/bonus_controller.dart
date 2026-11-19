import 'package:get/get.dart';
import '../services/favorite_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';

// GetX controller untuk halaman Bonus (notifikasi, lokasi, demo GetX).
class BonusController extends GetxController {
  // --- Demo GetX: jumlah favorit ter-update otomatis ---
  final favCount = 0.obs;

  // --- LBS ---
  final locText = 'Lokasi belum diambil'.obs;
  final locLoading = false.obs;

  void _syncFav() => favCount.value = FavoriteService.all().length;

  @override
  void onInit() {
    super.onInit();
    _syncFav();
    // Dengarkan perubahan box Hive agar favCount selalu sinkron.
    FavoriteService.listenable().addListener(_syncFav);
  }

  @override
  void onClose() {
    FavoriteService.listenable().removeListener(_syncFav);
    super.onClose();
  }

  // --- Notifikasi ---
  Future<void> sendTestNotification() =>
      NotificationService.show('Tes notifikasi', 'Notifikasi lokal berhasil muncul!');

  // --- LBS ---
  Future<void> fetchLocation() async {
    locLoading.value = true;
    try {
      final p = await LocationService.current();
      locText.value =
          'Lat: ${p.latitude.toStringAsFixed(5)}, Lng: ${p.longitude.toStringAsFixed(5)}';
    } catch (e) {
      // Pesan dari LocationService (GPS mati / izin ditolak).
      locText.value = '$e';
    }
    locLoading.value = false;
  }
}
