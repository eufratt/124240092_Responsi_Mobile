import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'bonus_page.dart';
import 'favorite_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

// Kerangka utama setelah login: BottomNavigationBar + 4 halaman.
// Tab aktif disimpan di MainController (GetX), jadi tidak perlu StatefulWidget.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const _pages = [HomePage(), FavoritePage(), BonusPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MainController());
    // Obx rebuild saat c.index berubah.
    return Obx(() => Scaffold(
          // IndexedStack menjaga state tiap halaman tetap ada saat pindah tab.
          body: IndexedStack(index: c.index.value, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            // fixed: label semua tab tetap terlihat (default berubah jika > 3 tab).
            type: BottomNavigationBarType.fixed,
            currentIndex: c.index.value,
            onTap: (v) => c.index.value = v,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
              BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Bonus'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            ],
          ),
        ));
  }
}
