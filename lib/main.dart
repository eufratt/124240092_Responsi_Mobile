import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/favorite_service.dart';
import 'services/notification_service.dart';

// Warna yang dipakai di seluruh aplikasi (tema gelap + aksen merah).
const kRed = Color(0xFFF44336); // warna aksen: tombol, ikon aktif
const kCard = Color(0xFF2C2C2C); // warna latar kartu

// Titik awal aplikasi. async karena perlu menyiapkan Hive, notifikasi, dan
// membaca SharedPreferences sebelum UI tampil.
void main() async {
  // Wajib dipanggil jika ada proses async sebelum runApp.
  WidgetsFlutterBinding.ensureInitialized();
  await FavoriteService.init(); // buka box Hive untuk favorit
  await NotificationService.init(); // siapkan notifikasi + minta izin
  final prefs = await SharedPreferences.getInstance();
  // Jika key 'username' ada, berarti user masih login (session tersimpan).
  runApp(MyApp(loggedIn: prefs.getString('username') != null));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  // GetMaterialApp menggantikan MaterialApp agar GetX (navigasi, snackbar,
  // dependency injection) bisa dipakai tanpa BuildContext.
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Keripikroll',
        debugShowCheckedModeBanner: false,
        // Tema global: semua halaman otomatis memakai gaya ini.
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(primary: kRed),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black, elevation: 0, scrolledUnderElevation: 0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF0A0A0A),
            selectedItemColor: kRed,
            unselectedItemColor: Colors.white70,
          ),
          // Gaya default FilledButton: merah, lebar penuh, bentuk pil.
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: kRed,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: const StadiumBorder(),
            ),
          ),
        ),
        // Sudah login -> langsung ke halaman utama, belum -> halaman login.
        home: loggedIn ? const MainPage() : const LoginPage(),
      );
}
