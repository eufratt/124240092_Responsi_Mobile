import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bonus_controller.dart';
import '../main.dart';

// Halaman Bonus: tiga fitur nilai tambah (Notifikasi, Lokasi/LBS, GetX).
class BonusPage extends StatelessWidget {
  const BonusPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put membuat controller dan mendaftarkannya ke GetX.
    final c = Get.put(BonusController());
    return Scaffold(
      appBar: AppBar(title: const Text('Bonus'), centerTitle: false),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // 1. Notifikasi
        _Section(
          icon: Icons.notifications,
          title: 'Notifikasi',
          desc: 'Notifikasi lokal juga muncul saat login dan saat menambah/menghapus favorit.',
          child: FilledButton(
              onPressed: c.sendTestNotification, child: const Text('Kirim notifikasi tes')),
        ),
        // 2. LBS
        _Section(
          icon: Icons.location_on,
          title: 'Lokasi (LBS)',
          desc: 'Mengambil koordinat GPS perangkat.',
          // Obx rebuild otomatis saat locText / locLoading berubah.
          child: Obx(() => Column(children: [
                Text(c.locText.value, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: c.locLoading.value ? null : c.fetchLocation,
                  child: Text(c.locLoading.value ? 'Mencari...' : 'Lokasi saya'),
                ),
              ])),
        ),
        // 3. GetX
        _Section(
          icon: Icons.bolt,
          title: 'GetX',
          desc: 'State management reaktif. Tambah/hapus favorit lalu kembali ke sini: '
              'angkanya berubah otomatis tanpa setState.',
          child: Obx(() => Text('Jumlah favorit: ${c.favCount.value}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        ),
      ]),
    );
  }
}

// Kartu pembungkus untuk satu bagian fitur.
class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Widget child;
  const _Section(
      {required this.icon, required this.title, required this.desc, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: kRed),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Center(child: child),
        ]),
      );
}
