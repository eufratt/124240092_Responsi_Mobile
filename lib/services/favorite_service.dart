import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Penyimpanan favorit memakai Hive (database lokal key-value).
// Key = id show, value = Map berisi id, name, image, rating.
class FavoriteService {
  static const _name = 'favorites';
  static Box get _box => Hive.box(_name);

  // Dipanggil sekali di main() sebelum runApp.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_name);
  }

  // Dipakai ValueListenableBuilder agar UI rebuild saat isi box berubah.
  static ValueListenable<Box> listenable() => _box.listenable();

  // Apakah show dengan id ini sudah difavoritkan?
  static bool isFav(String id) => _box.containsKey(id);

  // Semua favorit sebagai list Map (Hive mengembalikan Map<dynamic, dynamic>,
  // jadi dikonversi ke Map<String, dynamic>).
  static List<Map<String, dynamic>> all() =>
      _box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();

  // Jika sudah favorit -> hapus, jika belum -> simpan.
  static int get count => _box.length;

  static Future<void> toggle(String id, String name, String? image, String? rating) async {
    if (isFav(id)) {
      await _box.delete(id);
    } else {
      await _box.put(id, {'id': id, 'name': name, 'image': image, 'rating': rating});
    }
  }

  static Future<void> remove(String id) => _box.delete(id);
}
