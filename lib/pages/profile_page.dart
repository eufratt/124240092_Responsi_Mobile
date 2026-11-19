import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/favorite_service.dart';
import 'login_page.dart';

// Halaman profil: username, kesan & pesan, dan tombol logout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout() async {
    // Hapus session dari SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    // Get.offAll: kembali ke login dan hapus seluruh riwayat halaman,
    // sehingga tombol back tidak bisa kembali ke halaman utama.
    // Controller lama dibuang otomatis agar login berikutnya mulai bersih.
    Get.offAll(() => const LoginPage());
    Get.deleteAll(force: true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Profil'), centerTitle: true),
        // Ambil instance SharedPreferences untuk membaca username.
        body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snap) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const CircleAvatar(
                  radius: 68,
                  backgroundColor: Color(0xFF444444),
                  child: Icon(Icons.person, size: 70, color: Colors.white70)),
              const SizedBox(height: 24),
              // Username dari SharedPreferences ('-' selama masih loading).
              Text(snap.data?.getString('username') ?? '-',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Jumlah favorit dari Hive; rebuild saat box berubah.
              ValueListenableBuilder(
                valueListenable: FavoriteService.listenable(),
                builder: (_, _, _) => Text('Anime favorit: ${FavoriteService.count}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70)),
              ),
              const SizedBox(height: 20),
              // GANTI dengan kesan & pesan kamu.
              const Text(
                'Kesan: Praktikum mobile seru dan banyak ilmu baru.\n'
                'Pesan: Terima kasih kepada para asisten atas bimbingannya!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _logout, child: const Text('Logout')),
            ]),
          ),
        ),
      );
}
