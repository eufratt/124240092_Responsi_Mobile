import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import 'main_page.dart';

// GANTI dengan NIM kamu.
// NIM ini dipakai sebagai username yang valid; password-nya '123'.
const kNim = '124240092';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk membaca isi TextField.
  final _user = TextEditingController();
  final _pass = TextEditingController();

  Future<void> _login() async {
    if (_user.text == kNim && _pass.text == '123') {
      // Simpan username ke SharedPreferences sebagai penanda sudah login.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _user.text);
      NotificationService.show('Login berhasil', 'Selamat datang di Keripikroll');
      // Cek mounted: widget bisa saja sudah dibuang setelah await.
      if (!mounted) return;
      // Get.off: halaman login dibuang, tombol back tidak kembali ke sini.
      Get.off(() => const MainPage());
    } else {
      Get.snackbar('Gagal', 'Username atau password salah',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Dekorasi input yang dipakai bersama oleh kolom username dan password.
  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          // Bisa di-scroll agar tidak overflow saat keyboard muncul.
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const Icon(Icons.movie, size: 90, color: Colors.red),
              const SizedBox(height: 8),
              const Text('Keripikroll',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(controller: _user, decoration: _dec('Username', Icons.person)),
              const SizedBox(height: 16),
              // obscureText menyembunyikan password dengan titik.
              TextField(
                  controller: _pass, obscureText: true, decoration: _dec('Password', Icons.lock)),
              const SizedBox(height: 16),
              FilledButton(onPressed: _login, child: const Text('Login')),
            ]),
          ),
        ),
      );
}
