import 'package:geolocator/geolocator.dart';

// LBS: mengambil posisi GPS perangkat memakai package geolocator.
class LocationService {
  // Throws String message on failure.
  static Future<Position> current() async {
    // 1. GPS/layanan lokasi di perangkat harus aktif.
    if (!await Geolocator.isLocationServiceEnabled()) throw 'GPS tidak aktif';
    // 2. Cek izin; jika belum pernah diminta, tampilkan popup izin.
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak';
    }
    // 3. Ambil posisi saat ini.
    return Geolocator.getCurrentPosition();
  }
}
